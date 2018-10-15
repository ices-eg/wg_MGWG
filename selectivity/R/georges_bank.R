source("functions/cohortBiomass.R")
source("functions/read.R")
source("functions/stdplot.R")

path <- "../data/georges_bank/"
yrs <- 2002:2011
ages <- as.character(1:10)

## 1  Cohort biomass

N <- read("natage", plus=TRUE)
Ninit <- N$"1"[N$Year %in% yrs]
Ninit <- mean(Ninit)

w <- read("wcatch", plus=TRUE)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages])

M <- read("natmort", plus=TRUE)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[ages])

B <- cohortBiomass(Ninit, M, w)
BPR <- cohortBiomass(1, M, w)

## 2  Catch and selectivity

## C <- read("catage", plus=TRUE)
## C <- C[C$Year %in% yrs, ages]
## C <- colMeans(C)
## Cw <- C * w

Fmort <- read("fatage", plus=TRUE)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[ages])
S <- Fmort / max(Fmort)

pdf("georges_bank.pdf", 12, 6)  # 4, 12
par(mfrow=c(1,2))           # 4, 1
## barplot(C, xlab="Age", ylab="Catch (millions)", main="Average catch in numbers")
## barplot(Cw, xlab="Age", ylab="Catch (kt)", main="Average catch in weight")
plot(as.integer(names(S)), S, type="l", ylim=c(0,1.05), xlab="Age",
     ylab="Selectivity", main="Average selectivity", yaxs="i")
barplot(B, xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing")
dev.off()
