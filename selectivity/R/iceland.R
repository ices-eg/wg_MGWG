## Icelandic cod: cohort biomass, catch, selectivity

source("functions/cohortBiomass.R")
path <- "../data/iceland/"


yrs <- 2008:2017
ages <- as.character(3:13)

## 1  Cohort biomass

w <- read.csv(paste0(path, "wcatch.csv"), check.names = FALSE)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages])

M <- 0.2

N <- read.csv(paste0(path, "natage.csv"), check.names = FALSE)
Ninit <- N$"3"[N$Year %in% yrs]
Ninit <- mean(Ninit)

B <- cohortBiomass(Ninit, w, M)
BPR <- cohortBiomass(1, w, M)

## 2  Catch and selectivity

C <- read.csv(paste0(path, "catage.csv"), check.names = FALSE)
C <- C[C$Year %in% yrs, ages]
C <- colMeans(C)
Cw <- C * w

Fmort <- read.csv(paste0(path, "fatage.csv"), check.names = FALSE)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[-1])
S <- Fmort / max(Fmort)

## 3  Plot

pdf("iceland.pdf", 8, 8)  # 4, 12
par(mfrow=c(2,2))           # 4, 1
barplot(C, xlab="Age", ylab="Catch (millions)", main="Average catch in numbers", cex.main=1)
barplot(Cw, xlab="Age", ylab="Catch (kt)", main="Average catch in weight", cex.main=1)
plot(as.integer(names(S)), S, type="l", ylim=c(0,1.05), xlab="Age",
     ylab="Selectivity", main="Average selectivity", yaxs="i", cex.main=1)
barplot(B, xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing", cex.main=1)
dev.off()

pdf("iceland-biomass.pdf", 6, 6)
par(mfrow=c(1,1))
barplot(B, xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing")
dev.off()
