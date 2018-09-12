# sim.R - DESC
# /sim.R

# Copyright European Union, 2018
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.

library(FLife)
library(FLasher)

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

# EXTEND F=0.0057226 until year=100

om <- fwdWindow(stk[,2], eql, end=100)

# -- TRAJECTORIES

FMSY <- c(fmsy(eql))

# Roller coaster

om1 <- fwd(om, sr=srr, control=fwdControl(year=3:100, quant="f", 
  value=c(seq(0, FMSY * 1.4, length=40),
        rep(FMSY * 1.4, 20),
        seq(FMSY * 1.4, FMSY, length=38)
  )))

plot(om1)

# OUTPUT stock as VPA

writeVPA(om1, output.file="vpa/sim",
  slots=c("catch.n","catch.wt","m","mat","stock.wt", "m.spwn", "harvest.spwn"))

# OUTPUT real ssb, rec, naa, fbar, faa, catch.sel, params, model

# PROPAGATE x 1000

# GENERATE deviances:
# - rwalk()
# - rlnorm(500, 0, 0.4)

