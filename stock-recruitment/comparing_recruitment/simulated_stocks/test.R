# test.R - DESC
# /test.R

# Copyright European Union, 2019
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.


library(FLasher)

load("out/oms.RData")


# EXTRACT single OM

x <- oms[[1]]

# FWD with FLStock

y <- fwd(x, sr=srms$bhm, catch=catch(x)[,'50'] * 2, deviances=devs$rw, maxF=NULL)

stock.n(y)[,'50'] / stock.n(x)[,'50']
stock.n(y)[,'51'] / stock.n(x)[,'51']

# FWD with B + F

xb <- as(x, 'FLBiol')
rec(xb) <- srms$bhm

xf <- as(x, 'FLFishery')
names(xf) <- "B"

control <- fwdControl(list(year=50, quant="catch", value=c(catch(x)[,'50'] * 2),
  fishery=1, catch=1), FCB=FCB(c(1,1,1)))

yy <- fwd(xb, xf, control=control, deviances=devs$rw)

# COMPARE abundances, effort

n(yy$biols)[,'49'] / n(xb)[,'49']

n(yy$biols)[,'50'] / n(xb)[,'50']
effort(yy$fisheries)[,'50'] / effort(xf)[,'50']

n(yy$biols)[,'51'] / n(xb)[,'51']
effort(yy$fisheries)[,'51'] / effort(xf)[,'51']

n(yy$biols)[,'52'] / n(xb)[,'52']

