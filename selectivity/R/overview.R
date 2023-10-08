## Overview plots: weight, biomass per recruit, selectivity, catch, maturity

library(gplots)  # rich.colors
source("functions/stdline.R")

## 1  Import

setwd("stocks")

source("e_baltic.R")
source("faroe_plateau.R")
source("georges_bank.R")
source("greenland.R")
source("gulf_of_maine.R")
source("iceland.R")
source("irish_sea.R")
# source("kattegat.R")  # no fatage
source("nafo_2j3kl.R")
source("nafo_3m.R")
source("nafo_3no.R")
# source("nafo_3ps.R")  # no fatage
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("s_celtic.R")
source("w_baltic.R")

setwd("..")

## 2  Identify stocks that are actively fished

lwd <- 2
stocks <- c("E Baltic", "Faroe Plateau", "Georges Bank", "Greenl inshore",
            "Gulf of Maine", "Iceland", "Irish Sea", "NAFO 2J3KL", "NAFO 3M",
            "NAFO 3NO", "NE Arctic", "North Sea", "Norw coastal", "S Celtic",
            "W Baltic")
col <- rich.colors(length(stocks))

## Fishing mortality
plot(NA, xlim=c(1,14), ylim=c(0,1.2), yaxs="i",
     xlab="Age", ylab="Fishing mortality", main="F in recent years")
stdline(e_baltic$Fmort,      lwd, col[1])
stdline(faroe_plateau$Fmort, lwd, col[2])
stdline(georges_bank$Fmort,  lwd, col[3])
stdline(greenland$Fmort,     lwd, col[4])
stdline(gulf_of_maine$Fmort, lwd, col[5])
stdline(iceland$Fmort,       lwd, col[6])
stdline(irish_sea$Fmort,     lwd, col[7])
stdline(nafo_2j3kl$Fmort,    lwd, col[8], lty=2)  # moratorium
stdline(nafo_3m$Fmort,       lwd, col[9])
stdline(nafo_3no$Fmort,      lwd, col[10], lty=2)  # moratorium
stdline(ne_arctic$Fmort,     lwd, col[11], from=4, to=14)
stdline(north_sea$Fmort,     lwd, col[12])
stdline(norway$Fmort,        lwd, col[13])
stdline(s_celtic$Fmort,      lwd, col[14])
stdline(w_baltic$Fmort,      lwd, col[15])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

## 3  Plot

pdf("overview.pdf", 10, 20)
layout(matrix(c(1,2,3,3,4,4,5,5), nrow=4, byrow=TRUE))

## Weight
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
stdline(e_baltic$wcatch,      lwd, col[1])
stdline(faroe_plateau$wcatch, lwd, col[2])
stdline(georges_bank$wcatch,  lwd, col[3])
stdline(greenland$wcatch,     lwd, col[4])
stdline(gulf_of_maine$wcatch, lwd, col[5])
stdline(iceland$wcatch,       lwd, col[6])
stdline(irish_sea$wcatch,     lwd, col[7])
stdline(nafo_2j3kl$wcatch,    lwd, col[8], lty=2)
stdline(nafo_3m$wcatch,       lwd, col[9])
stdline(nafo_3no$wcatch,      lwd, col[10], lty=2)
stdline(ne_arctic$wcatch,     lwd, col[11], to=14)
stdline(north_sea$wcatch,     lwd, col[12])
stdline(norway$wcatch,        lwd, col[13])
stdline(s_celtic$wcatch,      lwd, col[14])
stdline(w_baltic$wcatch,      lwd, col[15])
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)

## Biomass per recruit
plot(NA, xlim=c(1,14), ylim=c(0,5.7), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
stdline(e_baltic$BPR,      lwd, col[1])
stdline(faroe_plateau$BPR, lwd, col[2])
stdline(georges_bank$BPR,  lwd, col[3])
stdline(greenland$BPR,     lwd, col[4])
stdline(gulf_of_maine$BPR, lwd, col[5])
stdline(iceland$BPR,       lwd, col[6])
stdline(irish_sea$BPR,     lwd, col[7])
stdline(nafo_2j3kl$BPR,    lwd, col[8], lty=2)
stdline(nafo_3m$BPR,       lwd, col[9])
stdline(nafo_3no$BPR,      lwd, col[10], lty=2)
stdline(ne_arctic$BPR,     lwd, col[11], to=14)
stdline(north_sea$BPR,     lwd*1.5, col[12], to=3, lty=3)
stdline(north_sea$BPR,     lwd,     col[12], from=3)
stdline(norway$BPR,        lwd, col[13])
stdline(s_celtic$BPR,      lwd, col[14])
stdline(w_baltic$BPR,      lwd, col[15])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)

## Selectivity
plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
stdline(e_baltic$S,      lwd, col[1])
stdline(faroe_plateau$S, lwd, col[2])
stdline(georges_bank$S,  lwd, col[3])
stdline(greenland$S,     lwd, col[4])
stdline(gulf_of_maine$S, lwd, col[5])
stdline(iceland$S,       lwd, col[6])
stdline(irish_sea$S,     lwd, col[7])
stdline(nafo_2j3kl$S,    lwd, col[8], lty=2)
stdline(nafo_3m$S,       lwd, col[9], from=4)
stdline(nafo_3no$S,      lwd, col[10], lty=2)
stdline(ne_arctic$S,     lwd, col[11], to=14)
stdline(north_sea$S,     lwd, col[12])
stdline(norway$S,        lwd, col[13])
stdline(s_celtic$S,      lwd, col[14])
stdline(w_baltic$S,      lwd, col[15])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

## Catch
plot(NA, xlim=c(1,14), ylim=c(0,0.49), yaxs="i",
     xlab="Age", ylab="Proportion of catch", main="Catch composition")
stdline(e_baltic$Cp,      lwd, col[1])
stdline(faroe_plateau$Cp, lwd, col[2])
stdline(georges_bank$Cp,  lwd, col[3])
stdline(greenland$Cp,     lwd, col[4])
stdline(gulf_of_maine$Cp, lwd, col[5])
stdline(iceland$Cp,       lwd, col[6])
stdline(irish_sea$Cp,     lwd, col[7])
stdline(nafo_2j3kl$Cp,    lwd, col[8], lty=2)
stdline(nafo_3m$Cp,       lwd, col[9])
stdline(nafo_3no$Cp,      lwd, col[10], lty=2)
stdline(ne_arctic$Cp,     lwd, col[11], to=14)
stdline(north_sea$Cp,     lwd, col[12], to=8)
stdline(norway$Cp,        lwd, col[13])
stdline(s_celtic$Cp,      lwd, col[14])
stdline(w_baltic$Cp,      lwd, col[15])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

## Maturity
plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Proportion mature", main="Maturity")
stdline(e_baltic$mat,      lwd, col[1])
stdline(faroe_plateau$mat, lwd, col[2])
stdline(georges_bank$mat,  lwd, col[3])
stdline(greenland$mat,     lwd, col[4])
stdline(gulf_of_maine$mat, lwd, col[5])
stdline(iceland$mat,       lwd, col[6])
stdline(irish_sea$mat,     lwd, col[7])
stdline(nafo_2j3kl$mat,    lwd, col[8], lty=2)
stdline(nafo_3m$mat,       lwd, col[9])
stdline(nafo_3no$mat,      lwd, col[10], lty=2)
stdline(ne_arctic$mat,     lwd, col[11], from=4, to=14)
stdline(north_sea$mat,     lwd, col[12])
stdline(norway$mat,        lwd, col[13])
stdline(s_celtic$mat,      lwd, col[14])
stdline(w_baltic$mat,      lwd, col[15])
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()

dev.off()
