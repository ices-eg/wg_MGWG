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
idxs <- readFLIndices('CCGOMYT_survey.dat')
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 6)
range(stk)[c('minfbar','maxfbar')] <- c(4,5)

# replace 0 with half of the minimum
catch.n(stk)[catch.n(stk)==0] <- min(catch.n(stk)[catch.n(stk)!=0])/2
idxs <- lapply(idxs, function(x){
	index(x)[index(x)==0] <- min(index(x)[index(x)!=0])/2
	x
})

my <- min(unlist(lapply(lapply(idxs, range), '[', 'minyear')))
stk <- window(stk, start=my)

setwd('a4asca')

#====================================================================
# default model
#====================================================================

qmod <- list(~s(age, k=3), ~s(age, k=3), ~s(age, k=3), ~s(age, k=3))
fmod <- ~ te(age, year, k=c(4, 23)) + s(age, k=4)
srmod <- ~geomean(CV=0.1)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel=srmod)
fits <- simulate(fit, 500)
stk.retro <- retro(stk, idxs, retro=7, k=c(age=4, year=23, age2=4), ftype="te", qmodel=qmod, srmodel=srmod)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel=srmod)
dumpTab1(stk, idxs, fits, predIdxs=fit.pi, mohnRho=fit.rm, prefix='te')
write.csv(fit.pi, file=paste0("te-","tab2.csv"))

#====================================================================
# separable model
#====================================================================

fmod <- ~s(age, k=4) + s(year, k=23)
fitsep <- sca(stk, idxs, fmodel=fmod, qmodel=qmod, srmodel=srmod)
fitseps <- simulate(fitsep, 500)
stksep.retro <- retro(stk, idxs, retro=7, k=c(age=4, year=23), ftype="sep", qmodel=qmod, srmodel=srmod)
fitsep.rm <- mohn(stksep.retro)
fitsep.pi <- predIdxs(stk, idxs, fmodel=fmod, qmodel=qmod, srmodel=srmod)
dumpTab1(stk, idxs, fitseps, predIdxs=fitsep.pi, mohnRho=fitsep.rm, prefix='sep')
write.csv(fitsep.pi, file=paste0("sep-","tab2.csv"))




