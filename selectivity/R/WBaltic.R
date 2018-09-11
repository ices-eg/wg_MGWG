source("functions/cohortBiomass.R")

path <- "../data/western_baltic/"

yrs <- 2008:2017
ages <- as.character(1:6)

## 1  Cohort biomass

w <- read.csv(paste0(path,"catch_weight.csv"), check.names=FALSE)
w <- w[w$year %in% yrs,]
w <- colMeans(w[ages])

M <- 0.2

N <- read.csv(paste0(path,"total_catch.csv"), check.names=FALSE)
Ninit <- N$"1"[N$year %in% yrs]
Ninit <- mean(Ninit) / 1000

B <- cohortBiomass(Ninit, w, M)
BPR <- cohortBiomass(exp(M+M), w, M)

## 2  Catch and selectivity

C <- structure(rep(0,6), names=1:6)
Cw <- C * w

Fmort <- read.csv(paste0(path,"F.csv"), check.names=FALSE)
Fmort <- Fmort[Fmort$year %in% yrs,]
Fmort <- colMeans(Fmort[ages])
S <- Fmort / max(Fmort)

pdf("WBaltic.pdf", 12, 6)  # 4, 12
par(mfrow=c(1,2))           # 4, 1
## barplot(C, xlab="Age", ylab="Catch (millions)", main="Average catch in numbers")
## barplot(Cw, xlab="Age", ylab="Catch (kt)", main="Average catch in weight")
plot(as.integer(names(S)), S, type="l", ylim=c(0,1.05), xlab="Age",
     ylab="Selectivity", main="Average selectivity", yaxs="i")
barplot(B, xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing")
dev.off()
