function [window_df_1, window_df_2] = get_peakwindow_df(locX, trials_start, fov_fs, k_window, branch1_df, branch2_df, dfthresh_1, dfthresh_2, stim_action_state)

num_peaks_tot = length(locX);

window_df_1 = nan(num_peaks_tot, 1);
window_df_2 = nan(num_peaks_tot, 1);

for ipeak = 1:num_peaks_tot
    
    if sum(locX(ipeak)-trials_start >= 0 & locX(ipeak)-trials_start <= round(fov_fs)*k_window) > 0
        continue
    elseif ipeak ~=1 && locX(ipeak)-round(fov_fs)*k_window < locX(ipeak-1)
        [loc_min1, ix1] = min(branch1_df(locX(ipeak-1): locX(ipeak)));
        idx1Tuft1 = (locX(ipeak-1)) + ix1-1;
        [loc_min2, ix2] = min(branch2_df(locX(ipeak-1): locX(ipeak)));
        idx1Tuft2 = (locX(ipeak-1)) + ix2-1;
    else
        [loc_min1, ix1] = min(branch1_df(locX(ipeak)-round(fov_fs)*k_window: locX(ipeak)));
        idx1Tuft1 = (locX(ipeak)-round(fov_fs)*k_window) + ix1-1;
        [loc_min2, ix2] = min(branch2_df(locX(ipeak)-round(fov_fs)*k_window: locX(ipeak)));
        idx1Tuft2 = (locX(ipeak)-round(fov_fs)*k_window) + ix2-1;
    end
    idx2 = locX(ipeak) +round(fov_fs);
    maxT1 = max(branch1_df(idx1Tuft1:idx2));
    maxT2 = max(branch2_df(idx1Tuft2:idx2));
    
    if (((maxT1 - loc_min1) > dfthresh_1) && (maxT1 > dfthresh_1)) || (((maxT2 - loc_min2) > dfthresh_2) && (maxT2 > dfthresh_2))
        
        if ~isempty(stim_action_state) && (stim_action_state(idx2) || stim_action_state(idx1Tuft1) || stim_action_state(idx1Tuft2))
            
            window_df_1(ipeak)  =  maxT1 - loc_min1;
            window_df_2(ipeak)  =  maxT2 - loc_min2;
            
       
        end
    end
end

keep_peak = ~isnan(window_df_1);
window_df_1 = window_df_1(keep_peak);
window_df_2 = window_df_2(keep_peak);

end
