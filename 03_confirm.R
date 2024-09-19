library(ggplot2)
library(dplyr)

d_mean_only <- read.csv(file="glm_means.csv")
ggplot(d_mean_only) +
   aes(y=AScorr, x=age, color=sex, group=`id`) +
   #geom_point() + geom_line() +
   geom_smooth(aes(group=NULL)) +
   facet_wrap(~roinum) +
   see::theme_modern()


phack <- d_mean_only |> split(d_mean_only$roinum) |> sapply(function(x) coef(summary(lm(ASerrorCo~age,data=x)))[2,"Pr(>|t|)"]) 
#          1           2           3           4           5           6 
#0.084942343 0.035268150 0.020171441 0.008404087 0.048423944 0.080818894 
#          7           8           9          10          11          12 
#0.882050746 0.505183076 0.116633781 0.417744784 0.008076829 0.001209913 
#         13          15          16          17          18 
#0.008943929 0.027526725 0.025300533 0.050947150 0.151677015 


# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3828464/
# >Mean growth curve for error processing (dACC during corrected error trials) indicates increases in the percentage of signal change with age.
FEF_L <- d_mean_only |> filter(roinum==2) # > p=.029 in ordez 2013
dACC <- d_mean_only |> filter(roinum==18) # > p=.000 in ordez 2013
m <- lmerTest::lmer(ASerrorCo ~ age + (1|id),data=dACC)
summary(m)
#Fixed effects:
#              Estimate Std. Error         df t value Pr(>|t|)
#(Intercept) -5.260e-03  1.540e-02  1.310e+02  -0.342    0.733
#age          1.253e-03  8.946e-04  1.326e+02   1.401    0.164

anova(m)
#       Sum Sq   Mean Sq NumDF DenDF F value Pr(>F)
#age 0.0074754 0.0074754     1 132.6   1.962 0.1636
