function plot_p_specific_events(coincident_peaks, noncoincident_peaks, line_c, marker_c)




Prop_tuft_Per_Bin = zeros(length(AllAnimals), 19);
wtuft_Per_Bin     = nan(length(AllAnimals), 19);
Bin = 0.1:0.05:1;
for iAnimal = 1:length(coincident_peaks)
    c = 0;
    nr_all = cat(1, coincident_peaks{iAnimal}, noncoincident_peaks{iAnimal});
    nr_coinci = coincident_peaks{iAnimal};
    for i = 0.1:0.05:1
        if i == 1
            f = 0.1;
        else
            f = 0.05;
        end
        c = c+1;
        Prop_tuft_Per_Bin(iAnimal, c )  = sum(nr_coinci<=i & nr_coinci>(i-f))./sum(nr_all<=i & nr_all>(i-f));
        wtuft_Per_Bin(iAnimal, c ) = sum(nr_all<=i & nr_all>(i-f));
    end

end
wm = wtuft_Per_Bin.*Prop_tuft_Per_Bin;
wsum = nansum(wm,1);
wmean =wsum./sum(wtuft_Per_Bin,1);
wSEM = [];
for i = 1:size(Prop_tuft_Per_Bin,2)
    idx = ~isnan(Prop_tuft_Per_Bin(:,i));
    wSEM(i) = std(Prop_tuft_Per_Bin(idx,i), wtuft_Per_Bin(idx,i))/sqrt(sum(idx));
end

scatter(Bin,1-wmean, 'MarkerFaceColor', marker_c, 'MarkerEdgeColor', 'k')

errorbar(Bin,1-wmean, wSEM, 'Color', line_c,'LineWidth', 3)






end