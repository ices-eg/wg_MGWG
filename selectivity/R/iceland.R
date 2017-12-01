## Icelandic cod: cohort biomass, catch, selectivity

source("functions/cohortBiomass.R")

url <- "http://data.hafro.is/assmt/2017/cod/"

yrs <- 2007:2016

## 1  Cohort biomass

w <- read.csv(paste0(url, "catch_weights.csv"), check.names = FALSE)
w <- w[w$Year %in% yrs,]
w <- colMeans(w[-1]/1000)

M <- 0.2

N <- read.csv(paste0(url, "nmat.csv"), check.names = FALSE)
Ninit <- N$"3"[N$Year %in% yrs]
Ninit <- mean(Ninit)

B <- cohortBiomass(Ninit, w, M)
BPR <- cohortBiomass(1, w, M)

## 2  Catch and selectivity

C <- read.csv(paste0(url, "catage.csv"), check.names = FALSE)
C <- C[C$Year %in% yrs,]
C <- colMeans(C[-1])
Cw <- C * w

Fmort <- read.csv(paste0(url, "fmat.csv"), check.names = FALSE)
Fmort <- Fmort[Fmort$Year %in% yrs,]
Fmort <- colMeans(Fmort[-1])
S <- Fmort / max(Fmort)

## 3  Plot

pdf("iceland.pdf", 10, 10)  # 4, 12
par(mfrow=c(2,2))           # 4, 1
barplot(C, xlab="Age", ylab="Catch (millions)", main="Average catch in numbers")
barplot(Cw, xlab="Age", ylab="Catch (kt)", main="Average catch in weight")
barplot(B, xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing")
plot(as.integer(names(S)), S, type="l", ylim=c(0,1.05), xlab="Age",
     ylab="Selectivity", main="Average selectivity", yaxs="i")
dev.off()
