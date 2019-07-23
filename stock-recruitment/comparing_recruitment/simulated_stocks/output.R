# output.R - DESC
# /output.R

# Copyright European Union, 2019
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.


# LOAD PKGS

library(FLCore)
library(data.table)

# LOAD OMs

load("out/oms.RData")
load("out/metrics.RData")

# REGISTER ncores

library(parallel)
library(doParallel)

ncores <- min(nrow(runs), floor(detectCores() * 0.9))

registerDoParallel(ncores)

# GET writeVPAFiles

source("R/functions.R")

# VARIABLES

its <- dim(m(oms[[1]]))[6]

# -- SA INPUTS

# VPA

res <- foreach(i=seq(nrow(runs))) %dopar% {

  paths <- file.path("sa/vpa", paste0("r", i), paste0("iter", seq(its)))

  for(j in seq(its)) {
  
    # CREATE FLIndices
    idxs <- FLIndices(A=FLIndex(index=iter(index[[i]], j),
      effort=FLQuant(1, dimnames=dimnames(iter(index[[1]], 1))["year"]),
      name="A", desc="Simulated", range=c(startf=0, endf=0)))

    # CREATE folder, if missing
    if(!dir.exists(paths[j]))
      dir.create(paths[j], recursive=TRUE)

    # DELETE existing files
    del <- file.remove(dir(paths[j], pattern='*.txt', full.name=TRUE))

    # WRITE VPA files FLStock + FLIndices)
    writeVPAFiles(window(iter(oms[[i]], j), start=42),
      indices=lapply(idxs, window, start=42), file=file.path(paths[[j]], "sim"))
  }
}

system("(cd sa; zip -r9X vpa.zip vpa/;)")

# ASAP

# a4a

indices <- FLIndices(setNames(lapply(index, function(x) {
    x[x == 0] <- 1e-12
    x <- FLIndex(name="A", index=window(x, start=42))
    range(x, c("startf", "endf")) <- c(0, 0)
    return(x)
  }), names(index)))

stocks <- lapply(oms, function(x) {
    x <- window(x, start=42)
    stock.n(x) <- 0
    harvest(x) <- 0
    return(x)
  })

save(indices, stocks, res, runs, file="sa/a4a/a4a.RData", compress="xz")

# SAM

# CASAL

# S/R TSs

# TRUE F, rec, Q as DF, txt / VPA files
