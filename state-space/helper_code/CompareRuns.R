rm(list=ls(all=T))
#devtools::install_github("fishfollower/SAM/stockassessment")
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

####calc approx 95% CI fxn 
asm.ci2<-function(x,cv.x){
  #generate approximate 95% confidence intervals based on log normal variable x
  #and it's cv. cv.x
  s<-sqrt(log(1+cv.x^2))
  s<-ifelse(is.finite(s),s,0)
  lci<-x*exp(-1.96*(s))
  uci<-x*exp(1.96*(s))
  return(data.frame("Low"=lci,"High"=uci))
}


ASAPname<-paste0(species,"_ASAP")
asap<-dget(paste(topdirect,species,"ASAP",paste0(ASAPname,"_000.rdat"),sep="\\"))
asapstd <- read.table(paste(topdirect,species,"ASAP",paste0(ASAPname,"_000.std"),sep="\\"), header = F, skip=1,sep = "") # Read in std file from admb
names(asapstd) <- c("index", "name", "value", "stdev" )
asapstd$CV<-asapstd$stdev/asapstd$value
CIs<-asm.ci2(x=asapstd$value,cv.x=asapstd$CV)
asapstd<-cbind(asapstd,CIs)
years <- seq(asap$parms$styr, asap$parms$endyr)

ASAPret<-get_asap_retros(asap.name=ASAPname)

rhos<-data.frame(ASAPret$rec.rho,ASAPret$ssb.rho,ASAPret$avgf.rho)
names(rhos)<-c("R(age 1)","SSB",paste0("Fbar(",paste(asap$options$Freport.agemin,asap$options$Freport.agemax,sep="-"),")"))
write.table(rhos,file=paste(topdirect,species,"ASAP","Mohn.txt",sep="\\"), sep="\t", quote=FALSE, row.names=FALSE)

tab1asap<-cbind(Year=years,asapstd[asapstd$name=="recruits",c(3,6:7)],
                asapstd[asapstd$name=="SSB",c(3,6:7)],
                asapstd[asapstd$name=="Freport",c(3,6:7)])
names(tab1asap)[c(2,5,8)]<-c("R(age 1)","SSB",paste0("Fbar(",paste(asap$options$Freport.agemin,asap$options$Freport.agemax,sep="-"),")"))
write.table(tab1asap, file=paste(topdirect,species,"ASAP","tab1.csv",sep="\\"), sep=",\t", quote=FALSE, row.names=FALSE)




