#####################################################################
# 20190922 EJ
#
# Running stock assessments for WGMG 2018 projects
#####################################################################

library(FLa4a)
source('../../helper_code/a4a_funs.R')

#====================================================================
# read data
#====================================================================
setwd('../')
idxs <- readFLIndices('SNEMAYT_survey.dat')
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 6)
range(stk)[c('minfbar','maxfbar')] <- c(4,5)
setwd('a4asca')

#====================================================================
# replace 0 with half of the minimum
#====================================================================
catch.n(stk)[catch.n(stk)==0] <- min(catch.n(stk)[catch.n(stk)!=0])/2
idxs <- lapply(idxs, function(x){
	index(x)[index(x)==0] <- min(index(x)[index(x)!=0])/2
	x
})

#====================================================================
# Use only years with surveys
#====================================================================
my <- min(unlist(lapply(lapply(idxs, range), '[', 'minyear')))
stk <- window(stk, start=my)

#====================================================================
# run model
#====================================================================
qmod <- list(~s(age, k=4, by=breakpts(year, 2008)), ~s(age, k=3, by=breakpts(year, 2008)))
fmod <- ~s(year, k=15, by=breakpts(age, 0:6)) + s(age, k=3)
srmod <- ~ricker(CV=0.6)
fit <- sca(stk, idxs, fmodel=fmod, qmodel=qmod, srmodel=srmod)
fits <- simulate(fit, 500)

#====================================================================
# run retro and predictions
#====================================================================
stk.retro <- retro_snemayt(stk, idxs, retro=7, k=c(age=3, year=15), qmodel=qmod, srmodel=srmod)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel=srmod)

#====================================================================
# save
#====================================================================
dumpTabs(stk, idxs, fits, preds=fit.pi, mohnRho=fit.rm)
dumpDiags(stk, idxs, fit, stk.retro, fit.pi)

