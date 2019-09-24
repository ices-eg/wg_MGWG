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
idxs <- readFLIndices('survey.dat')
idxs <- window(idxs, end=2016)
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- window(stk, end=2016, start=1983)
stk <- setPlusGroup(stk, 6)
range(stk)[c('minfbar','maxfbar')] <- c(2,4)
setwd('a4asca_constantFSelectivity')

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
qmod <- list(~s(age, k=3), ~s(age, k=3))
fmod <- ~s(age, k=4) + s(year, k=15)
srmod <- ~geomean(CV=0.3)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel=srmod)
fits <- simulate(fit, 500)

#====================================================================
# run retro and predictions
#====================================================================
stk.retro <- retro(stk, idxs, retro=7, k=c(age=4, year=15), ftype="sep", qmodel=qmod, srmodel=srmod)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel=srmod)

#====================================================================
# save
#====================================================================
dumpTabs(stk, idxs, fits, preds=fit.pi, mohnRho=fit.rm)
dumpDiags(stk, idxs, fit, stk.retro, fit.pi)



