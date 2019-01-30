
library(plotrix)

rm(list=ls())

nms<-c("faroe_plateau.R","georges_bank.R","greenland.R","gulf_of_maine.R","gulf_of_maine_2013.R","iceland.R","nafo_2j3kl.R",
  "nafo_3m.R","nafo_3no.R","nafo_3ps.R","ne_arctic.R","north_sea.R","norway.R","s_celtic.R","w_baltic.R")

refs<-setNames(data.frame(matrix(0,0,5)), c("Yield", "Biomass", "SSB", "stock", "selectivity"))


for(i in 1:length(nms)){
  if(i==10) next        ##skip nafo_3ps stock as there is no S value 
  #i=1
  setwd("stocks")
  source(nms[i])
  setwd("..")
  source("functions/applyFmax.R")
  source("functions/slide.R")
  Syoung <- slide(S, -1)
  Sold <- slide(S, +1)
  
  sy<-applyFmax(Ninit, M, Syoung, mat, wcatch)
  sc<-applyFmax(Ninit, M, S, mat, wcatch)
  so<-applyFmax(Ninit, M, Sold, mat, wcatch)
  
  ref<-setNames(data.frame(cbind(c(sy$Y, sc$Y, so$Y),
                                        c(sy$B,  sc$B,  so$B),
                                        c(sy$SSB,  sc$SSB,  so$SSB), rep(strsplit(nms[i],".R")[[1]],3),c("l","c","h"))), 
                       c("Yield", "Biomass", "SSB", "stock", "selectivity"))
  refs<-rbind(refs,ref)
  rm(list=setdiff(ls(),c("refs","nms")))
}  

str(refs)
refs$Yield<-as.numeric(as.character(refs$Yield))
refs$stnum<-as.numeric(refs$stock)

jpeg("../Fmax_plots/Yield_perStock_atS.jpg", quality=100, width = 700, height = 700)
gap.plot(refs$stnum, refs$Yield,  col=c("black", "grey", "blue"), pch=19, gap=c(95000,220000,280000,550000), 
         ytics=c(seq(0,90000,10000),240000,270000,570000,650000), xtics=levels(as.factor(refs$stnum)), xticlab=F, 
         ylab="Yield", xlab="Stocks")
mtext(c(unique(as.character(refs$stock))), 1, cex=0.8, at=levels(as.factor(refs$stnum)), line=rep(c(1,2),7), 
      col=rep(1:2,3, each=2))
legend("topright", c("young S","current S","old S"), pch=19, col=c("black", "grey", "blue") )
dev.off()

##create a graph for stocks with yields lower than 23000 tonnes
refs2<-droplevels(subset(refs, Yield<23000))

jpeg("../Fmax_plots/Yield_perStock_atS_smallYields.jpg", quality=100, width = 700, height = 700)
plot(refs2$stnum, refs2$Yield,  col=c("black", "grey", "blue"), pch=19, xaxt="n", ylab="Yield", xlab="Stocks")
axis(side=1, at=levels(as.factor(refs2$stnum)), labels=F, col=rep(1:2,2.5, each=2))
mtext(c(unique(as.character(refs2$stock))), 1, cex=0.8, at=levels(as.factor(refs2$stnum)), line=rep(c(1,2),4.5), col=rep(1:2,2.5, each=2))
legend("top", horiz=T, c("young S","current S","old S"), pch=19, col=c("black", "grey", "blue") )
dev.off()


#Standardize Yield values to compare stocks
g<-subset(refs, selectivity=="c")
refs$currentY<-rep(g$Yield, each=3)
refs$stdY<-refs$Yield/refs$currentY
head(refs)

jpeg("../Fmax_plots/Std_Yield_perStock_atS_smallYields.jpg", quality=100, width = 700, height = 700)
plot(refs$stnum, refs$stdY,  col=c("deeppink", "grey", "cyan3"), pch=19, xaxt="n", ylab="Standardized Yield", xlab="Stocks")
axis(side=1, at=levels(as.factor(refs$stnum)), labels=F, col=rep(1:2,2.5, each=2))
mtext(c(unique(as.character(refs$stock))), 1, cex=0.8, at=levels(as.factor(refs$stnum)), line=rep(c(1,2),4.5), col=rep(1:2,2.5, each=2))
abline(v=c(levels(as.factor(refs$stnum))), lty=2, col="grey")
legend("topleft", horiz=T, c("young S","current S","old S"), pch=19, col=c("deeppink", "grey", "cyan3") )
dev.off()

