# cohort cross validation
cgcv <- function(stk, ids, cohorts=missing, ...){

	if(missing(cohorts)) cohorts <- range(stk)[c("minyear")]:(range(stk)[c("maxyear")]-(range(stk)[c("max")]-range(stk)[c("min")]))
	args <- list(...)

	coh <- as.character(cohorts)
	cv <- FLCohort(catch.n(stk))[,coh]
	cv[] <- NA
#	cv <- vector(length=length(coh))
#	names(cv) <- coh
	#cth <- catch.n(stk)
	flc0 <- FLCohort(catch.n(stk))
	for(i in coh){
		cat(i, sep=" ")
		flc <- flc0
		flc[,i] <- NA
		catch.n(stk) <- as(flc, "FLQuant")
		args$stock <- stk
		args$indices <- ids
		fit <- do.call("sca", args)
#		cv[i] <- mean(log(flc0[,i]/FLCohort(catch.n(fit))[,i])^2, na.rm=T)
		cv[,i] <- log(flc0[,i]/FLCohort(catch.n(fit))[,i])
		#catch.n(stk) <- cth
	}
	cat("\n")
	cv
}


hindcast <- function(stk, ids, hc=5, ...){
	args <- list(...)
	mxy <- range(stk)["maxyear"]
	lst0 <- as.list(vector("numeric", length=hc+1))
	names(lst0) <- mxy:(mxy-hc)
	for(i in 0:hc){
		cat(mxy-i, sep=" ")
		catch.n(stk)[,ac(mxy-i)] <- NA
		args$stock <- stk
		args$indices <- ids
		lst0[[i+1]] <- do.call("sca", args)
	}	
	cat("\n")
	lst0
}


chandler <- function(stks, qoi, distFun){
	flqs <- lapply(stks, qoi)
	df0 <- data.frame(model=names(stks), score=NA)
	for(i in seq_along(flqs)) df0[i,"score"] <- mean((log(c(flqs[[i]])) - log(unlist(flqs[-i])))^2)
	df0
}

predIdxs <- function(stk, idxs, yrs=3, ...){
	i0 <- lapply(idxs, function(x){
		myr <- range(x)['maxyear']
		index(x)[,ac((myr-yrs+1):myr)][] <- NA
		x
	})
	args <- list(...)
	args$stock <- stk
	args$indices <- FLIndices(i0)
	fit <- do.call("sca", args)
	lst0 <- index(fit)
    myr <- unlist(lapply(idxs, function(x) range(x)['maxyear'])) 
	for(i in seq_along(idxs)){
		lst0[[i]] <- log(index(idxs[[i]])[,ac((myr[i]-yrs+1):myr[i])]/index(fit)[[i]][,ac((myr[i]-yrs+1):myr[i])])^2
	}
	mean(unlist(lst0), na.rm=TRUE)	
}

# retro
retro <- function(stk, idxs, retro=5, ...){
	args <- list(...)
	lst0 <- split(0:retro, 0:retro)
	lst0 <- lapply(lst0, function(x){
		yr <- range(stk)["maxyear"] - x
		args$stock <- window(stk, end=yr)
		args$indices <- window(idxs, end=yr)
		fit <- do.call("sca", args)
		args$stock + fit
	})
	FLStocks(lst0)
}

mohn <- function (stks, qoi=c('fbar','ssb','rec'), ...){
	v0 <- vector(mode='numeric', len=length(qoi))
	names(v0) <- qoi
	yrs <- unlist(lapply(stks, function(x) range(x)['maxyear']))[-1]
	for(i in qoi){
		lst0 <- lapply(stks, i)
		base <- c(lst0[[1]][,ac(yrs)])
		retros <- unlist(lapply(lst0[-1], function(x) x[,dim(x)[2]]))
		v0[i] <- mean(retros/base-1, na.rm=TRUE)
	}	
	v0	
}

dumpTab1 <- function(stock, indices, fit, probs=c(0.5,0.025, 0.975), prefix='fit', predIdxs, mohnRho){
	fitmet <- metrics(stock+fit)
	fitmet <- lapply(fitmet, quantile, probs=probs)
	fitmet <- lapply(fitmet, '[', drop=TRUE)
	fitmet <- do.call('cbind', fitmet)
	colnames(fitmet) <- c('R', 'Low', 'High', 'SSB', 'Low', 'High', 'Catch', 'Low', 'High', 'Fbar', 'Low', 'High')
	write.csv(fitmet, file=paste(prefix, 'tab1.csv', sep='-')) 
	write.table(predIdxs, file=paste(prefix, 'predIdxs.txt', sep='-'), quote=FALSE, col.names=FALSE, row.names=FALSE)
	write.csv(t(mohnRho), file=paste(prefix, 'mohn.txt', sep='-'), quote=FALSE, row.names=FALSE)
}




