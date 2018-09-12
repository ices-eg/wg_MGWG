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
ind.pred.at.age.df <- data.frame(ProjYear = integer(),
                                 Index = integer(),
                                 Age = integer(),
                                 Boot = integer(),
                                 PredIndexProp = double())

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
    
    # compute all bootstraps at once using matrices
    Fmat <- outer(Fmult.proj, Selvec)
    Mmat <- outer(rep(1, nboots), Mvec)
    Zmat <- Mmat + Fmat
    
    # adjust for timing of survey
    if (ind.timing == -1){
      tempNAA <- N.age.proj * (1 - exp(-Zvec)) / Zvec
    }else{
      tempNAA <- N.age.proj * exp(-1.0 * Zvec * (ind.timing - 1) / 12)
    }
    tempBAA <- tempNAA * outer(rep(1, nboots), Catchwt) # need to change this to correct index WAA
    
    # check whether aggregate index in numbers or biomass
    tempPAA <- tempNAA
    if (ind.units.aggregate == 1) tempPAA <- tempBAA
    
    # compute predicted aggregate index
    # need to add start and end age checks here
    index.pred <- tempPAA * outer(rep(1, nboots), ind.sel) * ind.q 
    ind.pred.agg <- apply(index.pred, 1, sum, na.rm = TRUE)

    # build the aggregate index data frame
    thisdf <- data.frame(ProjYear = iproj,
                         Index = ind,
                         Boot = seq(1, nboots),
                         PredIndex = ind.pred.agg)
    ind.pred.agg.df <- rbind(ind.pred.agg.df, thisdf)
    
    # check whether index proportions in numbers of biomass
    tempPAAp <- tempNAA
    if (ind.units.props == 1) tempPAAp <- tempBAA
    
    # compute predicted index proportions at age
    # need to add start and end age checks here
    index.pred.at.age <- tempPAAp * outer(rep(1, nboots), ind.sel) * ind.q 
    index.pred.at.age.props <- index.pred.at.age / rowSums(index.pred.at.age)
    
    # build the proportions data frmae
    thisaadf <- data.frame(ProjYear = iproj,
                           Index = ind,
                           Age = rep(1:nages, nboots),
                           Boot = iboot,
                           PredIndexProp = as.numeric(t(index.pred.at.age.props)))
    ind.pred.at.age.df <- rbind(ind.pred.at.age.df, thisaadf)
    ####################################################################
    # # loop through bootstraps (should be able to do this using matrix operations instead)
    # for (iboot in 1:nboots){
    #   Fvec <- Fmult.proj[iboot] * Selvec
    #   Zvec <- Mvec + Fvec
    #   # adjsut for timing of survey
    #   if (ind.timing == -1){
    #     tempNAA <- N.age.proj[iboot, ] * (1 - exp(-Zvec)) / Zvec
    #   }else{
    #     tempNAA <- N.age.proj[iboot, ] * exp(-1.0 * Zvec * (ind.timing - 1) / 12)
    #   }
    #   tempBAA <- tempNAA * Catchwt # need to change this to correct index WAA
    #   
    #   # check whether aggregate index in numbers or biomass
    #   tempPAA <- tempNAA
    #   if (ind.units.aggregate == 1) tempPAA <- tempBAA
    #   
    #   # compute predicted aggregate index
    #   index.pred <- tempPAA * ind.sel * ind.q # need to add start and end age checks here
    #   ind.pred.agg[iboot] <- sum(index.pred, na.rm = TRUE)
    #   
    #   # check whether index proportions in numbers of biomass
    #   tempPAAp <- tempNAA
    #   if (ind.units.props == 1) tempPAAp <- tempBAA
    #   
    #   # compute predicted index proportions at age
    #   index.pred.at.age <- tempPAAp * ind.sel * ind.q # need to add start and end age checks here
    #   index.pred.at.age <- index.pred.at.age / sum(index.pred.at.age, na.rm = TRUE)
    #   thisaadf <- data.frame(ProjYear = iproj,
    #                          Index = ind,
    #                          Age = 1:nages,
    #                          Boot = iboot,
    #                          PredIndexProp = index.pred.at.age)
    #   ind.pred.at.age.df <- rbind(ind.pred.at.age.df, thisaadf)
    # }
    # # build the aggregate index data frame
    # thisdf <- data.frame(ProjYear = iproj,
    #                      Index = ind,
    #                      Boot = seq(1, nboots),
    #                      PredIndex = ind.pred.agg)
    # ind.pred.agg.df <- rbind(ind.pred.agg.df, thisdf)
  }
}
