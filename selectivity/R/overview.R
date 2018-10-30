## Overview plots: weight, biomass per recruit, selectivity, catch, maturity

library(gplots)  # rich.colors
source("functions/stdline.R")

## 1  Import

setwd("stocks")

source("faroe_plateau.R")
source("georges_bank.R")
source("gulf_of_maine.R")
source("iceland.R")
source("nafo_2j3kl.R")
source("nafo_3m.R")
source("nafo_3no.R")
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("w_baltic.R")

setwd("..")

## 2  Identify stocks that are actively fished

lwd <- 2
stocks <- c("Faroe Plateau", "Georges Bank", "Gulf of Maine", "Iceland",
            "NAFO 2J3KL", "NAFO 3M", "NAFO 3NO", "NE Arctic", "North Sea",
            "Norwegian coastal", "W Baltic")
col <- rich.colors(length(stocks))

## Fishing mortality
plot(NA, xlim=c(1,14), ylim=c(0,1.2), yaxs="i",
     xlab="Age", ylab="Fishing mortality", main="F in recent years")
stdline(faroe_plateau$Fmort, lwd, col[1])
stdline(georges_bank$Fmort,  lwd, col[2])
stdline(gulf_of_maine$Fmort, lwd, col[3])
stdline(iceland$Fmort,       lwd, col[4])
stdline(nafo_2j3kl$Fmort,    lwd, col[5])
stdline(nafo_3m$Fmort,       lwd, col[6])
stdline(nafo_3no$Fmort,      lwd, col[7])
stdline(ne_arctic$Fmort,     lwd, col[8], from=4, to=14)
stdline(north_sea$Fmort,     lwd, col[9])
stdline(norway$Fmort,        lwd, col[10])
stdline(w_baltic$Fmort,      lwd, col[11])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

## 3  Plot

stocks <- c("Faroe Plateau", "Georges Bank", "Gulf of Maine", "Iceland",
            "NAFO 3M", "NE Arctic", "North Sea", "Norwegian coastal", "W Baltic")
col <- rich.colors(length(stocks))

pdf("overview.pdf", 10, 20)
layout(matrix(c(1,2,3,3,4,4,5,5), nrow=4, byrow=TRUE))

## Weight
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
stdline(faroe_plateau$wcatch, lwd, col[1])
stdline(georges_bank$wcatch,  lwd, col[2])
stdline(gulf_of_maine$wcatch, lwd, col[3])
stdline(iceland$wcatch,       lwd, col[4])
stdline(nafo_3m$wcatch,       lwd, col[5])
stdline(ne_arctic$wcatch,     lwd, col[6], to=14)
stdline(north_sea$wcatch,     lwd, col[7])
stdline(norway$wcatch,        lwd, col[8])
stdline(w_baltic$wcatch,      lwd, col[9])
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)

## Biomass per recruit
plot(NA, xlim=c(1,14), ylim=c(0,3.9), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
stdline(faroe_plateau$BPR, lwd, col[1])
stdline(georges_bank$BPR,  lwd, col[2])
stdline(gulf_of_maine$BPR, lwd, col[3])
stdline(iceland$BPR,       lwd, col[4])
stdline(nafo_3m$BPR,       lwd, col[5])
stdline(ne_arctic$BPR,     lwd, col[6], to=14)
stdline(north_sea$BPR,     lwd*1.5, col[7], to=3, lty=3)
stdline(north_sea$BPR,     lwd, col[7], from=3)
stdline(norway$BPR,        lwd, col[8])
stdline(w_baltic$BPR,      lwd, col[9])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)

## Selectivity
plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
stdline(faroe_plateau$S, lwd, col[1])
stdline(georges_bank$S,  lwd, col[2])
stdline(gulf_of_maine$S, lwd, col[3])
stdline(iceland$S,       lwd, col[4])
stdline(nafo_3m$S,       lwd, col[5], from=4)
stdline(ne_arctic$S,     lwd, col[6], to=14)
stdline(north_sea$S,     lwd, col[7])
stdline(norway$S,        lwd, col[8])
stdline(w_baltic$S,      lwd, col[9])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

## Catch
plot(NA, xlim=c(1,14), ylim=c(0,0.4), yaxs="i",
     xlab="Age", ylab="Proportion of catch", main="Catch composition")
stdline(faroe_plateau$Cp, lwd, col[1])
stdline(georges_bank$Cp,  lwd, col[2])
stdline(gulf_of_maine$Cp, lwd, col[3])
stdline(iceland$Cp,       lwd, col[4])
stdline(nafo_3m$Cp,       lwd, col[5])
stdline(ne_arctic$Cp,     lwd, col[6], to=14)
stdline(north_sea$Cp,     lwd, col[7], to=8)
stdline(norway$Cp,        lwd, col[8])
stdline(w_baltic$Cp,      lwd, col[9])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

## Maturity
plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Proportion mature", main="Maturity")
stdline(faroe_plateau$mat, lwd, col[1])
stdline(georges_bank$mat,  lwd, col[2])
stdline(gulf_of_maine$mat, lwd, col[3])
stdline(iceland$mat,       lwd, col[4])
stdline(nafo_3m$mat,       lwd, col[5])
stdline(ne_arctic$mat,     lwd, col[6], from=4, to=14)
stdline(north_sea$mat,     lwd, col[7])
stdline(norway$mat,        lwd, col[8])
stdline(w_baltic$mat,      lwd, col[9])
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

dev.off()
