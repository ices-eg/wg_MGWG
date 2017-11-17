rm(list=ls(all=T))

topdirect<-"C:\\Users\\jonathan.deroba\\Documents\\GitHub\\MGWG\\state-space"
species<-"SNEMAYT"

library(stockassessment)
SAMfit<-paste(topdirect,species,"SAM",sep="\\")


ASAPname<-paste0(species,"_ASAP_000.RDAT")
ASAPfit<-dget(paste(topdirect,species,"ASAP",ASAPname,sep="\\"))


