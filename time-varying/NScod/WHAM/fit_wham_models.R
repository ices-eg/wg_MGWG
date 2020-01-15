# Fit WHAM models with time-varying selectivity
# Brian Stock
# Dec 2019

# source("/home/bstock/Documents/wg_MGWG/time-varying/NScod/WHAM/fit_wham_models.R")

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
# only push summarized output to github: tab1.csv, tab2.csv, Mohn.txt
model.id <- "NScod"
Fbar.ages = 2:4
user.wd <- user.od <- paste0("/home/bstock/Documents/wg_MGWG/time-varying/",model.id,"/")
github.dir = paste0(user.wd,"WHAM")
local.dir = file.path("/home/bstock/Documents/wham/sandbox/ices_selectivity",model.id)
if(!dir.exists(user.wd)) dir.create(user.wd)
if(!dir.exists(local.dir)) dir.create(local.dir)
setwd(github.dir)

source("../../helper_code/wham_tab1.r")
source("../../helper_code/wham_tab2.r")
source("../../helper_code/wham_predict_index.r")
# source("../../helper_code/wham_write_readme.r")
# source("../../helper_code/wham_make_model_input.r")

# All 13 stocks have ASAP data files created already from state-space project
#   was an issue with the ASAP file in state-space project... extra comment line caused error reading it in
#   Tim's code creates a new ASAP file every time
source("../../helper_code/convert_ICES_to_ASAP.r")
# ICES2ASAP(user.wd, user.od, model.id = model.id, ices.id="")
# asap3 = read_asap3_dat(paste0("../", model.id,"_ASAP.dat"))
# file.remove(paste0("ASAP_", model.id,".dat"))
ICES2ASAP(user.wd, user.od, model.id = model.id, ices.id="")
asap3 = read_asap3_dat(file.path(user.wd,paste0("ASAP_", model.id,".dat")))
file.remove(file.path(user.wd,paste0("ASAP_", model.id,".dat")))

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
# initial fits - don't fix any fishery selectivity pars
sel_inits_age <- c(0.5,0.5,0.5,0.5,0.5,0.5)
fix_pars_age <- NULL
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL
for(m in 1:n.mods){
	if(df$sel_mod[m] == "age-specific"){
		sel_inits <- sel_inits_age
		fix_pars <- fix_pars_age
	} else {
		sel_inits <- sel_inits_logistic
		fix_pars <- fix_pars_logistic
	}
	input <- prepare_wham_input(asap3, model_name = paste0(model.id," m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")"),
						selectivity=list(model=c(df$sel_mod[m],"age-specific","age-specific"), re=c(df$sel_re[m],"none","none"),
										initial_pars=list(sel_inits, c(0.5,0.5,0.5,0.5,1,0.5), c(0.5,0.5,1,1,0.5,0.5)),
										fix_pars=list(fix_pars, 5, 3:4)))
	input$data$Fbar_ages = Fbar.ages

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
df <- df[,c("model","NAA_mod","sel_mod","sel_re","conv","runtime_min","nll","AIC","dAIC")]
write.csv(df, file=file.path(local.dir,paste0("df_",model.id,".csv")),quote=F,row.names=F)
# df <- read.csv(file.path(local.dir,paste0("df_",model.id,".csv")))

# selectivity-at-age plot (block 1 = fleet)
# selAA <- lapply(mods, function(x) x$report()$selAA[[1]])
df.selAA <- data.frame(matrix(NA, nrow=0, ncol=input$data$n_ages+2))
colnames(df.selAA) <- c(paste0("Age_",1:input$data$n_ages),"Year","Model")
for(m in 1:n.mods){
	tmp <- as.data.frame(selAA[[m]])
	tmp$Year <- input$years
	colnames(tmp) <- c(paste0("Age_",1:input$data$n_ages),"Year")
	# df$Model <- m
	tmp$Model <- paste0("m",m,": NAA = ",df$NAA_mod[m],", sel = ",df$sel_mod[m]," (",df$sel_re[m],")")
	df.selAA <- rbind(df.selAA, tmp)
}
df.plot <- df.selAA %>% pivot_longer(-c(Year,Model),
				names_to = "Age", 
				names_prefix = "Age_",
				names_ptypes = list(Age = integer()),
				values_to = "Selectivity")
df.plot$Model <- factor(as.character(df.plot$Model), levels=paste0("m",1:n.mods,": NAA = ",df$NAA_mod,", sel = ",df$sel_mod," (",df$sel_re,")"))

# df$sel_model <- factor(rep(c("Recruitment","Full state-space"), each=dim(df)[1]/2), levels=c("Recruitment","Full state-space"))
# df$sel_re <- factor(c(rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods), rep(c("None","IID","AR1","AR1_y","2D AR1"), each=dim(df)[1]/n.mods)), levels=c("None","IID","AR1","AR1_y","2D AR1"))
png(file.path(local.dir,paste0("selAA_",model.id,".png")), width = 11, height = 9, res = 100, units='in')
print(ggplot(df.plot, aes(x=Year, y=Age, fill=Selectivity)) + 
	geom_tile() +
	theme_bw() + 
	facet_wrap(~Model, ncol=2, dir="v") +
	# facet_grid(rows=vars(sel_re), cols=vars(sel_model)) +
	scale_fill_viridis())
dev.off()

# -------------------------------------------------------------------------------
# # look for selpars close to 0 or 1 (logit_selpars > 4 or < -4)
# lapply(mods[8:12], function(x) x$parList$logit_selpars)
# lapply(mods[8:12], function(x) x$parList$sel_repars) # log(sigma), rho, rho_y

# # look for selpars with NA sdrep
# lapply(mods[8:12], function(x) x$parList$logit_selpars)

# res <- compare_wham_models(list(m1=m1, m2=m2, m3=m3, m4=m4), fname="model_compare", sort = FALSE)

# #3-year projection for best model
# wham_predict_index()

# #Describe what we did for model 4
# best = "m4"
# wham_write_readme()
