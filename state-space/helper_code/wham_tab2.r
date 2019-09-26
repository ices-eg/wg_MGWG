wham_tab2 = function(model, years = NULL)
{
  ind = (model$env$data$n_years_model-2):model$env$data$n_years_model
  ind2 = 1:model$env$data$n_indices
  tab2 = cbind(c(sapply(ind, function(i) 
  {
    sapply(ind2, function(j) 
    {
      if(model$env$data$units_index_paa[j] != model$env$data$units_indices[j]) 
      warning(paste0("units of aggregate index and acomp for index ", i, " are not equal"))
      log(model$env$data$index_paa[j,i,] *model$env$data$agg_indices[i,j])
    })
  })))
  tab2 = cbind(tab2, c(sapply(ind, function(i) sapply(ind2, function(j) log(model$proj_IAA$pred[i,j,])))))
  tab2 = cbind(tab2, c(sapply(ind, function(i) sapply(ind2, function(j) model$proj_IAA$sd[i,j,]/model$proj_IAA$pred[i,j,]))))
  tab2[which(is.infinite(tab2))] = NA
  tab2 = cbind(rep(1:model$env$data$n_ages, length(ind)*length(ind2)), tab2) 
  tab2 = cbind(rep(rep(ind2, each = model$env$data$n_ages), length(ind)), tab2)
  tab2 = cbind(rep(ind, each = model$env$data$n_ages*length(ind2)), tab2)
  if(!is.null(years)) tab2[,1]= years[tab2[,1]]
  colnames(tab2) = c("year", "fleet", "age", "logObs", "pred", "predSd")
  return(tab2)
}
