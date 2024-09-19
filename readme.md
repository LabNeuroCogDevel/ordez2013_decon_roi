## Original

 from https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3828464/: 

> Thus, a total of 312 visits from 129 individuals spanning ages 8.1 to 28.9 years were included in initial statistical analyses


> Mean growth curve for error processing (dACC during corrected error trials) indicates increases in the percentage of signal change with age.

## scripts 

| `01_roi_tsv.bash` | extract ROI statistics from voxelwise GLM |
| `02_clean.R`      | rearrange roi stats |

## files

| `ROImask_all.nii.gz` | 18 rois: 2 is FEF-L; 18 is dACC |
| `roi_labels_cm-whereami.txt` | AFNI whereami labels of roi center of mass (RAI [not LPI] x,y,z coordinates) to confirm mask matches paper|
| `roistats.txt` | `3dROIStats` of deconvolved `glm_hrf_coefs` |
| `glm_allmeaures_long.csv` | roistats reshaped: rows for non-zero mean, stdev, and voxel count for each roi in each contract of each visit |
| `glm_means.csv` | roists: oon-zero mean only. columns for each contrast. rows for each visit and each roi |
| `notes/glm_href_coefs_example.log`| afni command history of an example `glm_hrf_coefs` file |
