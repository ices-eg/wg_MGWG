## devtools::install_github("fishfollower/sam/stockassessment")
library(stockassessment)
source("functions/cohortBiomass.R")
source("functions/read.sao.R")

url <- "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/nscod16-ass02/"

w <- read.ices(paste0(url, "data/sw.dat"))
w[w==0] <- NA
w <- tail(w[,1:10], 10)
w <- colMeans(w)

## cw <- read.ices(paste0(url, "data/cw.dat"))
## cw[cw==0] <- NA
## cw <- tail(cw[,1:10], 10)
## cw <- colMeans(cw)

M <- read.ices(paste0(url, "data/nm.dat"))
M <- tail(M[,1:10],10)
M <- colMeans(M)

N <- read.sao(paste0(url, "res/xxx-00-00.00.00_tab2.html"))
N <- tail(N$"1", 10)
N <- mean(N) / 1000

B <- cohortBiomass(N, w, M)
pdf("north-sea.pdf", 7, 6)
barplot(B, names=names(B), xlab="Age", ylab="Biomass (kt)",
        main="Biomass of average cohort, in the absence of fishing\n(North Sea cod)")
dev.off()
