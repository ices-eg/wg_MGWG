# convert_ASAP_ICES
# convert ASAP rdat file to ICES input format for use in SAM
# created 13 December 2016  Chris Legault
# last modified 3 January 2017

rm(list=ls())
graphics.off()

# function to compute catch at age (matrix) 
# from proportions at age (matrix), weight at age (matrix) and total weight (vector)
wtprop2caa <- function(totwt,waa,props){
  caa <- props
  for (i in 1:length(totwt)){
    if (sum(props[i,]) == 0) caa[i,] = 0
    if (sum(props[i,]) > 0) caa[i,] <- props[i,] * (totwt[i] / sum(props[i,] * waa[i,]))
  }
  return(caa)
}

get.CAA <- function(asap){ # used when only one fleet with no discards
  agg.ob <- asap$catch.obs[1,]
  props.ob <- asap$catch.comp.mats$catch.fleet1.ob
  waa <- asap$WAA.mats$WAA.catch.fleet1
  CAA <- wtprop2caa(agg.ob,waa,props.ob)  # use catch function
  CAA <- round(CAA, 3)  # only accurate to nearest fish
  return(CAA)
}  

get.CAA.nfleets <- function(asap){ # used with multiple fleets or discards
  nfleets <- asap$parms$nfleets
  caa <- list()
  waa <- list()
  for (i in 1:nfleets){  # catch
    agg.ob <- asap$catch.obs[i,]
    props.ob <- asap$catch.comp.mats[[((i-1)*4+1)]]
    waa[[i]] <- asap$WAA.mats[[((i-1)*2+1)]]
    caa[[i]] <- wtprop2caa(agg.ob,waa[[i]],props.ob)
  }
  for (i in 1:nfleets){ # discards
    agg.ob <- asap$discard.obs[i,]
    props.ob <- asap$catch.comp.mats[[((i-1)*4+3)]]
    waa[[(nfleets+i)]] <- asap$WAA.mats[[((i-1)*2+2)]]
    caa[[(nfleets+i)]] <- wtprop2caa(agg.ob,waa[[(nfleets+i)]],props.ob)
  }
  CAA <- caa[[1]]
  sumwcaa <- waa[[1]] * caa[[1]]
  for (j in 2:length(caa)){
    CAA <- CAA + caa[[j]]
    sumwcaa <- sumwcaa + (waa[[j]] * caa[[j]])
  }
  WAA <- sumwcaa / CAA
  res.CAA <- list(CAA=round(CAA,3), WAA=WAA)
  return(res.CAA)
}

convert_survey_to_at_age <- function(asap){
  # takes West Coast style surveys and converts them to catch at age matrices
  index.mats <- list()
  weight.mat.counter <- 0
  years <- asap$parms$styr:asap$parms$endyr
  for (ind in 1:asap$parms$nindices){
    if (asap$control.parms$index.age.comp.flag[ind] == 1){  # used age composition for the index
      # get the aggregate index observed time series
      agg.ob <- asap$index.obs[[ind]]

      # get proportions for correct years and ages only
      age.min <- asap$control.parms$index.sel.start.age[ind]
      age.max <- asap$control.parms$index.sel.end.age[ind]
      props.ob <- asap$index.comp.mats[[(ind*2-1)]][asap$index.year.counter[[ind]],age.min:age.max]

      # figure out units for aggregate and proportions
      agg.units <- asap$control.parms$index.units.aggregate[ind]
      prp.units <- asap$control.parms$index.units.proportions[ind]
      
      # get weight (matrix if necessary)
      if (agg.units==1 || prp.units==1){  # either in weight
        weight.mat.counter <- weight.mat.counter+1
        use.me <- weight.mat.counter + (asap$parms$nfleets * 2) + 4
        waa <- asap$WAA.mats[[use.me]][asap$index.year.counter[[ind]],age.min:age.max] 
      }
      
      # create index.obs based on which of the four possible combinations of units is used for this index
      if (agg.units==1 && prp.units==1){  # both in weight
        index.ob <- agg.ob * props.ob / waa
      }
      if (agg.units==1 && prp.units==2){  # agg in weight, props in numbers
        index.ob <- wtprop2caa(agg.ob,waa,props.ob)  # use catch function
      }
      if (agg.units==2 && prp.units==1){  # agg in numbers, props in weight
        # need to search for correct agg total in weight to result in observed agg total in number
        # for now just use simple approximation that agg.wt = sum(waa*prop) *ctot and then solve using both in weight approach
        agg.wt.ob <- apply((waa * props.ob),1,sum) * agg.ob
        index.ob <- agg.wt.ob * props.ob / waa
      }
      if (agg.units==2 && prp.units==2){  # both in numbers
        index.ob <- agg.ob * props.ob
      }
      
      # put matrices into full year matrix (ages only for selected ages though)
      # need to do this to account for missing years of data interspersed in time series
      index.ob.full <- matrix(NA, nrow=asap$parms$nyears, ncol=(age.max-age.min+1))
      for (i in 1:asap$index.nobs[ind]){
        index.ob.full[asap$index.year.counter[[ind]][i],] <- as.vector(index.ob[i,])
      }
      
      # save the results for this index
      index.mats$ob[[ind]] <- index.ob.full
      rownames(index.mats$ob[[ind]]) <- years
      colnames(index.mats$ob[[ind]]) <- age.min:age.max
    }
    if (asap$control.parms$index.age.comp.flag[ind] != 1){  # cannot use this index
      index.mats$ob[[ind]] <- NA
    }
  }
  return(index.mats)  
}

write.cn <- function(ices.dir, ices.base, start.yr, end.yr, nages, CAA){
  file_name <- paste0(ices.dir, ices.base, "_cn.dat")
  cat("Catch in Numbers (thousands)\n", file=file_name, append=FALSE)
  cat("1 2\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(CAA, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.cw <- function(ices.dir, ices.base, start.yr, end.yr, nages, WAA){
  file_name <- paste0(ices.dir, ices.base, "_cw.dat")
  cat("Mean Weight in Catch (kilograms)\n", file=file_name, append=FALSE)
  cat("1 3\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(WAA, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.dw <- function(ices.dir, ices.base, start.yr, end.yr, nages, WAA){
  file_name <- paste0(ices.dir, ices.base, "_dw.dat")
  cat("Mean Weight in Catch (kilograms)\n", file=file_name, append=FALSE)
  cat("1 3\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(WAA, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.lf <- function(ices.dir, ices.base, start.yr, end.yr, nages){
  lf <- matrix(1, nrow=(end.yr - start.yr + 1), ncol=nages)
  file_name <- paste0(ices.dir, ices.base, "_lf.dat")
  cat("Proportion of Catch that is Landed\n", file=file_name, append=FALSE)
  cat("1 1\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(lf, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.lw <- function(ices.dir, ices.base, start.yr, end.yr, nages, WAA){
  file_name <- paste0(ices.dir, ices.base, "_lw.dat")
  cat("Mean Weight in Catch (kilograms)\n", file=file_name, append=FALSE)
  cat("1 3\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(WAA, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.mo <- function(ices.dir, ices.base, start.yr, end.yr, nages, maturity){
  file_name <- paste0(ices.dir, ices.base, "_mo.dat")
  cat("Proportion Mature at Year Start\n", file=file_name, append=FALSE)
  cat("1 6\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(maturity, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.nm <- function(ices.dir, ices.base, start.yr, end.yr, nages, M){
  file_name <- paste0(ices.dir, ices.base, "_nm.dat")
  cat("Natural Mortality\n", file=file_name, append=FALSE)
  cat("1 5\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(M, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.pf <- function(ices.dir, ices.base, start.yr, end.yr, nages, pf){
  pf.tab <- matrix(pf, nrow=(end.yr - start.yr + 1), ncol=nages)
  file_name <- paste0(ices.dir, ices.base, "_pf.dat")
  cat("Proportion of F before Spawning\n", file=file_name, append=FALSE)
  cat("1 7\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(pf.tab, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.pm <- function(ices.dir, ices.base, start.yr, end.yr, nages, pm){
  pm.tab <- matrix(pm, nrow=(end.yr - start.yr + 1), ncol=nages)
  file_name <- paste0(ices.dir, ices.base, "_pm.dat")
  cat("Proportion of M before Spawning\n", file=file_name, append=FALSE)
  cat("1 8\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(pm.tab, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.sw <- function(ices.dir, ices.base, start.yr, end.yr, nages, WAA){
  file_name <- paste0(ices.dir, ices.base, "_sw.dat")
  cat("Mean Weight in Stock (kilograms)\n", file=file_name, append=FALSE)
  cat("1 4\n", file=file_name, append=TRUE)  ### need to figure out what this row does!!!
  cat(paste(start.yr, end.yr, "\n"), file=file_name, append=TRUE)
  cat(paste("1", nages, "\n"), file=file_name, append=TRUE)
  cat("1\n", file=file_name, append=TRUE)
  write.table(WAA, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  return()
}

write.survey <- function(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats){
  file_name <- paste0(ices.dir, ices.base, "_survey.dat")
  cat(paste(ices.base,"\n"), file=file_name, append=FALSE)
  cat(paste(100 + ind.mats$n, "\n"), file=file_name, append=TRUE)
  for (i in 1:ind.mats$n){
    cat(paste(ind.mats$names[i], "\n"), file=file_name, append=TRUE)
    cat(paste(ind.mats$start.year[i], ind.mats$end.year[i], "\n"), file=file_name, append=TRUE)
    cat(paste("1 1", ind.mats$timing[i], ind.mats$timing[i], "\n"), file=file_name, append=TRUE)
    cat(paste(ind.mats$start.age[i], ind.mats$end.age[i], "\n"), file=file_name, append=TRUE)
    years <- seq(ind.mats$start.year[i], ind.mats$end.year[i])
    nyears <- length(years)
    ages <- seq(ind.mats$start.age[i], ind.mats$end.age[i])
    mat <- ind.mats$ob[[i]]
    mat.sub1 <- mat[rownames(mat) %in% years, ]
    mat.sub2 <- mat.sub1[ , colnames(mat.sub1) %in% ages]
    final.mat <- cbind(rep(1, nyears), mat.sub2)
    write.table(final.mat, col=FALSE, row=FALSE, quote=TRUE, file=file_name, append=TRUE)
  }
  return()
}

####################################################################################
# Southern New England/Mid-Atlantic Yellowtail Flounder

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\SNEMAYT\\"
ices.base <- "SNEMAYT"

asap.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
asap.file <- "SNEMAYT_ASAP.rdat"

asap <- dget(paste0(asap.dir,asap.file))
names(asap)

start.yr <- asap$parms$styr
end.yr <- asap$parms$endyr
nages <- asap$parms$nages
  
CAA <- get.CAA(asap)

ind.mats.all <- convert_survey_to_at_age(asap)
use.index <- c(1,2)  ### have to figure this out for each stock 
ind.mats <- list()
for (i in 1:length(use.index)){
  ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
}
ind.mats$n <- length(use.index)
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall")
ind.mats$start.year <- c(1973, 1973)
ind.mats$end.year <- c(2016, 2016)
ind.mats$start.age <- c(1, 1)
ind.mats$end.age <- c(6, 6)
ind.mats$timing <- c(0.33, 0.8)

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.discard.all)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb)

####################################################################################
# Gulf of Maine cod (M=0.2)

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\GOMcod\\"
ices.base <- "GOMCOD"

asap.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
asap.file <- "GOMCOD_ASAP.rdat"

asap <- dget(paste0(asap.dir,asap.file))
names(asap)

start.yr <- asap$parms$styr
end.yr <- asap$parms$endyr
nages <- asap$parms$nages

CAA <- get.CAA(asap)

ind.mats.all <- convert_survey_to_at_age(asap)
use.index <- c(1,2,3)  ### have to figure this out for each stock
ind.mats <- list()
for (i in 1:length(use.index)){
  ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
}
ind.mats$n <- length(use.index)
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall","MADMF_Spring")
ind.mats$start.year <- c(1982, 1982, 1982)
ind.mats$end.year <- c(2016, 2016, 2016)
ind.mats$start.age <- c(1, 1, 1)
ind.mats$end.age <- c(7, 5, 6)
ind.mats$timing <- c(0.33, 0.8, 0.42)

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.discard.all)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb)

####################################################################################
# Southern New England/Mid-Atlantic Winter Flounder

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\SNEMAwinter\\"
ices.base <- "SNEMAWINTER"


asap.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
asap.file <- "SNEMAWINTER_ASAP.rdat"

asap <- dget(paste0(asap.dir,asap.file))
names(asap)

start.yr <- asap$parms$styr
end.yr <- asap$parms$endyr
nages <- asap$parms$nages

CAA <- get.CAA(asap)

ind.mats.all <- convert_survey_to_at_age(asap)
use.index <- c(1,2,3)  ### have to figure this out for each stock
ind.mats <- list()
for (i in 1:length(use.index)){
  ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
}
ind.mats$n <- length(use.index)
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall","MADMF_Spring")
ind.mats$start.year <- c(1981, 1981, 1981)
ind.mats$end.year <- c(2016, 2016, 2016)
ind.mats$start.age <- c(1, 2, 1)
ind.mats$end.age <- c(7, 7, 7)
ind.mats$timing <- c(0.33, 0.8, 0.42)

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.discard.all)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb)

####################################################################################
# Gulf of Maine Haddock

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\GOMhaddock\\"
ices.base <- "GOMHADDOCK"

asap.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
asap.file <- "GOMHADDOCK_ASAP.rdat"

asap <- dget(paste0(asap.dir,asap.file))
names(asap)

start.yr <- asap$parms$styr
end.yr <- asap$parms$endyr
nages <- asap$parms$nages

CAA <- get.CAA(asap)

ind.mats.all <- convert_survey_to_at_age(asap)
use.index <- c(1,2)  ### have to figure this out for each stock
ind.mats <- list()
for (i in 1:length(use.index)){
  ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
}
ind.mats$n <- length(use.index)
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall")
ind.mats$start.year <- c(1977, 1977)
ind.mats$end.year <- c(2016, 2016)
ind.mats$start.age <- c(1, 1)
ind.mats$end.age <- c(9, 9)
ind.mats$timing <- c(0.33, 0.8)

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.discard.all)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb)

####################################################################################
# White Hake

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\WhiteHake\\"
ices.base <- "WHITEHAKE"

asap.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
asap.file <- "WHITEHAKE_ASAP.rdat"

asap <- dget(paste0(asap.dir,asap.file))
names(asap)

start.yr <- 1989 ## hardwire for white hake ## asap$parms$styr
end.yr <- asap$parms$endyr
nages <- asap$parms$nages
yr1 <- 27  ## hardwire for white hake ##
yr2 <- 54  ## hardwire for white hake ##

CAA <- get.CAA(asap)
CAA <- CAA[yr1:yr2,]

ind.mats.all <- convert_survey_to_at_age(asap)
use.index <- c(1,2)  ### have to figure this out for each stock
ind.mats <- list()
for (i in 1:length(use.index)){
  ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
}
ind.mats$n <- length(use.index)
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall")
ind.mats$start.year <- c(1989, 1989)
ind.mats$end.year <- c(2016, 2016)
ind.mats$start.age <- c(1, 1)
ind.mats$end.age <- c(9, 9)
ind.mats$timing <- c(0.33, 0.8)

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all[yr1:yr2,])
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.discard.all[yr1:yr2,])
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all[yr1:yr2,])
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity[yr1:yr2,])
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age[yr1:yr2,])
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb[yr1:yr2,])

####################################################################################
# Pollock (ignoring recreational catch for now)

ices.dir <- "/home/dhennen/SAM/MGWG-master/state-space/Pollock/"
ices.base <- "POLLOCK"

asap.dir <- "/home/dhennen/SAM/MGWG-master/state-space/Pollock/"
asap.file <- "POLLOCK_ASAP.RDAT"

asap <- dget(paste0(asap.dir,asap.file))
names(asap)

start.yr <- asap$parms$styr
end.yr <- asap$parms$endyr
nages <- asap$parms$nages

res.CAA <- get.CAA.nfleets(asap)
CAA <- res.CAA$CAA
WAA <- res.CAA$WAA
#WAA[1:11,1] <- mean(WAA[,1], na.rm=T) # hard wire to deal with no catch at age 0 in first 11 years
# general fix 
fillcol=function(x){ifelse(is.na(x),mean(x,na.rm=T),x)} #x is a vector (column) we will be filling in
WAA=apply(WAA,2,fillcol)


ind.mats.all <- convert_survey_to_at_age(asap)
use.index <- c(1,2)  ### have to figure this out for each stock
ind.mats <- list()
for (i in 1:length(use.index)){
  ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
}
ind.mats$n <- length(use.index)
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall")
ind.mats$start.year <- c(1970, 1970)
ind.mats$end.year <- c(2016, 2016)
ind.mats$start.age <- c(1, 1)
ind.mats$end.age <- c(9, 9)
ind.mats$timing <- c(0.33, 0.8)

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, WAA)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, WAA)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, WAA)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb)


####################################################################################
# # Witch Flounder (SARC 62, model not accepted)
# 
# ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\Witch\\"
# ices.base <- "WITCH"
# 
# asap.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\Assessments\\witch_flounder\\witch retro explorations\\single_runs\\"
# asap.file <- "BASE_RUN.rdat"
# 
# asap <- dget(paste0(asap.dir,asap.file))
# names(asap)
# 
# start.yr <- asap$parms$styr
# end.yr <- asap$parms$endyr
# nages <- asap$parms$nages
# 
# CAA <- get.CAA(asap)
# 
# ind.mats.all <- convert_survey_to_at_age(asap)
# use.index <- c(1,2)  ### have to figure this out for each stock
# ind.mats <- list()
# for (i in 1:length(use.index)){
#   ind.mats$ob[[i]] <- ind.mats.all$ob[[use.index[i]]]
# }
# ind.mats$n <- length(use.index)
# ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall")
# ind.mats$start.year <- c(1982, 1982)
# ind.mats$end.year <- c(2015, 2015)
# ind.mats$start.age <- c(1, 1)
# ind.mats$end.age <- c(11, 11)
# ind.mats$timing <- c(0.33, 0.8)
# 
# write.cn(ices.dir, ices.base, start.yr, end.yr, nages, CAA)
# write.cw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
# write.dw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.discard.all)
# write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
# write.lw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.catch.all)
# write.mo(ices.dir, ices.base, start.yr, end.yr, nages, asap$maturity)
# write.nm(ices.dir, ices.base, start.yr, end.yr, nages, asap$M.age)
# write.pf(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
# write.pm(ices.dir, ices.base, start.yr, end.yr, nages, asap$options$frac.yr.spawn)
# write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
# write.sw(ices.dir, ices.base, start.yr, end.yr, nages, asap$WAA.mats$WAA.ssb)
