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

setwd('../')
idxs <- readFLIndices('SNEMAWINTER_survey.dat')
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 7)
range(stk)[c('minfbar','maxfbar')] <- c(4,5)

# replace 0 with half of the minimum
catch.n(stk)[catch.n(stk)==0] <- min(catch.n(stk)[catch.n(stk)!=0])/2
idxs <- lapply(idxs, function(x){
	index(x)[index(x)==0] <- min(index(x)[index(x)!=0])/2
	x
})

setwd('a4asca/')

#====================================================================
# default model
#====================================================================
qmod <- list(~s(age, k=4), ~s(age, k=3), ~s(age, k=3))
fmod <- ~te(age, year, k = c(4, 18), bs = "tp") + s(age, k = 5)
fit <- sca(stk, idxs, fmodel=fmod, qmodel=qmod)
stk.retro <- retro(stk, idxs, retro=7, qmodel=qmod, k=c(age=4, year=18, age2=5), ftype='te')
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs, fmodel=fmod, qmodel=qmod)
fitmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=250000), fmodel=fmod, qmodel=qmod)
dumpTab1(stk, idxs, fitmc, predIdxs=fit.pi, mohnRho=fit.rm, prefix='te')

#====================================================================
# separable model
#====================================================================

fmod <- ~s(age, k=5) + s(year, k=18)
fitsep <- sca(stk, idxs, fmodel=fmod, qmodel=qmod)
stksep.retro <- retro(stk, idxs, retro=7, qmodel=qmod, k=c(age=5, year=18), ftype='sep')
fitsep.rm <- mohn(stksep.retro)
fitsep.pi <- predIdxs(stk, idxs, fmodel=fmod, qmodel=qmod)
fitsepmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=250000), fmodel=fmod, qmodel=qmod)
dumpTab1(stk, idxs, fitsepmc, predIdxs=fitsep.pi, mohnRho=fitsep.rm, prefix='sep')


