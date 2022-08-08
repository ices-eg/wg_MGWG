#### Results analysis stock-recruitment simulations
## Just WHAM and SAM for now


path <- "stock-recruitment"


# Processing the true models ---------------------

## True SRR params in OMs ---------------------
true_SRR_param <- read.csv(paste0(path, "/evaluate_fit/runs_liz.csv"), header=TRUE) # scenario parameterization

## True outputs in OMs ---------------------
load(paste0(path, "/comparing_recruitment/simulated_stocks/out/true.RData"))
true_out <- true # OM trajectories for F, SSB and Rec
rm(params, true); gc()

## Extra variables ---------------------
n_it <- 300 # not 500 as true
true_models <- unique(true_SRR_param$model) # true SRR model
case_num_models <- sapply(true_models, function(x) true_SRR_param$case[which(true_SRR_param$model==x)]) # case number per model
scenario <- true_SRR_param[,c("case", "devs", "traj", "model")]



# Processing the different results ---------------------

## WHAM ---------------------
wham_files <- list.files(paste0(path, "/Results_sim_all/Tims"))[grep(".RData", list.files(paste0(path, "/Results_sim_all/Tims")))]
for (k in 1:length(wham_files)) load(paste0(path, "/Results_sim_all/Tims/", wham_files[k]))
fitted_models_wham <- gsub("_res.RData", "", wham_files)

## SAM ---------------------
sam_files <- list.files(paste0(path, "/Results_sim_all/Jons"))[grep(".RData", list.files(paste0(path, "/Results_sim_all/Jons")))]
sam_param <- c()
sam_traj <- c()
for (k in 1:length(sam_files)){
  load(paste0(path, "/Results_sim_all/Jons/", sam_files[k]))
  if (k==2){ # some ricker results are actually bh results! Remove those 10 lines for now. Will need to be re-run!?
    sr <- sr[-which(sr[,"sr.code"]!=k),] 
    srest <- srest[-which(srest[,"sr.code"]!=k),]
  }
  sam_param <- rbind(sam_param, sr) ## Some runs don't have 300 iterations! Will need to be re-run!?
  sam_traj <- rbind(sam_traj, srest)
  rm(sr, srest, vcv); gc()
}
sam_param <- as.data.frame(sam_param)
sam_traj <- as.data.frame(sam_traj)
sam_param$sr.code <- sapply(sam_param$sr.code, function (x) switch(x,"1" = "bh", "2" = "ricker", "3" = "RW"))
sam_traj$sr.code <- sapply(sam_traj$sr.code, function (x) switch(x,"1" = "bh", "2" = "ricker", "3" = "RW"))
# VT: I assume conv=NA means no convergence so I turn the lines to NA to be sure the results are not used for model selection or parameter estimation
sam_param[which(is.na(sam_param$conv)), 3: ncol(sam_param)] <- NA
fitted_models_sam <- c("bh", "rw", "ricker")


# Model selection via AIC per assessment models ---------------------

## WHAM ---------------------
wham_best_aic <- sapply(1:ncol(bh$aic),function(x) apply(cbind(bh$aic[,x], meanrec$aic[,x],ricker$aic[,x]),1, function(y) fitted_models_wham[which(y == min(y, na.rm = TRUE))]))

res_aic_wham <- cbind(scenario, bh=apply(wham_best_aic,2,function(x) sum(x=="bh")/n_it),
                      meanrec=apply(wham_best_aic,2,function(x) sum(x=="meanrec")/n_it),
                      ricker=apply(wham_best_aic,2,function(x) sum(x=="ricker")/n_it))


col3 <- RColorBrewer::brewer.pal(3, name = "PiYG")

pdf(paste0(path, "/evaluate_fit/WHAM_AIC.pdf"))
par(mfrow=c(length(unique(true_SRR_param$devs)), length(unique(true_SRR_param$traj))), oma=c(4,4,2,8), mar=c(1,0,0,0))
for (i in 1:length(unique(true_SRR_param$traj))){
  for (j in 1:length(unique(true_SRR_param$devs))){
    tmp <- t(as.matrix(subset(res_aic_wham, traj==unique(true_SRR_param$traj)[i] & devs==unique(true_SRR_param$devs)[j])[,4:ncol(res_aic_wham)]))
    colnames(tmp) <- tmp["model",]
    if (j==1) yaxis="s" else yaxis="n"
    if (i==3) xlab="s" else xlab="n"
    barplot(tmp[-1,], col = col3, yaxt=yaxis, xaxt=xlab)
    # if (i==3 & j==1) {
    #   par(xpd=NA)
    #   legend(x=0, y=-0.2, legend=fitted_models, fill=col, horiz = TRUE, bty="n")
    #   }
  }
}
mtext(unique(true_SRR_param$traj), 4, line = 0.5, at=c(5/6, 3/6, 1/6), outer=TRUE)
mtext(unique(true_SRR_param$devs), 3, line = 0.5, at=c(1/6, 3/6, 5/6), outer=TRUE)
mtext("Operating models", side=1, line=2, outer=TRUE)
mtext("Proportions", side=2, line=2.5, outer=TRUE)
par(xpd=NA)
legend(x=5.2, y=3.2, legend=rev(fitted_models_wham), fill=rev(col3), bty="n", cex=1.2, title="Estimation models", title.cex=1)
dev.off()


## SAM ---------------------
sam_best_aic <- array(dim=dim(wham_best_aic))

for (i in 1:ncol(sam_best_aic)){ # not ideal to have the loop but difficult when some iterations and runs are missing
  for (j in 1:nrow(sam_best_aic)){
    tmp <- subset(sam_param, run==paste0("r", i) & iter==paste0("iter", j))
    if(nrow(tmp)>0 & sum(is.na(tmp$AIC))!=length(tmp$AIC)) sam_best_aic[j,i] <- tmp$sr.code[which(tmp$AIC==min(as.numeric(tmp$AIC), na.rm=TRUE))] else sam_best_aic[j,i] <- NA
  }
} # NA when none of them have converged or missing result


res_aic_sam <- cbind(scenario, bh=apply(sam_best_aic,2,function(x) sum(x=="bh", na.rm=TRUE)/n_it),
                     RW=apply(sam_best_aic,2,function(x) sum(x=="RW", na.rm=TRUE)/n_it),
                     ricker=apply(sam_best_aic,2,function(x) sum(x=="ricker", na.rm=TRUE)/n_it),
                     nonConv=apply(sam_best_aic,2,function(x) sum(is.na(x))/n_it)) # right now missing results show as unconverged


col4 <- c(col3, "#91bfdb")

pdf(paste0(path, "/evaluate_fit/SAM_AIC.pdf"))
par(mfrow=c(length(unique(true_SRR_param$devs)), length(unique(true_SRR_param$traj))), oma=c(4,4,2,8), mar=c(1,0,0,0))
for (i in 1:length(unique(true_SRR_param$traj))){
  for (j in 1:length(unique(true_SRR_param$devs))){
    tmp <- t(as.matrix(subset(res_aic_sam, traj==unique(true_SRR_param$traj)[i] & devs==unique(true_SRR_param$devs)[j])[,4:ncol(res_aic_sam)]))
    colnames(tmp) <- tmp["model",]
    if (j==1) yaxis="s" else yaxis="n"
    if (i==3) xlab="s" else xlab="n"
    barplot(tmp[-1,], col = col4, yaxt=yaxis, xaxt=xlab)
    # if (i==3 & j==1) {
    #   par(xpd=NA)
    #   legend(x=0, y=-0.2, legend=fitted_models, fill=col, horiz = TRUE, bty="n")
    #   }
  }
}
mtext(unique(true_SRR_param$traj), 4, line = 0.5, at=c(5/6, 3/6, 1/6), outer=TRUE)
mtext(unique(true_SRR_param$devs), 3, line = 0.5, at=c(1/6, 3/6, 5/6), outer=TRUE)
mtext("Operating models", side=1, line=2, outer=TRUE)
mtext("Proportions", side=2, line=2.5, outer=TRUE)
par(xpd=NA)
legend(x=5.2, y=3.2, legend=rev(rownames(tmp[-1,])), fill=rev(col4), bty="n", cex=1.2, title="Estimation models", title.cex=1)
dev.off()


# Comparing reference points between assessment models (only MSY in common) ---------------------
## For best EM for each OM because to many results otherwise
# there is no MSY for meanrec in WHAM, should it be calculated even if not realistic?

## WHAM ---------------------
extract_wham <- function(best_aic, name){
  x <- array(dim=dim(best_aic))  
  for (i in 1:ncol(x)){
    for (j in 1:nrow(x)){
      best_model <- best_aic[j,i]
      if (!is.na(best_model)) {
        tmp <- eval(parse(text=best_model))[[name]][1,j,i]
        if (!is.null(tmp)) x[j,i] <-  tmp
      }
    }
  }
  return(x)
}

logBmsy_wham <- extract_wham(wham_best_aic, "log_ssbmsy")
logFmsy_wham <- extract_wham(wham_best_aic, "log_fmsy")
logMSY_wham <- extract_wham(wham_best_aic, "log_msy")


## SAM ---------------------
extract_sam <- function(best_aic, name){
  x <- array(dim=dim(best_aic))  
  for (i in 1:ncol(x)){
    for (j in 1:nrow(x)){
      best_model <- best_aic[j,i]
      if (!is.na(best_model)) {
        tmp <- subset(sam_param, run==paste0("r", i) & iter==paste0("iter", j) & sr.code==best_model)[,name]
        if(length(tmp)!=0) x[j,i] <-  as.numeric(tmp)
      }
    }
  }
  return(x)
}

logBmsy_sam <- log(extract_sam(sam_best_aic, "SSBmsy"))
logFmsy_sam <- log(extract_sam(sam_best_aic, "Fmsy"))
logMSY_sam <- log(extract_sam(sam_best_aic, "MSY"))


## Plots ---------------------

order_plot <- sapply(unique(scenario$traj), function(x) sapply(unique(scenario$devs), function(y) subset(scenario, devs==y & traj==x)[,"case"]))
merge_res <- function(x,y){
  xy <- c()
  for (k in c(order_plot)){
    name <- paste(scenario[k,"model"], scenario[k,"devs"], scenario[k,"traj"], sep="_")
    tmp <- cbind(x[,k], y[,k])
    colnames(tmp) <- paste(c("wham", "sam"), name, sep="_")
    xy <-cbind(xy, tmp)
  }
  xy
}

'%!in%' <- function(x,y)!('%in%'(x,y))

plot_ref_pt <- function(toplot, lim_low, lim_up, col, ylab, mar=c(1,1,1,1), oma=c(4,4,2,8), line0=FALSE, legend=NULL, ...){
  par(mfrow=c(length(unique(true_SRR_param$devs)), length(unique(true_SRR_param$traj))), oma=oma, mar=mar, xpd=FALSE)
  scen <- c(length(grep("bevholt", colnames(tmp)))>0, length(grep("ricker", colnames(tmp)))>0, length(grep("mean", colnames(tmp)))>0, length(grep("segreg", colnames(tmp)))>0)
  nscen<- sum(scen)
  for (i in 1:length(lim_low)){
    if (sum(mar)==0) if(i %in% c(1,4,7)) yaxis="s" else yaxis="n" else yaxis="s"
    if (ncol(toplot[,lim_low[i]:lim_up[i]])==8) at <- c(1,2, 4,5, 7,8, 10,11) else if (ncol(toplot[,lim_low[i]:lim_up[i]])==12) at <- c(1,2,3, 5,6,7, 9,10,11, 13,14,15) else if (nmodel==2) at <- c(1,2, 4,5) else at <- 1:4
    boxplot(toplot[,lim_low[i]:lim_up[i]], col=col, at=at, xaxt="n", boxlwd = 0.8, lwd=0.5, outcol=rgb(0,0,0,0.4), yaxt=yaxis, ...)
    if (line0) abline(h=0, lty=2)
    abline(v=which(1:(4*nmodel+1) %!in% at), col="lightgrey")
    if (i %in% 7:9) if (nmodel>1) axis(side=1, at=c(which(1:(nscen*nmodel+1) %!in% at), max(at+1))-(nmodel/2+0.5), labels = unique(scenario$model)[scen], cex.axis=0.8, tick = FALSE) else axis(side=1, at=at, labels = unique(scenario$model)[scen], cex.axis=0.8, tick = FALSE)
    if(i==3) {
      par(xpd=NA)
      legend(x=par("usr")[2]*1.1, y=par("usr")[4], legend=legend, fill=col, bty="n", cex=1.2, title="Estimation models", title.cex=1)
      par(xpd=FALSE)
    }
  }
  mtext(unique(true_SRR_param$traj), 4, line = 0.5, at=c(5/6, 3/6, 1/6), outer=TRUE)
  mtext(unique(true_SRR_param$devs), 3, line = 0.5, at=c(1/6, 3/6, 5/6), outer=TRUE)
  mtext("Operating models", side=1, line=2.5, outer=TRUE)
  mtext(ylab, side=2, line=2.5, outer=TRUE)
}

nmodel <- 2 # should be increased when more assessment models
lim_low<- seq(1, 36*nmodel, 4*nmodel)
lim_up<- seq(4*nmodel, 36*nmodel, 4*nmodel)
col2 <- c(col3[1], col3[3])

### Bmsy ---------------------

tmp <- merge_res(logBmsy_wham, logBmsy_sam)

pdf(paste0(path, "/evaluate_fit/logBmsy_best_EMs.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, "log(Bmsy)", legend=c("WHAM", "SAM"))
dev.off()

pdf(paste0(path, "/evaluate_fit/logBmsy_best_EMs_no_outlier.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, "log(Bmsy)", legend=c("WHAM", "SAM"), outline=FALSE)
dev.off()


### Fmsy ---------------------

tmp <- merge_res(logFmsy_wham, logFmsy_sam)

pdf(paste0(path, "/evaluate_fit/Fmsy_best_EMs.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(exp(tmp), lim_low, lim_up, col2, "Fmsy", legend=c("WHAM", "SAM"))
dev.off()

pdf(paste0(path, "/evaluate_fit/Fmsy_best_EMs_no_outlier.pdf")) 
plot_ref_pt(exp(tmp), lim_low, lim_up, col2, "Fmsy", legend=c("WHAM", "SAM"), outline=FALSE, ylim=c(0,0.6), mar=c(0,0,0,0), oma=c(4,4,2,9))
dev.off()

### MSY ---------------------

tmp <- merge_res(logMSY_wham, logMSY_sam)

pdf(paste0(path, "/evaluate_fit/logMSY_best_EMs.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, "log(MSY)", legend=c("WHAM", "SAM"))
dev.off()

pdf(paste0(path, "/evaluate_fit/logMSY_best_EMs_no_outlier.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, "log(MSY)", legend=c("WHAM", "SAM"), outline=FALSE)
dev.off()



# Comparing parameters between assessment models (a, b, sigmaR, ssb0, h) ---------------------
## Only makes sense when EM=OM
## Pb: WHAM is missing the mean recruitment value, segreg cannot be compared to anything, except if we compare b to meanrec or RW
## Pb: the non-converged run are not taken into account (SAM)
## For now only comparison for bh and ricker.

## True OMs ---------------------
OMs <- sapply(unique(scenario$case), function(x) cbind(rep(subset(scenario, case==x)[,"model"],300)))
OMs[which(OMs=="bevholt")] <- "bh"
OMs_extract <- OMs
OMs_extract[which(OMs_extract %in% c("mean", "segreg"))] <- NA # turn those to NA for extraction purpose

## WHAM ---------------------

# convert parameters so comparable to the truth
bh$h <- exp(bh$logit_h)/(1+exp(bh$logit_h)) # calculate h from logit 
ricker$h <- exp(ricker$log_h)/(1+exp(ricker$log_h)) # I think ricker$log_h is actually a logit not log, check with Tim!

bh$a <- exp(bh$log_a)/exp(bh$log_b) 
bh$b <- 1/exp(bh$log_b) 
ricker$a <- exp(ricker$log_a)
ricker$b <- exp(ricker$log_b)


a_wham <- extract_wham(OMs_extract, "a")
b_wham <- extract_wham(OMs_extract, "b")
h_wham <- extract_wham(OMs_extract, "h")
logRsig_wham <- extract_wham(OMs_extract, "log_Rsig")
logS0_wham <- extract_wham(OMs_extract, "log_S0")

rel_err_a_wham <- sapply(1:ncol(a_wham), function(x) (a_wham[,x]-true_SRR_param[x,"a"])/true_SRR_param[x,"a"])
rel_err_b_wham <- sapply(1:ncol(b_wham), function(x) (b_wham[,x]-true_SRR_param[x,"b"])/true_SRR_param[x,"b"])
rel_err_h_wham <- sapply(1:ncol(h_wham), function(x) (h_wham[,x]-as.numeric(true_SRR_param[x,"h"]))/as.numeric(true_SRR_param[x,"h"]))
rel_err_Rsig_wham <- sapply(1:ncol(logRsig_wham), function(x) (exp(logRsig_wham[,x])-true_SRR_param[x,"sigmaR"])/true_SRR_param[x,"sigmaR"])
rel_err_S0_wham <- sapply(1:ncol(logS0_wham), function(x) (exp(logS0_wham[,x])-true_SRR_param[x,"ssb0"])/true_SRR_param[x,"ssb0"])


## SAM ---------------------
## Note that the SAM param are already on natural scale not log!

# convert parameters so comparable to the truth
a_sam <- vector(length=length(sam_param$alpha))
b_sam <- vector(length=length(sam_param$beta))
a_sam[] <- NA
b_sam[] <- NA

a_sam[which(sam_param$sr.code=="bh")] <- as.numeric(sam_param$alpha[which(sam_param$sr.code=="bh")])/as.numeric(sam_param$beta[which(sam_param$sr.code=="bh")])  # assumed already on natural scale
b_sam[which(sam_param$sr.code=="bh")] <- 1/as.numeric(sam_param$beta[which(sam_param$sr.code=="bh")]) # assumed already on natural scale

a_sam[which(sam_param$sr.code=="ricker")] <- as.numeric(sam_param$alpha[which(sam_param$sr.code=="ricker")]) # assumed already on natural scale
b_sam[which(sam_param$sr.code=="ricker")] <- as.numeric(sam_param$beta[which(sam_param$sr.code=="ricker")]) # assumed already on natural scale

sam_param <- cbind(sam_param, a=a_sam, b=b_sam)  

a_sam <- extract_sam(OMs_extract, "a") 
b_sam <- extract_sam(OMs_extract, "b") 
h_sam <- extract_sam(OMs_extract, "steepness") # already on natural scale
Rsig_sam <- extract_sam(OMs_extract, "sigmaR") # already on natural scale
S0_sam <- extract_sam(OMs_extract, "SSB0") # already on natural scale

rel_err_a_sam <- sapply(1:ncol(a_sam), function(x) ((a_sam[,x])-true_SRR_param[x,"a"])/true_SRR_param[x,"a"])
rel_err_b_sam <- sapply(1:ncol(b_sam), function(x) ((b_sam[,x])-true_SRR_param[x,"b"])/true_SRR_param[x,"b"])
rel_err_h_sam <- sapply(1:ncol(h_sam), function(x) ((h_sam[,x])-as.numeric(true_SRR_param[x,"h"]))/as.numeric(true_SRR_param[x,"h"]))
rel_err_Rsig_sam <- sapply(1:ncol(Rsig_sam), function(x) (Rsig_sam[,x]-true_SRR_param[x,"sigmaR"])/true_SRR_param[x,"sigmaR"])
rel_err_S0_sam <- sapply(1:ncol(S0_sam), function(x) (S0_sam[,x]-true_SRR_param[x,"ssb0"])/true_SRR_param[x,"ssb0"])


## Plots ---------------------

### a ---------------------

tmp <- merge_res(rel_err_a_wham, rel_err_a_sam)
# removing mean and segreg for now:
tmp <- tmp[,-grep("mean", colnames(tmp))]
tmp <- tmp[,-grep("segreg", colnames(tmp))]

lim_low<- seq(1, ncol(tmp), 2*nmodel)
lim_up<- seq(2*nmodel, ncol(tmp), 2*nmodel)

pdf(paste0(path, "/evaluate_fit/rel_err_a.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in parameter a", legend=c("WHAM", "SAM"), ylim=c(-1, 5), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_a_no_outlier.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in parameter a", legend=c("WHAM", "SAM"), line0=TRUE, outline=FALSE)
dev.off()


### b ---------------------

tmp <- merge_res(rel_err_b_wham, rel_err_b_sam)
# removing mean and segreg for now:
tmp <- tmp[,-grep("mean", colnames(tmp))]
tmp <- tmp[,-grep("segreg", colnames(tmp))]

pdf(paste0(path, "/evaluate_fit/rel_err_b.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in parameter b", legend=c("WHAM", "SAM"), ylim=c(-1, 5), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_b_no_outlier.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in parameter b", legend=c("WHAM", "SAM"), line0=TRUE, outline=FALSE)
dev.off()


### h, steepness ---------------------

tmp <- merge_res(rel_err_h_wham, rel_err_h_sam)
# removing mean and segreg for now:
tmp <- tmp[,-grep("mean", colnames(tmp))]
tmp <- tmp[,-grep("segreg", colnames(tmp))]

pdf(paste0(path, "/evaluate_fit/rel_err_h.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in steepness", legend=c("WHAM", "SAM"), ylim=c(-1, 1.5), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_h_no_outlier.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in steepness", legend=c("WHAM", "SAM"), line0=TRUE, outline=FALSE)
dev.off()


### sigmaR ---------------------

tmp <- merge_res(rel_err_Rsig_wham, rel_err_Rsig_sam)
# removing mean and segreg for now:
tmp <- tmp[,-grep("mean", colnames(tmp))]
tmp <- tmp[,-grep("segreg", colnames(tmp))]

pdf(paste0(path, "/evaluate_fit/rel_err_sigmaR.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in recruitment variance parameter", legend=c("WHAM", "SAM"), ylim=c(-1, 0.8), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_sigmaR_no_outlier.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in recruitment variance parameter", legend=c("WHAM", "SAM"), line0=TRUE, outline=FALSE)
dev.off()


### ssb0 ---------------------

tmp <- merge_res(rel_err_S0_wham, rel_err_S0_sam)
# removing mean and segreg for now:
tmp <- tmp[,-grep("mean", colnames(tmp))]
tmp <- tmp[,-grep("segreg", colnames(tmp))]

pdf(paste0(path, "/evaluate_fit/rel_err_ssb0.pdf")) 
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in ssb0", legend=c("WHAM", "SAM"), ylim=c(-1, 5), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_ssb0_no_outlier.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col2, ylab="Relative error in ssb0", legend=c("WHAM", "SAM"), line0=TRUE, outline=FALSE)
dev.off()



# Comparing model outputs F, SSB, recruitment ---------------------
## For best EM for each OM because to many results otherwise
# Pb: WHAM do not include SSB and rec


## WHAM ---------------------
extract_traj_wham <- function(best_aic, name){
  x <- array(dim=c(dim(best_aic)[1],dim(bh$log_fbar)[length(dim(bh$log_fbar))], dim(best_aic)[2])) 
  for (i in 1:dim(x)[3]){
    for (j in 1:nrow(x)){
      best_model <- best_aic[j,i]
      if (!is.na(best_model)) {
        tmp <- eval(parse(text=best_model))[[name]][1,j,i,]
        if (!is.null(tmp)) x[j,,i] <-  tmp 
      }
    }
  }
  return(x)
}
year_name <- unique(sam_traj$year)
pivot_true <- pivot_wider(true_out, names_from=year, values_from=data)

logfbar_wham <- extract_traj_wham(wham_best_aic, "log_fbar")
rel_err_fbar_wham <- sapply(1:dim(logfbar_wham)[3], function(x) (exp(logfbar_wham[,,x])-subset(pivot_true, run==x & qname=="F")[(1:n_it),year_name])/subset(pivot_true, run==x & qname=="F")[(1:n_it),year_name])



## SAM ---------------------
extract_traj_sam <- function(best_aic, name){ # takes too much time can be made quicker when we have all iterations
  x <- array(dim=c(dim(best_aic)[1],dim(bh$log_fbar)[length(dim(bh$log_fbar))], dim(best_aic)[2])) 
  for (i in 1:dim(x)[3]){
    for (j in 1:nrow(x)){
      best_model <- best_aic[j,i]
      if (!is.na(best_model)) {
        tmp <- subset(sam_traj, run==paste0("r", i) & iter==paste0("iter", j) & sr.code==best_model)[,name]
        if(length(tmp)!=0) x[j,,i] <-  as.numeric(tmp)
      }
    }
  }
  return(x)
}

fbar_sam <- (extract_traj_sam(sam_best_aic, "F.ave"))
ssb_sam <- (extract_traj_sam(sam_best_aic, "ssb"))
rec_sam <- (extract_traj_sam(sam_best_aic, "recr"))


rel_err_fbar_sam <- sapply(1:dim(fbar_sam)[3], function(x) (fbar_sam[,,x]-subset(pivot_true, run==x & qname=="F")[(1:n_it),year_name])/subset(pivot_true, run==x & qname=="F")[(1:n_it),year_name])
rel_err_ssb_sam <- sapply(1:dim(ssb_sam)[3], function(x) (ssb_sam[,,x]-subset(pivot_true, run==x & qname=="SSB")[(1:n_it),year_name])/subset(pivot_true, run==x & qname=="SSB")[(1:n_it),year_name])
rel_err_rec_sam <- sapply(1:dim(rec_sam)[3], function(x) (rec_sam[,,x]-subset(pivot_true, run==x & qname=="Rec")[(1:n_it),year_name])/subset(pivot_true, run==x & qname=="Rec")[(1:n_it),year_name])


## Plots ---------------------

plot_traj <- function(traj, col, ylim=NULL, mar=c(1,1,1,1), ...){
  for (k in 1:length(unique(scenario$model))){
    num <- scenario[which(scenario$model==unique(scenario$model)[k]),"case"]
    par(mfrow=c(length(unique(true_SRR_param$devs)), length(unique(true_SRR_param$traj))), oma=c(4,4,4,2), mar=mar, xpd=FALSE)
    for (i in 1:length(num)){
      if (sum(mar)==0) if(i %in% c(1,4,7)) yaxis="s" else yaxis="n" else yaxis="s"
      tmp<-boxplot(traj[,num[i]], col=col, xaxt="n", boxlwd = 0.8, lwd=0.5, outcol=rgb(0,0,0,0.4), yaxt=yaxis, ylim=ylim, ...)
      abline(h=0, lty=2)
      if (i %in% 7:9) axis(side=1, at=1:length(year_name), labels = 1:length(year_name), cex.axis=0.8)
    }
    mtext(unique(true_SRR_param$traj), 4, line = 0.5, at=c(5/6, 3/6, 1/6), outer=TRUE)
    mtext(unique(true_SRR_param$devs), 3, line = 0.5, at=c(1/6, 3/6, 5/6), outer=TRUE)
    mtext("Year", side=1, line=2.2, outer=TRUE)
    mtext(unique(scenario$model)[k], side=3, line=2, outer=TRUE)
    mtext(paste0("Relative error ", gsub("rel_err_", "", gsub("_wham", "", gsub("_sam", "", deparse(substitute(traj)))))), side=2, line=2.5, outer=TRUE)
  } 
}

### Fbar ---------------------

pdf(paste0(path, "/evaluate_fit/rel_err_fbar_best_EMs_wham.pdf")) 
plot_traj(rel_err_fbar_wham, col=col2[1])
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_fbar_best_EMs_wham_ylim.pdf"))
plot_traj(rel_err_fbar_wham, col=col2[1], ylim=c(-1, 2), mar=c(0,0,0,0))
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_fbar_best_EMs_sam.pdf")) 
plot_traj(rel_err_fbar_sam, col=col2[2])
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_fbar_best_EMs_sam_ylim.pdf"))
plot_traj(rel_err_fbar_sam, col=col2[2], ylim=c(-1, 5), mar=c(0,0,0,0))
dev.off()

### ssb ---------------------

pdf(paste0(path, "/evaluate_fit/rel_err_ssb_best_EMs_sam.pdf")) 
plot_traj(rel_err_ssb_sam, col=col2[2])
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_ssb_best_EMs_sam_ylim.pdf"))
plot_traj(rel_err_ssb_sam, col=col2[2], ylim=c(-1, 30), mar=c(0,0,0,0))
dev.off()

### rec ---------------------

pdf(paste0(path, "/evaluate_fit/rel_err_rec_best_EMs_sam.pdf")) 
plot_traj(rel_err_rec_sam, col=col2[2])
dev.off()

pdf(paste0(path, "/evaluate_fit/rel_err_rec_best_EMs_sam_ylim.pdf"))
plot_traj(rel_err_rec_sam, col=col2[2], ylim=c(-1, 30), mar=c(0,0,0,0))
dev.off()


### Median rel err across years for F SSB and rec (1 boxplot for each scenario and variable)  ---------------------

median_bias_overtime <- function(rel_err){ # median rel err across years (300 values per case)
  y=sapply(1:ncol(rel_err), function(x) apply(sapply(1:length(rel_err[,x]), function(y) rel_err[,x][[y]]), 1, median))
  y
}
median_rel_err_fbar_wham <- median_bias_overtime(rel_err_fbar_wham)

median_rel_err_fbar_sam <- median_bias_overtime(rel_err_fbar_sam)
median_rel_err_ssb_sam <- median_bias_overtime(rel_err_ssb_sam)
median_rel_err_rec_sam <- median_bias_overtime(rel_err_rec_sam)


merge_res_3 <- function(x,y,z){
  xy <- c()
  for (k in c(order_plot)){
    name <- paste(scenario[k,"model"], scenario[k,"devs"], scenario[k,"traj"], sep="_")
    tmp <- cbind(x[,k], y[,k], z[,k])
    colnames(tmp) <- paste(c("fbar", "ssb", "rec"), name, sep="_")
    xy <-cbind(xy, tmp)
  }
  xy
}

nmodel <- 3 # fbar, ssb, rec
lim_low<- seq(1, 36*nmodel, 4*nmodel)
lim_up<- seq(4*nmodel, 36*nmodel, 4*nmodel)

tmp <- merge_res_3(median_rel_err_fbar_sam, median_rel_err_ssb_sam, median_rel_err_rec_sam)

pdf(paste0(path, "/evaluate_fit/rel_err_traj_median_best_EMs_sam.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col3, "Relative error time series in SAM", legend=c("Fbar", "SSB", "Rec"), ylim=c(-1, 5), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()

nmodel <- 1 # fbar
lim_low<- seq(1, 36*nmodel, 4*nmodel)
lim_up<- seq(4*nmodel, 36*nmodel, 4*nmodel)

tmp <- median_rel_err_fbar_wham[,c(order_plot)]
colnames(tmp) <- apply(scenario[c(order_plot),c("devs", "traj", "model")], 1, function(x) paste0(x, collapse="_"))
pdf(paste0(path, "/evaluate_fit/rel_err_traj_median_best_EMs_wham.pdf")) # possibility of narrowing the axis if necessary
plot_ref_pt(tmp, lim_low, lim_up, col3[1], "Relative error Fbar in WHAM", legend=c("Fbar"), ylim=c(-0.6, 0.6), mar=c(0,0,0,0), oma=c(4,4,2,9), line0=TRUE)
dev.off()



## Table of median bias over time ---------------------
# To copy to Rmd

# 1 value per case into table
median_bias <- function(rel_err){ # median across years of median rel err across iterations (1 median value per case)
  y=apply(sapply(1:ncol(rel_err), function(x) unlist(lapply(rel_err[,x], median, na.rm=T))), 2, median)
  y
}
median_bias_wham <- scenario
median_bias_wham <- cbind(median_bias_wham, bias_Fbar=median_bias(rel_err_fbar_wham))

median_bias_sam <- scenario
median_bias_sam <- cbind(median_bias_sam, bias_Fbar=median_bias(rel_err_fbar_sam))
median_bias_sam <- cbind(median_bias_sam, bias_SSB=median_bias(rel_err_ssb_sam))
median_bias_sam <- cbind(median_bias_sam, bias_rec=median_bias(rel_err_rec_sam))

save(median_bias_wham, median_bias_sam, file=paste0(path, "/evaluate_fit/rel_err_median_bias_table.RData"))

