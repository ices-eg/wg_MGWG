library(tidyverse)
### These development versions are required
## devtools::install_github("ss3sim/ss3sim", ref='development')
## devtools::install_github("r4ss/r4ss")
library(ss3sim)
library(r4ss)
## Can run scenarios or replicates in parallel
library(doParallel)
registerDoParallel(cores = parallel::detectCores()-1)
library(foreach)
getDoParWorkers() # check how many cores are registered

## !!!! Assumes working directory is the location of this script !!!!
getwd()
source('functions.R')

## Set up the case files which are constant for both models
case_folder <- "cases"
case_files <- list(F="F", D=c("index", "lcomp", "agecomp"),
                    E="E", O="O")

## A run with deterministic process error for exploring
## equilibrium behavior of the OM. Only need 1 iteration b/c no
## process error
scens <- c("D0-E100-F0-O0-cod", "D0-E100-F1-O1-cod")
unlink(scens, recursive = TRUE)
om <- file.path(getwd(), "models", "cod-om")
em <- file.path(getwd(), "models", "cod-em")
devs <- matrix(0, nrow=101, ncol=1)
run_ss3sim(iterations = 1, scenarios=scens,
           case_folder = case_folder, case_files = case_files,
           om_dir = om, em_dir = em, parallel=TRUE,
           bias_adjust = FALSE,
           user_recdevs = devs)
## Read in results and quick plot of OM biomass trajectories
out <- get_results_all(overwrite_files=TRUE)
ts.cod.equil <- read.csv('ss3sim_ts.csv')
plot_ts_lines(ts.cod.equil, y='SpawnBio_om')
## r4ss pulls in the numbers at age for population
report1 <- SS_output('D0-E100-F0-O0-cod/1/om', ncols=300)
report2 <- SS_output('D0-E100-F1-O1-cod/1/om', ncols=300)
## makes full output inside the report folder
SS_plots(report1, uncertainty=FALSE, plot=1:24)
SS_plots(report2, uncertainty=FALSE, plot=1:24)
## Get population length structure
d1 <- get_poplengthfreq(report1)
d2 <- get_poplengthfreq(report2)
d.cod <- rbind(cbind(spp='cod', M='Original', d1), cbind(spp='cod', M='Updated', d2))

## Repeat with yellow eye rockfish models
scens <- c("D0-E100-F0-O0-yellow", "D0-E100-F1-O1-yellow")
unlink(scens, recursive = TRUE)
om <- file.path(getwd(), "models", "yellow-om")
em <- file.path(getwd(), "models", "yellow-em")
devs <- matrix(0, nrow=500, ncol=1)
run_ss3sim(iterations = 1, scenarios=scens,
           case_folder = case_folder, case_files = case_files,
           om_dir = om, em_dir = em, parallel=TRUE,
           bias_adjust = FALSE,
           user_recdevs = devs)
## Read in results and quick plot of OM biomass trajectories
out <- get_results_all(overwrite_files=TRUE)
ts.yellow.equil <- read.csv('ss3sim_ts.csv')
plot_ts_lines(ts.yellow.equil, y='SpawnBio_om', horiz='species')
## r4ss pulls in the numbers at age for population
report1 <- SS_output('D0-E100-F0-O0-yellow/1/om', ncols=300)
report2 <- SS_output('D0-E100-F1-O1-yellow/1/om', ncols=300)
## makes full output inside the report folder
SS_plots(report1, uncertainty=FALSE, plot=1:24)
SS_plots(report2, uncertainty=FALSE, plot=1:24)
## Get population length structure
d1 <- get_poplengthfreq(report1)
d2 <- get_poplengthfreq(report2)
d.yellow <- rbind(cbind(spp='yellow', M='Original', d1), cbind(spp='yellow', M='Updated', d2))

## Quick plot to check equilibrium length at age when fished at FMSY
d.equil <- rbind(d.yellow, d.cod)
g <- d.equil %>% group_by(spp) %>%
  filter(Yr==max(Yr) & length >5) %>%
  ggplot( aes(length, numbers, color=M)) + geom_line() +
  facet_wrap('spp', scales='free') + theme_bw()
ggsave('equilibrium_length_dist.png', g, width=7, height=5, units='in')


