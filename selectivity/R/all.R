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

## 2  Plot

stocks <- c("North Sea", "Gulf of Maine", "Iceland")
lwd <- 2

pdf("all.pdf", 10, 10)                         # 4, 9
layout(matrix(c(1,2,3,3), nrow=2, byrow=TRUE)) # par(mfrow=c(c(3,1))
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
lines(as.integer(names(w.NorthSea)), w.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(w.GulfMaine)), w.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(w.Iceland)), w.Iceland, lwd=lwd, col=3)
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:3, inset=0.02)

plot(NA, xlim=c(1,14), ylim=c(0,4.5), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
lines(as.integer(names(BPR.NorthSea)), BPR.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(BPR.GulfMaine)), BPR.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(BPR.Iceland)), BPR.Iceland, lwd=lwd, col=3)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:3, inset=0.02)

plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
lines(as.integer(names(S.NorthSea)), S.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(S.GulfMaine)), S.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(S.Iceland)), S.Iceland, lwd=lwd, col=3)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:3, inset=0.02)
dev.off()

################################################################################

pdf("all-weight.pdf", 6, 6)
par(mfrow=c(1,1))
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
lines(as.integer(names(w.NorthSea)), w.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(w.GulfMaine)), w.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(w.Iceland)), w.Iceland, lwd=lwd, col=3)
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:3, inset=0.02)
dev.off()

pdf("all-bio-sel.pdf", 10, 4)
layout(matrix(c(1,2,2), nrow=1))
plot(NA, xlim=c(1,14), ylim=c(0,4.5), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
lines(as.integer(names(BPR.NorthSea)), BPR.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(BPR.GulfMaine)), BPR.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(BPR.Iceland)), BPR.Iceland, lwd=lwd, col=3)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:3, inset=0.02)

plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
lines(as.integer(names(S.NorthSea)), S.NorthSea, lwd=lwd, col=1)
lines(as.integer(names(S.GulfMaine)), S.GulfMaine, lwd=lwd, col=2)
lines(as.integer(names(S.Iceland)), S.Iceland, lwd=lwd, col=3)
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=1:3, inset=0.02)
dev.off()
