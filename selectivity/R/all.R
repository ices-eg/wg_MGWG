## All stocks: weight, selectivity, biomass per recruit

## 1  Import

source("iceland.R")
w.Iceland <- w
S.Iceland <- S
BPR.Iceland <- BPR

source("north_sea.R")
w.NorthSea <- w
S.NorthSea <- S
BPR.NorthSea <- BPR

source("gulf_of_maine.R")
w.GulfMaine <- w
S.GulfMaine <- S
BPR.GulfMaine <- BPR

source("GeorgesBank.R")
w.GeorgesBank <- w
S.GeorgesBank <- S
BPR.GeorgesBank <- BPR

source("NEArctic.R")
w.NEArctic <- w
S.NEArctic  <- S
BPR.NEArctic <- BPR

source("WBaltic.R")
w.WBaltic <- w
S.WBaltic  <- S
BPR.WBaltic <- BPR

## 2  Plot

stocks <- c("North Sea", "Gulf of Maine", "Georges Bank", "NEArctic",
            "Iceland", "WBaltic")
lwd <- 2

pdf("all.pdf", 10, 10)                         # 4, 9
layout(matrix(c(1,2,3,3), nrow=2, byrow=TRUE)) # par(mfrow=c(c(3,1))

plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
lines(as.integer(names(w.NorthSea)), w.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(w.GulfMaine)), w.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(w.GeorgesBank)), w.GeorgesBank, lwd=lwd, col=3)
lines(as.integer(names(w.NEArctic)), w.NEArctic, lwd=lwd, col=4)
lines(as.integer(names(w.Iceland)), w.Iceland, lwd=lwd, col=5)
lines(as.integer(names(w.WBaltic)), w.WBaltic, lwd=lwd, col=6)
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:6, inset=0.02,
       cex = .8)

plot(NA, xlim=c(1,14), ylim=c(0,4.5), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
lines(as.integer(names(BPR.NorthSea)), BPR.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(BPR.GulfMaine)), BPR.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(BPR.GeorgesBank)), BPR.GeorgesBank, lwd=lwd, col=3)
lines(as.integer(names(BPR.NEArctic)), BPR.NEArctic, lwd=lwd, col=4)
lines(as.integer(names(BPR.Iceland)), BPR.Iceland, lwd=lwd, col=5)
lines(as.integer(names(BPR.WBaltic)), BPR.WBaltic, lwd=lwd, col=6)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:6,
       inset=0.02, cex = .6)

plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
lines(as.integer(names(S.NorthSea)), S.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(S.GulfMaine)), S.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(S.GeorgesBank)), S.GeorgesBank, lwd=lwd, col=3)
lines(as.integer(names(S.NEArctic)), S.NEArctic, lwd=lwd, col=4)
lines(as.integer(names(S.Iceland)), S.Iceland, lwd=lwd, col=5)
lines(as.integer(names(S.WBaltic)), S.WBaltic, lwd=lwd, col=6)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:6,
       inset=0.02, cex = .8)

dev.off()

################################################################################

pdf("all-weight.pdf", 6, 6)
par(mfrow=c(1,1))
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
lines(as.integer(names(w.NorthSea)), w.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(w.GulfMaine)), w.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(w.GeorgesBank)), w.GeorgesBank, lwd=lwd, col=3)
lines(as.integer(names(w.NEArctic)), w.NEArctic, lwd=lwd, col=4)
lines(as.integer(names(w.Iceland)), w.Iceland, lwd=lwd, col=5)
lines(as.integer(names(w.WBaltic)), w.WBaltic, lwd=lwd, col=6)
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:6, inset=0.02)
dev.off()

pdf("all-bio-sel.pdf", 10, 4)

layout(matrix(c(1,2,2), nrow=1))
plot(NA, xlim=c(1,14), ylim=c(0,4.5), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
lines(as.integer(names(BPR.NorthSea)), BPR.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(BPR.GulfMaine)), BPR.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(BPR.GeorgesBank)), BPR.GeorgesBank, lwd=lwd, col=3)
lines(as.integer(names(BPR.NEArctic)), BPR.NEArctic, lwd=lwd, col=4)
lines(as.integer(names(BPR.Iceland)), BPR.Iceland, lwd=lwd, col=5)
lines(as.integer(names(BPR.WBaltic)), BPR.WBaltic, lwd=lwd, col=6)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:6, inset=0.02)
plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
lines(as.integer(names(S.NorthSea)), S.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(S.GulfMaine)), S.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(S.GeorgesBank)), S.GeorgesBank, lwd=lwd, col=3)
lines(as.integer(names(S.NEArctic)), S.NEArctic, lwd=lwd, col=4)
lines(as.integer(names(S.Iceland)), S.Iceland, lwd=lwd, col=5)
lines(as.integer(names(S.WBaltic)), S.WBaltic, lwd=lwd, col=6)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:6, inset=0.02)
dev.off()
