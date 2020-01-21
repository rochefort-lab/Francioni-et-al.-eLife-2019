%% TUFT - GET PEAKS

output_stim_action_state = true;
[TUFT_list_animals, TUFT_animals, TUFT_fovnames, TUFT_df, TUFT_fs, TUFT_sd_threshold, TUFT_stim_act_state] = get_data('tuftpeaks', DatSimPeak, output_stim_action_state);

% For each animal, for each FOV, save peaks of eaach branch.

peaks_loc = cell(nAnimals, 1); % location of peaks
peaks_A = cell(nAnimals, 1); % amplitude of peaks
peaks_thresh = cell(nAnimals, 1); % threshold for peak detection

for iAnimal = 1:nAnimals
    
    is_animal = strcmp(TUFT_animals, TUFT_list_animals(iAnimal));
    
    [peaks_loc{iAnimal}, peaks_A{iAnimal}, peaks_thresh{iAnimal}] = get_FOVtuft_peaks(TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_sd_threshold(is_animal), TUFT_fovnames(is_animal));
    
  
end




%% FIGURE 1 - PANEL D - tuft peaks correlation

do_shuffle = true;
corPerFov = cell(nAnimals, 1);
ShuffledPerFov = cell(nAnimals, 1);
PeakCorrAnimal = nan(nAnimals,1);
ShuffledPeakCorrAnimal = nan(nAnimals,1);
for iAnimal = 1:nAnimals
    
    is_animal = strcmp(TUFT_animals, TUFT_list_animals{iAnimal});
    
    [corPerFov{iAnimal}, ShuffledPerFov{iAnimal}] = compute_FOVtuft_peak_corr(TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), peaks_loc{iAnimal}, peaks_thresh{iAnimal}, do_shuffle, []);
    % corPerFov{iAnimal} : nan(nFovs, 1)
    
    PeakCorrAnimal(iAnimal) = nanmean(corPerFov{iAnimal});
    ShuffledPeakCorrAnimal(iAnimal) = nanmean(ShuffledPerFov{iAnimal});
end
corPerFov = cat(1, corPerFov{:}); % [nAnimals*nFovs_tot x 1]
ShuffledPerFov = cat(1, ShuffledPerFov{:}); % [nAnimals*nFovs_tot x 1]


% Correlation per Animal (not in the paper)
% figure(4409)
% bar([0 nanmean(PeakCorrAnimal) nanmean(ShuffledPeakCorrAnimal) 0], 'k')
% hold on
% for ii=1:size(PeakCorrAnimal,1)
  % scatter([2,3],[PeakCorrAnimal(ii,1),ShuffledPeakCorrAnimal(ii,1)],'MarkerEdgeColor', [0.7 0.7 0.7],...
              % 'MarkerFaceColor',[0.7 .7 .7])
% end
% hold on
% SEM = [0 nanstd(PeakCorrAnimal)/sqrt(length(PeakCorrAnimal))...
    % nanstd(ShuffledPeakCorrAnimal)/sqrt(length(ShuffledPeakCorrAnimal)) 0];
% errorbar([0 nanmean(PeakCorrAnimal) nanmean(ShuffledPeakCorrAnimal) 0], SEM, '.black', 'LineWidth', 2)
% hold on
% ylim([-0.3 1.1])
% hold off
% [p, s] = ttest(PeakCorrAnimal(~isnan(PeakCorrAnimal)), ShuffledPeakCorrAnimal(~isnan(ShuffledPeakCorrAnimal)) );




figure(4409)
bar([0 nanmean(corPerFov) nanmean(ShuffledPerFov) 0], 'k')
hold on
SEM = [0 nanstd(corPerFov)./sqrt(sum(~isnan(corPerFov))) ...
    nanstd(ShuffledPerFov)./sqrt(sum(~isnan(ShuffledPerFov))) 0];
hold on
C = cat(2, nan(numel(corPerFov),1), corPerFov, ShuffledPerFov, nan(numel(corPerFov),1));
plotSpread(C, 'distributionColors', [0.5 0.5 0.5])
set(findall(4409,'type','line','color',[0.5 0.5 0.5]),'markerSize',15);
hold on
errorbar([0 nanmean(corPerFov) nanmean(ShuffledPerFov) 0], SEM, 'Color', 'k',...
    'LineStyle','none', 'LineWidth', 2)
hold on
ylim([-0.6, 1.1])
yticks(-1:0.4:1)
hold off
[p, s] = ttest(corPerFov(~isnan(corPerFov)), ShuffledPerFov(~isnan(ShuffledPerFov)));




%% FIGURE 1 - PANEL H - tuft average deltaf

[~, ~, ~, TUFT_meandf_ss, TUFT_meandf_sl, TUFT_meandf_ds, TUFT_meandf_dl] = get_data('tuftmeandfcondi', DatStim, DatDark);

% TUFT_meandf_ss : stim still
% TUFT_meandf_sl : stim locomotion
% TUFT_meandf_ds : dark still
% TUFT_meandf_dl : dark locomotion

meandf_ss = nan(nAnimals,1);
meandf_sl = meandf_ss;
meandf_ds = meandf_ss;
meandf_dl = meandf_ss;

for iAnimal = 1:nAnimals
    
    is_animal = strcmp(TUFT_animals, TUFT_list_animals{iAnimal});
    list_fovs = unique(TUFT_fovnames, 'stable');
    nFovs = length(list_fovs);
    
    fov_meandf = nan(nFovs, 4);
    
    for iFov = 1:nFovs
        
        is_fov = is_animal & strcmp(TUFT_fovnames, list_fovs{iFov});
        
        fov_meandf(iFov, :) = [...
            nanmean(TUFT_meandf_ss(is_fov)), nanmean(TUFT_meandf_sl(is_fov)), ...
            nanmean(TUFT_meandf_ds(is_fov)), nanmean(TUFT_meandf_dl(is_fov))];
        
        
    end
    meandf_ss(iAnimal)=nanmean(fov_meandf(:,1));
    meandf_sl(iAnimal)=nanmean(fov_meandf(:,2));
    meandf_ds(iAnimal)=nanmean(fov_meandf(:,3));
    meandf_dl(iAnimal)=nanmean(fov_meandf(:,4));
end


meandf_ss_nrm = meandf_ss./meandf_ss;
meandf_ds_nrm = meandf_ds./meandf_ss;
meandf_sl_nrm = meandf_sl./meandf_ss;
meandf_dl_nrm = meandf_dl./meandf_ss;



figure(4518)
bar([nanmean(meandf_ss_nrm) nanmean(meandf_ds_nrm)...
    nanmean(meandf_sl_nrm) nanmean(meandf_dl_nrm)], 'r');
SEM = [nanstd((meandf_ss_nrm))./sqrt(length(meandf_ss_nrm))...
    nanstd((meandf_ds_nrm))./sqrt(length(meandf_ds_nrm))...
    nanstd((meandf_sl_nrm))./sqrt(length(meandf_sl_nrm))...
    nanstd((meandf_dl_nrm))./sqrt(length(meandf_dl_nrm))];
hold on
C = cat(2, meandf_ss_nrm, meandf_ds_nrm, meandf_sl_nrm, meandf_dl_nrm);
plotSpread(C, 'distributionColors', 'k')
set(findall(4518,'type','line','color','k'),'markerSize',15)
% for ii=1:length(df_ss_animal_nrm)
%   scatter([1:4],[df_ss_animal_nrm(ii),df_ds_animal_nrm(ii), df_sl_animal_nrm(ii),df_dl_animal_nrm(ii)],'MarkerEdgeColor', 'k',...
%               'MarkerFaceColor',[0.7 .7 .7], 'jitter', 'on', 'jitterAmount', 0.07)
% end
errorbar([nanmean(meandf_ss_nrm) nanmean(meandf_ds_nrm)...
    nanmean(meandf_sl_nrm) nanmean(meandf_dl_nrm)]...
    , SEM, 'Color', 'k', 'LineWidth', 2, 'LineStyle','none'); 
hold off



%% FIGURE 1 - PANEL I - tuft peaks correlation per condition


do_shuffle = false;
corPerFov_states = cell(nAnimals, 4);

for iAnimal = 1:nAnimals
    
    is_animal = strcmp(TUFT_animals, TUFT_list_animals{iAnimal});
    
    corPerFov_states{iAnimal, 1} = compute_FOVtuft_peak_corr(TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), peaks_loc{iAnimal}, peaks_thresh{iAnimal}, do_shuffle, ...
        TUFT_stim_act_state.stimstill(is_animal));
    % corPerFov{iAnimal} : nan(nFovs, 1)
    
    corPerFov_states{iAnimal, 2} = compute_FOVtuft_peak_corr(TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), peaks_loc{iAnimal}, peaks_thresh{iAnimal}, do_shuffle, ...
        TUFT_stim_act_state.stimloco(is_animal));
    
    corPerFov_states{iAnimal, 3} = compute_FOVtuft_peak_corr(TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), peaks_loc{iAnimal}, peaks_thresh{iAnimal}, do_shuffle, ...
        TUFT_stim_act_state.darkstill(is_animal));
    
    corPerFov_states{iAnimal, 4} = compute_FOVtuft_peak_corr(TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), peaks_loc{iAnimal}, peaks_thresh{iAnimal}, do_shuffle, ...
        TUFT_stim_act_state.darkloco(is_animal));
    
end
corPerFov_states = cell2mat({corPerFov_states}); % [nAnimals*nFovs_tot x 4]
% 1 : stim still
% 2 : stim locomotion
% 3 : dark still
% 4 : dark locomotion


figure(90909)
bar([nanmean(corPerFov_states(:,1)) nanmean(corPerFov_states(:,3)) nanmean(corPerFov_states(:,2)) nanmean(corPerFov_states(:,4))], 'r')
hold on
SEM = [nanstd(corPerFov_states(:,1))./sqrt(sum(~isnan(corPerFov_states(:,1)))) ...
    nanstd(corPerFov_states(:,3))./sqrt(sum(~isnan(corPerFov_states(:,1)))) ...
    nanstd(corPerFov_states(:,2))./sqrt(sum(~isnan(corPerFov_states(:,1)))) ...
    nanstd(corPerFov_states(:,4))./sqrt(sum(~isnan(corPerFov_states(:,1))))];
hold on
C = cat(2, corPerFov_states(:,1), corPerFov_states(:,3), corPerFov_states(:,2), corPerFov_states(:,4));
plotSpread(C, 'distributionColors', 'k')
set(findall(90909,'type','line','color','k'),'markerSize',15);
ylim([0 1.1])
hold on
errorbar([nanmean(corPerFov_states(:,1)) nanmean(corPerFov_states(:,3)) nanmean(corPerFov_states(:,2)) nanmean(corPerFov_states(:,4))], SEM, 'Color', 'k', 'LineWidth', 2, 'LineStyle','none')
hold off


%% FIGURE 1 - PANEL J - tuft peaks - branch-specific events


k_dfthresh = 1; % here we apply the normal threshold 

coincident_peaks = cell(nAnimals, 1);
noncoincident_peaks = cell(nAnimals, 1);
coincident_peaks_states = cell(nAnimals, 4);
noncoincident_peaks_states = cell(nAnimals, 4);

pr_p_animal = nan(nAnimals,1);
w_p_animal = nan(nAnimals,1);

for iAnimal = 1:nAnimals
    
    is_animal = strcmp(TUFT_animals, TUFT_list_animals{iAnimal});
    
    % All conditions
    [coincident_peaks{iAnimal}, noncoincident_peaks{iAnimal}] = get_FOVtuft_coincident_peaks(...
        TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), ...
        peaks_loc{iAnimal}, peaks_A{iAnimal}, peaks_thresh{iAnimal}, ...
        [], k_dfthresh);
    
    
    w_p_animal(iAnimal) = length(cat(1, coincident_peaks{iAnimal}, noncoincident_peaks{iAnimal}));
    pr_p_animal(iAnimal)= length(coincident_peaks{iAnimal})/w_p_animal(iAnimal);
    

    % Per condition
    % 1 : stim still
    % 2 : stim locomotion
    % 3 : dark still
    % 4 : dark locomotion
    
    [coincident_peaks_states{iAnimal,1}, noncoincident_peaks_states{iAnimal,1}] = get_FOVtuft_coincident_peaks(...
        TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), ...
        peaks_loc{iAnimal}, peaks_A{iAnimal}, peaks_thresh{iAnimal}, ...
        TUFT_stim_act_state.stimstill(is_animal), k_dfthresh);
    
    [coincident_peaks_states{iAnimal,2}, noncoincident_peaks_states{iAnimal,2}] = get_FOVtuft_coincident_peaks(...
        TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), ...
        peaks_loc{iAnimal}, peaks_A{iAnimal}, peaks_thresh{iAnimal}, ...
        TUFT_stim_act_state.stimloco(is_animal), k_dfthresh);
    
    [coincident_peaks_states{iAnimal,3}, noncoincident_peaks_states{iAnimal,3}] = get_FOVtuft_coincident_peaks(...
        TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), ...
        peaks_loc{iAnimal}, peaks_A{iAnimal}, peaks_thresh{iAnimal}, ...
        TUFT_stim_act_state.darkstill(is_animal), k_dfthresh);
    
    [coincident_peaks_states{iAnimal,4}, noncoincident_peaks_states{iAnimal,4}] = get_FOVtuft_coincident_peaks(...
        TUFT_df(is_animal), TUFT_fs(is_animal), TUFT_fovnames(is_animal), ...
        peaks_loc{iAnimal}, peaks_A{iAnimal}, peaks_thresh{iAnimal}, ...
        TUFT_stim_act_state.darkloco(is_animal), k_dfthresh);
    
    
end


% * Histogram of all DF events
figure(1712)

histogram(max(cat(1, cat(1,coincident_peaks{:}), cat(1,noncoincident_peaks{:})), 0.05), 20, 'BinEdges',0:0.05:1, 'FaceColor','k', 'normalization', 'probability', 'EdgeColor', [0.7 0.7 0.7] )

yticks(0:0.1:0.2)
ylim([0 0.2])
xlim([0 1])
box off
hold off


% * Percentage of Branch-specific events per condition
figure(1115)

hold on

% 1 : stim still
line_c = [224/255 111/255 1]; marker_c = line_c;
plot_p_specific_events(coincident_peaks_states(:,1), noncoincident_peaks_states(:,1), line_c, marker_c);

% 3 : dark still
line_c = [221/255 221/255 221/255]; marker_c = line_c;
plot_p_specific_events(coincident_peaks_states(:,3), noncoincident_peaks_states(:,3), line_c, marker_c);

% 2 : stim locomotion
line_c = [100/255 0 112/255]; marker_c = line_c;
plot_p_specific_events(coincident_peaks_states(:,2), noncoincident_peaks_states(:,2), line_c, marker_c);

% 4 : dark locomotion
line_c = [100/255 100/255 100/255]; marker_c = line_c;
plot_p_specific_events(coincident_peaks_states(:,4), noncoincident_peaks_states(:,4), line_c, marker_c);

ylim([0 1])
xlim([0 1.2])
yticks(0:0.2:1)



% * Pie chart
figure(1711)
 
wproduct = pr_p_animal.*w_p_animal;
wsumw = nansum(wproduct,1);
wmeanw =wsumw./sum(w_p_animal,1);

pie([wmeanw , 1-wmeanw])

