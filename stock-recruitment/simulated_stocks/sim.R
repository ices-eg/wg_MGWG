# sim.R - DESC
# /sim.R

# Copyright European Union, 2018
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.

library(FLife)
library(FLasher)

lastyr <- 100
its <- 5
set.seed(1809)

# SET initial parameters

par <- FLPar(linf=90, a=0.00001, sl=1, sr=2000, a1=4, s=0.65, v=1000)
range <- c(min=1, max=20, minfbar=4, maxfbar=15, plusgroup=20)

# GET full LH params set

parg <- lhPar(par)

# M Jensen

mJensen <- function(length, params){
  length[]=params["a50"]
  1.45 / length
}

# GET equilibrium FLBRP

eql <- lhEql(parg, range=range, m=mJensen)

# COERCE

stk <- as(eql, "FLStock")
srr <- as(eql, "predictModel")

# EXTEND w/F=0.0057226 until year=lastyr

om <- fwdWindow(stk[,2], eql, end=lastyr)

# -- DEVIANCES

# rand walk

foo <- function(x) {
  x <- cumsum(rnorm(98, sd = 0.05))
  exp(x - mean(x))
}

rwdev <- Reduce(combine, FLQuants(lapply(1:its, function(x)
  FLQuant(foo(), dimnames=list(year=3:lastyr)))))

rwdev <- FLQuant(unlist(lapply(1:its, foo)),
  dimnames=list(year=3:lastyr), iter=its)

# lnormal

lndev03 <- rlnorm(its, FLQuant(0, dimnames=list(year=3:lastyr)), 0.3)
lndev06 <- rlnorm(its, FLQuant(0, dimnames=list(year=3:lastyr)), 0.6)

plot(FLQuants(rw=rwdev, ln03=lndev03, ln06=lndev06))

# -- SR
# bevholt
bhm <- srr

# - ricker abPars()
rim <- predictModel(model=ricker,
  params=FLPar(a=1.77027, b=0.00155))

# - geomean asymptote BH
gmm <- predictModel(model=geomean, params=FLPar(a=400)) 

# - hockeystick 70% asymptote BH
# BUG
hsm <- predictModel(model=rec ~ FLQuant(ifelse(c(ssb) <= c(b), c(a) * c(ssb), c(a) * c(b)),
  dimnames = dimnames(ssb)), params=FLPar(a=0.9, b=450))

hsm <- predictModel(model=segreg, params=FLPar(a=0.9, b=450))

plot(FLQuants(
  ricker=predict(rim, ssb=FLQuant(seq(1, 2000, length=100))),
  bevholt=predict(bhm, ssb=FLQuant(seq(1, 2000, length=100))),
  geomean=predict(gmm, ssb=FLQuant(seq(1, 2000, length=100))),
  segreg=predict(hsm, ssb=FLQuant(seq(1, 2000, length=100)))))

ggplot(FLQuants(
  ricker=predict(rim, ssb=FLQuant(seq(1, 2000, length=100))),
  bevholt=predict(bhm, ssb=FLQuant(seq(1, 2000, length=100))),
  geomean=predict(gmm, ssb=FLQuant(seq(1, 2000, length=100))),
  segreg=predict(hsm, ssb=FLQuant(seq(1, 2000, length=100))),
  replac=FLQuant(seq(1, 2000, length=100))/c(spr0(eql)),),
  aes(year, data, group=qname)) + geom_line()


# -- TRAJECTORIES

FMSY <- c(fmsy(eql))

# Roller coaster

rcc <- fwdControl(year=3:lastyr, quant="f", value=c(
  rep(0.001, length=40),
  seq(0, FMSY * 1.4, length=20),
  rep(FMSY * 1.4, 18),
  seq(FMSY * 1.4, FMSY * 0.75, length=20)
  ))

# Low F: 0.70 * FMSY

lfc <- fwdControl(year=3:lastyr, quant="f", value=FMSY * runif(98, 0.2, 0.4))

# High F: 1.25 * FMSY

hfc <- fwdControl(year=3:lastyr, quant="f", value=FMSY * runif(98, 1.2, 1.4))

# --

om <- propagate(om, its)

# SCENARIOS

sce <- list(devs=c('rwdev', 'lndev03', 'lndev06'),
  srm=c('bhm', 'rim', 'gmm', 'hsm'),
  traj=c('rcc', 'lfc', 'hfc'))

runs <- expand.grid(sce)

# JUST DO IT!

library(doParallel)
registerDoParallel(6)

out <- foreach(i=seq(nrow(runs))) %dopar% {

  # GET elements
  devs <- get(ac(runs[i,"devs"]))
  srm <- get(ac(runs[i,"srm"]))
  traj <- get(ac(runs[i,"traj"]))

  # FWD
  fwd(om, sr=srm, control=traj, deviances=devs)
}

names(out) <- seq(nrow(runs))
oms <- FLStocks(out)

# PLOTS

# PLOT one stock
png(file='png/stk_rwdev.png')
  plot(oms[[1]], iter=1:5)
dev.off()

# 3 x PLOT 3 runs: diff srr, diff trajectory, diff deviances
png(file="figs/devs.png")
  plot(oms[1:3]) +
  scale_fill_discrete(labels=runs[1:3,'devs']) +
  scale_color_discrete(labels=runs[1:3,'devs'])
dev.off()

png(file="figs/srm.png")
  plot(oms[c(1,4,7,10)]) +
  scale_fill_discrete(labels=runs[c(1,4,7,10),'srm']) +
  scale_color_discrete(labels=runs[c(1,4,7,10),'srm'])
dev.off()

png(file="figs/traj.png")
  plot(oms[c(1,13,25)]) +
  scale_fill_discrete(labels=runs[c(1,13,25),'traj']) +
  scale_color_discrete(labels=runs[c(1,13,25),'traj'])
dev.off()


# OUTPUT real ssb, rec, naa, fbar, faa, catch.sel, params, model


# --- OBSERVATIONS

# CATCH

x <- mnlnoise(catch.n(oms[[1]]))

# SURVEY
# 20% CV

CM(survey(oms, sel, timing))

# 3 x PLOT 3 runs: diff srr, diff trajectory, diff deviances

# -- SA INPUTS

# OUTPUT stock as VPA

writeVPA(om1, output.file="vpa/sim",
  slots=c("landings.n","landings.wt","m","mat","stock.wt", "m.spwn", "harvest.spwn"))


# No. years: 20, 40
