library(stockassessment)

stockname<-"GBHADDOCK"

cn <- read.ices(paste0("../",stockname,"_cn.dat"))
cw <- read.ices(paste0("../",stockname,"_cw.dat"))
dw <- read.ices(paste0("../",stockname,"_dw.dat"))
lw <- read.ices(paste0("../",stockname,"_lw.dat"))
mo <- read.ices(paste0("../",stockname,"_mo.dat"))
nm <- read.ices(paste0("../",stockname,"_nm.dat"))
pf <- read.ices(paste0("../",stockname,"_pf.dat"))
pm <- read.ices(paste0("../",stockname,"_pm.dat"))
sw <- read.ices(paste0("../",stockname,"_sw.dat"))
lf <- read.ices(paste0("../",stockname,"_lf.dat"))
surveys <- read.ices(paste0("../",stockname,"_survey.dat"))

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

## conf <- defcon(dat)
## saveConf(conf, file="model.cfg")

conf <- loadConf(dat,"model.cfg")
par <- defpar(dat,conf)
fit <- sam.fit(dat,conf,par)

RES <- residuals(fit)
RESP <- procres(fit)
RETRO <- retro(fit, year=7)
rho <- mohn(RETRO, lag=1)

pdf(onefile=TRUE, width = 8, height = 8)
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
