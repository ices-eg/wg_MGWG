source("../functions/cohortBiomass.R")
source("../functions/dims.R")
source("../functions/read.R")
source("../functions/stdplot.R")

path <- "../../data/north_sea"
dims(path)
yrs <- 2008:2017
ages <- as.character(1:10)
plus <- FALSE

## 1  Cohort biomass

N <- read("natage", path, plus)
Ninit <- N$"1"[N$Year %in% yrs]
Ninit <- mean(Ninit)

M <- read("natmort", path, plus)
M <- M[M$Year %in% yrs,]
M <- colMeans(M[-1])
M <- c(M, rep(M[length(M)], length(ages)-length(M)))
names(M) <- ages

w <- read("wcatch", path, plus)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[ages], na.rm=TRUE)

B <- cohortBiomass(Ninit, M, w)
BPR <- cohortBiomass(1, M, w)

## 2  Catch and selectivity

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

## 3  Plot

## par(mfrow=c(2,2))
## stdplot(Cp, "Catch composition", "Proportion of catch")
## stdplot(w, "Average weight", "Weight (kg)")
## stdplot(S, "Average selectivity", "Selectivity")
## stdplot(BPR, "Biomass per recruit, in the absence of fishing",
##         "Biomass per recruit (kg)")

## 4  Export

north_sea <-
  list(N=N, Ninit=Ninit, M=M, w=w, B=B, BPR=BPR, C=C, Cp=Cp, Fmort=Fmort, S=S)
