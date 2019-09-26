library(tidyverse)
library(r4ss)
## devtools::install_github("ss3sim/ss3sim", ref='development')
library(ss3sim)
## An example of a run using parallel processing across 2 cores:
library(doParallel)
registerDoParallel(cores = 4)
library(foreach)
getDoParWorkers() # check how many cores are registered

## !Assumes working directory is the location of this script!
getwd()

## Define locations of the models. Depends on which species for
## now
om <- file.path(getwd(), "models", "cod-om")
em <- file.path(getwd(), "models", "cod-em")
om <- file.path(getwd(), "models", "yellow-om")
em <- file.path(getwd(), "models", "yellow-em")
case_folder <- "cases"
case_files <- list(F="F", D=c("index", "lcomp", "agecomp"),
                    E="E", O="O")

## A run with deterministic process error for exploring
## equilibrium behavior of the OM
 scens <- c("D0-E100-F0-O0-cod", "D0-E100-F0-O1-cod")
scens <- c("D0-E100-F0-O0-yellow", "D0-E100-F0-O1-yellow")
run_ss3sim(iterations = 1, scenarios=scens,
  case_folder = case_folder, case_files = case_files,
  om_dir = om, em_dir = em, parallel=TRUE,
  bias_adjust = FALSE, user_recdevs = matrix(0, nrow = 101, ncol = 2))
##  unlink(scens, recursive = TRUE)

## Read in results and quick plot of OM biomass trajectories
out <- get_results_all(overwrite_files=TRUE)
ts <- read.csv('ss3sim_ts.csv')
sc <- read.csv('ss3sim_scalar.csv')
plot_ts_lines(ts, 'SpawnBio_om', vert='O')

## Get population length distributions over time
## report1 <- SS_output('D0-E100-F0-O0-cod/1/om', ncols=300)
## report2 <- SS_output('D0-E100-F0-O1-cod/1/om', ncols=300)
report1 <- SS_output('D0-E100-F0-O0-yellow/1/om', ncols=300)
report2 <- SS_output('D0-E100-F0-O1-yellow/1/om', ncols=300)
SS_plots(report1, uncertainty=FALSE, plot=1:24)
SS_plots(report2, uncertainty=FALSE, plot=1:24)

get_poplengthfreq <- function(report){
  fd <- report$natlen
  names(fd)[11] <- 'Beg.Mid' ## couldn't get this to work with dplyr
  fd <- fd %>% filter(Beg.Mid=='B') %>%
    select(-Area, -Bio_Pattern, -BirthSeas, -Morph,
           -Seas, -Era, -Sex, -Settlement,
           -Platoon, -Time, -Beg.Mid)

  d <- gather(fd, length, numbers, -Yr) %>%
    group_by(Yr) %>%   mutate(proportion=numbers/sum(numbers)) %>%
    ungroup() %>%
    mutate(length=as.numeric(length),
           decade=Yr-Yr%%10,
           yr2=Yr-decade)
  return(d)
}
d1 <- get_poplengthfreq(report1)
d2 <- get_poplengthfreq(report2)
d <- rbind(cbind(M='Original', d1), cbind(M='Updated', d2))
d %>% filter(Yr==100 & length >15) %>%
ggplot( aes(length, numbers, color=M)) + geom_line()



