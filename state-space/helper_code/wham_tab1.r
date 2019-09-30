wham_tab1 = function(model, years = NULL)
{
  temp = summary(model$sdrep)
  if(any(is.na(as.list(model$sdrep, "Std")$log_NAA)))
  {
    temp = c(as.list(model$sdrep, "Std")$log_N1_pars[1], as.list(model$sdrep, "Std")$log_R)
    tab1 = cbind(
      "R(age 1)" = model$rep$NAA[,1],
      Low = exp(log(model$rep$NAA[,1]) - temp*qnorm(0.975)),
      High = exp(log(model$rep$NAA[,1]) + temp*qnorm(0.975)))
  } else
  {
    temp = rbind(as.list(model$sdrep, "Std")$log_N1_pars, as.list(model$sdrep, "Std")$log_NAA)
    tab1 = cbind( 
      "R(age 1)" = model$rep$NAA[,1],
      Low = exp(log(model$rep$NAA[,1]) - temp[,1]*qnorm(0.975)),
      High = exp(log(model$rep$NAA[,1]) + temp[,1]*qnorm(0.975)))
  }
  temp = summary(model$sdrep)
  temp = temp[which(rownames(temp) == "log_SSB"),2]  
  tab1 = cbind(tab1, 
    SSB = model$rep$SSB,
    Low = exp(log(model$rep$SSB) - temp*qnorm(0.975)),
    High = exp(log(model$rep$SSB) + temp*qnorm(0.975)))
  temp = summary(model$sdrep)
  temp = temp[which(rownames(temp) == "log_Fbar"),2]  
  tab1 = cbind(tab1, 
    Fbar = model$rep$Fbar,
    Low = exp(log(model$rep$Fbar) - temp*qnorm(0.975)),
    High = exp(log(model$rep$Fbar) + temp*qnorm(0.975)))
  temp = summary(model$sdrep)
  temp = temp[which(rownames(temp) == "log_pred_catch"),2]  
  tab1 = cbind(tab1, 
    Catch = c(model$rep$pred_catch),
    Low = exp(log(c(model$rep$pred_catch)) - temp*qnorm(0.975)),
    High = exp(log(c(model$rep$pred_catch)) + temp*qnorm(0.975)))
  if(is.null(years)) rownames(tab1) = 1:NROW(tab1)
  else rownames(tab1) = years
  return(tab1)
}
