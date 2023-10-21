## Import stocks

# Read stocks
# owd <- setwd("../../stocks")
owd <- setwd("../../../../stocks")
source("e_baltic.R")
source("faroe_plateau.R")
source("georges_bank.R")
source("greenland.R")
source("gulf_of_maine.R")
source("iceland.R")
source("irish_sea.R")
source("kattegat.R")
source("nafo_2j3kl.R")
source("nafo_3m.R")
source("nafo_3no.R")
source("nafo_3ps.R")
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("s_celtic.R")
source("w_baltic.R")
setwd(owd)
rm(ages, B, BPR, C, cohortBiomass, Cp, dims, Fmort, M, mat, minage, N, Ninit,
   owd, path, plus, read, S, stdplot, wcatch, wstock, yrs)

# Construct list
stocks <- list(e_baltic=e_baltic,
               e_baltic=e_baltic,
               faroe_plateau=faroe_plateau,
               georges_bank=georges_bank,
               greenland=greenland,
               gulf_of_maine=gulf_of_maine,
               iceland=iceland,
               irish_sea=irish_sea,
               kattegat=kattegat,
               nafo_2j3kl=nafo_2j3kl,
               nafo_3m=nafo_3m,
               nafo_3no=nafo_3no,
               nafo_3ps=nafo_3ps,
               ne_arctic=ne_arctic,
               north_sea=north_sea,
               norway=norway,
               s_celtic=s_celtic,
               w_baltic=w_baltic)

saveRDS(stocks, file="stocks.rds")
