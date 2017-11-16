# convert_VPA_ICES
# convert VPA rdat file to ICES input format for use in SAM
# created 14 December 2016  Chris Legault
# last modified 30 December 2016

rm(list=ls())
graphics.off()

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
# Georges Bank Winter Flounder

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\GBwinter\\"
ices.base <- "GBWINTER"

vpa.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
vpa.file <- "GBWINTER_VPA.rdat"

vpa <- dget(paste0(vpa.dir,vpa.file))
names(vpa)

start.yr <- vpa$genparms$minyear
end.yr <- vpa$genparms$maxyear
nages <- vpa$genparms$nages

### have to figure this out for each stock
ind.mats.all <- vpa$surveyobs
ind.mats <- list()
ind.mats$n <- 3
ind.mats$names <- c("NEFSC_Spring","DFO","NEFSC_Fall")
ind.mats$start.year <- c(1982, 1987, 1982)
ind.mats$end.year <- c(2016, 2016, 2016)
ind.mats$start.age <- c(1, 1, 1)
ind.mats$end.age <- c(7, 7, 7)
ind.mats$timing <- c(0.0, 0.0, 0.0)
use.cols.start <- c(1, 8,  15)
use.cols.end   <- c(7, 14, 21)
for (i in 1:ind.mats$n){
  ind.mats$ob[[i]] <- ind.mats.all[rownames(ind.mats.all) %in% seq(ind.mats$start.year[i],ind.mats$end.year[i]), colnames(ind.mats.all) %in% seq(use.cols.start[i], use.cols.end[i])]
  colnames(ind.mats$ob[[i]]) <- seq(ind.mats$start.age[i], ind.mats$end.age[i])
}


write.cn(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchnumbers)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, vpa$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$natmort)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, vpa$fspawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$mspawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$spstockwt)


####################################################################################
# Georges Bank Haddock

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\GBhaddock\\"
ices.base <- "GBHADDOCK"

vpa.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
vpa.file <- "GBHADDOCK_VPA.rdat"

vpa <- dget(paste0(vpa.dir,vpa.file))
names(vpa)

start.yr <- vpa$genparms$minyear
end.yr <- vpa$genparms$maxyear
nages <- vpa$genparms$nages

### have to figure this out for each stock
ind.mats.all <- vpa$surveyobs
ind.mats <- list()
ind.mats$n <- 3
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall","DFO")
ind.mats$start.year <- c(1982, 1964, 1986)
ind.mats$end.year <- c(2016, 2016, 2016)
ind.mats$start.age <- c(1, 1, 1)
ind.mats$end.age <- c(8, 6, 8)
ind.mats$timing <- c(0.0, 0.0, 0.0)
use.cols.start <- c(1, 17, 23)
use.cols.end   <- c(8, 22, 30)
for (i in 1:ind.mats$n){
  ind.mats$ob[[i]] <- ind.mats.all[rownames(ind.mats.all) %in% seq(ind.mats$start.year[i],ind.mats$end.year[i]), colnames(ind.mats.all) %in% seq(use.cols.start[i], use.cols.end[i])]
  colnames(ind.mats$ob[[i]]) <- seq(ind.mats$start.age[i], ind.mats$end.age[i])
}


write.cn(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchnumbers)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, vpa$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$natmort)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, vpa$fspawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$mspawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$spstockwt)


####################################################################################
# American Plaice

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\Plaice\\"
ices.base <- "PLAICE"

vpa.dir <- "/home/dhennen/SAM/MGWG-master/state-space/Plaice/"
vpa.file <- "PLAICE_VPA.RDAT"

vpa <- dget(paste0(vpa.dir,vpa.file))
names(vpa)

start.yr <- vpa$genparms$minyear
end.yr <- vpa$genparms$maxyear
nages <- vpa$genparms$nages

### have to figure this out for each stock
ind.mats.all <- vpa$surveyobs
ind.mats <- list()
ind.mats$n <- 4
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall","MADMF_Spring","MADMF_Fall")
ind.mats$start.year <- c(1980, 1981, 1982, 1983)
ind.mats$end.year <- c(2016, 2016, 2016, 2016)
ind.mats$start.age <- c(1, 2, 1, 2)
ind.mats$end.age <- c(8, 8, 5, 6)
ind.mats$timing <- c(0.0, 0.0, 0.0, 0.0)
use.cols.start <- c(1, 11, 20, 26)
use.cols.end   <- c(8, 17, 24, 30)
for (i in 1:ind.mats$n){
  ind.mats$ob[[i]] <- ind.mats.all[rownames(ind.mats.all) %in% seq(ind.mats$start.year[i]
        ,ind.mats$end.year[i]), colnames(ind.mats.all) %in% seq(use.cols.start[i], use.cols.end[i])]
  ind.mats$ob[[i]]=ifelse(is.na(ind.mats$ob[[i]]),0,ind.mats$ob[[i]]) #replace NA with 0
  colnames(ind.mats$ob[[i]]) <- seq(ind.mats$start.age[i], ind.mats$end.age[i])
}


write.cn(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchnumbers)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, vpa$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$natmort)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, vpa$fspawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$mspawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$spstockwt)


####################################################################################
# Cape Cod-Gulf of Maine Yellowtail Flounder

ices.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\CCGOMyt\\"
ices.base <- "CCGOMYT"

vpa.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\ICES-WGMG\\2017Mtg\\groundfish_sam\\new_VPA_ASAP_runs\\"
vpa.file <- "CCGOMYT_VPA.rdat"

vpa <- dget(paste0(vpa.dir,vpa.file))
names(vpa)

start.yr <- vpa$genparms$minyear
end.yr <- vpa$genparms$maxyear
nages <- vpa$genparms$nages

### have to figure this out for each stock
ind.mats.all <- vpa$surveyobs
ind.mats <- list()
ind.mats$n <- 4
ind.mats$names <- c("NEFSC_Spring","NEFSC_Fall","MADMF_Spring","MADMF_Fall")
ind.mats$start.year <- c(1985, 1985, 1985, 1985)
ind.mats$end.year <- c(2016, 2016, 2016, 2016)
ind.mats$start.age <- c(1, 1, 1, 1)
ind.mats$end.age <- c(6, 5, 6, 5)
ind.mats$timing <- c(0.0, 0.50, 0.0, 0.50)
use.cols.start <- c(1,  7, 13, 19)
use.cols.end   <- c(6, 11, 18, 23)
for (i in 1:ind.mats$n){
  ind.mats$ob[[i]] <- ind.mats.all[rownames(ind.mats.all) %in% seq(ind.mats$start.year[i],ind.mats$end.year[i]), colnames(ind.mats.all) %in% seq(use.cols.start[i], use.cols.end[i])]
  colnames(ind.mats$ob[[i]]) <- seq(ind.mats$start.age[i], ind.mats$end.age[i])
}


write.cn(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchnumbers)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, vpa$maturity)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$natmort)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, vpa$fspawn)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$mspawn)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$spstockwt)


