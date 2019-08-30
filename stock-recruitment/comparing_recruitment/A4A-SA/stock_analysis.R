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




#sr_par <-  array(NA, dim = c(3, 2, 50,36))

library(FLa4a)
library(ggplotFL)

load("A4Aruns.RData")
load("a4a.RData")

r22 <- stocks[[22]]
m <- fit_store[[22]]
BH_list <- list()
Ric_list <- list()
Geo_list <- list()

for (i in 1:50)
{
	print(i)
	BH_list[[i]] <- r22[,,,,,i] + m[[i]][[1]]
	Ric_list[[i]] <- r22[,,,,,i] + m[[i]][[2]]
	Geo_list[[i]] <- r22[,,,,,i] + m[[i]][[3]]

}



for(i in 1:36)
{
	for (j in 1:50) sr_par[3,1,j,i] <- 	c(params(as(fit_store[[i]][[j]][[3]], "FLSR"))@.Data)
1:8
}




converged <- data.frame(fitBH = NA, fitRic = NA, fitGeo = NA)
for (i in 1:36){
	converged[i,] <- NA
	m1 <- sr_par[,,,i]
	converged$fitBH[i] <- sum(apply(m1, 3, function(x) is.na(x[1,1])))
	converged$fitRic[i] <- sum(apply(m1, 3, function(x) is.na(x[2,2])))
	converged$fitGeo[i] <- sum(apply(m1, 3, function(x) is.na(x[3,1])))

}


cbind((converged),runs)

#fit_store[[i]][[j]]

pdf("residualsBH.pdf")
for (i in 1:36)
{
	for(j in 1:50)
	{
		print(plot(residuals(fit_store[[i]][[j]][[1]], stocks[[i]][,,,,,j], indices[[i]][1:8,,,,,j])))
	}
}


pdf("residualsRic.pdf")

for (i in 1:36)
{
	for(j in 1:50)
	{
		plot(residuals())
		plot(residuals(fitBH, stk, idxs))
	}
}

pdf("residuals.pdf")
for (i in 1:36)
{
	for(j in 1:50)
	{
		plot(residuals())
		plot(residuals(fitBH, stk, idxs))
	}
}
