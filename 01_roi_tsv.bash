roiatlas=../ROIs/ROImask_all.nii.gz 
i=1
if [ ! -r  roi_labels_cm-whereami.txt ]; then 
  mapfile -t xyzs < <(3dCM -all_rois $roiatlas |sed 1,3d|grep -v '#')
  for xyz in "${xyzs[@]}"; do
    echo "$((i++)) $xyz $(whereami -atlas CA_ML_18_MNI -tab $xyz | grep -m1 ^CA)"
  done | tee roi_labels_cm-whereami.txt
fi
# NB. 3dCM is RAI not LPI. use -1*x and -1*y to match to paper 
# 1 -25.5 1.5 58.5 CA_ML_18_MNI 0.0 Right_Superior_Frontal_Gyrus MPM 4
# 2 25.5 1.5 55.5 CA_ML_18_MNI 0.0 Left_Superior_Frontal_Gyrus MPM 3
# 3 1.5 4.66364 61.6636 CA_ML_18_MNI 0.0 Left_SMA MPM 19
# 4 1.5 -4.5 52.5 CA_ML_18_MNI 0.0 Left_SMA MPM 19
# 5 -31.5 55.5 46.5 CA_ML_18_MNI 0.0 Right_Angular_Gyrus MPM 66
# 6 31.5 49.5 49.5 CA_ML_18_MNI 0.0 Left_Inferior_Parietal_Lobule MPM 61
# 7 -25.3929 -1.44643 4.5 CA_ML_18_MNI 0.0 Right_Putamen MPM 74
# 8 24.9808 -4.5 4.67307 CA_ML_18_MNI 0.0 Left_Putamen MPM 73
# 9 -40.3937 -16.4882 40.5236 CA_ML_18_MNI 0.0 Right_Middle_Frontal_Gyrus MPM 8
# 10 40.4883 -19.5234 40.5352 CA_ML_18_MNI 0.0 Left_Middle_Frontal_Gyrus MPM 7
# 11 -49.5 -10.5 22.5 CA_ML_18_MNI 0.0 Right_Inferior_Frontal_Gyrus_(p._Opercularis) MPM 12
# 12 46.5 -10.5 22.5 CA_ML_18_MNI 0.0 Left_Inferior_Frontal_Gyrus_(p._Opercularis) MPM 11
# 13 0 73.5 4.5 CA_ML_18_MNI 0.0 Left_Lingual_Gyrus MPM 47
# 14 -40.5 -10.5 1.5 CA_ML_18_MNI 0.0 Right_Insula_Lobe MPM 30
# 15 40.5 -4.5 -1.5 CA_ML_18_MNI 0.0 Left_Insula_Lobe MPM 29
# 16 -22.5 58.5 -28.5 CA_ML_18_MNI 2.0 Right_Cerebellum_(VI) MPM 100
# 17 28.5 55.5 -31.5 CA_ML_18_MNI 0.0 Left_Cerebellum_(VIII) MPM 103
# 18 1.5 -19.5 40.5 CA_ML_18_MNI 0.0 Left_SMA MPM 19


# 'cd ..' and remove .. form roiatlas b/c
# originally had this script at top level and
# want to keep .. out of ../1*/*/analsyis* so R clean code stays the same
(cd ..; 3dROIstats -1DRformat -mask "${roiatlas/..\//}" -nomeanout -nzmean -nzsigma -nzvoxels 1*/*/analysis/glm_hrf_coefs.nii.gz) > roistats.txt

# from https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3828464/
# corrected error trials has most sig slope for dACC (roi #18)
# from table in paper
#   dACC	0.0	19.5	40.5	10	107
#
#
#> Thus, a total of 312 visits from 129 individuals spanning ages 8.1 to 28.9 years were included in initial statistical analyses
