# 0_functions.r
# some functions used in analyses

# remember to set the working directory to source file location to begin

library(ggplot2)  # pretty plots
library(dplyr)    # data wrangling
library(tidyr)    # data wrangling

# function to get random recruitments from series of estimated values
get_rand_recruits <- function(recruits, nsamps){
  recruits <- sort(as.numeric(recruits))
  nrecs <- length(recruits) - 1 # there are n-1 intervals from the n recruitment values
  cdf <- c(0, (1:nrecs) / nrecs)
  yy <- seq(1, (nrecs + 1))
  rr <- runif(nsamps)
  rand_recruits <- rep(NA, nsamps)
  for (i in 1:nsamps){
    tt <- cdf - rr[i]
    xx <- min(tt[tt >= 0])
    zz <- yy[tt == xx]
    rand_recruits[i] <- recruits[zz-1] + nrecs * (recruits[zz] - recruits[zz-1]) * (rr[i] - cdf[zz-1])
  }
  return(rand_recruits)
}

# function to calculate catch from N, M, Fmult, selectivity, and weight at age
get_catch <- function(Nadj, Mvec, Selvec, Catchwt, Fmult){
  Zvec <- Mvec + Fmult * Selvec
  mycatch <- sum(Catchwt * Nadj * Fmult * Selvec * (1 - exp(-Zvec)) / Zvec)
  return(mycatch)
}

# function to compute F to achieve catch given N, M, selectivity, and waa, includes check for F=0 and maxF
get_Fmult <- function(Nadj, Mvec, Selvec, Catchwt, target_catch, maxF){
  if (target_catch == 0) return(0)
  
  # check for maxF
  catchMaxF <- get_catch(Nadj, Mvec, Selvec, Catchwt, maxF)
  if (catchMaxF < target_catch) return(maxF)
  
  # bisection search for Fmult
  AA <- 0.0
  BB <- maxF
  for (iloop in 1:30){
    CC <- (AA + BB) / 2
    thiscatch <- get_catch(Nadj, Mvec, Selvec, Catchwt, CC)
    if (thiscatch > target_catch){
      BB <- CC
    }else{
      AA <- CC
    }
  }
  return(CC)
}
