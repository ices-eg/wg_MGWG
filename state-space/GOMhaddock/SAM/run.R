library(stockassessment)
source("../../helper_code/sampred.R") # function to predict 

prefix <- "../GOMHADDOCK_"

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

cn[,8:9][cn[,8:9]==0]<-1

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

conf <- loadConf(dat,"model.cfg")
par <- defpar(dat,conf)
fit <- sam.fit(dat,conf,par)

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
