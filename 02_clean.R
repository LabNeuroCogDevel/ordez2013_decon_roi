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

library(ggplot2)
d_mean_only %>%
   #filter(roinum %in% c(9,10)) %>%
   ggplot() +
   aes(y=AScorr, x=age, color=sex, group=`id`) +
   #geom_point() + geom_line() +
   geom_smooth(aes(group=NULL)) +
   facet_wrap(~roinum) +
   see::theme_modern()


d_mean_only %>% split(.$roinum) %>% lapply(function(x) coef(summary(lm(age~ASerrorCo,data=x))))#[2,"Pr(>|t|)"]) 

# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3828464/
# >Mean growth curve for error processing (dACC during corrected error trials) indicates increases in the percentage of signal change with age.
FEF_L <- d_mean_only %>% filter(roinum==2) # > p=.029 in ordez 2013
dACC <- d_mean_only %>% filter(roinum==18) # > p=.000 in ordez 2013
m <- lme4::lmer(age~ASerrorCo + (1|id),data=dACC)
summary(m)
