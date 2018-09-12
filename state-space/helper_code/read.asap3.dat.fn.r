read.asap3.dat.fn <- function(datf)
{

  char.lines <- readLines(datf)
  com.ind <- which(substring(char.lines,1,1) == "#")
  #print(com.ind)
  dat.start <- com.ind[c(which(diff(com.ind)>1), length(com.ind))]
  comments <- char.lines[dat.start]
#  print(comments)
  #print(dat.start)
  #print(length(dat.start))
  dat <- list()
  ind <- 0
  dat$n_years <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$year1 <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$n_ages <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$n_fleets <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  #print(dat)
  #print(ind)
  dat$n_fleet_sel_blocks <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$n_indices <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  
  dat$M <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years*dat$n_ages), dat$n_years, dat$n_ages, byrow = TRUE)
  dat$fec_opt <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$fracyr_spawn <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$maturity <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years*dat$n_ages), dat$n_years, dat$n_ages, byrow = TRUE)
  dat$n_WAA_mats <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$WAA_mats <- lapply(1:dat$n_WAA_mats, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = dat$n_years*dat$n_ages), dat$n_years, dat$n_ages, byrow = TRUE))
  
  ind <- ind+dat$n_WAA_mats
  npt <- dat$n_fleets * 2 + 2 + 2
  dat$WAA_pointers <- sapply(1:npt, function(x) scan(datf, what = integer(), skip = dat.start[ind+1]+x-1, n = 1))
  ind <- ind + 1
  print(ind)

  dat$sel_block_assign <- lapply(1:dat$n_fleets, function(x) scan(datf, what = integer(), skip = dat.start[ind+x], n = dat$n_years))
  ind <- ind+dat$n_fleets
  dat$sel_block_option <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_fleet_sel_blocks)
  print(ind)
  print(dat.start[ind])
  dat$sel_ini <- lapply(1:dat$n_fleet_sel_blocks, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = 4*(dat$n_ages+6)), dat$n_ages+6, 4, byrow = TRUE))
  ind <- ind + dat$n_fleet_sel_blocks
  dat$fleet_sel_start_age <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$fleet_sel_end_age <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$Frep_ages <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 2)
  dat$Frep_type <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$use_like_const <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$release_mort <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  
  dat$CAA_mats <- lapply(1:dat$n_fleets, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = dat$n_years*(dat$n_ages+1)), dat$n_years, dat$n_ages+1, byrow = TRUE))
  ind <- ind + dat$n_fleets
  dat$DAA_mats <- lapply(1:dat$n_fleets, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = dat$n_years*(dat$n_ages+1)), dat$n_years, dat$n_ages+1, byrow = TRUE))
  ind <- ind + dat$n_fleets
  dat$prop_rel_mats <- lapply(1:dat$n_fleets, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = dat$n_years*(dat$n_ages)), dat$n_years, dat$n_ages, byrow = TRUE))
  ind <- ind + dat$n_fleets
  print(ind)
  
  dat$index_units <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_acomp_units <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_WAA_pointers <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_month <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_sel_choice <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_sel_option <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_sel_start_age <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_sel_end_age <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$use_index_acomp <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$use_index <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$index_sel_ini <- lapply(1:dat$n_indices, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = 4*(dat$n_ages+6)), dat$n_ages+6, 4, byrow = TRUE))
  ind <- ind + dat$n_indices
  print(dat$n_indices)
  #stop()
  print(dat$index_sel_ini)
  dat$IAA_mats <- lapply(1:dat$n_indices, function(x) matrix(scan(datf, what = double(), skip = dat.start[ind+x], n = dat$n_years*(dat$n_ages+4)), dat$n_years, dat$n_ages+4, byrow = TRUE))
  ind <- ind + dat$n_indices
  print(ind)
  
  dat$phase_F1 <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_F_devs <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_rec_devs <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_N1_devs <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_q <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_q_devs <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_SR_scalar <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$phase_steepness <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$recruit_cv <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years)

  dat$lambda_index <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$lambda_catch <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$lambda_discard <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  
  dat$catch_cv <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years*dat$n_fleets), dat$n_years, dat$n_fleets, byrow = TRUE)
  dat$discard_cv <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years*dat$n_fleets), dat$n_years, dat$n_fleets, byrow = TRUE)
  dat$catch_Neff <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years*dat$n_fleets), dat$n_years, dat$n_fleets, byrow = TRUE)
  dat$discard_Neff <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_years*dat$n_fleets), dat$n_years, dat$n_fleets, byrow = TRUE)
  print(ind)

  dat$lambda_F1 <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$cv_F1 <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$lambda_F_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$cv_F_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)

  dat$lambda_N1_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$cv_N1_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$lambda_rec_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  
  dat$lambda_q <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$cv_q <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)

  dat$lambda_q_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$cv_q_devs <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)

  dat$lambda_steepness <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$cv_steepness <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)

  dat$lambda_SR_scalar <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$cv_SR_scalar <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  print(ind)

  dat$N1_flag <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$N1_ini <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_ages)
  dat$F1_ini <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$q_ini <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = dat$n_indices)
  dat$SR_scalar_type <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$SR_scalar_ini <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$steepness_ini <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$Fmax <- scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$ignore_guesses <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  print(ind)

  dat$do_proj <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$dir_fleet <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = dat$n_fleets)
  dat$nfinalyear <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  n <- dat$nfinalyear-dat$year1-dat$n_years+1
  print(n)
  print(ind)
  print(dat.start[ind])
  if(n>0) dat$proj_ini <- matrix(scan(datf, what = double(), skip = dat.start[ind <- ind + 1], n = n*5), n, 5, byrow = TRUE)
  else dat$proj_ini <- matrix(nrow = 0, ncol = 5)
  dat$doMCMC <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$MCMC_nyear_opt <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$MCMC_nboot <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$MCMC_nthin <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$MCMC_nseed <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$fill_R_opt <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$R_avg_start <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$R_avg_end <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$make_R_file <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  dat$testval <- scan(datf, what = integer(), skip = dat.start[ind <- ind + 1], n = 1)
  print(dat$testval)
  print(ind)
  return(list(dat = dat, comments = comments))
}
#x <- read.asap3.dat.fn("../admb/BASE_NORETRO.DAT")

