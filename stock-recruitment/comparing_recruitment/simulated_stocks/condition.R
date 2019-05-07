# condition.R - DESC
# /condition.R

# Copyright European Union, 2018
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.


# -- SETUP

# INSTALL PKGS from FLR and CRAN dependencies

install.packages(c("FLife", "FLasher", "ggplotFL", "data.table", "doParallel",
  "doRNG"), repos=structure(c(CRAN="https://cran.uni-muenster.de/",
    FLR="http://flr-project.org/R")))

# LOAD PKGS

library(FLife)
library(FLasher)
library(ggplotFL)
library(data.table)

# GET colinmillar:::mlnoise()

source("R/functions.R")

# VARIABLES

lastyr <- 100
its <- 5

set.seed(1809)


# -- INITIAL population

# SET initial parameters:

# h = 0.65, B0 = 1000, Linf = 90
par <- FLPar(linf=90, a=0.00001, sl=1, sr=2000, a1=4, s=0.65, v=1000)

# ages 1-20+, fbar = 4-15
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

om <- propagate(om, its)

# {{{ CHECK initial SRR

eqlR <- lhEql(parg, range=range, m=mJensen, sr="ricker")
stkR <- as(eql, "FLStock")
srrR <- as(eql, "predictModel")
omR <- fwdWindow(stk[,2], eql, end=lastyr)

comp <- FLQuants(BH=iter(stock.n(om)[,1],1), RK=stock.n(omR)[,1])

ggplot(comp, aes(x=age, y=data, colour=qname)) + geom_line() + facet_wrap(~qname)

# }}}

# -- DEVIANCES

# rand walk

rwfoo <- function(n, sd) {
  x <- cumsum(rnorm(n, sd = sd))
  exp(x - mean(x))
}

rwdev <- Reduce(combine, FLQuants(lapply(1:its, function(x)
  FLQuant(rwfoo(n=98, sd=0.05), dimnames=list(year=3:lastyr)))))

# lnormal

lndev03 <- rlnorm(its, FLQuant(0, dimnames=list(year=3:lastyr)), 0.3)
lndev06 <- rlnorm(its, FLQuant(0, dimnames=list(year=3:lastyr)), 0.6)

plot(FLQuants(rw=rwdev, ln03=lndev03, ln06=lndev06))


# -- SRRs

# bevholt
bhm <- srr

# ricker abPars()
rim <- predictModel(model=ricker,
  params=FLPar(a=1.77027, b=0.00155))

# geomean asymptote BH
gmm <- predictModel(model=geomean, params=FLPar(a=400)) 

# hockeystick 70% asymptote BH
hsm <- predictModel(model=rec ~ FLQuant(ifelse(c(ssb) <= c(b), c(a) * c(ssb), c(a) * c(b)),
  dimnames = dimnames(ssb)), params=FLPar(a=0.9, b=450))

ggplot(FLQuants(
  ricker=predict(rim, ssb=FLQuant(seq(1, 2000, length=100))),
  bevholt=predict(bhm, ssb=FLQuant(seq(1, 2000, length=100))),
  geomean=predict(gmm, ssb=FLQuant(seq(1, 2000, length=100))),
  segreg=predict(hsm, ssb=FLQuant(seq(1, 2000, length=100))),
  replacement=FLQuant(seq(1, 2000, length=100))/c(spr0(eql)),),
  aes(year, data, group=qname, colour=qname)) + geom_line() +
  ylab("Recruits (1000s)") + xlab("SSB (t)") +
  scale_x_continuous(expand=c(0,0),
    labels=floor(seq(1, 2000, length=5)),
    breaks=seq(1, 100, length=5)) +
  scale_y_continuous(sec.axis = sec_axis(~ .,
    breaks = c(160, 415, 380, 460),
    label=c("Ricker", "SegReg", "Mean", "BevHolt"))) +
  scale_color_discrete(name="SRR: ")


# -- TRAJECTORIES

# Refpt

FMSY <- c(fmsy(eql))

# Roller coaster

rcc <- fwdControl(year=3:lastyr, quant="f", value=c(
  rep(0.001, length=40),
  seq(0.001, FMSY * 1.4, length=20),
  rep(FMSY * 1.4, 18),
  seq(FMSY * 1.4, FMSY * 0.75, length=20)
  ))

# Low F: 0.30 * FMSY

lfc <- fwdControl(
  # year 3-40, F=0.001
  list(year=seq(3, 40), quant="f", value=0.001),
  # year 41-lastyr, F=FMSY * [0.2-0.4]
  list(year=seq(41, lastyr), quant="f", value=FMSY * runif(60, 0.2, 0.4)))

# High F: 1.30 * FMSY

hfc <- fwdControl(
  # year 3-40, F=0.001
  list(year=seq(3, 40), quant="f", value=0.001),
  # year 41-lastyr, F=FMSY * [1.2-1.4]
  list(year=seq(41, lastyr), quant="f", value=FMSY * runif(60, 1.2, 1.4)))


# SCENARIOS

sce <- list(
  devs=c('rwdev', 'lndev03', 'lndev06'),
  srm=c('bhm', 'rim', 'gmm', 'hsm'),
  traj=c('rcc', 'lfc', 'hfc'))

runs <- expand.grid(sce)

# -- PROJECT OMs

library(parallel)
library(doParallel)

# REGISTER ncores
ncores <- min(nrow(runs), floor(detectCores() * 0.9))

registerDoParallel(ncores)

# SET parallel RNG seed
library(doRNG)
registerDoRNG(8234)

# SETUP for psocks connection
out <- foreach(i=seq(nrow(runs)),
  .final=function(i) setNames(i, seq(nrow(runs)))) %dopar% {

  # GET elements
  devs <- get(ac(runs[i,"devs"]))
  srm <- get(ac(runs[i,"srm"]))
  traj <- get(ac(runs[i,"traj"]))

  # FWD
  fwd(om, sr=srm, control=traj, deviances=devs)
}

oms <- FLStocks(out)

# PLOTS

# PLOT one stock
plot(oms[[1]], iter=1:5)

# 3 x PLOT 3 runs: diff srr, diff trajectory, diff deviances
plot(oms[1:3]) +
  scale_fill_discrete(labels=runs[1:3,'devs']) +
  scale_color_discrete(labels=runs[1:3,'devs'])

plot(oms[c(1,4,7,10)]) +
  scale_fill_discrete(labels=runs[c(1,4,7,10),'srm']) +
  scale_color_discrete(labels=runs[c(1,4,7,10),'srm'])

plot(oms[c(1,13,25)]) +
  scale_fill_discrete(labels=runs[c(1,13,25),'traj']) +
  scale_color_discrete(labels=runs[c(1,13,25),'traj'])

# OUTPUT real ssb, rec, naa, fbar, faa, catch.sel, params, model

metrics <- lapply(oms, metrics,
  list(ssb=ssb, rec=rec, naa=stock.n, fbar=fbar, faa=harvest, catch.sel=catch.sel))

srrs <- rbindlist(lapply(list(bhm=bhm, rim=rim, gmm=gmm, hsm=hsm)[runs$srm], function(x)
  cbind(data.frame(model=SRModelName(model(x)), data.frame(as(params(x), 'list'))))),
  fill=TRUE)

# RUNS: devs, srm, traj, model, a, b
runs <- cbind(runs, srrs)

 
# PLOT stock, mat, m, waa

# -- OBSERVATIONS

# CATCH.N, mnlnoise w/ 10% CV, 200 ESS

numbers <- catch.n(oms[[1]])
sdlog <- sqrt(log(1 + ((catch(oms[[1]]) * 0.10)^2 / catch(oms[[1]])^2)))

catch.n <- FLQuants(mclapply(oms, function(x)
  mnlnoise(n=its, numbers=catch.n(x),
  sdlog=sqrt(log(1 + ((catch(x) * 0.10)^2 / catch(x)^2))), ess=200), mc.cores=ncores))


# SURVEY, mnlnoise w/ 20% CV, 100 ESS

survey.q <- 0.14
survey.sel <- catch.sel(oms[[1]])[,1]

index <- FLQuants(mclapply(oms, function(x)
  mnlnoise(n=its, numbers=survey.q * stock.n(x) %*% survey.sel,
  sdlog=sqrt(log(1 + ((stock(x) * 0.20)^2 / stock(x)^2))), ess=100), mc.cores=ncores))

# 3 x PLOT 3 runs: diff srr, diff trajectory, diff deviances

# SAVE

save(index, catch.n, metrics, srrs, runs, file="out/metrics.RData", compress="xz")

save(oms, runs, file="out/oms.RData", compress="xz")

# -- SA INPUTS

# VPA

res <- foreach(i=seq(nrow(runs))) %dopar% {

  paths <- file.path("vpa", paste0("r", i), paste0("iter", seq(its)))

  for(j in seq(its)) {
  
    # CREATE FLIndices
    idxs <- FLIndices(A=FLIndex(index=iter(index[[i]], j),
      effort=FLQuant(1, dimnames=dimnames(iter(index[[1]], 1))["year"]),
      name="A", desc="Simulated"))

    if(!dir.exists(paths[j]))
      dir.create(paths[j], recursive=TRUE)

    writeVPAFiles(iter(oms[[i]], j), indices=idxs, file=file.path(paths[[j]], "sim"))
  }
}

# ASAP

# a4a

# SAM

# CASAL

# S/R TSs

# TRUE F, rec, Q as DF, txt / VPA files
