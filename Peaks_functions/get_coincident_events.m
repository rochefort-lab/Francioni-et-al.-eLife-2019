function [coincident_peaks, noncoincident_peaks] = get_coincident_events(A1, loc1, loc2, trials_start, fs, k_window, ...
    df_1, df_2, dfthresh_1, dfthresh_2, k_dfthresh, stim_action_state)

num_peaks_tot = length(loc1);

coincident_peaks = nan(num_peaks_tot, 1);
noncoincident_peaks = nan(num_peaks_tot, 1);

for ipeak = 1:num_peaks_tot
    
    if sum(loc1(ipeak)-trials_start >= 0 & loc1(ipeak)-trials_start <= round(fs)*k_window) > 0
        continue
    elseif ipeak ~=1 && loc1(ipeak)-round(fs)*k_window < loc1(ipeak-1)
        [loc_min1, ixTuft1] = min(df_1(loc1(ipeak-1): loc1(ipeak)));
        min_idx = (loc1(ipeak-1)) + ixTuft1-1;
    else
        [loc_min1, ixTuft1] = min(df_1(loc1(ipeak)-round(fs)*k_window: loc1(ipeak)));
        min_idx = (loc1(ipeak)-round(fs)*k_window) + ixTuft1-1;
    end
    idx2 = min(loc1(ipeak) +round(fs), length(df_1));
    
    
    if (A1(ipeak)- loc_min1) <= dfthresh_1 || A1(ipeak) <= dfthresh_1 || ...
            sum( (loc1(ipeak)-trials_start) >= 0 & (loc1(ipeak)-trials_start) <= round(fs)) > 0
        continue
    else
        
        if ~ isempty(stim_action_state) && (stim_action_state(idx2) || stim_action_state(min_idx))
            
            if (max(df_2(min_idx:idx2)) - min(df_2(min_idx:idx2)) )> k_dfthresh*dfthresh_2 || ...
                    max(df_2(min_idx:idx2)) > k_dfthresh*dfthresh_2 || sum(loc2 <= idx2 & loc2>=min_idx) > 0
                
                coincident_peaks(ipeak) = A1(ipeak)- loc_min1;
                
                
            else
                
                noncoincident_peaks(ipeak) = A1(ipeak)- loc_min1;
                
            end
            
        end

    end
end


coincident_peaks = coincident_peaks(~isnan(coincident_peaks));
noncoincident_peaks = noncoincident_peaks(~isnan(noncoincident_peaks));

% Normalize
peakmax = max([coincident_peaks;noncoincident_peaks]);

if ~isempty(coincident_peaks)
    coincident_peaks = coincident_peaks/peakmax;
end
if ~isempty(noncoincident_peaks)
    noncoincident_peaks = noncoincident_peaks/peakmax;
end

end