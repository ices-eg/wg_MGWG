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
idxs <- readFLIndices('survey.dat')
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
stk.retro <- retro(stk, idxs, retro=7)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs)

#====================================================================
# separable model
#====================================================================

fmod <- ~s(age, k=5) + s(year, k=17)
fitsep <- sca(stk, idxs, fmodel=fmod)
stksep.retro <- retro(stk, idxs, retro=7, fmodel=fmod)
fitsep.rm <- mohn(stksep.retro)
fitsep.pi <- predIdxs(stk, idxs, fmodel=fmod)


