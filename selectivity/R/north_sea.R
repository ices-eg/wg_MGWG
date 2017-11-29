## North Sea cod: cohort biomass, catch, selectivity

## devtools::install_github("fishfollower/sam/stockassessment")
library(stockassessment)
source("functions/cohortBiomass.R")
source("functions/read.html.R")

url <- "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/nscod_ass06_fc17/"

yrs <- as.character(2007:2016)
ages <- as.character(1:10)

## 1  Cohort biomass

w <- read.ices(paste0(url, "data/sw.dat"))
w[w==0] <- NA
w <- w[yrs, ages]
w <- colMeans(w)

M <- read.ices(paste0(url, "data/nm.dat"))
M <- M[yrs, ages]
M <- colMeans(M)

N <- read.html(paste0(url, "res/xxx-00-00.00.00_tab2.html"))
Ninit <- N[N$Year %in% yrs, "1"]
Ninit <- mean(Ninit) / 1000

B <- cohortBiomass(Ninit, w, M)

## 2  Catch and selectivity

C <- read.ices(paste0(url, "data/cn.dat"))
C <- C[yrs, ages]
C <- colMeans(C) / 1000
Cw <- C * w

Fmort <- read.html(paste0(url, "res/xxx-00-00.00.00_tab3.html"))
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[-1])
S <- Fmort / max(Fmort)
S <- c(S[1:5], rep(S["6+"],5))
names(S) <- 1:10

## 3  Plot

pdf("north_sea.pdf", 4, 12)
par(mfrow=c(4,1))
barplot(C, names=names(C), xlab="Age", ylab="Catch (millions)",
        main="Average catch in numbers")
barplot(Cw, names=names(Cw), xlab="Age", ylab="Catch (1000 t)",
        main="Average catch in tonnes")
barplot(B, names=names(B), xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing")
plot(as.integer(names(S)), S, type="l", ylim=c(0,1.05), xlab="Age",
     ylab="Selectivity", main="Average selectivity", yaxs="i")
dev.off()
