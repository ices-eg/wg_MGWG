# Fit WHAM models with time-varying selectivity
# Brian Stock
# Dec 2019

# source("/home/bstock/Documents/wg_MGWG/time-varying/ICEherring/WHAM/fit_wham_models.R")

# Phase 1: Fit each stock with 1) time-constant (no blocks) and 2) time-varying selectivity
#   NAA model: Full state-space

#   Time-varying selectivity models
#     1: logistic, time-invariant
#     2: logistic, IID (RE on sel pars, no correlation)
#     3: logistic, AR1_a (correlation across ages/parameters)
#     4: logistic, AR1_y (correlation across years)
#     5: logistic, 2D AR1 (correlation across ages/pars and years)
#     6: age-specific, time-invariant
#     7: age-specific, IID (RE on sel pars, no correlation)
#     8: age-specific, AR1_a (correlation across ages/parameters)
#     9: age-specific, AR1_y (correlation across years)
#     10: age-specific, 2D AR1 (correlation across ages/pars and years)

# devtools::install_github("timjmiller/wham", dependencies=TRUE)
library(wham)
library(tidyverse)
library(viridis)

# save model runs locally
model.id <- "ICEherring"
Fbar.ages = 5:10 - 2 # first age is 3 in the model
user.od <- paste0("/home/bstock/Documents/wg_MGWG/time-varying/",model.id,"/")
user.wd <- paste0(user.od,"ices_data/") # converted to ICES format by 'convert.R' in main folder
github.dir = paste0(user.od,"WHAM/")
local.dir = file.path("/home/bstock/Documents/wham/sandbox/ices_selectivity",model.id)
if(!dir.exists(user.od)) dir.create(user.od)
if(!dir.exists(local.dir)) dir.create(local.dir)
setwd(github.dir)

# Some stocks have ASAP data files already - maybe the original assessment code?
#   Tim's code creates a new ASAP file every time
source("../../helper_code/convert_ICES_to_ASAP.r")
ICES2ASAP(user.wd, github.dir, model.id = model.id, ices.id="")
asap3 = read_asap3_dat(file.path(github.dir,paste0("ASAP_", model.id,".dat")))
# file.remove(file.path(user.od,paste0("ASAP_", model.id,".dat")))

# define models
df <- data.frame(sel_mod = c(rep("logistic",5),rep("age-specific",5)),
				sel_re = rep(c("none","iid","ar1","ar1_y","2dar1"), 2), stringsAsFactors = FALSE)
df$NAA_mod = "all" # full state-space model ("rec" specifies only RE on recruitment)
n.mods <- dim(df)[1]
df$conv <- df$nll <- df$runtime_min <- rep(NA, n.mods)
df$model <- paste0("m",1:n.mods)
conv <- vector("list",n.mods)
selAA <- vector("list",n.mods)

# --------------------------------------------------------------------------
sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
fix_pars_age <- NULL
# sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
# sel_inits_age[11] = 1
# fix_pars_age <- 11
# sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
# sel_inits_age[10:11] = 1
# fix_pars_age <- 10:11
# sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
# fix_pars_age <- c(1,10:11)
# sel_inits_age[fix_pars_age] = 1
# sel_inits_age[1] = 0
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL
# for(m in 1:n.mods){ # all models
# for(m in c(1,6)){ # only time-constant

# # start age-specific models at F_devs estimated in logistic 2D AR1
# mod <- readRDS("/home/bstock/Documents/wham/sandbox/ices_selectivity/ICEherring/fishery11_survey5678_inits/m5.rds")
# F_devs_init <- mod$parList$F_devs

for(m in 1:n.mods){ # all
# for(m in 6:n.mods){ # only age-specific
# for(m in 1:5){	# only logistic
	if(df$sel_mod[m] == "age-specific"){
		sel_inits <- sel_inits_age
		fix_pars <- fix_pars_age
	} else {
		sel_inits <- sel_inits_logistic
		fix_pars <- fix_pars_logistic
	}
	input <- prepare_wham_input(asap3, model_name = paste0(model.id," m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")"),
						selectivity=list(model=c(df$sel_mod[m],"age-specific"), re=c(df$sel_re[m],"none"),
										initial_pars=list(sel_inits, c(0.5,0.5,0.5,0.5,1,1,1,1,0.5,0.5,0.5)),
										fix_pars=list(fix_pars, 5:8)))
	input$data$Fbar_ages = Fbar.ages

	# initialize selectivity parameters for time-varying models at estimated values from time-constant models
	if(m %in% c(2:5,7:10)) input$par$logit_selpars = inits_logit_selpars	

	# logistic normal age comp
	input$data$age_comp_model_indices = rep(7, input$data$n_indices)
	input$data$age_comp_model_fleets = rep(7, input$data$n_fleets)
	input$data$n_age_comp_pars_indices = rep(1, input$data$n_indices)
	input$data$n_age_comp_pars_fleets = rep(1, input$data$n_fleets)
	input$par$index_paa_pars = rep(0, input$data$n_indices)
	input$par$catch_paa_pars = rep(0, input$data$n_fleets)
	input$map = input$map[!(names(input$map) %in% c("index_paa_pars", "catch_paa_pars"))]

	# NAA option
	if(df$NAA_mod[m] == "rec"){ # recruitment random effects
		input$data$random_recruitment = 1
		input$map = input$map[!(names(input$map) %in% c("log_R_sigma", "mean_rec_pars"))]
		input$random = c(input$random, "log_R")
	} else { # full state-space
		input$data$use_NAA_re = 1
		input$map = input$map[!(names(input$map) %in% c("log_NAA", "log_NAA_sigma", "mean_rec_pars"))]
		input$map$log_R = factor(rep(NA, length(input$par$log_R)))
		input$random = c(input$random, "log_NAA")
	}

	btime <- Sys.time()
	# input$par$F_devs <- F_devs_init
	if(m %in% 7:10){
		base = input
		# input$map$F_devs = factor(rep(NA, length(input$par$F_devs)))
		# input$map$catch_paa_pars = factor(rep(NA, length(input$par$catch_paa_pars)))
		input$map$sel_repars = factor(rep(NA, length(input$par$sel_repars)))
		mod <- fit_wham(input, do.retro=F, do.osa=F, do.proj=F)
		input = base
		input$par = mod$parList
		# input$par$sel_repars[1,1] = 0
	}
	mod1 <- fit_wham(input, do.retro=F, do.osa=F, do.proj=F)
	etime <- Sys.time()
	saveRDS(mod, file=file.path(local.dir,paste0("m",m,".rds")))
	if(exists("err")) rm("err") # need to clean this up

	# save selectivity parameter estimates from time-constant models, use as initial values for time-varying models
	if(m %in% c(1,6)) inits_logit_selpars <- mod$parList$logit_selpars

	df$runtime_min[m] = round(as.numeric(difftime(etime, btime), units="mins"),2)
	df$nll[m] = mod$opt$obj
	df$conv[m] = mod$opt$convergence
	selAA[[m]] <- mod$report()$selAA[[1]]
	conv[[m]] <- capture.output(check_convergence(mod))
	rm("mod")
}
mod.list <- file.path(local.dir,paste0("m",1:n.mods,".rds"))
mods <- lapply(mod.list, readRDS)
# sapply(mods, function(x) x$opt$obj)
# compare_wham_models(mods, sort=FALSE)$tab
# sapply(mods, function(x) x$opt$convergence)
# selAA <- lapply(mods, function(x) x$report()$selAA[[1]])
# conv <- lapply(mods, function(x) capture.output(check_convergence(x)))

# Which models converged? 0 = convergence
df <- cbind(df, compare_wham_models(mods, sort=FALSE, calc.rho=FALSE)$tab)
df$runtime_min <- round(df$runtime_min,2)
df$nll <- round(df$nll,3)
min.AIC <- min(df$AIC[df$conv==0])
df$dAIC <- round(df$AIC - min.AIC, 1)
df$dAIC[df$conv==1] = NA
df <- df[,c("model","NAA_mod","sel_mod","sel_re","conv","runtime_min","nll","AIC","dAIC")]
# df$conv <- sapply(mods, function(x) x$opt$convergence)
# df$nll <- sapply(mods, function(x) x$opt$obj)
write.csv(df, file=file.path(local.dir,paste0("df_",model.id,".csv")),quote=F,row.names=F)
# df <- read.csv(file.path(local.dir,paste0("df_",model.id,".csv")))

# selectivity-at-age plot (block 1 = fleet)
# selAA <- lapply(mods, function(x) x$report()$selAA[[1]])
df.selAA <- data.frame(matrix(NA, nrow=0, ncol=input$data$n_ages+2))
colnames(df.selAA) <- c(paste0("Age_",1:input$data$n_ages),"Year","Model")
for(m in 1:n.mods){
	if(df$conv[m] == 0){	# only plot converged models	
		tmp <- as.data.frame(selAA[[m]])
		tmp$Year <- input$years
		colnames(tmp) <- c(paste0("Age_",1:input$data$n_ages),"Year")
		# df$Model <- m
		tmp$Model <- paste0("m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")")
		tmp$sel_re <- df$sel_re[m]
		tmp$sel_mod <- df$sel_mod[m]
		df.selAA <- rbind(df.selAA, tmp)
	} else {

	}
}
# df.plot <- df.selAA %>% pivot_longer(-c(Year,Model),
df.plot <- df.selAA %>% pivot_longer(-c(Year,Model,sel_re,sel_mod),
				names_to = "Age", 
				names_prefix = "Age_",
				names_ptypes = list(Age = integer()),
				values_to = "Selectivity")
df.plot$Model <- factor(as.character(df.plot$Model), levels=paste0("m",1:n.mods,": NAA = ",df$NAA_mod,", sel = ",df$sel_mod," (",df$sel_re,")"))
df.plot$sel_mod <- factor(as.character(df.plot$sel_mod), levels=c("logistic","age-specific"))
df.plot$sel_re <- factor(as.character(df.plot$sel_re), levels=c("none","iid","ar1","ar1_y","2dar1"))

# df$sel_model <- factor(rep(c("Recruitment","Full state-space"), each=dim(df)[1]/2), levels=c("Recruitment","Full state-space"))
# df$sel_re <- factor(c(rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods), rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods)), levels=c("None","IID","AR1","AR1_y","2D AR1"))
png(file.path(local.dir,paste0("selAA_",model.id,".png")), width = 11, height = 9, res = 100, units='in')
print(ggplot(df.plot, aes(x=Year, y=Age, fill=Selectivity)) + 
	geom_tile() +
	theme_bw() + 
	# facet_wrap(~Model, ncol=2, dir="v") +
	facet_grid(rows=vars(sel_re), cols=vars(sel_mod), drop=F) +
	scale_fill_viridis())
dev.off()

# -------------------------------------------------------------------------------
# # look for selpars close to 0 or 1 (logit_selpars > 4 or < -4)
# lapply(mods[1:5], function(x) x$parList$logit_selpars)
# lapply(mods[1:5], function(x) x$parList$sel_repars) # log(sigma), rho, rho_y
# lapply(mods[6:10], function(x) x$parList$logit_selpars)
# lapply(mods[6:10], function(x) x$parList$sel_repars) # log(sigma), rho, rho_y
# mod$parList$logit_selpars
# mod$parList$sel_repars
# lapply(mods[6:10], function(x) capture.output(check_convergence(x)))

# # look for pars with NA sdrep
# lapply(mods[6:10], function(x) unique(names(which(is.nan(summary(x$sdrep, select='fixed')[,"Std. Error"]))))) # log(sigma), rho, rho_y

# summary(mods[[7]]$sdrep, select='fixed')
# summary(mods[[9]]$sdrep, select='fixed')
# summary(mods[[10]]$sdrep, select='fixed')

# state-space project used logistic selectivity for fleet

# -----------------------------------------------------------
# # plot selAA for all models, incl unconverged 
local.dir = "/home/bstock/Documents/wham/sandbox/ices_selectivity/ICEherring/survey5678_inits"
mod.list <- file.path(local.dir,paste0("m",1:10,".rds"))
mods <- lapply(mod.list, readRDS)
selAA <- lapply(mods, function(x) x$report()$selAA[[1]])
n.mods <- length(mod.list)

df.selAA <- data.frame(matrix(NA, nrow=0, ncol=input$data$n_ages+2))
colnames(df.selAA) <- c(paste0("Age_",1:input$data$n_ages),"Year","Model")
for(m in 1:n.mods){
	# if(df$conv[m] == 0){	# only plot converged models	
		tmp <- as.data.frame(selAA[[m]])
		tmp$Year <- input$years
		colnames(tmp) <- c(paste0("Age_",1:input$data$n_ages),"Year")
		# df$Model <- m
		tmp$Model <- paste0("m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")")
		tmp$sel_re <- df$sel_re[m]
		tmp$sel_mod <- df$sel_mod[m]
		df.selAA <- rbind(df.selAA, tmp)
	# } else {

	# }
}
# df.plot <- df.selAA %>% pivot_longer(-c(Year,Model),
df.plot <- df.selAA %>% pivot_longer(-c(Year,Model,sel_re,sel_mod),
				names_to = "Age", 
				names_prefix = "Age_",
				names_ptypes = list(Age = integer()),
				values_to = "Selectivity")
df.plot$Model <- factor(as.character(df.plot$Model), levels=paste0("m",1:n.mods,": NAA = ",df$NAA_mod,", sel = ",df$sel_mod," (",df$sel_re,")"))
df.plot$sel_mod <- factor(as.character(df.plot$sel_mod), levels=c("logistic","age-specific"))
df.plot$sel_re <- factor(as.character(df.plot$sel_re), levels=c("none","iid","ar1","ar1_y","2dar1"))
df.plot$conv <- df.plot$Model
df.plot$conv <- plyr::mapvalues(df.plot$conv, from=levels(df.plot$Model), to=df$conv)

# df$sel_model <- factor(rep(c("Recruitment","Full state-space"), each=dim(df)[1]/2), levels=c("Recruitment","Full state-space"))
# df$sel_re <- factor(c(rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods), rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods)), levels=c("None","IID","AR1","AR1_y","2D AR1"))
png(file.path(local.dir,paste0("selAA_",model.id,"_all.png")), width = 11, height = 9, res = 100, units='in')
print(ggplot(df.plot, aes(x=Year, y=Age, fill=Selectivity)) + 
	geom_tile() +
	theme_bw() + 
	# facet_wrap(~Model, ncol=2, dir="v") +
	facet_grid(rows=vars(sel_re), cols=vars(sel_mod), drop=F) +
	scale_fill_viridis())
dev.off()

png(file.path(local.dir,paste0("selAA_",model.id,"_conv.png")), width = 11, height = 9, res = 100, units='in')
print(ggplot(filter(df.plot, conv==0), aes(x=Year, y=Age, fill=Selectivity)) + 
	geom_tile() +
	theme_bw() + 
	# facet_wrap(~Model, ncol=2, dir="v") +
	facet_grid(rows=vars(sel_re), cols=vars(sel_mod), drop=F) +
	scale_fill_viridis())
dev.off()

# run 1: no selpars fixed
# [[1]]
# [1] "log_F1"        "logit_selpars"

# [[2]]
# [1] "F_devs"         "log_N1_pars"    "log_NAA_sigma"  "logit_selpars" 
# [5] "catch_paa_pars"

# [[3]]
# character(0)
# This model estimates logit_selpars for last age = 21

# [[4]]
# [1] "logit_selpars"

# [[5]]
# [1] "F_devs"         "logit_selpars"  "catch_paa_pars"

# ----------------------------------------------------------------------
# run 2: fix sel at last age = 1
# [[1]]
# character(0)

# [[2]]
# [1] "F_devs"        "log_NAA_sigma" "logit_selpars"

# [[3]]
# character(0)

# [[4]]
# [1] "mean_rec_pars" "logit_selpars"

# [[5]]
# [1] "F_devs"         "catch_paa_pars"
# --------------------------------------------------------------------
# [[1]]
#           [,1]     [,2]      [,3]      [,4]      [,5]      [,6]       [,7]
# [1,] -2.859501 -1.74744 -1.468494 -1.359262 -1.140057 -1.046054 -0.9173851
# [2,]  1.209829  1.50550  1.478172  1.688589       Inf       Inf        Inf
#            [,8]       [,9]      [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] -0.8678995 -0.6113623 -0.4321655   Inf    NA    NA    NA    NA    NA    NA
# [2,]        Inf       -Inf       -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[2]]
#            [,1]       [,2]      [,3]      [,4]     [,5]     [,6]     [,7]
# [1,] -1.2654513  0.4495388 1.4233470 2.1077837 4.043686 3.387479 2.186667
# [2,]  0.5128675 -0.3043943 0.5921039 0.6539056      Inf      Inf      Inf
#          [,8]    [,9]    [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 14.04106 4.95146 3.941761   Inf    NA    NA    NA    NA    NA    NA
# [2,]      Inf    -Inf     -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[3]]
#           [,1]        [,2]      [,3]      [,4]     [,5]     [,6]     [,7]
# [1,] -1.608007 -0.05993244 0.4747039 0.6605569 1.111432 1.361091 1.674208
# [2,]  1.737582  2.07083814 1.7828686 2.0642422      Inf      Inf      Inf
#          [,8]     [,9]    [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 1.757697 1.840153 2.561777   Inf    NA    NA    NA    NA    NA    NA
# [2,]      Inf     -Inf     -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[4]]
#           [,1]      [,2]       [,3]      [,4]     [,5]     [,6]       [,7]
# [1,] -2.965853 0.3282323   1.195543  6.243682 6.672591 5.671312 -0.7272359
# [2,]  1.753826 6.6102991 -10.572029 41.410832      Inf      Inf        Inf
#         [,8]     [,9]     [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 2.75757 5.984257 -3.898275   Inf    NA    NA    NA    NA    NA    NA
# [2,]     Inf     -Inf      -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[5]]
#           [,1]       [,2]       [,3]       [,4]      [,5]     [,6]      [,7]
# [1,] -1.969670 -0.5641117 -0.1566179 -0.0456818 0.3104485 0.421114 0.6436744
# [2,]  1.695321  2.0187805  1.7322434  2.0042494       Inf      Inf       Inf
#           [,8]      [,9]    [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 0.6204831 0.9566286 1.168717   Inf    NA    NA    NA    NA    NA    NA
# [2,]       Inf      -Inf     -Inf  -Inf    NA    NA    NA    NA    NA    NA

# ----------------------------------------------------------------------
# run 3: fix sel at last 2 ages = 1

# [[1]]
# character(0)

# [[2]]
# [1] "F_devs"        "logit_selpars"

# [[3]]
# character(0)

# [[4]]
# [1] "mean_rec_pars" "logit_q"       "F_devs"        "log_NAA_sigma"
# [5] "logit_selpars" "sel_repars"   

# [[5]]
# character(0)


# [[1]]
#           [,1]       [,2]       [,3]       [,4]      [,5]      [,6]      [,7]
# [1,] -1.839054 -0.5008201 -0.1016361 0.08088094 0.4798743 0.6586409 0.9574516
# [2,]  1.250951  1.5418902  1.5297803 1.74370685       Inf       Inf       Inf
#          [,8]     [,9] [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 1.067716 1.930591   Inf   Inf    NA    NA    NA    NA    NA    NA
# [2,]      Inf     -Inf  -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[2]]
#           [,1]      [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]
# [1,] -1.233794 0.5658996 1.598765 2.156333 4.712793 2.469907 2.782632 3.266141
# [2,]  1.929432 2.8909178 3.291060 4.479096      Inf      Inf      Inf      Inf
#          [,9] [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 2.653559   Inf   Inf    NA    NA    NA    NA    NA    NA
# [2,]     -Inf  -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[3]]
#           [,1]       [,2]      [,3]     [,4]     [,5]     [,6]     [,7]
# [1,] -1.508770 0.07987641 0.6941664 1.018330 1.437283 1.718823 2.089409
# [2,]  1.504392 1.85018783 1.6911185 1.987773      Inf      Inf      Inf
#          [,8]     [,9] [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 2.135347 2.476167   Inf   Inf    NA    NA    NA    NA    NA    NA
# [2,]      Inf     -Inf  -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[4]]
#           [,1]       [,2]      [,3]     [,4]     [,5]     [,6]     [,7]    [,8]
# [1,] -1.527232 0.03593005 0.7450232 1.299796 2.008969 2.149538 2.637074 2.89921
# [2,]  0.781231 1.46283756 1.3360298 1.766139      Inf      Inf      Inf     Inf
#          [,9] [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 3.352586   Inf   Inf    NA    NA    NA    NA    NA    NA
# [2,]     -Inf  -Inf  -Inf    NA    NA    NA    NA    NA    NA

# [[5]]
#           [,1]      [,2]      [,3]     [,4]     [,5]     [,6]     [,7]     [,8]
# [1,] -1.507896 0.1186824 0.7548756 1.082802 1.527404 1.823169 2.179104 2.182427
# [2,]  1.519652 1.8987223 1.7481285 2.041301      Inf      Inf      Inf      Inf
#          [,9] [,10] [,11] [,12] [,13] [,14] [,15] [,16] [,17]
# [1,] 2.500735   Inf   Inf    NA    NA    NA    NA    NA    NA
# [2,]     -Inf  -Inf  -Inf    NA    NA    NA    NA    NA    NA



