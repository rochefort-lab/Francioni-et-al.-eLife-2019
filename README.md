# Francioni, Padamsey, Rochefort, eLife 2019
MATLAB code from the Rochefort lab used for analysis in this paper.

## General notes
- The functions used for analysis are defined in two files, **getFuncHandleRec.m** or **getFuncHandleRGroup.m**. 
These files can be found in the folder **\analysis**.
The analysis functions may call other specific functions (e.g. compute_lmi.m), which can be found in **\analysis\projectfunctions**, 
as well as utilities tools (e.g. for data handling) which are in the folder **\analysis\utilities**.
- Code downloaded from external sources can be found in the folder **\external** (licence in corresponding folder).
- The documentation for each function can be found in the corresponding matlab files.

Below are the functions used for each figure in the paper. 
Letters on the left indicate the corresponding panel within each figure.

## Figure 1
   D,F,H,I,J) Apical_tuft_main 
   
## Figure 2
   D) Compartments_main
   
## Figure 3
   B-C) Compartments_main 
    
## Figure 4
   exVivo_Extraction&Analysis.m
   
   ReadImageJRoi.m (external)

## Figure 5
   A) Compartments_main 
   B,D) Compartments_conditions 
   
## Figure 6
   D) Apical_tuft_main 
   E-K) Visual_stim_analysis
   L) Visual_stim_analysis
   M) Visual_compartments 
    
## Figure 1 - supplementary 2
   B) Apical_tuft_main 
   C) Compartments_main 
   D) Times_Apical_tuft 
   E) Times_Apical_tuft 
   F) Times_Compartments 
    
## Figure 2 - supplementary 2
   B) Compartments_main
 
## Figure 3 - supplementary 1
   B) Compartments_main 
   C) Apical_tuft_main 

## Figure 5 - supplementary 1
   A) Compartments_conditions 
   B) Compartments_conditions 

## Figure 5 - supplementary 2
   A) Times_Compartments
