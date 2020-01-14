function [peaks_loc, peaks_A, x1] = detect_df_peaks(df, sd_th, fs)

% df : deltaf trace
% sd_th : Peak threshold (sd_th * std)
% fs : sampling frequency


min_freq1 = fs/8;
[b1,a1] = butter(9,min_freq1/fs,'high');
signal_filtered1 = filter(b1, a1, df);
x1 = sd_th*std(signal_filtered1);


[peaks_A, peaks_loc, ~, ~]  = findpeaks(df, 'MinPeakProminence', x1, 'Annotate', 'extents', 'MinPeakDistance', round(fs));



end