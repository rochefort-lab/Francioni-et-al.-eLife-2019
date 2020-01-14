function [trials_start] = get_start_of_trials(fs, num_frames)

% fs : sampling frequency
% num_frames : total number of frames of df trace


duration_seconds = num_frames/fs;
if duration_seconds/65 == floor(duration_seconds./65)
    trials = 0:round(num_frames/(65*fs))-1;
    trials_start = round((fs.*65.*trials));
elseif duration_seconds/64 == floor(duration_seconds./64)
    trials = 0:round(num_frames/(64*fs))-1;
    trials_start = round((fs.*64.*trials));
else
    error('Something is wrong with trial duration.')
end
    

end