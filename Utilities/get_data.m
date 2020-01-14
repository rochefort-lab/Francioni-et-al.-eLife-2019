function [list_animals, animals, varargout] = get_data(datatype, cache_data, varargin)
  

animals = cache_data.animal;
list_animals = unique(animals, 'stable');


[soma, Trunk, Second, Third, High, junk, Branch, ALL_tuft, ATS] = get_branches(cache_data.ROItype);

switch datatype
    case 'tuftpeaks'

        varargout{1} = cache_data.fovname(ALL_tuft); % Name of fov
        varargout{2} = cache_data.data(ALL_tuft,1); % deltaf
        varargout{3} = cat(1,cache_data.data{ALL_tuft,6}); % sampling freq
        varargout{4} = cellfun(@(d)d{1,1},cache_data.data(ALL_tuft,7)); % peak detection threshold
        
        if ~isempty(varargin) && varargin{1}
            % Output conditions : stimulus and action
            
            varargout{5}.stimstill = cache_data.data(ALL_tuft,2);
            varargout{5}.stimloco = cache_data.data(ALL_tuft,3);
            varargout{5}.darkstill = cache_data.data(ALL_tuft,4);
            varargout{5}.darkloco = cache_data.data(ALL_tuft,5);

        end
        
        
    case 'tuftmeandfcondi'
        
        varargout{1} = cache_data.fovname(ALL_tuft); % Name of fov
        varargout{2} = nanmean(cache_data.data(ALL_tuft,:,1,1),2); % average across stimuli of mean deltaf during stim +still
        varargout{3} = nanmean(cache_data.data(ALL_tuft,:,1,3),2); % average across stimuli of mean deltaf during stim +locomotion
        varargout{4} = varargin{1}.data(ALL_tuft,1); % average df during dark +still
        varargout{4} = varargin{1}.data(ALL_tuft,3); % average df during dark +locomotion
        
        
end

    
end



function [soma, Trunk, Second, Third, High, junk, Branch, ALL_tuft, ATS] = get_branches(ROItype)

% Identify Branches with different branching orders

soma = strncmp(ROItype, 'soma',4);
Trunk = strncmp(ROItype, 'Trunk',5);
Second = strncmp(ROItype, 'Secondary',9);
Third = strncmp(ROItype, 'Third',5);
High = strncmp(ROItype, 'Higher',6);
junk = strncmp(ROItype, 'junk',4);
Branch = strncmp(ROItype, 'branch',6);
ALL_tuft = Second | Third | High | Branch;
ATS = ALL_tuft | Trunk | soma;



end