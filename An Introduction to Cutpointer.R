##Installation
install.packages("cutpointr")
#For example, the optimal cutpoint for the included data set is 2 when maximizing the sum of sensitivity and specificity.

## calling the library
library(cutpointr)

## Attaching the data set for analysis
data(suicide)

## Checking first few observations in the data set
head(suicide)



cp <- cutpointr(suicide, dsi, suicide, 
                method = maximize_metric, metric = sum_sens_spec)

summary(cp)

plot(cp)

opt_cut <- cutpointr(suicide, dsi, suicide, direction = ">=", pos_class = "yes",
                     neg_class = "no", method = maximize_metric, metric = youden)

plot_metric(opt_cut)


##Predictions for new data can be made using predict:
predict(opt_cut, newdata = data.frame(dsi = 0:5))





##Separate subgroups and bootstrapping
set.seed(12)
opt_cut_b <- cutpointr(suicide, dsi, suicide, boot_runs = 1000)
opt_cut_b
opt_cut_b$boot
summary(opt_cut_b)

plot(opt_cut_b)



##Parallelized bootstrapping
library(doParallel)
cl <- makeCluster(2) # 2 cores
registerDoParallel(cl)
registerDoRNG(12) # Reproducible parallel loops using doRNG
opt_cut <- cutpointr(suicide, dsi, suicide, gender, pos_class = "yes",
                     direction = ">=", boot_runs = 1000, allowParallel = TRUE)
stopCluster(cl)
opt_cut

##Finding all cutpoints with acceptable performance
library(tidyr)
library(dplyr)
opt_cut <- cutpointr(suicide, dsi, suicide, metric = sum_sens_spec, 
                     tol_metric = 0.05, break_ties = c)
  

opt_cut |> 
  select(optimal_cutpoint, sum_sens_spec) |> 
  unnest(cols = c(optimal_cutpoint, sum_sens_spec))


##Manual and mean / median cutpoints
set.seed(100)
opt_cut_manual <- cutpointr(suicide, dsi, suicide, method = oc_manual, 
                            cutpoint = mean(suicide$dsi), boot_runs = 1000)
set.seed(100)
opt_cut_mean <- cutpointr(suicide, dsi, suicide, method = oc_mean, boot_runs = 1000)


##Nonstandard evaluation via tidyeval
myvar <- "dsi"
cutpointr(suicide, !!myvar, suicide)

##Midpoints
dat <- data.frame(outcome = c("neg", "neg", "neg", "pos", "pos", "pos", "pos"),
                  pred    = c(1, 2, 3, 8, 11, 11, 12))

dat <- data.frame(outcome = c("neg", "neg", "neg", "pos", "pos", "pos", "pos"),
                  pred    = c(1, 2, 3, 8, 11, 11, 12))

plot_x(opt_cut)