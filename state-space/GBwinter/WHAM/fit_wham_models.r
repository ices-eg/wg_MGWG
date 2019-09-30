#write.dir = "~/work/ICES/MGWG/MGWG/state-space/CCGOMyt/WHAM"
write.dir = "./"
user.wd <- "../" #"~/work/ICES/MGWG/SS_vs_SCAA/R/ccgomyt/"
user.od <- write.dir
model.id <- "GBwinter"
ices.id = "GBWINTER_"
Fbar.ages = 4:6

library(TMB)
library(wham)
library(dplyr)
library(tidyr)
source("../../helper_code/convert_ICES_to_ASAP.r")
source("../../helper_code/wham_tab1.r")
source("../../helper_code/wham_tab2.r")
source("../../helper_code/wham_predict_index.r")
source("../../helper_code/wham_write_readme.r")
source("../../helper_code/wham_make_model_input.r")

# convert Lowestoft input files to vanilla ASAP
ICES2ASAP(user.wd, user.od, model.id = model.id, ices.id= ices.id)

asap3 = read_asap3_dat(paste0("ASAP_", model.id,".dat"))
file.remove(paste0("ASAP_", model.id,".dat"))
x = prepare_wham_input(asap3, model_name = model.id)
x$data$Fbar_ages = Fbar.ages

age.specific = 3
not.age.specific = (1:x$data$n_selblocks)[-age.specific]
x = set_age_sel0(x, age.specific)
x$par$logit_selpars[not.age.specific,c(1:x$data$n_ages,x$data$n_ages + 3:6)] = Inf
x$par$logit_selpars[3,1] = Inf
x$map$logit_selpars = matrix(x$map$logit_selpars, x$data$n_selblocks, x$data$n_ages + 6)
x$map$logit_selpars[is.infinite(x$par$logit_selpars)] = NA
x$map$logit_selpars[!is.infinite(x$par$logit_selpars)] = 1:sum(!is.infinite(x$par$logit_selpars))
x$map$logit_selpars = factor(x$map$logit_selpars)
base = x

#SCAA, but with random effects for recruitment and index observation error variances fixed
m1 <- fit_wham(make_m1())
#Like m1, but change age comp likelihoods to logistic normal
m2 <- fit_wham(make_m2())
#full state-space model, abundance is the state vector
m3 <- fit_wham(make_m3())
#Like m3, but change age comp likelihoods to logistic normal
m4 <- fit_wham(make_m4())

res <- compare_wham_models(list(m1=m1, m2=m2, m3=m3, m4=m4), fname="model_compare", sort = FALSE)

#3-year projection for best model
wham_predict_index()

#Describe what we did for model 4
best = "m4"
wham_write_readme()
