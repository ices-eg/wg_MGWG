source("functions/cohortBiomass.R")

path <- "../data/gulf_of_maine/"

yrs <- 2002:2011
ages <- as.character(1:8)

## 1  Cohort biomass

w <- read.csv(paste0(path,"wcatch.csv"), check.names=FALSE)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages])

M <- 0.2

N <- read.csv(paste0(path,"natage.csv"), check.names=FALSE)
Ninit <- N$"1"[N$Year %in% yrs]
Ninit <- mean(Ninit)

B <- cohortBiomass(Ninit, w, M)
BPR <- cohortBiomass(exp(M+M), w, M)

## 2  Catch and selectivity


## C <- read.csv(paste0(path,"catage.csv"), check.names=FALSE)
## C <- C[C$Year %in% yrs, ages]
## C <- colMeans(C)
## Cw <- C * w

Fmort <- read.csv(paste0(path,"fatage.csv"), check.names=FALSE)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[ages])
S <- Fmort / max(Fmort)

pdf("gulf_of_maine.pdf", 12, 6)  # 4, 12
par(mfrow=c(1,2))           # 4, 1
## barplot(C, xlab="Age", ylab="Catch (millions)", main="Average catch in numbers")
## barplot(Cw, xlab="Age", ylab="Catch (kt)", main="Average catch in weight")
plot(as.integer(names(S)), S, type="l", ylim=c(0,1.05), xlab="Age",
     ylab="Selectivity", main="Average selectivity", yaxs="i")
barplot(B, xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing")
dev.off()
