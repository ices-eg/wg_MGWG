## convert_VPA_ICES
## convert VPA rdat file to ICES input format for use in SAM
## created 10 Sep 2018 Arni Magnusson
## based on comments found in convert_VPA_ICES.r

source("../helper_code/convert_VPA_ICES.r")
suppressWarnings(dir.create("ices_data"))  # dest dir

################################################################################
## Icelandic herring

ices.dir <- "./"
ices.base <- "ices_data/"

vpa.dir <- "./"
vpa.file <- "RUN1NWWG.RDAT"

vpa <- dget(paste0(vpa.dir,vpa.file))

start.yr <- vpa$genparms$minyear
end.yr <- vpa$genparms$maxyear
nages <- vpa$genparms$nages

## Have to figure this out for each stock
ind.mats.all <- vpa$surveyobs
ind.mats <- list()
ind.mats$n <- 1
ind.mats$names <- "Acoustic"
ind.mats$start.year <- 1987
ind.mats$end.year <- 2017
ind.mats$start.age <- 4
ind.mats$end.age <- 11
ind.mats$timing <- 0
use.cols.start <- 1
use.cols.end <- 8
for (i in 1:ind.mats$n){
  ind.mats$ob[[i]] <- ind.mats.all[rownames(ind.mats.all) %in%
                                   seq(ind.mats$start.year[i],
                                       ind.mats$end.year[i]),
                                   colnames(ind.mats.all) %in%
                                   seq(use.cols.start[i],
                                       use.cols.end[i])]
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

from <- paste0(ices.base, dir(ices.base))  # single slash
to <- sub("/_", "/", from)
file.rename(from, to)
