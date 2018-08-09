###############################################################################
#                                                                             #
#       Script to compare diagnostic plots from ASAP, SAM and WHAM            #
#                                                                             #
# Notes: Need to add code for WHAM when ready. Still miss the 3 years         #
# back-projections plot because outputs are not ready. Also residuals where   #
# simply calculated for the plots to keep consistency between the models.     #
# It may not be the best method so this may need to be changed and            # 
# standadized for the 3 models.                                               #
# An example of how the pdf file can look like is given in the folder SNEMAYT #
# Vanessa Trijoulet                                                           #
#                                                                             #
###############################################################################

if (require("IDPmisc")==FALSE) {install.packages("IDPmisc")} else {library("IDPmisc")} # package used to handle Inf values in residuals

dir <- getwd() # Should be the correct directory if open the .Rproj
dir_ss <- paste(dir,"state-space",sep="/")
setwd(dir_ss) # work on the state-space folder



#### Choose the fish species you want to plot the diagnoctics for ####

temp <- file.choose() # Choose any file in the folder for species of interest
dir_sp <- dirname(temp) # New directory
#setwd(dir_sp)
dir_sam <- paste(dir_sp,"SAM",sep="/")
dir_asap <- paste(dir_sp,"ASAP",sep="/")
dir_wham <- paste(dir_sp,"WHAM",sep="/")
sp <- tail(strsplit(dir_sp,split="/")[[1]],1) # Extract species name



#### Get files to plot diagnostics ####

models <- c("SAM","ASAP") # Need to add WHAM when ready
n_model <- length(models)

tab1.sam <- read.csv(paste(dir_sam,"tab1.csv",sep="/"),header=T)
tab2.sam <- read.csv(paste(dir_sam,"tab2.csv",sep="/"),header=T)
mohn.sam <- read.table(paste(dir_sam,"Mohn.txt",sep="/"),header=T)
all.sam <- readRDS(paste(dir_sam,"SAMfit.RData",sep="/"))
retro.sam <- readRDS(paste(dir_sam,"SAMfitRETRO.RData",sep="/"))

tab1.asap <- read.csv(paste(dir_asap,"tab1.csv",sep="/"),header=T)
#tab2.asap <- read.csv(paste(dir_asap,"tab2.csv",sep="/"),header=T)
mohn.asap <- read.table(paste(dir_asap,"Mohn.txt",sep="/"),header=T)
all.asap <- dget(paste(dir_asap,paste0(sp,"_ASAP_000.rdat"),sep="/"))
retro.asap <- list()
n_retro <- length(retro.sam)
for (t in 1:n_retro){ # n_retro years peel
  retro.asap[[t]] <- dget(paste(dir_asap,paste0(sp,"_ASAP_00",t,".rdat"),sep="/"))
}
# tab1.wham <- read.csv(paste(dir_wham,"tab1.csv",sep="/"),header=T)
# tab2.wham <- read.csv(paste(dir_wham,"tab2.csv",sep="/"),header=T)
# mohn.wham <- read.table(paste(dir_wham,"Mohn.txt",sep="/"),header=T)
# all.wham <- load(paste(dir_wham,"whamfit.RData",sep="/"))




#### Plot diagnostics in 1 pdf file ####

setwd(dir_sp)
col<-c("black","blue","red")


pdf(file="Diagnostics_3_models.pdf",height=7, width=10)



#### Recruitment, SSB, Fbar + CI ####

tab1.names<-colnames(tab1.sam)

index<-c(2,5,8)
index.legend<-c(1,3,5)

for (i in index){
  min <- min(c(tab1.sam[,i+1],tab1.asap[,i+1]))
  max <- max(c(tab1.sam[,i+2],tab1.asap[,i+2]))
  
  ## different plots
  par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
  plot(tab1.sam[,i]~tab1.sam$Year,ylim=c(min,max),type="l")
  polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam[,i+1],rev(tab1.sam[,i+2])),border=NA,col=rgb(0,0,0,alpha=0.2))
  plot(tab1.asap[,i]~tab1.asap$Year,ylim=c(min,max),type="l",yaxt="n",ylab="")
  polygon(x=c(tab1.asap$Year,rev(tab1.asap$Year)),y=c(tab1.asap[,i+1],rev(tab1.asap[,i+2])),border=NA,col=rgb(0,0,0,alpha=0.2))
  mtext("Year",side=1,outer=T,line=3)
  mtext(tab1.names[i], side=2, outer=T, line=3)
  for (k in 1:n_model){
    mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
  }

  ## or on the same plot
  par(mfrow=c(1,1),xpd=NA)
  plot(tab1.sam[,i]~tab1.sam$Year,ylim=c(min,max),type="l",xlab="Year",ylab=tab1.names[i])
  polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam[,i+1],rev(tab1.sam[,i+2])),border=NA,col=rgb(0,0,0,alpha=0.2))
  lines(tab1.asap[,i]~tab1.asap$Year,col=col[2],lty=2)
  polygon(x=c(tab1.asap$Year,rev(tab1.asap$Year)),y=c(tab1.asap[,i+1],rev(tab1.asap[,i+2])),border=NA,col=rgb(0,0,255,alpha=60,maxColorValue=255))
  legend("topright",legend=models,lty=1:n_model,bty="n",col=col)
  
}


#### Mohn's rho ####

mohn <- rbind(mohn.sam,mohn.asap)
rownames(mohn)<-models
min<-min(mohn)
max<-max(mohn)

par (mfrow=c(1,1),xpd=NA)
plot(t(mohn[1,]),ylim=c(min,max),pch=16,xaxt="n",xlab="",ylab="Mohn's rho")
for (i in 2:n_model){
  points(t(mohn[i,]),pch=15+i,col=col[i])
}
text(x=1:ncol(mohn),y=rep(min*1.5,ncol(mohn)),labels=colnames(mohn))
legend("topright",legend=models,pch=16:(16+n_model),bty="n",col=col)
par(xpd=FALSE)
abline(h=0,lty=2,col="grey")


#### Aggregated catch ####

obs.catch<-all.asap$catch.obs[1,]

min <- min(c(obs.catch,tab1.sam$Low.3,all.asap$catch.pred))
max <- max(c(obs.catch,tab1.sam$High.3,all.asap$catch.pred))
  
## different plots
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
#SAM
plot(obs.catch~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red")
lines(tab1.sam$Catch~tab1.sam$Year)
polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
# ASAP
plot(obs.catch~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",yaxt="n")
lines(all.asap$catch.pred[1,]~tab1.sam$Year)
#polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
# WHAM
#
mtext("Year",side=1,outer=T,line=3)
mtext("Aggregated catch", side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
  
## or on the same plot
par(mfrow=c(1,1),xpd=NA)
plot(obs.catch~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="Year",ylab="Aggregated catch")
lines(tab1.sam$Catch~tab1.sam$Year)
polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
lines(all.asap$catch.pred[1,]~tab1.sam$Year,lty=2,col=col[2])
#polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,255,alpha=60,maxColorValue=255))
legend("topright",legend=models,lty=1:n_model,bty="n",col=col)



#### Age composition catch ####

obs.catch.age<-all.asap$catch.comp.mats$catch.fleet1.ob
age<-ncol(obs.catch.age)
n_survey<-length(all.asap$index.comp.mats)/2

obs<-matrix(data=exp(all.sam$data$logobs),nrow=length(tab1.sam$Year)*3,ncol=age,byrow=TRUE)
obs_catch_survey<-array(0,dim=c(length(tab1.sam$Year),age,n_survey+1)) # 3rd dim= catch, survey 1, survey 2, etc.
t=1
for (y in 1:length(tab1.sam$Year)){
  for (i in 1:(n_survey+1)){
    obs_catch_survey[y,,i] <- obs[t+(i-1),] 
    if (i==3) t=t+i
  }
}

pred.sam<-matrix(data=exp(all.sam$rep$predObs),nrow=length(tab1.sam$Year)*3,ncol=age,byrow=TRUE)
pred_catch_survey.sam<-array(0,dim=c(length(tab1.sam$Year),age,n_survey+1)) # 3rd dim= catch, survey 1, survey 2, etc.
t=1
for (y in 1:length(tab1.sam$Year)){
  for (i in 1:(n_survey+1)){
    pred_catch_survey.sam[y,,i] <- pred.sam[t+(i-1),] 
    if (i==3) t=t+i
  }
}
pred.propCatch.sam<-pred_catch_survey.sam[,,1]/apply(pred_catch_survey.sam[,,1],1,sum)

min <- 0
max <- 1
xaxt <- c("n","n","n","s","s","s")
yaxt <- c("s","n","n","s","n","n")

## different plots
par(mfrow=c(2,3),mar=c(0,0,0,0),oma=c(5,5,2,1),xpd=FALSE)
#SAM
for (a in 1:age){
  plot(obs.catch.age[,a]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt[a],yaxt=yaxt[a])
  text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=0.95,labels=paste("Age ",a,sep=""))
  lines(pred.propCatch.sam[,a]~tab1.sam$Year)
  #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
}
mtext("Year",side=1,outer=T,line=3)
mtext("Age composition catch", side=2, outer=T, line=3)
mtext(models[1],side=3,outer=T,line=0.5)
# ASAP
for (a in 1:age){
  plot(obs.catch.age[,a]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt[a],yaxt=yaxt[a])
  text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=0.95,labels=paste("Age ",a,sep=""))
  lines(all.asap$catch.comp.mats$catch.fleet1.pr[,a]~tab1.sam$Year)
  #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
}
mtext("Year",side=1,outer=T,line=3)
mtext("Age composition catch", side=2, outer=T, line=3)
mtext(models[2],side=3,outer=T,line=0.5)
# WHAM
#



## or on the same plot
par(mfrow=c(2,3),mar=c(0,0,0,0),oma=c(5,5,2,1),xpd=FALSE)
for (a in 1:age){
  plot(obs.catch.age[,a]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt[a],yaxt=yaxt[a])
  text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=0.95,labels=paste("Age ",a,sep=""))
  lines(pred.propCatch.sam[,a]~tab1.sam$Year)
  lines(all.asap$catch.comp.mats$catch.fleet1.pr[,a]~tab1.sam$Year,col=col[2],lty=2)
}
legend("topright",legend=models,lty=1:n_model,bty="n",col=col)
mtext("Year",side=1,outer=T,line=3)
mtext("Age composition catch", side=2, outer=T, line=3)



#### Catch at age residuals (line plot) ####

res.Caa.asap<-(all.asap$catch.comp.mats$catch.fleet1.pr-obs.catch.age)/obs.catch.age
res.Caa.sam<-(pred.propCatch.sam-obs.catch.age)/obs.catch.age

xaxt <- c("n","n","n","s","s","s")
yaxt <- c("s","n","n","s","n","n")

## different plots
par(mfrow=c(2,3),mar=c(0,1,0,1),oma=c(5,5,2,1),xpd=FALSE)
#SAM
for (a in 1:age){
  plot(res.Caa.sam[,a]~tab1.sam$Year,type="l",xlab="",ylab="",xaxt=xaxt[a])
  ymax=max(NaRV.omit(res.Caa.sam[,a]))
  text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ymax,labels=paste("Age ",a,sep=""))
}
mtext("Year",side=1,outer=T,line=3)
mtext("Catch at age residuals (pred-obs)/obs", side=2, outer=T, line=3)
mtext(models[1],side=3,outer=T,line=0.5)
# ASAP
for (a in 1:age){
  plot(res.Caa.asap[,a]~tab1.asap$Year,type="l",xlab="",ylab="",xaxt=xaxt[a])
  ymax=max(NaRV.omit(res.Caa.asap[,a]))
  text(x=tab1.asap$Year[round(length(tab1.asap$Year)/2)],y=ymax,labels=paste("Age ",a,sep=""))
}
mtext("Year",side=1,outer=T,line=3)
mtext("Catch at age residuals (pred-obs)/obs", side=2, outer=T, line=3)
mtext(models[2],side=3,outer=T,line=0.5)
# WHAM
#


## or on the same plot
par(mfrow=c(2,3),mar=c(0,1,0,1),oma=c(5,5,2,1),xpd=FALSE)
for (a in 1:age){
  ymax=max(NaRV.omit(c(res.Caa.sam[,a],res.Caa.asap[,a])))
  ymin=min(c(res.Caa.sam[,a],res.Caa.asap[,a]))
  plot(res.Caa.sam[,a]~tab1.sam$Year,type="l",xlab="",ylab="",xaxt=xaxt[a],ylim=c(ymin,ymax))
  ymax2=ymax*0.9
  text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ymax2,labels=paste("Age ",a,sep=""))
  lines(res.Caa.asap[,a]~tab1.asap$Year,col=col[2],lty=2)
}
legend("topright",legend=models,lty=1:n_model,bty="n",col=col)
mtext("Year",side=1,outer=T,line=3)
mtext("Catch at age residuals (pred-obs)/obs", side=2, outer=T, line=3)



#### Catch at age residuals (bubble plot) ####

res.Caa.asap<-(obs.catch.age-all.asap$catch.comp.mats$catch.fleet1.pr)/sqrt(all.asap$catch.comp.mats$catch.fleet1.pr)
res.Caa.sam<-(obs.catch.age-pred.propCatch.sam)/sqrt(pred.propCatch.sam)

## different plots
X<-matrix(tab1.sam$Year,nrow=length(tab1.sam$Year),ncol=age)
Y<-matrix(nrow=length(tab1.sam$Year),ncol=age,rep(1:age,length(tab1.sam$Year)),byrow=TRUE)
col1 <- matrix(nrow=length(tab1.sam$Year),ncol=age)
col2 <- matrix(nrow=length(tab1.sam$Year),ncol=age)
col3 <- matrix(nrow=length(tab1.sam$Year),ncol=age)
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(5,5,2,1),xpd=FALSE)
#SAM
for (t in 1:nrow(col1)){
  for (a in 1:ncol(col1)){
    if (res.Caa.sam[t,a]>0) {
      col1[t,a]<-1
      col2[t,a]<-1
      col3[t,a]<-1
    } else {
      col1[t,a]<-1
      col2[t,a]<-0
      col3[t,a]<-0
    }
  }
}
symbols(x=c(X),y=c(Y),circles=c(abs(res.Caa.sam)),bg=rgb(c(col1),c(col2),c(col3),alpha=0.2))
legend("topleft",pt.bg = c(rgb(1,1,1,alpha=0.2),rgb(1,0,0,alpha=0.2)),pch=21,legend=c(">0","<0"),bty="n")
#ASAP
for (t in 1:nrow(col1)){
  for (a in 1:ncol(col1)){
    if (res.Caa.asap[t,a]>0) {
      col1[t,a]<-1
      col2[t,a]<-1
      col3[t,a]<-1
    } else {
      col1[t,a]<-1
      col2[t,a]<-0
      col3[t,a]<-0
    }
  }
}
symbols(x=c(X),y=c(Y),circles=c(abs(res.Caa.asap)),bg=rgb(c(col1),c(col2),c(col3),alpha=0.2),yaxt="n")
mtext("Year",side=1,outer=T,line=3)
mtext("Catch at age residuals (obs-pred)/sqrt(pred)", side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}





#### Aggregated index ####

obs.index <- matrix(nrow=length(tab1.sam$Year),ncol=n_survey)
pred.index.asap <- matrix(nrow=length(tab1.sam$Year),ncol=n_survey)
pred.index.sam <- matrix(nrow=length(tab1.sam$Year),ncol=n_survey)
for (k in 1:n_survey){
  obs.index[,k]<-all.asap$index.obs[[k]]
  pred.index.asap[,k]<-all.asap$index.pred[[k]]
  pred.index.sam[,k]<-apply(pred_catch_survey.sam[,,k+1],1,sum)
}

min <- min(c(obs.index,pred.index.asap,pred.index.sam))
max <- max(c(obs.index,pred.index.asap,pred.index.sam))

## different plots
par(mfrow=c(n_survey,n_model),mar=c(0,0,0,0),oma=c(4,4,2,2),xpd=FALSE)
for(k in 1:n_survey){
  #SAM
  if (k==1) {xaxt="n"} else {xaxt="s"}
  plot(obs.index[,k]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt)
  lines(pred.index.sam[,k]~tab1.sam$Year)
  #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
  # ASAP
  plot(obs.index[,k]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",yaxt="n",xaxt=xaxt)
  lines(pred.index.asap[,k]~tab1.sam$Year)
  #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
  # WHAM
  #
}
mtext("Year",side=1,outer=T,line=3)
mtext("Aggregated index", side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
for (k in 1:n_survey){
  mtext(paste("Survey",k), side=4, outer=T, line=0.5, at=1-(index.legend[k]/(n_survey*2)))
}

## or on the same plot
par(mfrow=c(1,1),xpd=NA)
for (k in 1:n_survey){
  plot(obs.index[,k]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="Year",ylab="Aggregated index")
  lines(pred.index.sam[,k]~tab1.sam$Year)
  lines(pred.index.asap[,k]~tab1.sam$Year,lty=2,col=col[2])
  legend("topright",legend=models,lty=1:n_model,bty="n",col=col)
  mtext(paste("Survey",k),line=0.5,outer=TRUE,side=3)
}


#### Age composition index ####

index.age<-all.asap$index.comp.mats
age<-ncol(obs.catch.age)
obs.index.age<- array(dim=c(length(tab1.sam$Year),age,n_survey))
pred.propIndex.asap<- array(dim=c(length(tab1.sam$Year),age,n_survey))
x=0
for (k in 1:n_survey){
  x=x+k
  obs.index.age[,,k]<-index.age[[x]]
  pred.propIndex.asap[,,k]<-index.age[[x+1]]
}

pred.propIndex.sam<- array(dim=c(length(tab1.sam$Year),age,n_survey))
for (k in 1:n_survey){
  pred.propIndex.sam[,,k]<-pred_catch_survey.sam[,,k+1]/apply(pred_catch_survey.sam[,,k+1],1,sum)
}

min <- 0
max <- 1
xaxt <- c("n","n","n","s","s","s")
yaxt <- c("s","n","n","s","n","n")

## different plots
par(mfrow=c(2,3),mar=c(0,0,0,0),oma=c(5,5,2,1),xpd=FALSE)
for (k in 1:n_survey){
  #SAM
  for (a in 1:age){
    plot(obs.index.age[,a,k]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt[a],yaxt=yaxt[a])
    text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=0.95,labels=paste("Age ",a,sep=""))
    lines(pred.propIndex.sam[,a,k]~tab1.sam$Year)
    #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
  }
  mtext("Year",side=1,outer=T,line=3)
  mtext("Age composition index", side=2, outer=T, line=3)
  mtext(paste("Survey",k,models[1]), side=3, outer=T, line=0.5)
  
  # ASAP
  for (a in 1:age){
    plot(obs.index.age[,a,k]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt[a],yaxt=yaxt[a])
    text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=0.95,labels=paste("Age ",a,sep=""))
    lines(pred.propIndex.asap[,a,k]~tab1.sam$Year)
    #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
  }
  mtext("Year",side=1,outer=T,line=3)
  mtext("Age composition index", side=2, outer=T, line=3)
  mtext(paste("Survey",k,models[2]), side=3, outer=T, line=0.5)
  
  # WHAM
  #
  
}

## or on the same plot
par(mfrow=c(2,3),mar=c(0,0,0,0),oma=c(5,5,2,1),xpd=FALSE)
for (k in 1:n_survey){
  for (a in 1:age){
    plot(obs.index.age[,a,k]~tab1.sam$Year,pch=16,ylim=c(min,max),xlab="",ylab="",col="red",xaxt=xaxt[a],yaxt=yaxt[a])
    text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=0.95,labels=paste("Age ",a,sep=""))
    lines(pred.propIndex.sam[,a,k]~tab1.sam$Year)
    lines(pred.propIndex.asap[,a,k]~tab1.sam$Year,col=col[2],lty=2)
    #polygon(x=c(tab1.sam$Year,rev(tab1.sam$Year)),y=c(tab1.sam$Low.3,rev(tab1.sam$High.3)),border=NA,col=rgb(0,0,0,alpha=0.2))
  }
  legend("topright",legend=models,lty=1:n_model,bty="n",col=col)
  mtext("Year",side=1,outer=T,line=3)
  mtext("Age composition index", side=2, outer=T, line=3)
  mtext(paste("Survey",k), side=3, outer=T, line=0.5)
}



#### Index at age residuals (line plot) ####

res.Iaa.asap<-(pred.propIndex.asap-obs.index.age)/obs.index.age
res.Iaa.sam<-(pred.propIndex.sam-obs.index.age)/obs.index.age

xaxt <- c("n","n","n","s","s","s")
yaxt <- c("s","n","n","s","n","n")

## different plots
par(mfrow=c(2,3),mar=c(0,1,0,1),oma=c(5,5,2,1),xpd=FALSE)
for (k in 1:n_survey){
  #SAM
  for (a in 1:age){
    plot(res.Iaa.sam[,a,k]~tab1.sam$Year,type="l",xlab="",ylab="",xaxt=xaxt[a])
    ymax=max(NaRV.omit(res.Iaa.sam[,a,k]))*0.9
    text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ymax,labels=paste("Age ",a,sep=""))
  }
  mtext("Year",side=1,outer=T,line=3)
  mtext("Index at age residuals", side=2, outer=T, line=3)
  mtext(paste("Survey",k,models[1]), side=3, outer=T, line=0.5)
  # ASAP
  for (a in 1:age){
    plot(res.Iaa.asap[,a,k]~tab1.asap$Year,type="l",xlab="",ylab="",xaxt=xaxt[a])
    ymax=max(NaRV.omit(res.Iaa.asap[,a,k]))*0.9
    text(x=tab1.asap$Year[round(length(tab1.asap$Year)/2)],y=ymax,labels=paste("Age ",a,sep=""))
  }
  mtext("Year",side=1,outer=T,line=3)
  mtext("Index at age residuals (pred-obs)/obs", side=2, outer=T, line=3)
  mtext(paste("Survey",k,models[2]), side=3, outer=T, line=0.5)
  # WHAM
  #
}


## or on the same plot
par(mfrow=c(2,3),mar=c(0,1,0,1),oma=c(5,5,2,1),xpd=FALSE)
for (k in 1:n_survey){
  for (a in 1:age){
    ymax=max(NaRV.omit(c(res.Iaa.sam[,a,k],res.Iaa.asap[,a,k])))
    ymin=min(c(res.Iaa.sam[,a,k],res.Iaa.asap[,a,k]))
    plot(res.Iaa.sam[,a,k]~tab1.sam$Year,type="l",xlab="",ylab="",xaxt=xaxt[a],ylim=c(ymin,ymax))
    ymax2=ymax*0.9
    text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ymax2,labels=paste("Age ",a,sep=""))
    lines(res.Iaa.asap[,a,k]~tab1.asap$Year,col=col[2],lty=2)
  }
  legend("topright",legend=models,lty=1:n_model,bty="n",col=col)
  mtext("Year",side=1,outer=T,line=3)
  mtext("Index at age residuals (pred-obs)/obs", side=2, outer=T, line=3)
  mtext(paste("Survey",k), side=3, outer=T, line=0.5)
}



#### Index at age residuals (bubble plot) ####

res.Iaa.asap<-(obs.index.age-pred.propIndex.asap)/sqrt(pred.propIndex.asap)
res.Iaa.sam<-(obs.index.age-pred.propIndex.sam)/sqrt(pred.propIndex.sam)

## different plots
X<-matrix(tab1.sam$Year,nrow=length(tab1.sam$Year),ncol=age)
Y<-matrix(nrow=length(tab1.sam$Year),ncol=age,rep(1:age,length(tab1.sam$Year)),byrow=TRUE)
col1 <- array(dim=c(length(tab1.sam$Year),age,n_survey))
col2 <- array(dim=c(length(tab1.sam$Year),age,n_survey))
col3 <- array(dim=c(length(tab1.sam$Year),age,n_survey))
col1b <- array(dim=c(length(tab1.sam$Year),age,n_survey))
col2b <- array(dim=c(length(tab1.sam$Year),age,n_survey))
col3b <- array(dim=c(length(tab1.sam$Year),age,n_survey))
for (t in 1:nrow(col1)){
  for (a in 1:ncol(col1)){
    for (k in 1:n_survey){
      if (res.Iaa.sam[t,a,k]>0) {
        col1[t,a,k]<-1
        col2[t,a,k]<-1
        col3[t,a,k]<-1
      } else {
        col1[t,a,k]<-1
        col2[t,a,k]<-0
        col3[t,a,k]<-0
      }
      if (res.Iaa.asap[t,a,k]>0) {
        col1b[t,a,k]<-1
        col2b[t,a,k]<-1
        col3b[t,a,k]<-1
      } else {
        col1b[t,a,k]<-1
        col2b[t,a,k]<-0
        col3b[t,a,k]<-0
      }
    }
  }
}
for (k in 1:n_survey){
  par(mfrow=c(1,n_survey),mar=c(0,0,0,0),oma=c(5,5,2,1),xpd=FALSE)
  #SAM
  symbols(x=c(X),y=c(Y),circles=c(abs(res.Iaa.sam[,,k])),bg=rgb(c(col1[,,k]),c(col2[,,k]),c(col3[,,k]),alpha=0.2))
  legend("topleft",pt.bg = c(rgb(1,1,1,alpha=0.2),rgb(1,0,0,alpha=0.2)),pch=21,legend=c(">0","<0"),bty="n")
  #ASAP
  symbols(x=c(X),y=c(Y),circles=c(abs(res.Iaa.asap[,,k])),bg=rgb(c(col1b[,,k]),c(col2b[,,k]),c(col3b[,,k]),alpha=0.2),yaxt="n")
  mtext("Year",side=1,outer=T,line=3)
  mtext(paste0("Index at age residuals (obs-pred)/sqrt(pred) Survey ",k), side=2, outer=T, line=3)
  for (k in 1:n_model){
    mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
  }
}




#### Retro plots for SSB, recruitment and Fbar (as time series values) ####


retro.SSB.sam<-list()
retro.R.sam<-list()
retro.Fbar.sam<-list()

retro.SSB.asap<-list()
retro.R.asap<-list()
retro.Fbar.asap<-list()

for (t in 1:n_retro){
  #SAM
  retro.SSB.sam[[t]] <- exp(retro.sam[[t]]$sdrep$value[which(names(retro.sam[[t]]$sdrep$value)=="logssb")])
  retro.R.sam[[t]] <- exp(retro.sam[[t]]$sdrep$value[which(names(retro.sam[[t]]$sdrep$value)=="logR")])
  retro.Fbar.sam[[t]] <- exp(retro.sam[[t]]$sdrep$value[which(names(retro.sam[[t]]$sdrep$value)=="logfbar")])
  # ASAP
  retro.SSB.asap[[t]] <- retro.asap[[t]]$SSB
  retro.R.asap[[t]] <- retro.asap[[t]]$N.age[,1]
  retro.Fbar.asap[[t]] <- apply(retro.asap[[t]]$F.age,1,mean) #average over all ages
  # WHAM
}

  
min.SSB <- min(unlist(lapply(retro.SSB.sam,min)),unlist(lapply(retro.SSB.asap,min)))
max.SSB <- max(unlist(lapply(retro.SSB.sam,max)),unlist(lapply(retro.SSB.asap,max)))
min.R <- min(unlist(lapply(retro.R.sam,min)),unlist(lapply(retro.R.asap,min)))
max.R <- max(unlist(lapply(retro.R.sam,max)),unlist(lapply(retro.R.asap,max)))
min.Fbar <- min(unlist(lapply(retro.Fbar.sam,min)),unlist(lapply(retro.Fbar.asap,min)))
max.Fbar <- max(unlist(lapply(retro.Fbar.sam,max)),unlist(lapply(retro.Fbar.asap,max)))


## SSB
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
plot(tab1.sam[,5]~tab1.sam$Year,ylim=c(min.SSB,max.SSB),type="l")
for (t in 1:n_retro){
  lines(retro.SSB.sam[[t]]~tab1.sam$Year[-((length(tab1.sam$Year)-t+1):length(tab1.sam$Year))],col=t+1)
}
plot(tab1.asap[,5]~tab1.asap$Year,ylim=c(min.SSB,max.SSB),type="l",yaxt="n")
for (t in 1:n_retro){
  lines(retro.SSB.asap[[t]]~tab1.asap$Year[-((length(tab1.asap$Year)-t+1):length(tab1.asap$Year))],col=t+1)
}
mtext("Year",side=1,outer=T,line=3)
mtext(paste0("Retro ",tab1.names[5]), side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
legend("topright",legend=0:n_retro,col=1:(n_retro+1),lty=1,bty="n")


## R
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
plot(tab1.sam[,2]~tab1.sam$Year,ylim=c(min.R,max.R),type="l")
for (t in 1:n_retro){
  lines(retro.R.sam[[t]]~tab1.sam$Year[-((length(tab1.sam$Year)-t+1):length(tab1.sam$Year))],col=t+1)
}
plot(tab1.asap[,2]~tab1.asap$Year,ylim=c(min.R,max.R),type="l",yaxt="n")
for (t in 1:n_retro){
  lines(retro.R.asap[[t]]~tab1.asap$Year[-((length(tab1.asap$Year)-t+1):length(tab1.asap$Year))],col=t+1)
}
mtext("Year",side=1,outer=T,line=3)
mtext(paste0("Retro ",tab1.names[2]), side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
legend("topright",legend=0:n_retro,col=1:(n_retro+1),lty=1,bty="n")



## Fbar
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
plot(tab1.sam[,8]~tab1.sam$Year,ylim=c(min.Fbar,max.Fbar),type="l")
for (t in 1:n_retro){
  lines(retro.Fbar.sam[[t]]~tab1.sam$Year[-((length(tab1.sam$Year)-t+1):length(tab1.sam$Year))],col=t+1)
}
plot(tab1.asap[,8]~tab1.asap$Year,ylim=c(min.Fbar,max.Fbar),type="l",yaxt="n")
for (t in 1:n_retro){
  lines(retro.Fbar.asap[[t]]~tab1.asap$Year[-((length(tab1.asap$Year)-t+1):length(tab1.asap$Year))],col=t+1)
}
mtext("Year",side=1,outer=T,line=3)
mtext(paste0("Retro ",tab1.names[8]), side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
legend("topright",legend=0:n_retro,col=1:(n_retro+1),lty=1,bty="n")




#### Retro plots for SSB, recruitment and Fbar (relative mohn's rho) ####

## Function below came from Legault.  Jon modified the Mohn's rho to do relative retro plotting.
# Modified by VT
calc_Mohn_rho <- function(mod,fit,ret,npeel,what){
  if (mod=="SAM"){
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
      reldiff[1:length(y2),i]<-(y2-y[1:length(y2)])/y[1:length(y2)]
    }
  }
  if (mod=="ASAP"){
    y <- fit
    rho <- rep(NA, npeel)
    reldiff<-matrix(nrow=length(y),ncol=npeel)
    for (i in 1:npeel){
      y.val <- y[length(y)-i]
      y2 <- ret[[i]]
      y2.val <- y2[length(y2)]
      rho[i] <- (y2.val - y.val) / y.val
      reldiff[1:length(y2),i]<-(y2-y[1:length(y2)])/y[1:length(y2)]
    }
  }
  if (mod=="WHAM"){
  }
  return(reldiff)
}

mohn_rhossb.sam<-calc_Mohn_rho(mod=models[1],fit=all.sam,ret=retro.sam,npeel=n_retro,what="ssb")
mohn_rhoR.sam<-calc_Mohn_rho(mod=models[1],fit=all.sam,ret=retro.sam,npeel=n_retro,what="R")
mohn_rhoFbar.sam<-calc_Mohn_rho(mod=models[1],fit=all.sam,ret=retro.sam,npeel=n_retro,what="fbar")

mohn_rhossb.asap<-calc_Mohn_rho(mod=models[2],fit=tab1.asap[,5],ret=retro.SSB.asap,npeel=n_retro,what="SSB")
mohn_rhoR.asap<-calc_Mohn_rho(mod=models[2],fit=tab1.asap[,2],ret=retro.R.asap,npeel=n_retro,what="R")
mohn_rhoFbar.asap<-calc_Mohn_rho(mod=models[2],fit=tab1.asap[,8],ret=retro.Fbar.asap,npeel=n_retro,what="Fbar")


## SSB
ylim <- c(min(na.omit(c(mohn_rhossb.sam,mohn_rhossb.asap))),max(na.omit(c(mohn_rhossb.sam,mohn_rhossb.asap))))
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
plot(mohn_rhossb.sam[,1]~tab1.asap$Year,type='l',ylim=ylim)
for (t in 1:n_retro){
  lines(mohn_rhossb.sam[,t]~tab1.sam$Year,col=t+1)
}
abline(0,0)
text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ylim[2]*0.9,paste("Mohn's Rho =",round(mohn[1,2],digits=2),sep=" "))
plot(mohn_rhossb.asap[,1]~tab1.asap$Year,type='l',ylim=ylim,yaxt="n")
for (t in 1:n_retro){
  lines(mohn_rhossb.asap[,t]~tab1.asap$Year,col=t+1)
}
abline(0,0)
text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ylim[2]*0.9,paste("Mohn's Rho =",round(mohn[2,2],digits=2),sep=" "))
mtext("Year",side=1,outer=T,line=3)
mtext(paste0("Relative Mohn's rho for ",tab1.names[5]), side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
legend("topleft",legend=0:n_retro,col=1:(n_retro+1),lty=1,bty="n")


## R
ylim <- c(min(na.omit(c(mohn_rhoR.sam,mohn_rhoR.asap))),max(na.omit(c(mohn_rhoR.sam,mohn_rhoR.asap))))
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
plot(mohn_rhoR.sam[,1]~tab1.asap$Year,type='l',ylim=ylim)
for (t in 1:n_retro){
  lines(mohn_rhoR.sam[,t]~tab1.sam$Year,col=t+1)
}
abline(0,0)
text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ylim[2]*0.9,paste("Mohn's Rho =",round(mohn[1,1],digits=2),sep=" "))
plot(mohn_rhoR.asap[,1]~tab1.asap$Year,type='l',ylim=ylim,yaxt="n")
for (t in 1:n_retro){
  lines(mohn_rhoR.asap[,t]~tab1.asap$Year,col=t+1)
}
abline(0,0)
text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ylim[2]*0.9,paste("Mohn's Rho =",round(mohn[2,1],digits=2),sep=" "))
mtext("Year",side=1,outer=T,line=3)
mtext(paste0("Relative Mohn's rho for ",tab1.names[2]), side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
legend("topleft",legend=0:n_retro,col=1:(n_retro+1),lty=1,bty="n")

## Fbar
ylim <- c(min(na.omit(c(mohn_rhoFbar.sam,mohn_rhoFbar.asap))),max(na.omit(c(mohn_rhoFbar.sam,mohn_rhoFbar.asap))))
par(mfrow=c(1,n_model),mar=c(0,0,0,0),oma=c(4,4,2,1),xpd=FALSE)
plot(mohn_rhoFbar.sam[,1]~tab1.asap$Year,type='l',ylim=ylim)
for (t in 1:n_retro){
  lines(mohn_rhoFbar.sam[,t]~tab1.sam$Year,col=t+1)
}
abline(0,0)
text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ylim[2]*0.9,paste("Mohn's Rho =",round(mohn[1,3],digits=2),sep=" "))
plot(mohn_rhoFbar.asap[,1]~tab1.asap$Year,type='l',ylim=ylim,yaxt="n")
for (t in 1:n_retro){
  lines(mohn_rhoFbar.asap[,t]~tab1.asap$Year,col=t+1)
}
abline(0,0)
text(x=tab1.sam$Year[round(length(tab1.sam$Year)/2)],y=ylim[2]*0.9,paste("Mohn's Rho =",round(mohn[2,3],digits=2),sep=" "))
mtext("Year",side=1,outer=T,line=3)
mtext(paste0("Relative Mohn's rho for ",tab1.names[8]), side=2, outer=T, line=3)
for (k in 1:n_model){
  mtext(models[k], side=3, outer=T, line=0.5, at=index.legend[k]/(n_model*2))
}
legend("topleft",legend=0:n_retro,col=1:(n_retro+1),lty=1,bty="n")


dev.off()
