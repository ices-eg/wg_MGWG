source("../functions/cohortBiomass.R")
source("../functions/dims.R")
source("../functions/read.R")
source("../functions/stdplot.R")

path <- "../../data/nafo_3ps"
dims(path)
yrs <- 2004:2013
ages <- as.character(3:14)
plus <- TRUE

## 1  Population

## N <- read("natage", path, plus)
## Ninit <- N$"1"[N$Year %in% yrs]
## Ninit <- mean(Ninit)

## M <- read("natmort", path, plus)
## M <- M[M$Year %in% yrs,]
## M <- colMeans(M[ages])

## 2  Weights, cohort biomass

wcatch <- read("wcatch", path, plus)
wcatch <- wcatch[wcatch$Year %in% yrs,]
wcatch <- colMeans(wcatch[ages])

wstock <- read("wstock", path, plus)
wstock <- wstock[wstock$Year %in% yrs,]
wstock <- colMeans(wstock[ages])

## B <- cohortBiomass(Ninit, M, wcatch)
## One recruit at age 3
## BPR <- cohortBiomass(1, M, wcatch)

## 3  Catch and selectivity

C <- read("catage", path, plus)
C <- C[C$Year %in% yrs,]
C <- colMeans(C[ages])
Cp <- C / sum(C)

## Fmort <- read("fatage", path, plus)
## Fmort <- Fmort[Fmort$Year %in% yrs,]
## Fmort <- colMeans(Fmort[ages])
## S <- Fmort / max(Fmort)

## 4  Maturity

mat <- read("maturity", path, plus)
mat <- mat[mat$Year %in% yrs,]
mat <- colMeans(mat[ages])

## 5  Plot

## par(mfrow=c(3,2))
## stdplot(Cp, "Catch composition", "Proportion of catch")
## stdplot(wcatch, "Average catch weights", "Weight (kg)")
## stdplot(mat, "Average maturity", "Proportion mature")
## stdplot(wstock, "Average stock weights", "Weight (kg)")

## 6  Export

nafo_3ps <-
  list(wcatch=wcatch, wstock=wstock,
       C=C, Cp=Cp, mat=mat)
