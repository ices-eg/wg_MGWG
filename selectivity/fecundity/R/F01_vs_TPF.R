
library(plotrix)

rm(list=ls())

nms<-c("faroe_plateau.R", "georges_bank.R",       "greenland.R",
       "gulf_of_maine.R", "gulf_of_maine_2013.R", "iceland.R",
       "nafo_2j3kl.R",    "nafo_3m.R",            "nafo_3no.R",
       "nafo_3ps.R",      "ne_arctic.R",          "north_sea.R",
       "norway.R",        "s_celtic.R",           "w_baltic.R")

refs<-setNames(data.frame(matrix(0,0,6)), c("Yield", "Biomass", "SSB",
                                            "TPF", "stock", "selectivity"))
for(i in c(1, 4, 6, 11, 12, 13, 15)){
    setwd("stocks")
    source(nms[i])
    setwd("..")
    source("functions/applyF0.1TPF.R")
    source("../../R/functions/slide.R")
    Syoung <- slide(S, -1)
    Sold <- slide(S, +1)

    sy<-applyF0.1(Ninit, M, Syoung, mat, wcatch, FecAA)
    sc<-applyF0.1(Ninit, M, S,      mat, wcatch, FecAA)
    so<-applyF0.1(Ninit, M, Sold,   mat, wcatch, FecAA)

   ref<-setNames(data.frame(cbind(c(sy$Y, sc$Y, so$Y),
                                 c(sy$B,  sc$B,  so$B),
                                 c(sy$SSB,  sc$SSB,  so$SSB),
                                 c(sy$TPF, sc$TPF, so$TPF),
                                 rep(strsplit(nms[i],".R")[[1]],3),
                                 c("l","c","h"))),
                 c("Yield", "Biomass", "SSB", "TPF",
                   "stock", "selectivity"))
    refs<-rbind(refs,ref)
    rm(list=setdiff(ls(),c("refs","nms")))
}

str(refs)
refs$TPF<-as.numeric(as.character(refs$TPF))
refs$stnum<-as.numeric(refs$stock)
sort(round(refs$TPF))
jpeg("plots/F01_plots/TPF_atS.jpg", quality=100, width = 700, height = 700)
gap.plot(refs$stnum, refs$TPF,  col=c("black", "grey", "blue"), pch=19,
         gap=c(70000, 650000, 900000, 3200000),
         ytics=c(0, 20000, 50000, 700000, 800000, 900000, 3300000,3500000),
         xtics=levels(as.factor(refs$stnum)),
         xticlab=F, ylab="Total Fecundity (millions)", xlab="Stocks")
mtext(c(unique(as.character(refs$stock))), 1, cex=0.8,
      at=levels(as.factor(refs$stnum)), line=rep(1,7))
legend("topright", c("young S","current S","old S"),
       pch=19, col=c("black", "grey", "blue") )
dev.off()

## ##create a graph for stocks with TPF lower than 55000 million
## refs2<-droplevels(subset(refs, TPF<55000))
## sort(round(refs2$TPF))
## jpeg("../F01_plots/TPF_perStock_atS_smallYields.jpg", quality=100, width = 700, height = 700)
## plot(refs2$stnum, refs2$TPF,  col=c("black", "grey", "blue"),
##      pch=19, ylab="Total Fecundity (millions)", xlab="Stocks",
##      axes = FALSE)
## axis(2)
## axis(1, labels = FALSE)
## mtext(c(unique(as.character(refs$stock))), 1, cex=0.8,
##       at=levels(as.factor(refs$stnum)), line=rep(1,7))
## legend("topleft", c("young S","current S","old S"),
##        pch=19, col=c("black", "grey", "blue"))
## dev.off()


#Standardize TPF values to compare stocks
g<-subset(refs, selectivity=="c")
refs$currentTPF<-rep(g$TPF, each=3)
refs$stdTPF<-refs$TPF/refs$currentTPF
head(refs)

jpeg("plots/F01_plots/Std_TPF_perStock.jpg", quality=100, width = 700, height = 700)
plot(refs$stnum, refs$stdTPF,
     col=c("deeppink", "grey", "cyan3"),
     pch=19, xaxt="n",
     ylab="Standardized TPF", xlab="Stocks")
axis(side=1, at=levels(as.factor(refs$stnum)),
     labels=F, col=rep(1:2,2.5, each=2))
mtext(c(unique(as.character(refs$stock))), 1,
      cex=0.8, at=levels(as.factor(refs$stnum)),
      line=rep(c(1),4.5))
abline(v=c(levels(as.factor(refs$stnum))), lty=2, col="grey")
legend("topright", horiz=T, c("young S","current S","old S"),
       pch=19, col=c("deeppink", "grey", "cyan3") )
dev.off()


#Standardize SSB values to compare stocks
refs$SSB<-as.numeric(as.character(refs$SSB))
g<-subset(refs, selectivity=="c")
refs$currentSSB<-rep(g$SSB, each=3)
refs$stdSSB<-refs$SSB/refs$currentSSB
head(refs)

jpeg("../F01_plots/Std_SSB_perStock.jpg", quality=100, width = 700, height = 700)
plot(refs$stnum, refs$stdSSB,
     col=c("deeppink", "grey", "cyan3"),
     pch=19, xaxt="n",
     ylab="Standardized SSB", xlab="Stocks")
axis(side=1, at=levels(as.factor(refs$stnum)),
     labels=F, col=rep(1:2,2.5, each=2))
mtext(c(unique(as.character(refs$stock))), 1,
      cex=0.8, at=levels(as.factor(refs$stnum)),
      line=rep(c(1),4.5))
abline(v=c(levels(as.factor(refs$stnum))), lty=2, col="grey")
legend("topright", horiz=T, c("young S","current S","old S"),
       pch=19, col=c("deeppink", "grey", "cyan3") )
