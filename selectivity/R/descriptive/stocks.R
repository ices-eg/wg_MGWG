options(stringsAsFactors=FALSE)

## Import stocks

owd <- setwd("../stocks")
source("greenland.R")
source("iceland.R")
source("ne_arctic.R")
source("norway.R")
source("faroe_plateau.R")
source("s_celtic.R")
source("irish_sea.R")
source("north_sea.R")
source("w_baltic.R")
setwd(owd)

rm(ages, B, BPR, C, cohortBiomass, Cp, dims, Fmort, M, mat, N, Ninit, owd, path,
   plus, read, S, stdplot, wcatch, wstock, yrs)

## source("georges_bank.R")
## source("gulf_of_maine.R")
## source("nafo_2j3kl.R")
## source("nafo_3m.R")
## source("nafo_3no.R")
## source("nafo_3ps.R")
