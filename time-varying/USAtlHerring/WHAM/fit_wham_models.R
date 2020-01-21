# Fit WHAM models with time-varying selectivity
# Brian Stock
# Jan 2019

# source("/home/bstock/Documents/wg_MGWG/time-varying/USAtlHerring/WHAM/fit_wham_models.R")

# Phase 1: Fit each stock with 1) time-constant (no blocks) and 2) time-varying selectivity
#   NAA model: Full state-space
#   age comp: logistic normal (7)

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
model.id <- "USAtlHerring"
ices.id = "USAtHERRING_"
Fbar.ages = 7:8
user.od <- paste0("/home/bstock/Documents/wg_MGWG/time-varying/",model.id,"/")
user.wd <- user.od
github.dir = paste0(user.od,"WHAM/")
local.dir = file.path("/home/bstock/Documents/wham/sandbox/ices_selectivity",model.id)
if(!dir.exists(user.od)) dir.create(user.od)
if(!dir.exists(local.dir)) dir.create(local.dir)
setwd(github.dir)

# Some stocks have ASAP data files already - maybe the original assessment code?
#   Tim's code creates a new ASAP file every time
source("../../helper_code/convert_ICES_to_ASAP.r")
ICES2ASAP(user.wd, github.dir, model.id = model.id, ices.id=ices.id)
asap3 = read_asap3_dat(file.path(github.dir,paste0("ASAP_", model.id,".dat")))
# ICES2ASAP(user.wd, user.od, model.id = model.id, ices.id=ices.id)
# asap3 = read_asap3_dat(file.path(user.od,paste0("ASAP_", model.id,".dat")))
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
# sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
# fix_pars_age <- 2:8
# sel_inits_age[fix_pars_age] = 1
# sel_inits_logistic <- c(2,0.2)
# fix_pars_logistic <- NULL
# sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
# fix_pars_age <- 3:8
# sel_inits_age[fix_pars_age] = 1
# sel_inits_logistic <- c(1.5,0.2)
# fix_pars_logistic <- NULL
# sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
# fix_pars_age <- c(1,3:8)
# sel_inits_age[fix_pars_age] = 1
# sel_inits_age[1] = 0
# sel_inits_logistic <- list(c(2,0.2),c(1.5,0.2),c(1.5,0.2),c(2,0.2),c(2,0.2))
# fix_pars_logistic <- NULL
sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
fix_pars_age <- 2:8
sel_inits_age[fix_pars_age] = 1
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL
for(m in 1:n.mods){ # all models
# for(m in 4:n.mods){ # all models
# for(m in c(1,6)){ # only time-constant
# for(m in 6:n.mods){ # only age-specific
# for(m in 1:5){	# only logistic
	if(df$sel_mod[m] == "age-specific"){
		sel_inits <- sel_inits_age
		fix_pars <- fix_pars_age
	} else {
		sel_inits <- sel_inits_logistic
		# sel_inits <- sel_inits_logistic[[m]]
		fix_pars <- fix_pars_logistic
	}
	input <- prepare_wham_input(asap3, model_name = paste0(model.id," m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")"),
						selectivity=list(model=c(df$sel_mod[m],"age-specific","age-specific"), re=c(df$sel_re[m],"none","none"),
										initial_pars=list(sel_inits, c(0.5,0.5,1,1,1,1,1,1), c(0.5,0.5,1,1,1,1,1,1)),
										fix_pars=list(fix_pars, 3:8, 3:8)))
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
	mod <- fit_wham(input, do.retro=F, do.osa=F, do.proj=F)
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
# mod.list <- file.path(local.dir,paste0("m",c(1,2,4:n.mods),".rds"))
# mod.list <- grep(".rds", list.files(local.dir, full.names=TRUE), value=TRUE)
mods <- lapply(mod.list, readRDS)
# sapply(mods, function(x) x$opt$obj)
# compare_wham_models(mods, sort=FALSE)$tab
# sapply(mods, function(x) x$opt$convergence)
# selAA <- lapply(mods, function(x) x$report()$selAA[[1]])
# conv <- lapply(mods, function(x) capture.output(check_convergence(x)))

# Which models converged? 0 = convergence
tmp <- compare_wham_models(mods, sort=FALSE, calc.rho=FALSE)$tab
# tmp <- rbind(tmp[1:2,], matrix(NA,ncol=2,nrow=1), tmp[3:9,])
df <- cbind(df, tmp)
df$runtime_min <- round(df$runtime_min,2)
df$nll <- round(df$nll,3)
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
	# if(!is.na(df$conv[m])){
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
# lapply(mods[5:9], function(x) x$parList$sel_repars) # log(sigma), rho, rho_y
# mod$parList$logit_selpars
# mod$parList$sel_repars

# # look for pars with NA sdrep
# lapply(mods[6:10], function(x) unique(names(which(is.nan(summary(x$sdrep, select='fixed')[,"Std. Error"]))))) # log(sigma), rho, rho_y

# summary(mods[[7]]$sdrep, select='fixed')
# summary(mods[[9]]$sdrep, select='fixed')
# summary(mods[[10]]$sdrep, select='fixed')


# # ------------------------------------------
# # Make plot and df for initial run when m3 didn't find optimum
# library(wham)
# library(tidyverse)
# library(viridis)
# local.dir <- "/home/bstock/Documents/wham/sandbox/ices_selectivity/USAtlHerring/fishery2345678"
# model.id <- "USAtlHerring"
# df <- data.frame(sel_mod = c(rep("logistic",5),rep("age-specific",5)),
# 				sel_re = rep(c("none","iid","ar1","ar1_y","2dar1"), 2), stringsAsFactors = FALSE)
# df$NAA_mod = "all" # full state-space model ("rec" specifies only RE on recruitment)
# n.mods <- dim(df)[1]
# df$runtime_min <- rep(NA, n.mods)
# df$model <- paste0("m",1:n.mods)
# mod.list <- file.path(local.dir,paste0("m",c(1,2,4:n.mods),".rds"))
# mods <- lapply(mod.list, readRDS)

# tmp <- as.data.frame(compare_wham_models(mods, sort=FALSE, calc.rho=FALSE)$tab)
# tmp$conv <- sapply(mods, function(x) x$opt$convergence)
# tmp$nll <- sapply(mods, function(x) x$opt$obj)
# tmp <- rbind(tmp[1:2,], data.frame(dAIC=NA,AIC=NA,conv=NA,nll=NA), tmp[3:9,])
# df <- cbind(df, tmp)
# df$runtime_min <- round(df$runtime_min,2)
# df$nll <- round(df$nll,3)
# df <- df[,c("model","NAA_mod","sel_mod","sel_re","conv","runtime_min","nll","AIC","dAIC")]
# write.csv(df, file=file.path(local.dir,paste0("df_",model.id,".csv")),quote=F,row.names=F)

# selAA <- lapply(mods, function(x) x$report()$selAA[[1]])
# tmp <- selAA[3:9]
# selAA[4:10] <- tmp
# df.selAA <- data.frame(matrix(NA, nrow=0, ncol=10))
# colnames(df.selAA) <- c(paste0("Age_",1:8),"Year","Model")
# for(m in 1:n.mods){
# 	if(!is.na(df$conv[m])){
# 		tmp <- as.data.frame(selAA[[m]])
# 		tmp$Year <- 1965:2014
# 		colnames(tmp) <- c(paste0("Age_",1:8),"Year")
# 		# df$Model <- m
# 		tmp$Model <- paste0("m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")")
# 		df.selAA <- rbind(df.selAA, tmp)
# 	} else {

# 	}
# }
# df.plot <- df.selAA %>% pivot_longer(-c(Year,Model),
# 				names_to = "Age", 
# 				names_prefix = "Age_",
# 				names_ptypes = list(Age = integer()),
# 				values_to = "Selectivity")
# df.plot$Model <- factor(as.character(df.plot$Model), levels=paste0("m",1:n.mods,": NAA = ",df$NAA_mod,", sel = ",df$sel_mod," (",df$sel_re,")"))

# # df$sel_model <- factor(rep(c("Recruitment","Full state-space"), each=dim(df)[1]/2), levels=c("Recruitment","Full state-space"))
# # df$sel_re <- factor(c(rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods), rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods)), levels=c("None","IID","AR1","AR1_y","2D AR1"))
# png(file.path(local.dir,paste0("selAA_",model.id,".png")), width = 11, height = 9, res = 100, units='in')
# print(ggplot(df.plot, aes(x=Year, y=Age, fill=Selectivity)) + 
# 	geom_tile() +
# 	theme_bw() + 
# 	facet_wrap(~Model, ncol=2, dir="v", drop=F) +
# 	# facet_grid(rows=vars(sel_re), cols=vars(sel_model)) +
# 	scale_fill_viridis())
# dev.off()

