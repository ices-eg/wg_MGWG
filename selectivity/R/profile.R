## Effects of alternative selectivity patterns

source("functions/applyFmax.R")
source("functions/applyF0.1.R")
source("functions/prof.R")
source("functions/profPlot.R")
source("functions/slide.R")

## 1  Import

setwd("stocks")
source("faroe_plateau.R")
source("georges_bank.R")
source("gulf_of_maine.R")
source("iceland.R")
source("nafo_2j3kl.R")
source("ne_arctic.R")
source("north_sea.R")
source("w_baltic.R")
setwd("..")

## 2  Apply Fmax

shift <- list(fp=-1:8, gb=-1:8, gm=-1:7, ic=-1:9,
              n2=-1:9, ne=-1:9, ns=-1:9, wb=-1:6)

par(mfrow=c(3,3))
profPlot(faroe_plateau, shift$fp, applyFmax, "Y", c(-1,9), c(0,14))
profPlot(georges_bank,  shift$gb, applyFmax, "Y", c(-1,9), c(0,10))
profPlot(gulf_of_maine, shift$gm, applyFmax, "Y", c(-1,9), c(0,4))
profPlot(iceland,       shift$ic, applyFmax, "Y", c(-1,9), c(0,350))
profPlot(nafo_2j3kl,    shift$n2, applyFmax, "Y", c(-1,9), c(0,100))
profPlot(ne_arctic,     shift$ne, applyFmax, "Y", c(-1,9), c(0,900))
profPlot(north_sea,     shift$ns, applyFmax, "Y", c(-1,9), c(0,100))
profPlot(w_baltic,      shift$wb, applyFmax, "Y", c(-1,9), c(0,35))

par(mfrow=c(3,3))
profPlot(faroe_plateau, shift$fp, applyFmax, "SSB", c(-1,9), c(0,100))
profPlot(georges_bank,  shift$gb, applyFmax, "SSB", c(-1,9), c(0,70))
profPlot(gulf_of_maine, shift$gm, applyFmax, "SSB", c(-1,9), c(0,20))
profPlot(iceland,       shift$ic, applyFmax, "SSB", c(-1,9), c(0,2500))
profPlot(nafo_2j3kl,    shift$n2, applyFmax, "SSB", c(-1,9), c(0,500))
profPlot(ne_arctic,     shift$ne, applyFmax, "SSB", c(-1,9), c(0,7000))
profPlot(north_sea,     shift$ns, applyFmax, "SSB", c(-1,9), c(0,700))
profPlot(w_baltic,      shift$wb, applyFmax, "SSB", c(-1,9), c(0,160))

## 3  Apply F0.1

par(mfrow=c(3,3))
profPlot(faroe_plateau, shift$fp, applyF0.1, "Y", c(-1,9), c(0,14))
profPlot(georges_bank,  shift$gb, applyF0.1, "Y", c(-1,9), c(0,10))
profPlot(gulf_of_maine, shift$gm, applyF0.1, "Y", c(-1,9), c(0,4))
profPlot(iceland,       shift$ic, applyF0.1, "Y", c(-1,9), c(0,350))
profPlot(nafo_2j3kl,    shift$n2, applyF0.1, "Y", c(-1,9), c(0,100))
profPlot(ne_arctic,     shift$ne, applyF0.1, "Y", c(-1,9), c(0,900))
profPlot(north_sea,     shift$ns, applyF0.1, "Y", c(-1,9), c(0,100))
profPlot(w_baltic,      shift$wb, applyF0.1, "Y", c(-1,9), c(0,35))

par(mfrow=c(3,3))
profPlot(faroe_plateau, shift$fp, applyF0.1, "SSB", c(-1,9), c(0,100))
profPlot(georges_bank,  shift$gb, applyF0.1, "SSB", c(-1,9), c(0,70))
profPlot(gulf_of_maine, shift$gm, applyF0.1, "SSB", c(-1,9), c(0,20))
profPlot(iceland,       shift$ic, applyF0.1, "SSB", c(-1,9), c(0,2500))
profPlot(nafo_2j3kl,    shift$n2, applyF0.1, "SSB", c(-1,9), c(0,500))
profPlot(ne_arctic,     shift$ne, applyF0.1, "SSB", c(-1,9), c(0,7000))
profPlot(north_sea,     shift$ns, applyF0.1, "SSB", c(-1,9), c(0,700))
profPlot(w_baltic,      shift$wb, applyF0.1, "SSB", c(-1,9), c(0,160))
