library(stockassessment)

cn <- read.ices("../cn.dat")
cw <- read.ices("../cw.dat")
dw <- read.ices("../dw.dat")
lw <- read.ices("../lw.dat")
mo <- read.ices("../mo.dat")
nm <- read.ices("../nm.dat")
pf <- read.ices("../pf.dat")
pm <- read.ices("../pm.dat")
sw <- read.ices("../sw.dat")
lf <- read.ices("../lf.dat")
surveys <- read.ices("../survey.dat")

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
RETRO <- retro(fit, year=5)
rho <- mohn(RETRO, lag=1)

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
