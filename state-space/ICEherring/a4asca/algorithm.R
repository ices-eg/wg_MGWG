#####################################################################
# 20180910 EJ
#
# Running stock assessments for WGMG 2018 projects
#####################################################################

library(RMGWG)
library(ggplotFL)

#====================================================================
# read data
#====================================================================

setwd('../ices_data/')
idxs <- readFLIndices('survey.dat')
idxs <- window(idxs, end=2016)
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 11)
range(stk)[c('minfbar','maxfbar')] <- c(5,10)
setwd('../a4asca/')

#====================================================================
# default model
#====================================================================

fit <- sca(stk, idxs)
stk.retro <- retro(stk, idxs, retro=7)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs)
fitmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=250000))
dumpTab1(stk, idxs, fitmc, predIdxs=fit.pi, mohnRho=fit.rm, prefix='te')

#====================================================================
# separable model
#====================================================================

fmod <- ~s(age, k=6) + s(year, k=15)
fitsep <- sca(stk, idxs, fmodel=fmod)
stksep.retro <- retro(stk, idxs, retro=7, fmodel=fmod)
fitsep.rm <- mohn(stksep.retro)
fitsep.pi <- predIdxs(stk, idxs, fmodel=fmod)
fitsepmc <- sca(stk, idxs, fmodel=fmod, fit='MCMC', mcmc=SCAMCMC(mcmc=250000))
dumpTab1(stk, idxs, fitsepmc, predIdxs=fitsep.pi, mohnRho=fitsep.rm, prefix='sep')


