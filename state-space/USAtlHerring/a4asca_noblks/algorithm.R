#####################################################################
# 20190922 EJ
#
# Running stock assessments for WGMG 2018 projects
#####################################################################

library(FLa4a)
source('../../helper_code/a4a_funs.R')
wkdir <- system("pwd", intern=TRUE)

#====================================================================
# read data
#====================================================================
setwd('../')
idxs <- readFLIndices('USAtHERRING_survey.dat')
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 8)
range(stk)[c('minfbar','maxfbar')] <- c(7,8)

setwd(wkdir)

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
qmod <- list(~s(age, k=3), ~s(age, k=5))
fmod <- ~s(year, k=4, by=breakpts(age,c(0,1,2,6,7,8))) + te(age, year, k=c(4,10)) + s(age, k=6)
srmod <- ~geomean(CV=0.3)
fit <- sca(stk, idxs, fmodel=fmod, qmodel=qmod, srmodel=srmod)
fits <- simulate(fit, 500)

#====================================================================
# run retro and predictions
#====================================================================
stk.retro <- retro_usatlher(stk, idxs, retro=7, k=c(age=5, year=10), frat=.36, qmodel=qmod, srmodel=srmod)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel=srmod)

#====================================================================
# save
#====================================================================
dumpTabs(stk, idxs, fits, preds=fit.pi, mohnRho=fit.rm)
dumpDiags(stk, idxs, fit, stk.retro, fit.pi)

