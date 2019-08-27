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
source("greenland.R")
source("gulf_of_maine.R")
source("iceland.R")
source("irish_sea.R")
source("nafo_2j3kl.R")
source("nafo_3m.R")
source("nafo_3no.R")
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("s_celtic.R")
source("w_baltic.R")
setwd("..")

## 2  Apply Fmax

shift <- list(fp=-1:8, gb=-1:8, gr=-1:6, gm=-1:7, ic=-1:9, is=-1:6, n2=-1:9,
              n3=-1:5, n4=-1:8, ne=-1:9, ns=-1:9, nw=-1:7, sc=-1:6, wb=-1:6)

par(mfrow=c(4,4))
profPlot(faroe_plateau, shift$fp, applyFmax, "Y", c(-1,9), c(0,14))
profPlot(georges_bank,  shift$gb, applyFmax, "Y", c(-1,9), c(0,10))
profPlot(greenland,     shift$gr, applyFmax, "Y", c(-1,9), c(0,30))
profPlot(gulf_of_maine, shift$gm, applyFmax, "Y", c(-1,9), c(0,4))
profPlot(iceland,       shift$ic, applyFmax, "Y", c(-1,9), c(0,350))
profPlot(irish_sea,     shift$is, applyFmax, "Y", c(-1,9), c(0,0.4))
profPlot(nafo_2j3kl,    shift$n2, applyFmax, "Y", c(-1,9), c(0,100))
profPlot(nafo_3m,       shift$n3, applyFmax, "Y", c(-1,9), c(0,9))
profPlot(nafo_3no,      shift$n4, applyFmax, "Y", c(-1,9), c(0,6))
profPlot(ne_arctic,     shift$ne, applyFmax, "Y", c(-1,9), c(0,900))
profPlot(north_sea,     shift$ns, applyFmax, "Y", c(-1,9), c(0,100))
profPlot(norway,        shift$nw, applyFmax, "Y", c(-1,9), c(0,40))
profPlot(s_celtic,      shift$sc, applyFmax, "Y", c(-1,9), c(0,2))
profPlot(w_baltic,      shift$wb, applyFmax, "Y", c(-1,9), c(0,35))

par(mfrow=c(4,4))
profPlot(faroe_plateau, shift$fp, applyFmax, "SSB", c(-1,9), c(0,100))
profPlot(georges_bank,  shift$gb, applyFmax, "SSB", c(-1,9), c(0,65))
profPlot(greenland,     shift$gr, applyFmax, "SSB", c(-1,9), c(0,130))
profPlot(gulf_of_maine, shift$gm, applyFmax, "SSB", c(-1,9), c(0,17))
profPlot(iceland,       shift$ic, applyFmax, "SSB", c(-1,9), c(0,2300))
profPlot(irish_sea,     shift$is, applyFmax, "SSB", c(-1,9), c(0,2))
profPlot(nafo_2j3kl,    shift$n2, applyFmax, "SSB", c(-1,9), c(0,450))
profPlot(nafo_3m,       shift$n3, applyFmax, "SSB", c(-1,9), c(0,30))
profPlot(nafo_3no,      shift$n4, applyFmax, "SSB", c(-1,9), c(0,28))
profPlot(ne_arctic,     shift$ne, applyFmax, "SSB", c(-1,9), c(0,6000))
profPlot(north_sea,     shift$ns, applyFmax, "SSB", c(-1,9), c(0,800))
profPlot(norway,        shift$nw, applyFmax, "SSB", c(-1,9), c(0,160))
profPlot(s_celtic,      shift$sc, applyFmax, "SSB", c(-1,9), c(0,9))
profPlot(w_baltic,      shift$wb, applyFmax, "SSB", c(-1,9), c(0,160))

## 3  Apply F0.1

Y <- list()

par(mfrow=c(4,4))
Y$fp <- profPlot(faroe_plateau, shift$fp, applyF0.1, "Y", c(-1,9), c(0,14))
Y$gb <- profPlot(georges_bank,  shift$gb, applyF0.1, "Y", c(-1,9), c(0,10))
Y$gr <- profPlot(greenland,     shift$gr, applyF0.1, "Y", c(-1,9), c(0,28))
Y$gm <- profPlot(gulf_of_maine, shift$gm, applyF0.1, "Y", c(-1,9), c(0,4))
Y$ic <- profPlot(iceland,       shift$ic, applyF0.1, "Y", c(-1,9), c(0,320))
Y$n2 <- profPlot(nafo_2j3kl,    shift$n2, applyF0.1, "Y", c(-1,9), c(0,80))
Y$n3 <- profPlot(nafo_3m,       shift$n3, applyF0.1, "Y", c(-1,9), c(0,8))
Y$n4 <- profPlot(nafo_3no,      shift$n4, applyF0.1, "Y", c(-1,9), c(0,5))
Y$ne <- profPlot(ne_arctic,     shift$ne, applyF0.1, "Y", c(-1,9), c(0,800))
Y$ns <- profPlot(north_sea,     shift$ns, applyF0.1, "Y", c(-1,9), c(0,90))
Y$nw <- profPlot(norway,        shift$nw, applyF0.1, "Y", c(-1,9), c(0,34))
Y$sc <- profPlot(s_celtic,      shift$sc, applyF0.1, "Y", c(-1,9), c(0,1.6))
Y$wb <- profPlot(w_baltic,      shift$wb, applyF0.1, "Y", c(-1,9), c(0,33))

optx <- function(stock, y.list=Y)
{
  xy <- y.list[[stock]]
  opt <- xy$shift[which.max(xy$result)]
  opt
}

opty <- function(stock, b.list=B, y.list=Y)
{
  xy <- b.list[[stock]]
  x <- optx(stock, y.list=y.list)
  opt <- xy$result[xy$shift==x]
  opt
}

point <- function(stock)
{
  points(optx(stock), opty(stock), pch="x")
}

B <- list()

par(mfrow=c(4,4))
B$fp <- profPlot(faroe_plateau, shift$fp, applyF0.1, "SSB", c(-1,9), c(0,100));  point("fp")
B$gb <- profPlot(georges_bank,  shift$gb, applyF0.1, "SSB", c(-1,9), c(0,65));   point("gb")
B$gr <- profPlot(greenland,     shift$gr, applyF0.1, "SSB", c(-1,9), c(0,130));  point("gr")
B$gm <- profPlot(gulf_of_maine, shift$gm, applyF0.1, "SSB", c(-1,9), c(0,17));   point("gm")
B$ic <- profPlot(iceland,       shift$ic, applyF0.1, "SSB", c(-1,9), c(0,2500)); point("ic")
B$n2 <- profPlot(nafo_2j3kl,    shift$n2, applyF0.1, "SSB", c(-1,9), c(0,460));  point("n2")
B$n3 <- profPlot(nafo_3m,       shift$n3, applyF0.1, "SSB", c(-1,9), c(0,30));   point("n3")
B$n4 <- profPlot(nafo_3no,      shift$n4, applyF0.1, "SSB", c(-1,9), c(0,28));   point("n4")
B$ne <- profPlot(ne_arctic,     shift$ne, applyF0.1, "SSB", c(-1,9), c(0,7000)); point("ne")
B$ns <- profPlot(north_sea,     shift$ns, applyF0.1, "SSB", c(-1,9), c(0,800));  point("ns")
B$nw <- profPlot(norway,        shift$nw, applyF0.1, "SSB", c(-1,9), c(0,150));  point("nw")
B$sc <- profPlot(s_celtic,      shift$sc, applyF0.1, "SSB", c(-1,9), c(0,9));    point("sc")
B$wb <- profPlot(w_baltic,      shift$wb, applyF0.1, "SSB", c(-1,9), c(0,150));  point("wb")
