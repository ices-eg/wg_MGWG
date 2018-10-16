source("functions/cohortBiomass.R")
source("functions/read.R")
source("functions/stdplot.R")

path <- "../data/iceland"
yrs <- 2008:2017
ages <- as.character(3:14)
plus <- FALSE

## 1  Cohort biomass

N <- read("natage", path, plus)
Ninit <- N$"3"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- read("natmort", path, plus)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[ages])

w <- read("wcatch", path, plus)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages])

B <- cohortBiomass(Ninit, M, w)
BPR <- cohortBiomass(exp(-0.4), M, w)  # 1 recruit at age 1 => 0.67 at age 3

## 2  Catch and selectivity

C <- read("catage", path, plus)
C <- C[C$Year %in% yrs,]
C <- colMeans(C[ages])
Cp <- C / sum(C)

Fmort <- read("fatage", path, plus)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[ages])
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
