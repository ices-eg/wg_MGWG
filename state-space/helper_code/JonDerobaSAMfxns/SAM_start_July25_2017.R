rm(list=ls(all=T))
#devtools::install_github("fishfollower/SAM/stockassessment", ref="mack")
#devtools::install_github("fishfollower/SAM/stockassessment")
#install.packages("TMB")
library(stockassessment)
source(paste("F:\\SAM_StateSpace","functions.R",sep="\\")) #shouldn't have to touch
#library(TMB)

datdirect<-"C:\\Users\\jonathan.deroba\\Documents\\GitHub\\MGWG\\state-space\\WhiteHake" #directory where data are held
run<-"Run1" #subdirectory of datdirect to hold individual model runs.
likeliprof<-TRUE #Do likelihood profile of M?  Results placed in "run" folder

docomps<-FALSE #make plots of SSB, R, F, and catch (in case multipliers estimated) for runs specified
if(docomps){
  #needs sub folder in datdirect called CompRuns
  compare<-compruns(runs=c("Run23","Run23M27"),datdirect=datdirect)
}
  
#read in data; the data structure is a Lowestoft relic that SAM was written to steal from
#should only touch if .dat names change or if you add a data file
cn <- read.ices(paste(datdirect,"WHITEHAKE_cn.dat",sep="\\"))
cw <- read.ices(paste(datdirect,"WHITEHAKE_cw.dat",sep="\\"))
dw <- read.ices(paste(datdirect,"WHITEHAKE_dw.dat",sep="\\"))
lf <- read.ices(paste(datdirect,"WHITEHAKE_lf.dat",sep="\\"))
lw <- read.ices(paste(datdirect,"WHITEHAKE_lw.dat",sep="\\"))
mo <- read.ices(paste(datdirect,"WHITEHAKE_mo.dat",sep="\\"))
nm <- read.ices(paste(datdirect,"WHITEHAKE_nm.dat",sep="\\"))
pf <- read.ices(paste(datdirect,"WHITEHAKE_pf.dat",sep="\\"))
pm <- read.ices(paste(datdirect,"WHITEHAKE_pm.dat",sep="\\"))
sw <- read.ices(paste(datdirect,"WHITEHAKE_sw.dat",sep="\\"))
surveys <- read.ices(paste(datdirect,"WHITEHAKE_survey.dat",sep="\\"))

ages<-seq(1,ncol(cn),1) #just ages, no need to touch

#setup the data as needed for SAM; only touch if data files are added above
dat <- setup.sam.data(surveys=surveys,
                      residual.fleet=cn, 
                      prop.mature=mo, 
                      stock.mean.weight=sw, 
                      prop.f=pf, 
                      prop.m=pm, 
                      natural.mortality=nm,
                      land.frac=lf,
                      dis.mean.weight = dw,
                      land.mean.weight = lw,
                      catch.mean.weight=cw)

#conf<-loadConf(dat=dat,file=paste(datdirect,paste(run,"ModelConf.txt",sep="\\"),sep="\\" ))
conf<-defcon(dat) #a default configuration for SAM; no touch
saveConf(conf,file=paste(datdirect,paste(run,"ModelConf.txt",sep="\\"),sep="\\" ),overwrite=T)

conf<-loadConf(dat=dat,file=paste(datdirect,paste(run,"ModelConf.txt",sep="\\"),sep="\\" ))
#conf<-fit$conf #set configuration to a previous run (need to read in a previous fit below)

###Shouldn't need to touch anything below here.  #although changing SR params starting vals if estimated can help convergence

par<-defpar(dat,conf) #some default starting values

#par$rec_loga<-1 #if using Bev Holt recruitment for changing start val
#par$rec_logb<- -12 #if using Bev Holt recruitment for changing start val
fit<-sam.fit(dat,conf,par,run=T) #fit the model
saveRDS(fit,file=paste(datdirect,paste(run,"SAMfit.RData",sep="\\"),sep="\\" )) #save the results
#fit<-readRDS(file=paste(datdirect,paste(run,"SAMfit.RData",sep="\\"),sep="\\" )) #read old result back-in; I noticed some plots aren't made correctly when you read in old results.

modelTable<-modeltable(fit) #AIC and number of params
write.csv(modelTable,file=paste(datdirect,paste(run,"ModelTable.csv",sep="\\"),sep="\\" ))

#Creates graphic axis names
#getnames<-function(confa,agesa,looptoa,looptob,namesa) 
#confa is the section of configuration file wanted
#agesa is vector of ages c(1,2,...)
#looptoa is number of unique states, couplings, or whatever in the given conf
#looptob is number of rows in the conf file that are relevant (e.g., first row of keyLogFpar is for fishery, and so looptob isn't nrows, it's number of surveys)
#names are exactly that, the names for the graphic (the fxn ties these names to proper age couplings)
qplotnames<-getnames(confa=conf$keyLogFpar[2:nrow(conf$keyLogFpar),],agesa=ages,looptoa=(max(conf$keyLogFpar)+1),looptob=(length(names(surveys))),namesa=names(surveys))
Fpronames<-getnames(confa=t(as.matrix(conf$keyVarF[1,])),agesa=ages,looptoa=(max(conf$keyVarF)+1),looptob=1,namesa="SD LogF process")
Npronames<-getnames(confa=t(as.matrix(conf$keyVarLogN)),agesa=ages,looptoa=(max(conf$keyVarLogN)+1),looptob=1,namesa="SD LogN process")
Obsnames<-getnames(confa=conf$keyVarObs,agesa=ages,looptoa=(max(conf$keyVarObs)+1),looptob=nrow(conf$keyVarObs),namesa=c("Catch",names(surveys)))
Obsnames<-paste("SD",Obsnames)
varplotnames<-c(Fpronames,Npronames,Obsnames)
Fstanames<-getnames(confa=t(as.matrix(conf$keyLogFsta[1,])),agesa=ages,looptoa=(max(conf$keyLogFsta)+1),looptob=1,namesa="F")

if(conf$noScaledYears>0){
catchmultnames<-getnames(confa=as.matrix(conf$keyParScaledYA),agesa=ages,looptoa=(max(conf$keyParScaledYA)+1),looptob=(max(conf$keyParScaledYA)+1),namesa=rep("Scalar",max(conf$keyParScaledYA)+1))
#to assign years to catch scalar names for plots
catchmults<-data.frame(t(conf$keyScaledYears),conf$keyParScaledYA)
names(catchmults)<-c("Year",ages)
for(m in 1:(max(conf$keyParScaledYA)+1)) {
  myearnum<-c()
  for(r in 1:nrow(conf$keyParScaledYA)){
    myears<-sapply(data.frame(conf$keyParScaledYA)[r,],function(x) any(x==(m-1)))
    if(myears[m]) {
      myearnum<-c(myearnum,catchmults[r,1])
    }
  }
  if(m==1) {
    yearlabels<-paste(min(myearnum),max(myearnum),sep="to")
  } else {
    yearlabels<-c(yearlabels,paste(min(myearnum),max(myearnum),sep="to"))
  }
}
catchmultnames<-paste(catchmultnames,yearlabels,sep=" ")
if(length(catchmultnames)==2*(max(conf$keyParScaledYA)+1)) {
  catchmultnames<-catchmultnames[1:(max(conf$keyParScaledYA)+1)]
}
} else {
  catchmultnames<-NA
}

#make the plots and save to pdf in Run sub-directory
plotfxn(afit=fit,datdirect=datdirect,run=run,confa=conf,qplotnamesa=qplotnames,varplotnamesa=varplotnames,fstanamesa=Fstanames,catchmultnamesa=catchmultnames)

#does likelihood profile and makes some plots; puts results in run directory
#may not be working correctly
if(likeliprof){likeliprofile(fit=fit,datdirect=datdirect,run=run)}

