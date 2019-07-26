# test.R - DESC
# /test.R

# Copyright European Union, 2019
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the GPL 3.0

# XX {{{
# }}}

library(FLa4a)

load("a4a.RData")

a <- 2
stk<- stocks[[1]][,,,,,a]
idxs <- FLIndices(indices[[1]][,,,,,a])

fmod <-  ~ te(age, year, k = c(4,10)) + s(age, k = 10) + s(year, k = 25)
#fmod <-  ~s(age, k = 15) + s(year, k = 30)
qmod <- list(~s(age, k = 12))
srmod <- ~geomean(0.5)

fit <- sca(stk, idxs, qmodel=qmod)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod)
fit <- sca(stk, idxs, srmodel = srmod)
fit <- sca(stk, idxs, qmodel=qmod, srmodel = srmod)
fit <- sca(stk, idxs, fmodel=fmod, srmodel = srmod)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel = srmod)
s1 <- stk+fit
res1 <- residuals(fit, stk, idxs)
pr1 <- predict(fit)

plot(residuals(fit, stk, idxs))
