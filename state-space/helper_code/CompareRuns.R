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


ASAPname<-paste0(species,"_ASAP_000.RDAT")
ASAPfit<-dget(paste(topdirect,species,"ASAP",ASAPname,sep="\\"))


