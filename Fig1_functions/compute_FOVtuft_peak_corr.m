function [peakcorr, peakcorr_shuffl] = compute_FOVtuft_peak_corr(df, fs, fovnames, peaks_loc, peaks_thresh, do_shuffle, stim_action_state)

% INPUT
% ------
%   df : cell array ; each cell contains a vector deltaF/F0 
%   fs : sampling frequency
%   fovnames
      

k_window = 2 ; 
min_num_datapts = 5;

list_fovs = unique(fovnames, 'stable');
nFovs = length(list_fovs);

peakcorr = nan(nFovs, 1);
if do_shuffle
    peakcorr_shuffl = nan(nFovs, 1);
else
    peakcorr_shuffl = [];
end

if isempty(stim_action_state)
    check_state = false;
    fov_state = [];
else
    check_state = true;
end

for iFov = 1:nFovs
    
    is_fov = strcmp(fovnames, list_fovs{iFov});
    
    fov_first_idx = find(is_fov, 1, 'first');
    

    % Get branches for this FOV
    fov_df = df(is_fov);
    fov_fs = fs(fov_first_idx);
    num_branches = sum(is_fov);
    

    % Get start of trials
    fov_nFrames = length(fov_df{fov_first_idx});
    [trials_start] = get_start_of_trials(fov_fs, fov_nFrames);
    
    
    % Get the peaks detected for each branch in this fov
    fov_peaks_loc = peaks_loc{iFov};
    fov_dfthresh = peaks_thresh{iFov};
    
    % Check if filter some specific conditions
    if check_state
        fov_state = stim_action_state{fov_first_idx};
    end
    
    
    % Loop over branches to get peak correlations
    corrOneFov = nan(num_branches-1, num_branches);
    ShuffledcorrOneFov = nan(num_branches-1, num_branches);
    for ibranch = 1:num_branches-1
        
        % Get ref branch
        branch1_df = fov_df{ibranch};
        branch1_loc = fov_peaks_loc{ibranch};
        dfthresh_1 = fov_dfthresh(ibranch);
        
        % Loop over the other branches
        for ipartner = ibranch+1:num_branches
            
            % Get partner branch
            branch2_df = fov_df{ipartner};
            branch2_loc = fov_peaks_loc{ipartner};
            dfthresh_2 = fov_dfthresh(ipartner);
            
            locX = branch1_loc; % save all peaks
            for ipeak2 = 1:length(branch2_loc)
                
                idx1 = max(branch2_loc(ipeak2)-round(fov_fs)*k_window, 1);
                idx2 = min(branch2_loc(ipeak2)+round(fov_fs), fov_nFrames);
                
                if sum(locX>=idx1 & locX<=idx2) == 0 % if there are
                    % peaks in the second branch which are not found in
                    % the first one, add them  to the list
                    locX(end+1) = branch2_loc(ipeak2);
                end
            end
            locX = sort(locX);
            
            [tuft1_window_df, tuft2_window_df] = get_peakwindow_df(locX, trials_start, fov_fs, k_window, branch1_df, branch2_df, dfthresh_1, dfthresh_2, fov_state);
           
            
            if length(tuft1_window_df) > min_num_datapts
                corrOneFov(ibranch, ipartner) = corr(tuft1_window_df, tuft2_window_df);

                if do_shuffle
                    s = RandStream('mrg32k3a');
                    RandStream.setGlobalStream(s);
                    
                    shuffleddata = datasample(s,tuft1_window_df,length(tuft1_window_df),'Replace',false);
                    ShuffledcorrOneFov(ibranch, ipartner) = corr(shuffleddata, tuft2_window_df);
                end
            end
            
        end
        
        
    end

    
    peakcorr(iFov) = nanmean(corrOneFov(~isnan(corrOneFov) & corrOneFov ~= 1));
    
    if do_shuffle
        peakcorr_shuffl(iFov) = nanmean(ShuffledcorrOneFov(~isnan(ShuffledcorrOneFov) | ShuffledcorrOneFov ~= 1));
    end
end

end


