predictYears <- function(fit, years=NULL, fleets=(1:fit$data$noFleets)[-1], map=fit$obj$env$map, ...){
  data <- fit$data
  idx <- which((data$aux[,"fleet"] %in% fleets) & (data$aux[,"year"] %in% years))  
  data$logobs[idx] <- NA
  idx2 <- which(is.na(data$logobs))
  conf <- fit$conf
  par <- defpar(data,conf)
  par$logFpar<-fit$pl$logFpar
  thisfit <- sam.fit(data, conf, par, rm.unidentified = TRUE, newtonsteps=0, silent=TRUE, map=map, ...)
  ret <- as.data.frame(cbind(data$aux[idx2,], obs=fit$data$logobs[idx2], pred=thisfit$pl$missing, predSd=thisfit$plsd$missing))
  ret <- ret[complete.cases(ret),]
  attr(ret, "fit") <- thisfit
  return(ret)
}
