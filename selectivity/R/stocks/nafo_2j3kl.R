source("../functions/cohortBiomass.R")
source("../functions/dims.R")
source("../functions/read.R")
source("../functions/stdplot.R")

path <- "../../data/nafo_2j3kl"
dims(path)
yrs <- 2006:2015
ages <- as.character(2:14)
plus <- FALSE

## 1  Population

N <- read("natage", path, plus)
Ninit <- N$"2"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- read("natmort", path, plus)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[-1])
M <- c(M, rep(M[length(M)], length(ages)-length(M)))
names(M) <- ages

## 2  Weights, cohort biomass

wcatch <- read("wcatch", path, plus)
wcatch <- wcatch[wcatch$Year %in% yrs,]
wcatch <- colMeans(wcatch[ages], na.rm=TRUE)

wstock <- read("wstock", path, plus)
wstock <- wstock[wstock$Year %in% yrs,]
wstock <- colMeans(wstock[ages])

B <- cohortBiomass(Ninit, M, wcatch)
## One recruit at age 3 => exp(M["2"]) at age 2
BPR <- cohortBiomass(exp(M["2"]), M, wcatch)

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

nafo_2j3kl <-
  list(N=N, Ninit=Ninit, M=M, wcatch=wcatch, wstock=wstock,
       B=B, BPR=BPR, C=C, Cp=Cp, Fmort=Fmort, S=S, mat=mat)
