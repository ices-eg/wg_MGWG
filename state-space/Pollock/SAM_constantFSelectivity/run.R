library(stockassessment)
source("../../helper_code/sampred.R") # function to predict

prefix <- "../POLLOCK_"

cn <- read.ices(paste0(prefix,"cn.dat"))
cw <- read.ices(paste0(prefix,"cw.dat"))
dw <- read.ices(paste0(prefix,"dw.dat"))
lw <- read.ices(paste0(prefix,"lw.dat"))
mo <- read.ices(paste0(prefix,"mo.dat"))
nm <- read.ices(paste0(prefix,"nm.dat"))
pf <- read.ices(paste0(prefix,"pf.dat"))
pm <- read.ices(paste0(prefix,"pm.dat"))
sw <- read.ices(paste0(prefix,"sw.dat"))
lf <- read.ices(paste0(prefix,"lf.dat"))
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

conf <- loadConf(dat,"../SAM/model.cfg")

if(!file.exists("model.cfg")){
  saveConf(conf, file="model.cfg")
}

par <- defpar(dat,conf)

timeBefore=Sys.time();
rhoF = 0.9999
par$itrans_rho = -log(2/(1+rhoF)-1)/2
par$logSdLogN = c(-0.35,-5) #remove the process error because it its variance converged to something close to 0 with high variance.
fit <- sam.fit(dat,conf,par, map = list(itrans_rho = as.factor(NA), logSdLogN = as.factor(c(0,NA))))
timeUsed = difftime(Sys.time(),timeBefore,units="mins")
print(paste("Tid brukt for aa tilpasse model: ", round(timeUsed,3),".",sep=""))



fselectivityplot(fit, cexAge = 1)



RES <- residuals(fit)
RESP <- procres(fit)
RETRO <- retro(fit, year=7)
PRED <- predictYears(fit,years=max(fit$data$years)-2:0)
colnames(PRED)<-sub("obs", "logObs", colnames(PRED))

rho <- mohn(RETRO, lag=0)



pdf(onefile=FALSE, width = 8, height = 8)
  ssbplot(fit)
  fbarplot(fit)
  recplot(fit)
  catchplot(fit)
  for(f in 1:fit$data$noFleets)fitplot(fit, fleets=f)
  plot(RES)
  plot(RESP)
  ssbplot(RETRO, drop=1)
  legend("topright", legend=substitute(rho==RHO, list(RHO=rho[2])), bty="n")
  fbarplot(RETRO, drop=1)
  legend("topright", legend=substitute(rho==RHO, list(RHO=rho[3])), bty="n")
  recplot(RETRO, drop=1)
  legend("topright", legend=substitute(rho==RHO, list(RHO=rho[1])), bty="n")
dev.off()

tab1 <- cbind(Year=fit$data$years, summary(fit), round(catchtable(fit)))
colnames(tab1) <- sub("Estimate", "Catch", colnames(tab1))
write.table(tab1, file="tab1.csv", sep=",\t", quote=FALSE, row.names=FALSE)

write.table(PRED, file="tab2.csv", sep=",\t", quote=FALSE, row.names=FALSE)

sink("Mohn.txt")
print(rho)
sink()
