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
idxs <- readFLIndices('GOMCOD_survey.dat')
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 9)
range(stk)[c('minfbar','maxfbar')] <- c(2,4)

# replace 0 with half of the minimum
catch.n(stk)[catch.n(stk)==0] <- min(catch.n(stk)[catch.n(stk)!=0])/2
idxs <- lapply(idxs, function(x){
	index(x)[index(x)==0] <- min(index(x)[index(x)!=0])/2
	x
})

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
plot(stk+fitmc)

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


