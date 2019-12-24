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
    Functions used: upper panel, VRsuccessRate; lower panel, successRateSMI_VR.
## Figure 2
    Functions used: pairedTestGratVSrwdZone
    Functions used: tempMatchVR_HitMiss
    Functions used: pairedTestGratVSrwdZone; successRateSMI_VR.
## Figure 3
    B) Functions used: VRsuccessRate
    C) Functions used: pairedTestGratVSrwdZone; binnedVRDataHit; binnedVRDataMiss 
    D) Functions used: tempMatchVR_RZ_CuedUncued
    E-F) Mean calcium activity for gain modulated and normal trials. Functions used: gainModVRData
## Figure S1
    B-C) Division of response categories and example calcium traces. Functions used: pairedTestGratVSrwdZone; lmiVR; TestLicksVSnonLickPreRwd
## Figure S2 
    A) Functions used: trialTime
    D) Functions used: peakVarByOnset
    E) Functions used: slowMedfastTrials
    F) Functions used: mancovaVR; mancovaVRshuffDist
