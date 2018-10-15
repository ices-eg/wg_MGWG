source("functions/cohortBiomass.R")
source("functions/read.R")
source("functions/stdplot.R")

path <- "../data/faroe_plateau"
yrs <- 2008:2017
ages <- as.character(2:10)

## 1  Cohort biomass

N <- read("natage", plus=TRUE)
Ninit <- N$"2"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- read("natmort", plus=TRUE)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[ages])

w <- read("wcatch", plus=TRUE)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages])

B <- cohortBiomass(Ninit, M, w)
BPR <- cohortBiomass(exp(-0.2), M, w)  # 1 recruit at age 1 => 0.82 at age 2

## 2  Catch and selectivity

C <- read("catage", plus=TRUE)
C <- C[C$Year %in% yrs,]
C <- colMeans(C[ages])
Cp <- C / sum(C)

Fmort <- read("fatage", plus=TRUE)
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
