## devtools::install_github("fishfollower/sam/stockassessment")
library(stockassessment)
source("functions/cohortBiomass.R")
source("functions/read.html.R")

url <- "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/nscod_ass06_fc17/"

## 1  Cohort biomass

w <- read.ices(paste0(url, "data/sw.dat"))
w[w==0] <- NA
w <- tail(w[,1:10], 10)
w <- colMeans(w)

M <- read.ices(paste0(url, "data/nm.dat"))
M <- tail(M[,1:10],10)
M <- colMeans(M)

N <- read.html(paste0(url, "res/xxx-00-00.00.00_tab2.html"))
N <- tail(N$"1", 10)
N <- mean(N) / 1000

B <- cohortBiomass(N, w, M)
pdf("north-sea-cohort.pdf", 7, 6)
barplot(B, names=names(B), xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing\n(North Sea cod)")
dev.off()

## 2  Catch and selectivity

C <- read.ices(paste0(url, "data/cn.dat"))
C <- tail(C[,1:10], 10)
C <- colMeans(C) / 1000
pdf("north-sea-catch.pdf", 7, 6)
barplot(C, names=names(C), xlab="Age", ylab="Catch (millions)",
        main="Average catch in numbers\n(North Sea)")
dev.off()

Fmort <- read.html(paste0(url, "res/xxx-00-00.00.00_tab3.html"))
Fmort <- tail(Fmort, 10)
Fmort <- colMeans(Fmort[-1])
S <- Fmort / max(Fmort)
pdf("north-sea-selectivity.pdf", 7, 6)
plot(S, type="l", ylim=c(0,1.05), xlab="Age", ylab="Selectivity",
     main="Average selectivity\n(North Sea)", xaxt="n", yaxs="i")
axis(1, at=seq_along(S), labels=names(S))
dev.off()
