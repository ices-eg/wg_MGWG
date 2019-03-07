source("../../../R/functions/cohortBiomass.R")
source("../../../R/functions/dims.R")
source("../../../R/functions/read.R")
source("../../../R/functions/stdplot.R")

path <- "../../../data/ne_arctic"
dims(path)
yrs <- 2008:2017
ages <- as.character(3:15)
plus <- TRUE

## 1  Population

N <- read("natage", path, plus)
Ninit <- N$"3"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- read("natmort", path, plus)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[ages])

## 2  Weights, cohort biomass

wcatch <- read("wcatch", path, plus)
wcatch <- wcatch[wcatch$Year %in% yrs,]
wcatch <- colMeans(wcatch[ages])

wstock <- read("wstock", path, plus)
wstock <- wstock[wstock$Year %in% yrs,]
wstock <- colMeans(wstock[ages])

B <- cohortBiomass(Ninit, M, wcatch)
## One recruit at age 3
BPR <- cohortBiomass(1, M, wcatch)

## 3  Catch and selectivity

C <- read("catage", path, plus)
C <- C[C$Year %in% yrs,]
C <- colMeans(C[ages])
Cp <- C / sum(C)

Fmort <- read("fatage", path, plus)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[ages])
S <- Fmort / max(Fmort)

## 4  Maturity

mat <- read("maturity", path, plus)
mat <- mat[mat$Year %in% yrs,]
mat <- colMeans(mat[ages])


## 5 Fecundity

## Laa <- read("../../Aopt_estimates/data/VBG_length_estimates")
## LAA <- LAA[LAA$Stock == "NEA_russian", ]
## fec <- read.csv("../../fecundity/fecundity.csv")
## FecAA_russian <- exp(fec[1, 2]) * ((LAA[2:16])^fec[1, 3])


## LAA <- read("../../Aopt_estimates/data/VBG_length_estimates")
## LAA <- LAA[LAA$Stock == "NEA_Lofoten_17", ]
## fec <- read.csv("../../fecundity/fecundity.csv")
## FecAA_Lofoten_17 <- exp(fec[1, 2]) * ((LAA[2:16])^fec[1, 3])


LAA <- read("../../../Aopt_estimates/data/VBG_length_estimates")
LAA <- LAA[LAA$Stock == "NEA_Lofoten_18", ]
fec <- read.csv("../../../fecundity/fecundity.csv")
FecAA <- exp(fec[1, 2]) * ((LAA[4:16])^fec[1, 3])



## 5  Plot

## par(mfrow=c(3,2))
## stdplot(Cp, "Catch composition", "Proportion of catch")
## stdplot(wcatch, "Average catch weights", "Weight (kg)")
## stdplot(S, "Average selectivity", "Selectivity")
## stdplot(BPR, "Biomass per recruit, in the absence of fishing",
##         "Biomass per recruit (kg)")
## stdplot(mat, "Average maturity", "Proportion mature")
## stdplot(wstock, "Average stock weights", "Weight (kg)")

## 6  Export

ne_arctic <-
  list(N=N, Ninit=Ninit, M=M, wcatch=wcatch, wstock=wstock,
       B=B, BPR=BPR, C=C, Cp=Cp, Fmort=Fmort, S=S, mat=mat)
