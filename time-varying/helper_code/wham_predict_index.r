wham_predict_index = function()
{
  for(i in paste0("m", 1:4)) 
  {
    temp = list(data = get(i)$env$data, par = get(i)$parList, map = get(i)$env$map,
      random = unique(names(get(i)$env$par[get(i)$env$random])))
    temp$data$use_indices[(temp$data$n_years_model-2):temp$data$n_years_model,] = 0
    temp$data$use_index_paa[(temp$data$n_years_model-2):temp$data$n_years_model,] = 0
    eval(parse(text = paste0(i, "$proj = fit_wham(temp, do.retro = FALSE, do.osa = FALSE)")))
    x = summary(get(i)$proj$sdrep)
    x = x[which(rownames(x) == "pred_IAA"),]
    eval(parse(text = paste0(i, "$proj$proj_IAA = list(pred = array(x[,1], dim = dim(", i, "$proj$rep$pred_IAA)))")))
    eval(parse(text = paste0(i, "$proj$proj_IAA$sd = array(x[,2], dim = dim(", i, "$proj$rep$pred_IAA))")))
    tab1 = wham_tab1(get(i), years = base$years)
    tab2 = wham_tab2(get(i)$proj, years = base$years)
    write.csv(tab1, file = paste0(write.dir, "/", i, "_tab1.csv"))
    write.csv(tab2, file = paste0(write.dir, "/", i, "_tab2.csv"))
  }
}
