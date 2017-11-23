## Icelandic Cod

source("functions/cohortBiomass.R")

## Read weight data and average the last ten years
w <- read.csv("http://data.hafro.is/assmt/2017/cod/catch_weights.csv", check.names = FALSE)
w <- tail(w, 10)
w <- colMeans(w[-1]/1000)

M <- 0.2

N <- read.csv("http://data.hafro.is/assmt/2017/cod/nmat.csv", check.names = FALSE)
Ninit <- tail(N$"3", 10)
Ninit <- mean(Ninit)

B <- cohortBiomass(Ninit, w, M)
pdf("icelandic.pdf", 7, 6)
barplot(B, names=names(B), xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing\n(Icelandic cod)")
dev.off()
