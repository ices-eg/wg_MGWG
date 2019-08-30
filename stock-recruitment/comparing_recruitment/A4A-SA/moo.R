# internal rec: 3 models geomean, ricker, bevholt
# AIC, BIC model selection
#AIC(fit)


library(FLa4a)
library(ggplotFL)
load("a4a/a4a.RData")
load("backup23.RData")


fmod <-  ~s(age, k= 10) + s(year, k = 28)  
qmod <- list(~s(age, k = 6))
srmod_BH <- ~bevholt(CV = 0.2)
srmod_Ric <- ~ricker(CV = 0.3)
srmod_geo <- ~geomean(CV = 0.2)
#qmod <- list(~factor(age))

sr_par <-  array(NA, dim = c(3, 2, 50,36))
#sr_par <- array(NA, dim = c(3, 2, 50))
#ModSel <- array(NA, dim = c(50, 3, 2, 36))
fit_store <-lapply(fit_store<-vector(mode = 'list',36), 
				function(x) x<-lapply(x<-vector(mode = 'list',50),function(x)x))
20

i <- 21
# while(i < 36){
# 	for (i in 1:36) {
# 		print(i)


i <- 36


for (i in 1:10){
	for (j in 1:50)
	{
		stk  <- stocks[[i]][,,,,,j]
		inds <- FLIndices(indices[[i]][1:8,,,,,j])
		fitBH <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_BH)
		fitRic <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_Ric)
		fitGeo <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_geo)
		fit_store[[i]][[j]] <- list(fitBH, fitRic, fitGeo)

		sr_par[1,,j,i] <- c(params(as(fitBH, "FLSR"))@.Data)
		sr_par[2,,j,i] <- c(params(as(fitRic, "FLSR"))@.Data)
		#sr_par[j,,3,i] <- c(params(as(fitGeo, "FLSR"))@.Data)

		rm(list = c("fitBH", "fitGeo", "fitRic"))
		print(j)
	}
}




# 	}i


# i <- i + 1

# }

#Problem
#i = 15, j = 10,30
#i = 18, j = 12,18,22,24,30,40
#i = 20 (?), j = 42
#i = 21, j = 10,22,24
#i = 24, j = 10,22,47,39,40,47, 50

save(fit_store, sr_par, con.n, con.r, file = "A4Aruns.RData")



converged <- data.frame(fitBH = NA, fitRic = NA, fitGeo = NA)
for (i in 1:36){
	converged[i,] <- NA
	m1 <- sr_par[,,,i]
	converged$fitBH[i] <- sum(apply(m1, 3, function(x) is.na(x[1,1])))
	converged$fitRic[i] <- sum(apply(m1, 3, function(x) is.na(x[2,2])))

}

con.r <- 1 -  converged/50
con.n <- 50 -  converged



















for (i in 1:10) {

  skip_to_next <- FALSE

  # Note that print(b) fails since b doesn't exist

  tryCatch(print(b), error = function(e) { skip_to_next <<- TRUE})
print(i)
  if(skip_to_next) { next }     
}






library(doParallel)
library(foreach)
registerDoParallel(cores=6)

a <- foreach(i =  1:36, .combine = list, .errorhandling='remove') %dopar% {

	sr_par <- array(NA, dim = c(3, 2, 50))
	fit_store <- vector(mode = 'list',50)
	print(i)			
	for (j in 1)
	{
		stk  <- stocks[[i]][,,,,,j]
		inds <- FLIndices(indices[[i]][1:8,,,,,j])

		fitBH <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_BH)
		fitRic <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_Ric)
		fitGeo <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_geo)
		fit_store[[j]] <- list(fitBH, fitRic, fitGeo)

		sr_par[1,,j] <- c(params(as(fitBH, "FLSR"))@.Data)
		sr_par[2,,j] <- c(params(as(fitRic, "FLSR"))@.Data)
		#sr_par[j,,3,i] <- c(params(as(fitGeo, "FLSR"))@.Data)

		rm(list = c("fitBH", "fitGeo", "fitRic"))
	}
	list(SR_PAR = sr_par, F_Store = fit_store)
	#list(fit_store)
}


moo <- function(x){
	sr_par <- array(NA, dim = c(3, 2, 50))
	fit_store <- vector(mode = 'list',50)
	for (j in 1)
	{
		stk  <- stocks[[i]][,,,,,j]
		inds <- FLIndices(indices[[i]][1:8,,,,,j])

		fitBH <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_BH)
		fitRic <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_Ric)
		fitGeo <- sca(stk, inds, qmodel=qmod, fmodel=fmod, srmodel = srmod_geo)
		fit_store[[j]] <- list(fitBH, fitRic, fitGeo)

		sr_par[1,,j] <- c(params(as(fitBH, "FLSR"))@.Data)
		sr_par[2,,j] <- c(params(as(fitRic, "FLSR"))@.Data)
		#sr_par[j,,3,i] <- c(params(as(fitGeo, "FLSR"))@.Data)

		rm(list = c("fitBH", "fitGeo", "fitRic"))
	}
	list(SR_PAR = sr_par, F_Store = fit_store)
	#list(fit_store)
}




library(parallel)
mclapply


fitGeo@pars@stkmodel@centering
fitBH@pars@stkmodel@coefficient
# ModSel[j,,1,i] <- AIC(fitBH, fitRic, fitGeo)
# ModSel[j,,2,i] <- BIC(fitBH, fitRic, fitGeo)


# fitBH@pars@stkmodel@srMod  
# fitBH@pars@stkmodel@coefficients


j =10
i = 11

parallelise





foreach(a=1:3, b=rep(10, 3)) %dopar% (a + b)