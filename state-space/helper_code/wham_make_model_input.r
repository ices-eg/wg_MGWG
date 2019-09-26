make_m1 = function()
{
  temp = base
  temp$random = "log_R"
  temp$map = temp$map[!(names(temp$map) %in% c("log_R_sigma", "mean_rec_pars"))]
  temp$data$random_recruitment = 1
  return(temp)
}

make_m2 = function()
{
  temp = base
  temp$data$age_comp_model_indices = rep(7, temp$data$n_indices)
  temp$data$age_comp_model_fleets = rep(7, temp$data$n_fleets)
  temp$data$n_age_comp_pars_indices = rep(1, temp$data$n_indices)
  temp$data$n_age_comp_pars_fleets = rep(1, temp$data$n_fleets)
  temp$par$index_paa_pars = rep(0, temp$data$n_indices)
  temp$par$catch_paa_pars = rep(0, temp$data$n_fleets)
  temp$map = temp$map[!(names(temp$map) %in% c("index_paa_pars", "catch_paa_pars"))]
  temp$random = "log_R"
  temp$map = temp$map[!(names(temp$map) %in% c("log_R_sigma", "mean_rec_pars"))]
  temp$data$random_recruitment = 1
  return(temp)
}


make_m3 = function()
{
  temp = base
  temp$data$use_NAA_re = 1
  temp$data$random_recruitment = 0
  temp$map = temp$map[!(names(temp$map) %in% c("log_NAA", "log_NAA_sigma", "mean_rec_pars"))]
  temp$map$log_R = factor(rep(NA, length(temp$par$log_R)))
  temp$random = "log_NAA"
  return(temp)
}

make_m4 = function()
{
  temp = base
  temp$data$age_comp_model_indices = rep(7, temp$data$n_indices)
  temp$data$age_comp_model_fleets = rep(7, temp$data$n_fleets)
  temp$data$n_age_comp_pars_indices = rep(1, temp$data$n_indices)
  temp$data$n_age_comp_pars_fleets = rep(1, temp$data$n_fleets)
  temp$par$index_paa_pars = rep(0, temp$data$n_indices)
  temp$par$catch_paa_pars = rep(0, temp$data$n_fleets)
  temp$map = temp$map[!(names(temp$map) %in% c("index_paa_pars", "catch_paa_pars"))]
  temp$data$use_NAA_re = 1
  temp$data$random_recruitment = 0
  temp$map = temp$map[!(names(temp$map) %in% c("log_NAA", "log_NAA_sigma", "mean_rec_pars"))]
  temp$map$log_R = factor(rep(NA, length(temp$par$log_R)))
  temp$random = "log_NAA"
  return(temp)
}










