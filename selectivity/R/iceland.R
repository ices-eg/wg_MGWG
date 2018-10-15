source("functions/cohortBiomass.R")
source("functions/stdplot.R")
path <- "../data/iceland"

yrs <- 2008:2017
ages <- as.character(3:14)

## 1  Cohort biomass

N <- read.csv(file.path(path,"natage.csv"), check.names=FALSE)
Ninit <- N$"3"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- 0.2

w <- read.csv(file.path(path,"wcatch.csv"), check.names=FALSE)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages])

B <- cohortBiomass(Ninit, M, w)
BPR <- cohortBiomass(1, M, w)

## 2  Catch and selectivity

C <- read.csv(file.path(path,"catage.csv"), check.names=FALSE)
C <- C[C$Year %in% yrs, ages]
C <- colMeans(C)
Cp <- C / sum(C)

Fmort <- read.csv(file.path(path,"fatage.csv"), check.names=FALSE)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[-1])
S <- Fmort / max(Fmort)

## 3  Plot

if(interactive())
{
  par(mfrow=c(2,2))
  stdplot(Cp, "Catch composition", "Proportion of catch")
  stdplot(w, "Average weight", "Weight (kg)")
  stdplot(S, "Average selectivity", "Selectivity")
  stdplot(BPR, "Biomass per recruit, in the absence of fishing",
          "Biomass per recruit (kg)")
}
