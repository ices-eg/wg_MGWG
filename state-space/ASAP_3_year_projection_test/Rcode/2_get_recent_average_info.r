source("1_check_data.r")

# 2_get_recent_average_info.r
# compute the recent averages needed for projections from the <asap.file.name>_DROP3.rdat file

# remember to set working directory to source file location

### important user selection ###
nyrs.avg <- 5  # number of recent years used in average

# grab the number of years from the drop3 case
nyears <- asap$parms$nyears

# compute the recent averages for M, selectivity, catch weight at age, and SSB weight at age
Mvec <- apply(asap$M.age[(nyears - nyrs.avg + 1):nyears, ], 2, mean)
Fvec <- apply(asap$F.age[(nyears - nyrs.avg + 1):nyears, ], 2, mean)
Selvec <- Fvec / max(Fvec)
Catchwt <- apply(asap$WAA.mats$WAA.catch.all[(nyears - nyrs.avg + 1):nyears, ], 2, mean)
SSBwt <- apply(asap$WAA.mats$WAA.ssb[(nyears - nyrs.avg + 1):nyears, ], 2, mean)

### important user selection ###
recruitment.years <- seq((nyears - 10), (nyears - 1)) # other common options: all years or (nyears-9):nyears
recruits <- asap$N.age[c(recruitment.years), 1]
