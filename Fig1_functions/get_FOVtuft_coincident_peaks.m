function [coincident_peaks, noncoincident_peaks] = get_FOVtuft_coincident_peaks(df, fs, fovnames, peaks_loc, peaks_A, peaks_thresh, stim_action_state, k_dfthresh)

% INPUT
% ------
%   df : cell array ; each cell contains a vector deltaF/F0
%   fs : sampling frequency
%   fovnames


k_window = 2 ;

list_fovs = unique(fovnames, 'stable');
nFovs = length(list_fovs);

coincident_peaks = cell(nFovs, 1);
noncoincident_peaks = cell(nFovs, 1);

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
    fov_peaks_A = peaks_A{iFov};
    fov_dfthresh = peaks_thresh{iFov};
    
    % Check if filter some specific conditions
    if check_state
        fov_state = stim_action_state{fov_first_idx};
    end
    
    
    % Loop over branches to get peak correlations
    fov_coincident_peaks = [];
    fov_noncoincident_peaks = [];
    for ibranch = 1:num_branches-1
        
        % Get ref branch
        branch1_df = fov_df{ibranch};
        branch1_loc = fov_peaks_loc{ibranch};
        branch1_A = fov_peaks_A{ibranch};
        dfthresh_1 = fov_dfthresh(ibranch);
        
        % Loop over the other branches
        for ipartner = ibranch+1:num_branches
            
            % Get partner branch
            branch2_df = fov_df{ipartner};
            branch2_loc = fov_peaks_loc{ipartner};
            branch2_A = fov_peaks_A{ibranch};
            dfthresh_2 = fov_dfthresh(ipartner);
            
            
            % Find coincident peaks for branch 1 > store amplitude
            [cp1, ncp1] = get_coincident_events(branch1_A, branch1_loc, branch2_loc, trials_start, fov_fs, k_window, ...
                branch1_df, branch2_df, dfthresh_1, dfthresh_2, k_dfthresh, fov_state);
            
            
             % Find coincident peaks for branch 2 > store amplitude
            [cp2, ncp2] = get_coincident_events(branch2_A, branch2_loc, branch1_loc, trials_start, fov_fs, k_window, ...
                branch2_df, branch1_df, dfthresh_2, dfthresh_1, k_dfthresh, fov_state);
           
          
            % Concat all
            fov_coincident_peaks = [fov_coincident_peaks; cp1; cp2];
            fov_noncoincident_peaks = [fov_noncoincident_peaks; ncp1; ncp2];
            
        end
        
        
    end
    
    coincident_peaks{iFov} = fov_coincident_peaks;
    noncoincident_peaks{iFov} = fov_noncoincident_peaks;
end
% Finally, simply concat all
coincident_peaks = cat(1, coincident_peaks{:});
noncoincident_peaks = cat(1, noncoincident_peaks{:});


end



