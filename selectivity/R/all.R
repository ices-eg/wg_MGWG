## All: weight, selectivity, biomass per recruit

## 1  Import

source("iceland.R")
w.Iceland <- w
S.Iceland <- S
BPR.Iceland <- BPR

source("north_sea.R")
w.NorthSea <- w
S.NorthSea <- S
BPR.NorthSea <- BPR

## 2  Plot

pdf("all_weight.pdf")
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight (kg)", main="Average weight")
lines(as.integer(names(w.NorthSea)), w.NorthSea, lty=1)
lines(as.integer(names(w.Iceland)), w.Iceland, lty=2)
legend("topleft", legend=c("North Sea","Iceland"), bty="n", lty=1:2, inset=0.02)
dev.off()

pdf("all_selectivity.pdf", 6, 4)
plot(NA, xlim=c(1,14), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Selectivity", main="Average selectivity")
lines(as.integer(names(S.NorthSea)), S.NorthSea, lty=1)
lines(as.integer(names(S.Iceland)), S.Iceland, lty=2)
legend("bottomright", legend=c("North Sea","Iceland"), bty="n", lty=1:2, inset=0.02)
dev.off()

pdf("all_bpr.pdf")
plot(NA, xlim=c(1,14), ylim=c(0,4.5), yaxs="i",
     xlab="Age", ylab="Biomass per recruit (kg)",
     main="Biomass per recruit, in the absence of fishing")
lines(as.integer(names(BPR.NorthSea)), BPR.NorthSea, lty=1)
lines(as.integer(names(BPR.Iceland)), BPR.Iceland, lty=2)
legend("bottomright", legend=c("North Sea","Iceland"), bty="n", lty=1:2, inset=0.02)
dev.off()
