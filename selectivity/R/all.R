## All stocks: weight, selectivity, biomass per recruit

library(gplots)
source("functions/stdline.R")

## 1  Import

setwd("stocks")

source("faroe_plateau.R")
source("georges_bank.R")
source("gulf_of_maine_2013.R")
source("gulf_of_maine_2017.R")
source("iceland.R")
source("nafo_2j3kl.R")
source("nafo_3ps.R")
source("ne_arctic.R")
source("north_sea.R")
source("w_baltic.R")

setwd("..")

## 2  Plot

lwd <- 2
col <- rich.colors(10)

stocks <- c("Faroe Plateau", "Georges Bank", "Gulf of Maine 2013",
            "Gulf of Maine 2017", "Iceland", "NAFO 2J3KL", "NAFO 3Ps",
            "NE Arctic", "North Sea", "W Baltic")

pdf("all.pdf", 10, 10)
layout(matrix(c(1,2,3,3), nrow=2, byrow=TRUE))

plot(NA, xlim=c(1,15), ylim=c(0,16), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
stdline(faroe_plateau$w,      lwd, col[1])
stdline(georges_bank$w,       lwd, col[2])
stdline(gulf_of_maine_2013$w, lwd, col[3])
stdline(gulf_of_maine_2017$w, lwd, col[4])
stdline(iceland$w,            lwd, col[5])
stdline(nafo_2j3kl$w,         lwd, col[6])
stdline(nafo_3ps$w,           lwd, col[7])
stdline(ne_arctic$w,          lwd, col[8])
stdline(north_sea$w,          lwd, col[9])
stdline(w_baltic$w,           lwd, col[10])
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.9)

plot(NA, xlim=c(1,15), ylim=c(0,3.9), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
stdline(faroe_plateau$BPR,      lwd, col[1])
stdline(georges_bank$BPR,       lwd, col[2])
stdline(gulf_of_maine_2013$BPR, lwd, col[3])
stdline(gulf_of_maine_2017$BPR, lwd, col[4])
stdline(iceland$BPR,            lwd, col[5])
stdline(nafo_2j3kl$BPR,         lwd, col[6])
stdline(nafo_3ps$BPR,           lwd, col[7])
stdline(ne_arctic$BPR,          lwd, col[8])
stdline(north_sea$BPR,          lwd, col[9])
stdline(w_baltic$BPR,           lwd, col[10])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.9)

plot(NA, xlim=c(1,15), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
stdline(faroe_plateau$S,      lwd, col[1])
stdline(georges_bank$S,       lwd, col[2])
stdline(gulf_of_maine_2013$S, lwd, col[3])
stdline(gulf_of_maine_2017$S, lwd, col[4])
stdline(iceland$S,            lwd, col[5])
stdline(nafo_2j3kl$S,         lwd, col[6])
stdline(nafo_3ps$S,           lwd, col[7])
stdline(ne_arctic$S,          lwd, col[8])
stdline(north_sea$S,          lwd, col[9])
stdline(w_baltic$S,           lwd, col[10])
legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.9)
box()

dev.off()
