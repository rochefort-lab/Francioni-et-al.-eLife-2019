function [peaks_loc, peaks_A, peaks_thresh] = get_FOVtuft_peaks(df, fs, sd_threshold, fovnames)

% INPUT
% ------
%   df : cell array ; each cell contains a vector deltaF/F0 
%   fs : sampling frequency
%   sd_threshold : Peak threshold (thresh * std)
%   fovnames

 

list_fovs = unique(fovnames, 'stable');
nFovs = length(list_fovs);

peaks_loc = cell(nFovs, 1); % location of peaks
peaks_A = cell(nFovs, 1); % amplitude of peaks
peaks_thresh = cell(nFovs, 1); % threshold for peak detection


for iFov = 1:nFovs
    
    is_fov = strcmp(fovnames, list_fovs{iFov});
    
    fov_first_idx = find(is_fov, 1, 'first');
    
    % Get branches for this FOV
    fov_df = df(is_fov);
    fov_fs = fs(fov_first_idx);
    fov_sd_threshold = sd_threshold(is_fov);  % Get the peak threshold (thresh * std)
    num_branches = sum(is_fov);
    

    % Loop over branches to get peaks locations
    fov_peaks_loc = cell(1,num_branches);
    fov_peaks_A = cell(1,num_branches);
    fov_dfthresh = zeros(1,num_branches);
    for ibranch = 1:num_branches
        
        branch_df = fov_df{ibranch};
        branch_sd_th = fov_sd_threshold(ibranch);
        
        
        [fov_peaks_loc{ibranch}, fov_peaks_A{ibranch}, fov_dfthresh(ibranch)] = detect_df_peaks(branch_df, branch_sd_th, fov_fs);
        
        
    end
    
    peaks_loc{iFov} = fov_peaks_loc; % location of peaks
    peaks_A{iFov} = fov_peaks_A; % amplitude of peaks
    peaks_thresh{iFov} = fov_dfthresh; % threshold for peak detection
    
  
end

end



