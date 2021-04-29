# Francioni, Padamsey, Rochefort, eLife 2019
MATLAB code from the Rochefort lab used for analysis in this paper.

## General notes
- The code in the folder **/Peaks_functions** includes functions used to find peaks in deltaf traces (**detect_df_peaks.m**), 
extract the peak deltaf window (**get_peakwindow_df.m**) and peaks coincidence between two compartments (**get_coincident_events.m**). 
- A practical example is given for the apical tuft results presented in Figure 1 (**main_fig1.m** and **/Fig1_functions** folder). 
For all remaining figures, except for **_Electrophysiology_ in Figure 4**, we refer to the relevant panels in Figure 1 
which implement the same method.
- The analysis functions may call other specific functions in the folder **/Utilities**, e.g. for data handling or plot.
- Code downloaded from external sources can be found in the folder **/external** (licence in corresponding folder).

Below are the functions used for each figure in the paper. 
Letters on the left indicate the corresponding panel within each figure.

## Data repository
Repository for electrophysiological and anatomical data included in the article:

https://datashare.ed.ac.uk/handle/10283/3873

## 3D Reconstructions of the neurons
The 3D reconstructions of 19 neurons included in the manuscript are freely available at:

http://neuromorpho.org/KeywordResult.jsp?count=19&keywords=%22rochefort%22

## Figure 1
The main functions and plot scripts for each panel are called in **main_fig1.m**.

    D) get_FOVtuft_peaks.m, detect_df_peaks.m, compute_FOVtuft_peak_corr.m (calls get_peakwindow_df.m)
    F) see panel D
    I) get_FOVtuft_peaks.m, detect_df_peaks.m, compute_FOVtuft_peak_corr.m (calls get_peakwindow_df.m)
    J) get_FOVtuft_peaks.m, detect_df_peaks.m, get_FOVtuft_coincident_peaks.m (calls get_coincident_events.m)  
    
## Figure 1 - supplementary 2
For each panel see Fig1 panel J. 

The same method is applied for various compartments, 
and two parameters can vary when calling **get_FOVtuft_coincident_peaks.m**:
(i) the peak detection threshold (*k_dfthresh*) and (ii) the peak window size (*k_window*) 

	B,C) see Fig1 panel J, vary peak detection threshold
	E,F) see Fig1 panel J, vary peak window size
   
## Figure 2
    D) see Fig1 panel D, between planes
    
## Figure 2 - supplementary 2
    B) see Fig1 panel J
    
## Figure 3
    B) get the frequency of events using detect_df_peaks.m ; see get_FOVtuft_peaks.m at the start of main_fig1.m
    C) see Fig1 panel J, between planes
    
## Figure 3 - supplementary 1
    B) see Fig1 panel J
    C) get the frequency of events using detect_df_peaks.m ; see get_FOVtuft_peaks.m at the start of main_fig1.m
    
## Figure 4 & Figure 4 supplementary 1
    exVivo_Extraction_Analysis.m 
    ReadImageJRoi.m (external)
    
    Data available as xlsx tables in folders /Fig4_Data and /Fig4S1_Data

## Figure 5
    A,B) see Fig1 panel J, between planes; vary condition (stim_action_state)

## Figure 5 - supplementary 1 & 2
    S1-A,B; S2-A) see Fig1 panel J, between planes; vary condition (stim_action_state)

## Figure 6
    D,L,M) see Fig1 panel D; select deltaf during specific stimulation (e.g. preferred orientation)
