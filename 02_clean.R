library(dplyr)
library(tidyr)

## read data: can't find original roi annotatoins. getting age and sex from old file
roilab <- read.table('roi_labels_cm-whereami.txt',header=F,comment.char="",
                     col.names=c("roinum","x","y","z","atlas","dist_from","label","MPM","val"))

age_sex <- read.table('../VoxelwiseHLM//oldTxt/listage.txt',
                      col.names=c("id","visit","age", "sex"),
                      # leading zero is important!
                      colClass=c(visit="character")) %>%
   mutate(sex=ifelse(sex==1,"M","F"), age=round(age,1))

d <- read.table('roistats.txt',sep="\t", comment.char="",header=T)

## reshape rois: afni 3dROIStats is neither fully wide nor long
d_clean <- d %>%
   select(-X,-X.1) %>%
   filter(grepl('\\[(AS|VGS)', name)) %>%
   mutate(name=gsub('/analysis.*\\[','/',name) %>% gsub('#.*|]','',.)) %>%
   separate(name,c('id','visit','contrast'))

d_long <- d_clean %>%
   pivot_longer(matches('^NZ'))  %>%
   separate(name, c("metric","roinum")) %>%
   merge(roilab %>% select(roinum,label), by="roinum") %>%
   mutate(roinum=as.numeric(roinum))

d_semilong <- d_long %>%
   pivot_wider(id_cols=c("id","visit","contrast","roinum","label"),names_from="metric") %>%
   merge(age_sex, by=c("id","visit"),all.y=F)

d_mean_only <- d_semilong %>%
   select(id,visit,age,sex,contrast,roinum,label,NZMean) %>%
   pivot_wider(names_from="contrast",values_from="NZMean")

write.csv(file="glm_allmeaures_long.csv", d_long)
write.csv(file="glm_means.csv", d_mean_only)

#> Thus, a total of 312 visits from 129 individuals spanning ages 8.1 to 28.9 years were included in initial statistical analyses
