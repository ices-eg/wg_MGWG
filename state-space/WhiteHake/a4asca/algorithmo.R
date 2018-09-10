#####################################################################
# 20180910 EJ
#
# Running stock assessments for WGMG 2018 projects
#####################################################################

library(FLa4a)
library(ggplotFL)

#====================================================================
# read data
#====================================================================

setwd('../')
idxs <- readFLIndices('WHITEHAKE_survey.dat')
idxs <- window(idxs, end=2016)
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- window(stk, end=2016, start=1983)
stk <- setPlusGroup(stk, 6)
range(stk)[c('minfbar','maxfbar')] <- c(2,4)

setwd('a4asca')

#====================================================================
# default model
#====================================================================

fit <- sca(stk, idxs)
res <- residuals(fit, stk, idxs)
plot(res)
plot(fit, stk)
plot(fit, idxs[1])
plot(fit, idxs[2])
plot(stk+simulate(fit, 250))
wireframe(data~year+age, data=harvest(fit))

fitmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=25000))

#====================================================================
# separable model
#====================================================================

fitsep <- sca(stk, idxs, fmod=~s(age, k=5) + s(year, k=17))
ressep <- residuals(fitsep, stk, idxs)
plot(ressep)
plot(fitsep, stk)
plot(fitsep, idxs[1])
plot(fitsep, idxs[2])
plot(stk+simulate(fitsep, 250))
wireframe(data~year+age, data=harvest(fitsep))

fitsepmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=25000))

plot(stk+fitsepmc)


