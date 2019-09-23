#####################################################################
# (20190922) EJ
# auxiliary funs for a4a runs
#####################################################################

# predict indices
predIdxs <- function(stk, idxs, yrs=3, ...){
	miny <- range(stk)['maxyear']-yrs+1
	i0 <- lapply(idxs, function(x){
		myr <- range(x)['maxyear']
		if(myr>=miny) index(x)[,ac(miny:myr)][] <- NA
		x
	})
	args <- list(...)
	args$stock <- stk
	args$indices <- FLIndices(i0)
	fit <- do.call("sca", args)
	fits <- simulate(fit, 500)
	#pred <- window(index(fit), start=miny)
	preds <- window(index(fits), start=miny)
	pred <- as.data.frame(lapply(preds, function(x) iterMedians(log(x))))
	fitVar <- as.data.frame(lapply(preds, function(x) iterVars(log(x))))
	oeVar <- as.data.frame(window(predict(fit)$vmodel[-1], start=miny))
	obs <- as.data.frame(window(lapply(lapply(idxs, index), log), start=miny))
	df0 <- obs[,c(2,8,1)]
	df0$logObs <- obs$data
	df0$pred <- pred$data
	df0$predSd <- sqrt(fitVar$data + oeVar$data)
	df0
}

# retro
retro <- function(stk, idxs, retro=5, k="missing", ftype="missing", ...){
	args <- list(...)
	kT <- missing(k)
	tT <- missing(ftype)
	lst0 <- split(0:retro, 0:retro)
	lst0 <- lapply(lst0, function(x){
		yr <- range(stk)["maxyear"] - x
		args$stock <- window(stk, end=yr)
		args$indices <- window(idxs, end=yr)
		if(!kT & !tT){
			KA <- unname(k['age'])
			KY <- unname(k['year'] - floor(x/2))
			if(!is.na(k['age2'])) KA2 <- k['age2'] else KA2 <- KA
			KA2 <- unname(KA2)
			if(ftype=='te'){
				fmod <- substitute(~te(age, year, k = c(KA, KY))+s(age, k=KA2), list(KA = KA, KY=KY, KA2=KA2))
			} else {
				fmod <- substitute(~s(year, k = KY)+s(age, k = KA), list(KA = KA, KY=KY))
			}
			args$fmodel <- as.formula(fmod)
		}
		fit <- do.call("sca", args)
		args$stock + fit
	})
	FLStocks(lst0)
}


retro_gomcod <- function(stk, idxs, retro, k, ...){
	args <- list(...)
	lst0 <- split(0:retro, 0:retro)
	lst0 <- lapply(lst0, function(x){
		yr <- range(stk)["maxyear"] - x
		args$stock <- window(stk, end=yr)
		args$indices <- window(idxs, end=yr)
		KA <- unname(k['age'])
		KY <- unname(k['year'] - floor(x/2))
		fmod <- substitute(~s(year, k = KY, by = breakpts(age, c(0,2,4,8)))+ s(age, k = KA), list(KA = KA, KY=KY))
		args$fmodel <- as.formula(fmod)
		fit <- do.call("sca", args)
		args$stock + fit
	})
	FLStocks(lst0)
}


# Mohn's rho
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

# save tabs
dumpTabs <- function(stock, indices, fit, probs=c(0.5,0.025, 0.975), preds, mohnRho){
	fitmet <- metrics(stock+fit)
	fitmet <- lapply(fitmet, quantile, probs=probs)
	fitmet <- lapply(fitmet, '[', drop=TRUE)
	fitmet <- do.call('cbind', fitmet)
	colnames(fitmet) <- c('R', 'Low', 'High', 'SSB', 'Low', 'High', 'Catch', 'Low', 'High', 'Fbar', 'Low', 'High')
	write.csv(fitmet, file='tab1.csv') 
	names(preds)[2] <- 'fleet'
	write.csv(preds, file='tab2.csv')
	write.csv(t(mohnRho), file='Mohn.txt', quote=FALSE, row.names=FALSE)
}

# save diags
dumpDiags <- function(stk, idxs, fit, ret, preds){
	require('ggplotFL')

	theme_update(plot.title = element_text(hjust = 0.5, face = 'bold'))

	pdf(file='diags.pdf', 7, 7)	
		res <- residuals(fit, stk, idxs)
		print(plot(res))

		print(qqmath(res))

		print(plot(fit, stk))

		for(i in 1:length(idxs)){ 
			plot(fit, idxs[i])
		}

		stk0 <- stk+simulate(fit, 250)	
		ret[[1]] <- stk0 
		print(plot(ret) + ggtitle('Retrospective'))

		print(plot(stk0) + ggtitle('Stock summary'))

		pfun <- function(x,y,...){
			panel.abline(a=0, b=1, col.line="gray80")
			panel.xyplot(x,y,...)
		}

		pset <- list( 
			strip.background=list(col="gray90"), 
			strip.border=list(col="black"), 
			box.rectangle=list(col="gray90")
		)

		print(xyplot(logObs~pred|qname, data=fit.pi, panel=pfun, par.settings=pset, col=1, pch=19, cex=0.5, main='Abundance indices predictions'))
	dev.off()

}


