## Icelandic Cod

source("functions/cohortBiomass.R")

## 1  Cohort biomass

w <- read.csv("http://data.hafro.is/assmt/2017/cod/catch_weights.csv", check.names = FALSE)
w <- tail(w, 10)
w <- colMeans(w[-1]/1000)

M <- 0.2

N <- read.csv("http://data.hafro.is/assmt/2017/cod/nmat.csv", check.names = FALSE)
N <- tail(N$"3", 10)
N <- mean(N)

B <- cohortBiomass(N, w, M)
pdf("icelandic-cohort.pdf", 7, 6)
barplot(B, names=names(B), xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing\n(Icelandic cod)")
dev.off()


## 2  Catch and selectivity

C <- read.csv("http://data.hafro.is/assmt/2017/cod/catage.csv", check.names = FALSE)
C <- tail(C, 10)
C <- colMeans(C[-1])
pdf("Icelandic-catch.pdf", 7, 6)
barplot(C, names=names(C), xlab="Age", ylab="Catch (millions)",
        main="Average catch in numbers\n(Icelandic)")
dev.off()


Fmort <- read.csv("http://data.hafro.is/assmt/2017/cod/fmat.csv", check.names = FALSE)
Fmort <- tail(Fmort, 10)
Fmort <- colMeans(Fmort[-1])
S <- Fmort / max(Fmort)
pdf("Icelandic-selectivity.pdf", 7, 6)
plot(S, type="l", ylim=c(0,1.05), xlab="Age", ylab="Selectivity",
     main="Average selectivity\n(Icelandic)", xaxt="n", yaxs="i")
axis(1, at=seq_along(S), labels=names(S))
dev.off()


