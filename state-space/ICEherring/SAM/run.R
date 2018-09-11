library(stockassessment)
source("pred.R") # function to predict 

prefix <- "../ices_data/"

patch<-function(m){
  rn<-rownames(m)    
  m<-rbind(m,m[nrow(m),])
  rownames(m)<-c(rn,max(as.integer(rn))+1)
  m
}

cn <- read.ices(paste0(prefix,"cn.dat"))
cw <- read.ices(paste0(prefix,"cw.dat"))  #; cw<-patch(cw)
dw <- read.ices(paste0(prefix,"dw.dat"))  #; dw<-patch(dw)
lw <- read.ices(paste0(prefix,"lw.dat"))  #; lw<-patch(lw)
mo <- read.ices(paste0(prefix,"mo.dat"))  ; mo<-patch(mo)
nm <- read.ices(paste0(prefix,"nm.dat"))  ; nm<-patch(nm)
pf <- read.ices(paste0(prefix,"pf.dat"))  ; pf<-patch(pf)
pm <- read.ices(paste0(prefix,"pm.dat"))  ; pm<-patch(pm)
sw <- read.ices(paste0(prefix,"sw.dat"))  ; sw<-patch(sw)
lf <- read.ices(paste0(prefix,"lf.dat"))  #; lf<-patch(lf)
surveys <- read.ices(paste0(prefix,"survey.dat"))

#cn[,8:9][cn[,8:9]==0]<-1

dat <- setup.sam.data(surveys=surveys,
                      residual.fleet=cn, 
                      prop.mature=mo, 
                      stock.mean.weight=sw, 
                      catch.mean.weight=cw, 
                      dis.mean.weight=dw, 
                      land.mean.weight=lw,
                      prop.f=pf, 
                      prop.m=pm, 
                      natural.mortality=nm, 
                      land.frac=lf)

if(!file.exists("model.cfg")){
  saveConf(defcon(dat), file="model.cfg")
}    
conf <- loadConf(dat,"model.cfg")

par <- defpar(dat,conf)
par$logSdLogN<-c(-.35,-5)
fit <- sam.fit(dat,conf,par, map=list(logSdLogN=factor(c(0,NA))))

RES <- residuals(fit)
#RESP <- procres(fit)
RETRO <- retro(fit, year=7)
PRED <- suppressWarnings(predictYears(fit,years=max(fit$data$years)-2:0))
colnames(PRED)<-sub("obs", "logObs", colnames(PRED))

rho <- mohn(RETRO, lag=0)



pdf(onefile=FALSE, width = 8, height = 8)
  ssbplot(fit)
  fbarplot(fit)
  recplot(fit)
  catchplot(fit)
  for(f in 1:fit$data$noFleets)fitplot(fit, fleets=f)
  plot(RES)
  #plot(RESP)
  ssbplot(RETRO, drop=1)
  legend("topright", legend=substitute(rho==RHO, list(RHO=rho[2])), bty="n")
  fbarplot(RETRO, drop=1)
  legend("topright", legend=substitute(rho==RHO, list(RHO=rho[3])), bty="n")
  recplot(RETRO, drop=1)
  legend("topright", legend=substitute(rho==RHO, list(RHO=rho[1])), bty="n")
dev.off()

summ<-summary(fit)
cattab<-round(catchtable(fit))
if((nrow(cattab)+1)==nrow(summ))cattab<-rbind(cattab,NA)
tab1 <- cbind(Year=fit$data$years, summ, cattab)
colnames(tab1) <- sub("Estimate", "Catch", colnames(tab1))
write.table(tab1, file="tab1.csv", sep=",\t", quote=FALSE, row.names=FALSE)

write.table(PRED, file="tab2.csv", sep=",\t", quote=FALSE, row.names=FALSE)

sink("Mohn.txt")
print(rho)
sink()
