predictYears <- function(fit, years=NULL, fleets=(1:fit$data$noFleets)[-1], ...){
  data <- fit$data
  idx <- which((data$aux[,"fleet"] %in% fleets) & (data$aux[,"year"] %in% years))  
  data$logobs[idx] <- NA
  idx2 <- which(is.na(data$logobs))
  conf <- fit$conf
  par <- defpar(data,conf)
  thisfit <- sam.fit(data, conf, par, rm.unidentified = TRUE, newtonsteps=0, silent=TRUE,...)
  ret <- as.data.frame(cbind(data$aux[idx2,], obs=fit$data$logobs[idx2], pred=thisfit$pl$missing, predSd=thisfit$plsd$missing))
  ret <- ret[complete.cases(ret),]
  attr(ret, "fit") <- thisfit
  return(ret)
}
##  
##  
##  predictYears2 <- function(fit, years=NULL, fleets=(1:fit$data$noFleets)[-1], ...){
##    data <- fit$data
##    idx<-integer(0)
##    for(i in fleets){
##      maxyf<-max(data$aux[data$aux[,2]==i,1])  
##      idx <- c(idx,which((data$aux[,"fleet"]==i) & (data$aux[,"year"] %in% c(maxyf-0:2))))
##    }
##    data$logobs[idx] <- NA
##    idx2 <- which(is.na(data$logobs))
##    conf <- fit$conf
##    par <- defpar(data,conf)
##    thisfit <- sam.fit(data, conf, par, rm.unidentified = TRUE, newtonsteps=0, silent=TRUE,...)
##    ret <- as.data.frame(cbind(data$aux[idx2,], obs=fit$data$logobs[idx2], pred=thisfit$pl$missing, predSd=thisfit$plsd$missing))
##    ret <- ret[complete.cases(ret),]
##    attr(ret, "fit") <- thisfit
##    return(ret)
##  }
