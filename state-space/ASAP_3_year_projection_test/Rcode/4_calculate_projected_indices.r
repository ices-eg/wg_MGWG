source("3_project_three_years.r")

# 4_calculate_predicted_indices.r
# have to apply survey timing, selectivity, and catchability to get predicted indices

# remember to set working directory to source file location

# asap$control.parms has details about index options 
# need to deal with numbers vs weight as well as start and end ages

# loop through the 3 projection years computing predicted indices and indices at age
ind.pred.agg.df <- data.frame(ProjYear = integer(),
                              Index = integer(),
                              Boot = integer(),
                              PredIndex = double())

for (iproj in 1:3){
  N.age.proj <- N.age.mat[, ((iproj - 1) * nages + 1): ((iproj - 1) * nages + nages)]
  Fmult.proj <- Fmult.mat[, iproj]
  for (ind in 1:nindices){
    start.age <- asap$control.parms$index.sel.start.age[ind]
    end.age <- asap$control.parms$index.sel.end.age[ind]
    ind.sel <- asap$index.sel[ind, ]
    ind.q <- asap$q.indices[ind]
    ind.timing <- asap$control.parms$index.month[ind]
    ind.units.aggregate <- asap$control.parms$index.units.aggregate[ind] # 1=biomass, 2=numbers
    ind.units.props <- asap$control.parms$index.units.proportions[ind]   # 1=biomass, 2=numbers
    ind.age.comps.flag <- asap$control.parms$index.age.comp.flag[ind]
    ind.pred.agg <- rep(NA, nboots) # container for predicted aggregate index
    
    # loop through bootstraps (should be able to do this using matrix operations instead)
    for (iboot in 1:nboots){
      Fvec <- Fmult.proj[iboot] * Selvec
      Zvec <- Mvec + Fvec
      # adjsut for timing of survey
      if (ind.timing == -1){
        tempNAA <- N.age.proj[iboot, ] * (1 - exp(-Zvec)) / Zvec
      }else{
        tempNAA <- N.age.proj[iboot, ] * exp(-1.0 * Zvec * (ind.timing - 1) / 12)
      }
      tempBAA <- tempNAA * Catchwt # need to change this to correct index WAA
      
      # check whether numbers or biomass
      tempPAA <- tempNAA
      if (ind.units.aggregate == 1) tempPAA <- tempBAA
      
      # compute predicted aggregate index
      index.pred <- tempPAA * ind.sel * ind.q # need to add start and end age checks here
      ind.pred.agg[iboot] <- sum(index.pred, na.rm = TRUE)
    }
    thisdf <- data.frame(ProjYear = iproj,
                         Index = ind,
                         Boot = seq(1, nboots),
                         PredIndex = ind.pred.agg)
    ind.pred.agg.df <- rbind(ind.pred.agg.df, thisdf)
  }
}
