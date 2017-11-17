
plotfxn<-function(afit=NULL,datdirect=NULL,run=NULL,confa=NULL,qplotnamesa=NULL,varplotnamesa=NULL,fstanamesa=NULL,catchmultnamesa=NULL){
  forpdf<-paste(run,".pdf",sep="")
  pdf(paste(paste(datdirect,run,sep="/"),forpdf,sep="/")) #create pdf for graph storage
  
  #a bunch of pre-fab SAM plots that come with the fitting package
  par(mfrow=c(1,1))
  catchplot(afit)
  par(mfrow=c(1,1))
  fbarplot(afit)
  par(mfrow=c(1,1))
  fitplot(afit)
  par(mfrow=c(1,1))
  obscorrplot(afit)
  par(mfrow=c(1,1))
  parplot(afit)
  par(mfrow=c(1,1))
  recplot(afit)
  par(mfrow=c(1,1))
  srplot(afit)
  par(mfrow=c(1,1))
  ssbplot(afit)
  par(mfrow=c(1,1))
  tsbplot(afit)
  
  resids<-residuals(afit)
  plot(resids)
  residpro<-procres(afit)
  plot(residpro)
  retro<-retro(afit,year=7)
  plot(retro)
  lo<-leaveout(afit) #"leave one out", as in fit without each survey
  plot(lo)
  
  #rescale F's at age to max of one as in selectivity and plot through years
  select<-matrix(nrow=nrow(faytable(afit)),ncol=ncol(faytable(afit)))
  for(s in 1:nrow(faytable(afit))){
    select[s,]<-faytable(afit)[s,]/max(faytable(afit)[s,])
  }
  select.b<-select #this saves select at all ages instead of just 1 select for each Fstate
  select<-select[,!duplicated(select,MARGIN=2)]
  for(d in 1:ncol(select)){
    if(d==1){
      plot(select[,d],type='l',col=d,ylim=c(0,1),xlab="",xaxt="n",ylab="Selectivity")
    } else {
      lines(select[,d],type='l',col=d)
    }
  }
  axis(1,at=seq(1:length(afit$data$years)),labels=afit$data$years)
  legend(x="topleft",legend=fstanamesa,fill=seq(1:ncol(select)))
  
  #3d of selectivity through time
  library(lattice)
  print(wireframe(as.matrix(select.b),aspect = c(1.1, 0.9),ylab="Age",xlab="Year",zlab="Selectivity",
            drape=T,col.regions=rainbow(500),colorkey=T,screen=list(z=-55,x=-50),par.box = list(col=1),col=NA,alpha.regions=0.8))
  
  #############################MSY reference points and unfished conditions
  ###################using final year life history and selectivity if BH estimated
  if(afit$conf$stockRecruitmentModelCode==2){
    alpha<-partable(afit)["rec_loga_0","exp(par)"]
    beta<-partable(afit)["rec_logb_0","exp(par)"]
    natMor<- afit$data$natMor[nrow(afit$data$natMor),]
    StWt<-afit$data$stockMeanWeight[nrow(afit$data$stockMeanWeight),]
    Mature<-afit$data$propMat[nrow(afit$data$propMat),]
    
    SRparms<-SR.parms(nage=max(afit$data$maxAgePerFleet),M=natMor,Wt=StWt,Mat=Mature,alpha=alpha,beta=beta,type=afit$conf$stockRecruitmentModelCode)
    R0<-SRparms$R0
    B0<-SRparms$B0
    steep<-SRparms$steep
    SSBR0<-SRparms$SSBR0
    Fmsy<-MSY.find(M=natMor,Wt=StWt,Mat=Mature,steep=steep,selectivity.F=select.b[nrow(select.b),],B0=B0,type=afit$conf$stockRecruitmentModelCode,med.recr=0,SSBR0=SSBR0,B.MSYflag=F)$F.MSY
    MSY<-MSY.find(M=natMor,Wt=StWt,Mat=Mature,steep=steep,selectivity.F=select.b[nrow(select.b),],B0=B0,type=afit$conf$stockRecruitmentModelCode,med.recr=0,SSBR0=SSBR0,B.MSYflag=F)$MSY
    Bmsy<-max.ypr(F=Fmsy,M=natMor,Wt=StWt,Mat=Mature,selectivity.F=select.b[nrow(select.b),],B0=B0,type=afit$conf$stockRecruitmentModelCode,med.recr=0,steep=steep,SSBR0=SSBR0,B.MSYflag=T)
    write.csv(data.frame(R0,B0,steep,Fmsy,MSY,Bmsy),paste(datdirect,paste(run,"MSYrefs_SRparms.csv",sep="/"),sep="/"))
  }    
  ########
  
  mohn_rhossb<-calc_Mohn_rho(fit=afit,ret=retro,npeel=7,what="ssb") #calculate and plot retro
  mohn_rhofbar<-calc_Mohn_rho(fit=afit,ret=retro,npeel=7,what="fbar") #calculate and plot retro
  mohn_rhoR<-calc_Mohn_rho(fit=afit,ret=retro,npeel=7,what="R") #calculate and plot retro
  catchresids<-calc_catch_resids(fit=afit) #Legault catch residuals
  
  
  par(mar=c(15,4.1,4.1,2.1))
  params<-partable(afit)
  #catchabilities
  barplot(params[grep("^logFpar",rownames(params)),"exp(par)"],names.arg=qplotnamesa,las=3,ylab="Catchability")
  #variance params
  barplot(params[grep("^logSd",rownames(params)),"exp(par)"],names.arg=varplotnamesa,las=3,ylab="Std. Dev.")
  #if using catch scalars
  if(confa$noScaledYears>0){
    barplot(params[grep("^logScale",rownames(params)),"exp(par)"],names.arg=catchmultnamesa,las=3,ylab="Catch Multiplier")
    abline(h=1,lty=2)
  }
  #if F states use estimated correlation
  if(confa$corFlag==1){
    barplot(params[grep("^transf",rownames(params)),"exp(par)"],names.arg=NULL,las=3,ylab="F States Correlation")
  }
  dev.off() #turn off graph pdf
} 

#function to get barplot names
getnames<-function(confa,agesa,looptoa,looptob,namesa) {
  for(q in 1:looptoa) {
    qages<-sapply(data.frame(confa),function(x) any(x==(q-1))) #loop through config file looking for linked parms (e.g., all the 1's)
    #create the age range name (e.g., 1to4) that a given parameter applies to.
    if(q==1) { qagenum<-paste(na.omit(ifelse(qages,agesa,NA))[1],na.omit(ifelse(qages,agesa,NA))[length(na.omit(ifelse(qages,agesa,NA)))],sep="to")
    } else {
      qagenum<-c(qagenum,paste(na.omit(ifelse(qages,agesa,NA))[1],na.omit(ifelse(qages,agesa,NA))[length(na.omit(ifelse(qages,agesa,NA)))],sep="to"))
    }
  }

  for(i in 1:looptob) {
    #repeat the name of the parameter (e.g., SD of F process) as many times as appropriate
    if(looptob==1){
      qplotnames<-rep(namesa[i],length(unique(confa[confa>-1])))
    } else {
    if(i==1) { qplotnames<-rep(namesa[i],length(unique(confa[i,confa[i,]>-1])))
    } else {
      qplotnames<-c(qplotnames,rep(namesa[i],length(unique(confa[i,confa[i,]>-1]))))
    }
    }
  }
  return(paste(qplotnames,qagenum)) #paste parameter name and age range and return it (e.g., SD of F process 1to4)
}

####Two functions below came from Legault.  I modified the Mohn's rho to do relative retro plotting.
# function to compute Mohn's rho 
calc_Mohn_rho <- function(fit,ret,npeel,what){
  what<-paste0("log",what)
  idx <- names(fit$sdrep$value) == what
  y <- exp(fit$sdrep$value[idx])
  if (npeel > length(ret)) npeel <- length(ret)
  rho <- rep(NA, npeel)
  reldiff<-matrix(nrow=length(y),ncol=npeel)
  for (i in 1:npeel){
    y.val <- y[length(y)-i]
    idx <- names(ret[[i]]$sdrep$value) == what
    y2 <- exp(ret[[i]]$sdrep$value[idx])
    y2.val <- y2[length(y2)]
    rho[i] <- (y2.val - y.val) / y.val
    reldiff[,i]<-(y2-y)/y
    if(i==1){
      plot(reldiff[1:(length(y)-i),i],type='l',ylim=c(-1,1),ylab=unlist(strsplit(what,"log",fixed=TRUE))[2],xlab="")
      abline(0,0,col="red")
    } else {
      lines(reldiff[1:(length(y)-i),i],type='l')
    }
  }
  Mohn.rho <- mean(rho, na.rm=T)
  title(main=paste("Mohn's Rho =",round(Mohn.rho,digits=2),sep=" "))
  res <- c(Mohn.rho,rho)
  names(res) <- c("Mohn_rho",paste0("peel",1:npeel))
  return(res)
}

# function to calculate residuals of total catch (in weight)
calc_catch_resids <- function(fit){
  year <- fit$data$years
  CW <- fit$data$catchMeanWeight
  aux <- fit$data$aux
  logobs <- fit$data$logobs
  .goget <- function(y,a){
    ret <- exp(logobs[aux[,"fleet"]==1 & aux[,"year"]==y & aux[,"age"]==a])
    ifelse(length(ret)==0,0,ret)
  }
  obs <- rowSums(outer(rownames(CW), colnames(CW), Vectorize(.goget))*CW, na.rm=TRUE)
  idx <- names(fit$sdrep$value)=="logCatch"
  prd <- exp(fit$sdrep$value[idx])
  catch.resids <- prd - obs
  func.res <- list(year = year,
                   obs = obs,
                   prd = prd,
                   catch.resids = catch.resids)
  plot(year,catch.resids,pch=16)
  abline(h=0,col="red")
  plot(year,catch.resids/obs,pch=16,col="blue")
  abline(h=0,col="red")
  return(func.res)
}

#compare ssb,r, and f time series of different runs
compruns<-function(runs=NULL,datdirect=NULL){
  pdf(paste(paste(datdirect,"CompRuns",sep="/"),"Comp.pdf",sep="/")) #create pdf for graph storage
  numruns<-length(runs)
  want<-c("ssb","fbar","R","Catch")
  wants<-paste0("log",want)
  for(w in 1:4){
  for(r in 1:numruns){
    temprun<-readRDS(file=paste(datdirect,paste(runs[r],"SAMfit.RData",sep="/"),sep="/" ))
    idx <- names(temprun$sdrep$value) == wants[w]
    y <- exp(temprun$sdrep$value[idx])
    if(w==1 & r==1) {
      restable<-data.frame(y)
      resnames<-paste(want[w],runs[r],sep="_")
    } else {
      restable<-data.frame(restable,y)
      resnames<-c(resnames,paste(want[w],runs[r],sep="_"))
    }
    if(r==1){
      plot(y,type='l',col=r,ylab=want[w],xaxt="n",xlab="Year")
    } else {
      lines(y,type='l',col=r)
    }
  }
    legend(x="topright",legend=runs,fill=seq(1:numruns))
    axis(1,at=seq(1:length(temprun$data$years)),labels=temprun$data$years)
  }
  dev.off()
  colnames(restable)<-resnames
  write.csv(restable,paste(paste(datdirect,"CompRuns",sep="/"),"CompTable.csv",sep="/"),row.names=FALSE)
}

#Given SAM estimates of BH alpha and beta, use recent year LH params and calc steepness, unfished...
SR.parms<-function(nage=NULL,M=NULL,Wt=NULL,Mat=NULL,alpha=NULL,beta=NULL,type=NULL){
  nvec<-c()
  nvec[1]<-1 #set the population to one so you don't have to rescale SSBR
  for(i in 2:(nage-1)){nvec[i]<-nvec[i-1]*exp(-M[i-1])}  #unfished abundance vector
  nvec[nage]<-nvec[(nage-1)]*exp(-M[(nage-1)])*(1/(1-exp(-M[nage]))) #plus group!
  SSBR0<-sum(Mat*Wt*nvec)  #unfished SSBR
  
  if(type==2) { #Beverton-Holt stock recruit
    alpha.star<-1/alpha #convert from one variant of BH parm to another because I already had code written for 'other'.
    beta.star<-beta/alpha #convert between BH variant parameterizations (see page 88 Quinn and Deriso)
    steep<-1/((4*alpha.star*(1/SSBR0))+1)
    R0<-(5*steep-1)/(4*steep*beta.star)
    B0<-SSBR0*R0
    return(data.frame("R0"=R0,"B0"=B0,"steep"=steep,"SSBR0"=SSBR0))
  } else if(type!=2){ 
    print("Unknown SR Relationship")
  }
}

#YPR function used to calculate MSY parms, and Fx% levels
max.ypr<-function(F,M,Wt,Mat,selectivity.F,B0,type,med.recr,steep,SSBR0,B.MSYflag){
  #function to be maximized for MSY calculation
  nvec<-c()
  nvec[1]<-1 #set the population to one so you don't have to rescale SSBR
  Faa<-F*selectivity.F
  Z<-M+Faa #total mortality
  for(i in 2:(length(Mat)-1)){nvec[i]<-nvec[i-1]*exp(-Z[i-1])} #ages up to oldest
  nvec[length(Mat)]<-nvec[(length(Mat)-1)]*exp(-Z[length(Mat)-1])*(1/(1-exp(-Z[length(Mat)]))) #plus group!
  SSBR<-sum(Mat*Wt*nvec)
  
  if(type==2) { #Beverton-Holt stock recruit
    R0<-(1/SSBR0)*B0
    Reca<-(B0/R0)*((1-steep)/(4*steep)) #Bev-Holt alpha parm (See Mangel et al 2010 Fish and Fisheries)
    Recb<-(5*steep-1)/(4*steep*R0)  #Bev-Holt Beta
    SSBhat<-(SSBR-Reca)/Recb  #equlibrium SSB
    Rhat<-SSBhat/SSBR        #equilibrium recruitment
  } else if(type==1){ #Ricker
    beta<-(log(steep)-log(0.2))/(0.8*B0)
    alpha<-(exp(beta*B0))/SSBR0
    SSBhat<-(log(alpha)-log(1/SSBR))/(beta)  #equlibrium SSB
    Rhat<-alpha*SSBhat*exp(-beta*SSBhat)     #equilibrium recruitment
  } else (Rhat<-med.recr) #Random recruitment - just use the median for the year being evaluated
  yield<-sum((Faa/Z)*nvec*Wt*(1-exp(-1*Z)))
  if(B.MSYflag) {         #see MSY function for need for flag
    return(SSBhat)
  } else return(yield*Rhat)
}

#Function to return MSY, FMSY.  Calls to max.ypr
MSY.find<-function(M=NULL,Wt=NULL,Mat=NULL,steep=NULL,selectivity.F=NULL
                   ,B0=NULL,type=NULL,med.recr=NULL,SSBR0=NULL,B.MSYflag=NULL)
  #need B.MSYflag because it would screw up optimize function to return something from max.ypr other than MSY (i.e., yield*Rhat)
{
  MSY<-optimize(f=max.ypr,interval=c(0,10),M,Wt,Mat,selectivity.F,B0,type,med.recr,steep,SSBR0,B.MSYflag,maximum=TRUE)
  return(data.frame("MSY"=MSY$objective,"F.MSY"=MSY$maximum))
}

#function to do likelihood profile over M; requires folder called LikeliProfile in the dat direct
likeliprofile<-function(fit=NULL,datdirect=NULL,run=NULL){
  conf<-fit$conf #configuration always exactly like the fit sent, except for M changed below in each run
  par<-defpar(fit$data,conf)  #start each run at default param values
  fit.temp<-fit #let's me change M value easily in loop below
  modelTable<-data.frame(modeltable(fit),"M"=fit$data$natMor[1,1]) #AIC and number of params
  
  for(i in 1:10) {
      step<-0.2*i
      if(step != 1){  #step=1 equates to the fit sent to function and doesn't need to run again
      fit.temp$data$natMor[,]<-fit$data$natMor[,]*step #change M value
      fit.temp<-sam.fit(fit.temp$data,conf,par) #fit the model
      modelTable<-rbind(modelTable,data.frame(modeltable(fit.temp),"M"=fit.temp$data$natMor[1,1]))
      } #close if step != 1
    } #close i
  write.csv(modelTable,file=paste(datdirect,paste(run,"ModelTableLikeProf.csv",sep="/"),sep="/" )
            ,sep=",",row.names=F)
  #modelTable<-read.csv(file=paste(datdirect,paste(run,"ModelTableLikeProf.csv",sep="/"),sep="/" )
  #                     ,header = T,stringsAsFactors = F)[1:10,] #time saver if working in function
  #modelTable<-modelTable[order(modelTable$log.L.),] #don't want to do this
  modelTable=data.frame(apply(modelTable,2,as.numeric)) #check case
  #change from windows to make this platform independent
  png(filename=paste(datdirect,paste(run,"NegLogLike.png",sep="/"),sep="/" ),height = 800,width=800) #plot negativel log likelihood; the modeltable contains loglike and so mult by -1 here
  plot(modelTable$M,(-1*modelTable$log.L.),type='l',xlab="Natural Mortality",ylab="Negative Log Likelihood")
  #savePlot(filename=paste(datdirect,paste(run,"NegLogLike.png",sep="/"),sep="/" ),type="png")
  png(filename=paste(datdirect,paste(run,"AIC.png",sep="/"),sep="/" ),height = 800,width=800) #plot AIC
  plot(modelTable$M,modelTable$AIC,type='l',xlab="Natural Mortality",ylab="AIC")
  #savePlot(filename=paste(datdirect,paste(run,"AIC.png",sep="/"),sep="/" ),type="png")
  graphics.off()
} #close likeliprofile function

