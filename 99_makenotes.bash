mkdir -p notes
3dNotes "$(printf "%s\n" ../1*/*/analysis/glm_hrf_coefs.nii.gz|sed 1q)" > notes/glm_href_coefs_example.log
