# Collect plots and AIC/convergence tables into one folder for easy comparison
# Brian Stock
# Jan 2019

# source("/home/bstock/Documents/wg_MGWG/time-varying/0_prelim_plots/WHAM/collect_results.R")

github.dir <- "/home/bstock/Documents/wg_MGWG/time-varying"
wham.dir <- file.path(github.dir,"0_prelim_plots","WHAM")
selAA.all.dir <- file.path(wham.dir,"selAA_all")
selAA.conv.dir <- file.path(wham.dir,"selAA_conv")
df.dir <- file.path(wham.dir,"df_AIC")

species.dirs <- list.dirs(path=github.dir, recursive=FALSE)
torm <- grep("helper_code",species.dirs)
torm <- c(torm, grep("0_prelim_plots",species.dirs))
species.dirs <- species.dirs[-torm]
if(length(species.dirs) != 13) warning("Only 13 species but more than 13 folders selected...")
from.dirs <- file.path(species.dirs,"WHAM")

file.copy(from=grep("df_",list.files(from.dirs,full.names=T),value=T), to=df.dir)
file.copy(from=grep("_all",list.files(from.dirs,full.names=T),value=T), to=selAA.all.dir)
file.copy(from=grep("_conv",list.files(from.dirs,full.names=T),value=T), to=selAA.conv.dir)
