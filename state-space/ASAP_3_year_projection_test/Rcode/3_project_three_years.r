source("2_get_recent_average_info.r")

# 3_project_three_years.r
# conduct stochastic projections for the three dropped years based on observed catch

# remember to set working directory to source file location

# create recruitment in years t+1 and t+2 based on empirical cdf of estimated recruits
nboots <- length(bsn[,1])
nsamps <- nboots * 2
rand_recruits <- get_rand_recruits(recruits, nsamps)
proj.recruits <- matrix(rand_recruits, nrow = nboots, ncol = 2)

# loop through the starting population at age and future recruitment values filling in N at age
# note: N.age.mat has the three age vectors for each bootstrap in a single row
nages <- asap$parms$nages
N.age.mat <- matrix(NA, nrow = nboots, ncol = nages * 3)
Fmult.mat <- matrix(NA, nrow = nboots, ncol = 3)

for (iboot in 1:nboots){
  Nstart <- bsn[iboot,]
  
  # apply retro adjustment here
  Nadj <- as.numeric(Nstart / (1 + mohns.rho))
  N.age.mat[iboot, 1:nages] <- Nadj
  
  ### important user selection ###
  maxF <- 2
  
  # loop through the projection years
  for (iyear in 1:3){
    Fmult <- get_Fmult(Nadj, Mvec, Selvec, Catchwt, catch3proj[iyear], maxF)
    Fmult.mat[iboot, iyear] <- Fmult
    if (iyear <= 2){
      Zvec <- Mvec + Fmult * Selvec
      Nnext <- rep(NA, nages)
      Nnext[1] <- proj.recruits[iboot, iyear]
      for (iage in 2:nages){
        Nnext[iage] <- Nadj[iage - 1] * exp(-Zvec[iage - 1])
      }
      Nnext[nages] <- Nnext[nages] + Nadj[nages] * exp(-Zvec[nages])
      Nadj <- Nnext
      countage <- nages * iyear + 1
      N.age.mat[iboot, countage:(countage + nages - 1)] <- Nadj
    }
  }
}

# summary of N and F projection matrices
# need to expand this to count number of times Fmax was used
summary(N.age.mat)
summary(Fmult.mat)
