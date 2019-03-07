
library(plotrix)

rm(list=ls())
nms<-c("faroe_plateau.R", "georges_bank.R",       "greenland.R",
       "gulf_of_maine.R", "gulf_of_maine_2013.R", "iceland.R",
       "nafo_2j3kl.R",    "nafo_3m.R",            "nafo_3no.R",
       "nafo_3ps.R",      "ne_arctic.R",          "north_sea.R",
       "norway.R",        "s_celtic.R",           "w_baltic.R")

refs<-setNames(data.frame(matrix(0,0,6)), c("Yield", "Biomass", "SSB",
                                            "TPF", "stock", "selectivity"))
## to skip if(i== c(2, 3, 5, 7, 8, 9, 10, 14)) next
i <- 4
##for(i in 1:length(nms)){
for(i in c(1, 4, 6, 11, 12, 13, 15)){
  setwd("stocks")
  source(nms[i])
  setwd("..")
  source("functions/applyFmaxTPF.R")
  source("functions/slide.R")
  Syoung <- slide(S, -1)
  Sold <- slide(S, +1)

  sy<-applyFmax(Ninit, M, Syoung, mat, wcatch, FecAA)
  sc<-applyFmax(Ninit, M, S, mat, wcatch, FecAA)
  so<-applyFmax(Ninit, M, Sold, mat, wcatch, FecAA)

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
jpeg("../Fmax_plots/TPF_atS.jpg", quality=100, width = 700, height = 700)

gap.plot(refs$stnum, refs$TPF,  col=c("black", "grey", "blue"), pch=19,
         gap=c(500000,  3500000),
#         ytics=c(0, 20000, 50000, 700000, 800000, 900000, 3300000,3500000),
         xtics=levels(as.factor(refs$stnum)),
         xticlab=F, ylab="Total Fecundity (millions)", xlab="Stocks")
mtext(c(unique(as.character(refs$stock))), 1, cex=0.8,
      at=levels(as.factor(refs$stnum)), line=rep(1,7))
legend("topright", c("young S","current S","old S"),
       pch=19, col=c("black", "grey", "blue") )
dev.off()

##create a graph for stocks with yields lower than 23000 tonnes
## refs2<-droplevels(subset(refs, Yield<23000))

## jpeg("../Fmax_plots/Yield_perStock_atS_smallYields.jpg", quality=100, width = 700, height = 700)
## plot(refs2$stnum, refs2$Yield,  col=c("black", "grey", "blue"), pch=19, xaxt="n", ylab="Yield", xlab="Stocks")
## axis(side=1, at=levels(as.factor(refs2$stnum)), labels=F, col=rep(1:2,2.5, each=2))
## mtext(c(unique(as.character(refs2$stock))), 1, cex=0.8, at=levels(as.factor(refs2$stnum)), line=rep(c(1,2),4.5), col=rep(1:2,2.5, each=2))
## legend("top", horiz=T, c("young S","current S","old S"), pch=19, col=c("black", "grey", "blue") )
## dev.off()

#Standardize TPF values to compare stocks
g<-subset(refs, selectivity=="c")
refs$currentTPF<-rep(g$TPF, each=3)
refs$stdTPF<-refs$TPF/refs$currentTPF
head(refs)

jpeg("../Fmax_plots/Std_TPF_perStock.jpg", quality=100, width = 700, height = 700)
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



