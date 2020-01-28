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

# ----------------------------------------------------
# Summary plots
#   AIC rank by model
#   % converged by model
#   boxplot dAIC by model

# get data frame of results
library(tidyverse)
res <- lapply(list.files(df.dir,full.names=TRUE), function(x) read.csv(x))
species.labs <- gsub(".*/time-varying/","",species.dirs)
names(res) <- species.labs
df.res <- bind_rows(res, .id="Stock")
df.res$model <- factor(as.character(df.res$model), levels=paste0("m",1:10))
df.res$sel_mod <- factor(as.character(df.res$sel_mod), levels=c("logistic", "age-specific"))
levels(df.res$sel_mod) = c("Logistic", "Age-specific")

png(file.path(wham.dir,"dAIC_boxplot.png"), units='in', height=5, width=7, res=300)
ggplot(df.res, aes(x=model,y=dAIC)) +
	geom_boxplot(fill='grey') +
	facet_wrap(~sel_mod, nrow=1, scales="free_x") +
	xlab("Model") +
	theme_bw()
dev.off()

png(file.path(wham.dir,"percent_converged.png"), units='in', height=5, width=7, res=300)
ggplot(df.res %>% group_by(model) %>% summarize(p.conv=sum(1-conv)/n(), sel_mod=sel_mod[1]), aes(x=model,y=p.conv)) +
	geom_point(size=3) +
	facet_wrap(~sel_mod, nrow=1, scales="free_x") +
	xlab("Model") +
	ylab("Proportion of stocks converged (of 13)") +
	ylim(c(0,1)) +
	theme_bw()
dev.off()

aic.rank <- df.res %>% group_by(Stock) %>% mutate(Rank = rank(dAIC, na.last="keep",ties.method = "average"))
png(file.path(wham.dir,"AIC_rank.png"), units='in', height=7, width=7, res=300)
ggplot(aic.rank , aes(x=model,y=Stock,fill=Rank)) +
	geom_tile() +
	scale_fill_gradient2(midpoint=5.5, na.value = "grey80") +
	# facet_wrap(~sel_mod, nrow=1, scales="free_x") +
	xlab("Model") +
	ylab("Stock") +
	theme_bw()
dev.off()

