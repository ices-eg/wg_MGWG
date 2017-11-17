rm(list=ls(all=T))

topdirect<-"C:\\Users\\jonathan.deroba\\Documents\\GitHub\\MGWG\\state-space"
species<-"SNEMAYT"

########do SAM fit
library(stockassessment)
fit<-readRDS(file=paste(topdirect,species,"SAM","SAMfit.RData",sep="\\")) 

source(paste(topdirect,species,"SAM","pred.R",sep="\\")) # function to predict 

dat<-fit$data
conf <- loadConf(dat,paste(topdirect,species,"SAM","model.cfg",sep="\\"))
par <- defpar(dat,conf)

RES <- residuals(fit)
RESP <- procres(fit)
RETRO <- retro(fit, year=7)
PRED <- predictYears(fit,years=max(fit$data$years)-2:0)
colnames(PRED)<-sub("obs", "logObs", colnames(PRED))

rho <- mohn(RETRO, lag=0)

tab1 <- cbind(Year=fit$data$years, summary(fit), round(catchtable(fit)))
colnames(tab1) <- sub("Estimate", "Catch", colnames(tab1))
write.table(tab1, file=paste(topdirect,species,"SAM","tab1.csv",sep="\\"), sep=",\t", quote=FALSE, row.names=FALSE)

write.table(PRED, file=paste(topdirect,species,"SAM","tab2.csv",sep="\\"), sep=",\t", quote=FALSE, row.names=FALSE)

sink(file=paste(topdirect,species,"SAM","Mohn.txt",sep="\\"))
print(rho)
sink()
########End SAM fit

#########ASAP fit
#-----------------------------------------------
get_asap_retros <- function(asap.name, npeels=7){
  retro.lst <- list()
  asap<-dget(paste(topdirect,species,"ASAP",paste0(asap.name,"_000.rdat"),sep="\\"))
  term.ssb <- asap$SSB
  term.avgf <- asap$F.report
  term.rec <- asap$N.age[,1]
  nyears <- length(term.ssb)
  ssb.rho.vals <- rep(NA, npeels)
  avgf.rho.vals <- rep(NA, npeels)
  rec.rho.vals <- rep(NA, npeels)
  for (ipeel in 1:npeels){
    peel <- dget(paste(topdirect,species,"ASAP",paste0(asap.name,"_00",ipeel,".rdat"),sep="\\"))
    peel.ssb <- peel$SSB
    peel.avgf <- peel$F.report
    peel.rec <- peel$N.age[,1]
    
    xterm <- term.ssb[nyears - ipeel]
    xtip <- peel.ssb[nyears - ipeel]
    ssb.rho.vals[ipeel] <- (xtip - xterm) / xterm
    
    yterm <- term.avgf[nyears - ipeel]
    ytip <- peel.avgf[nyears - ipeel]
    avgf.rho.vals[ipeel] <- (ytip - yterm) / yterm
    
    zterm <- term.rec[nyears - ipeel]
    ztip <- peel.rec[nyears - ipeel]
    rec.rho.vals[ipeel] <- (ztip - zterm) / zterm
  }
  ssb.rho <- mean(ssb.rho.vals, na.rm = TRUE)
  avgf.rho <- mean(avgf.rho.vals, na.rm = TRUE)
  rec.rho <- mean(rec.rho.vals, na.rm = TRUE)
  
  retro.lst$ssb.rho.vals <- ssb.rho.vals
  retro.lst$ssb.rho <- ssb.rho
  retro.lst$avgf.rho.vals <- avgf.rho.vals
  retro.lst$avgf.rho <- avgf.rho
  retro.lst$rec.rho.vals <- rec.rho.vals
  retro.lst$rec.rho <- rec.rho
  return(retro.lst)
}


ASAPname<-paste0(species,"_ASAP")
ASAPret<-get_asap_retros(asap.name=ASAPname)



