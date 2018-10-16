source("../functions/cohortBiomass.R")
source("../functions/dims.R")
source("../functions/read.R")
source("../functions/stdplot.R")

path <- "../../data/north_sea"
dims(path)
yrs <- 2008:2017
ages <- as.character(1:10)
plus <- FALSE

## 1  Population

N <- read("natage", path, plus)
Ninit <- N$"1"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- read("natmort", path, plus)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[-1])
M <- c(M, rep(M[length(M)], length(ages)-length(M)))
names(M) <- ages

## 2  Weights, cohort biomass

wcatch <- read("wcatch", path, plus)
wcatch <- wcatch[wcatch$Year %in% yrs,]
wcatch <- colMeans(wcatch[ages])

wstock <- read("wstock", path, plus)
wstock <- wstock[wstock$Year %in% yrs,]
wstock <- colMeans(wstock[ages])

B <- cohortBiomass(Ninit, M, wcatch)
## One recruit at age 3 => exp(M["1"]+M["2"]) at age 1
BPR <- cohortBiomass(exp(M["1"]+M["2"]), M, wcatch)

## 3  Catch and selectivity

C <- read("catage", path, plus)
C <- C[C$Year %in% yrs,]
C <- colMeans(C[ages])
Cp <- C / sum(C)

Fmort <- read("fatage", path, plus)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[-1])
Fmort <- c(Fmort, rep(Fmort[length(Fmort)], length(ages)-length(Fmort)))
names(Fmort) <- ages
S <- Fmort / max(Fmort)

## 4  Maturity

mat <- read("maturity", path, plus)
mat <- mat[mat$Year %in% yrs,]
mat <- colMeans(mat[-1])
mat <- c(mat, rep(mat[length(mat)], length(ages)-length(mat)))
names(mat) <- ages


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

north_sea <-
  list(N=N, Ninit=Ninit, M=M, wcatch=wcatch, wstock=wstock,
       B=B, BPR=BPR, C=C, Cp=Cp, Fmort=Fmort, S=S, mat=mat)
