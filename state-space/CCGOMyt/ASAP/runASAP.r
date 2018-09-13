# runASAP.r
# run ASAP for ICES WGMG 2018
# run initial data, run intial data retro, run dropping 3 recent years of indices and predict indices
# uses Lowestoft files and convert_ICES_to_ASAP.r code to create naive ASAP run (no tuning done)
# use combination automation and by hand aspects for now, try to automate it all later

# assumes download from GitHub, so working directory is ~/MGWG/

source(".\\state-space\\helper_code\\convert_ICES_to_ASAP.r")

user.wd <- ".\\state-space\\CCGOMyt\\"
user.od <- ".\\state-space\\CCGOMyt\\ASAP\\"
model.id <- "CCGOMYT_"

# convert Lowestoft input files to vanilla ASAP
ICES2ASAP(user.wd, user.od, model.id)

# externally run ASAP in different directory
#  copy ASAP_<model.id>.rdat file into user.od directory

# externally run ASAP retro (5 year peel) in different directory
# externally run ASAPplots on the retro run
#  copy Retro.rho.values_ASAP_<model.id>RETRO_000.csv into user.od directory
#  copy CV.All.Params.ASAP_<model.id>RETRO_000.csb into user.od directory

# externally modify ASAP file to drop recent 3 years of index data and run in different directory
#  copy ASAP_<model.id>DROP3.rdat file into user.od directory

# remember to change working directory back to MGWG
setwd("C:\\Users\\chris.legault\\Desktop\\qqq\\MGWG")

# create Mohn.txt
mohns.rho <- read.csv(paste0(user.od,"Retro.rho.values_ASAP_",model.id,"RETRO_000.csv"), header = TRUE)
mohns.rho
mohns.rho.table <- data.frame(R = mohns.rho$recr.rho[mohns.rho$X == "Mohn.rho"], 
                              SSB = mohns.rho$ssb.rho[mohns.rho$X == "Mohn.rho"], 
                              Fbar = mohns.rho$f.rho[mohns.rho$X == "Mohn.rho"])
mohns.rho.table
write.csv(mohns.rho.table, file = paste0(user.od, "Mohn.txt"), row.names = FALSE)

# create tab1.csv time series of F, SSB, Recruits, and Predicted Catch with 95% CI (except PredCatch)
asap <- dget(paste0(user.od, "ASAP_", model.id, ".rdat"))
Year <- seq(asap$parms$styr, asap$parms$endyr)
PredCatch <- as.numeric(asap$catch.pred)
res <- read.csv(paste0(user.od,"CV.All.Params.ASAP_",model.id,"RETRO_000.csv"), header = TRUE)
res
res.f <- res %>%
  filter(name == "Freport") %>%
  mutate(Frep = value,
         sigma = sqrt(log(1 + CV*CV)),
         Low = value * exp(-1.96 * sigma),
         High = value * exp(1.96 * sigma)) %>%
  select(Frep, Low, High)
res.ssb <- res %>%
  filter(name == "SSB") %>%
  mutate(SSB = value,
         sigma = sqrt(log(1 + CV*CV)),
         Low = value * exp(-1.96 * sigma),
         High = value * exp(1.96 * sigma)) %>%
  select(SSB, Low, High)
res.r <- res %>%
  filter(name == "recruits") %>%
  mutate(R = value,
         sigma = sqrt(log(1 + CV*CV)),
         Low = value * exp(-1.96 * sigma),
         High = value * exp(1.96 * sigma)) %>%
  select(R, Low, High)

res.table <- cbind(Year, res.f, res.ssb, res.r, PredCatch)
write.csv(res.table, file = paste0(user.od, "tab1.csv"), row.names = FALSE)

# create tab2.csv observed (but dropped) and predicted indices from last 3 years (no SD available)
tab2 <- data.frame(Year = integer(),
                   Index = integer(),
                   Age = integer(),
                   logObs = double(),
                   Pred = double())

for (ind in 1:asap$parms$nindices){
  start.age <- asap$control.parms$index.sel.start.age[ind]
  end.age <- asap$control.parms$index.sel.end.age[ind]
  ind.sel <- asap$index.sel[ind, ]
  ind.q <- asap$q.indices[ind]
  ind.timing <- asap$control.parms$index.month[ind]
  ind.units.aggregate <- asap$control.parms$index.units.aggregate[ind] # 1=biomass, 2=numbers
  ind.units.props <- asap$control.parms$index.units.proportions[ind]   # 1=biomass, 2=numbers
  ind.age.comps.flag <- asap$control.parms$index.age.comp.flag[ind]

  # check to make sure using indices in numbers not biomass (should be due to ICES2ASAP)
  if (ind.units.aggregate == 1 | ind.units.props == 1){
    stop("Index Units in Biomass not Numbers")
  }
  
  # start with observed values from original run
  ob.agg <- asap$index.obs[[ind]]
  ob.props <- as.data.frame(asap$index.comp.mats[[(ind - 1) * 2 + 1]])
  ob.atage <- ob.agg  * ob.props
  ob.atage$Year <- as.numeric(rownames(ob.props))
  ob.df <- ob.atage %>%
    gather(key = Age, value = Obs, 1:asap$parms$nages) %>%
    filter(Age %in% seq(start.age, end.age), Year %in% seq(asap$parms$endyr - 2, asap$parms$endyr)) %>%
    filter(Obs > 0) %>%
    mutate(logObs = log(Obs)) %>%
    select(Year, Age, logObs)
  
  # adjust for timing of survey
  if (ind.timing == -1){
    tempNAA <- asap$N.age * (1 - exp(-asap$Z.age)) / asap$Z.age
  }else{
    tempNAA <- asap$N.age * exp(-1.0 * asap$Z.age * (ind.timing - 1) / 12)
  }
  
  # compute predicted index values by applying survey selectivity and catchability
  pred.atage <- as.data.frame(cbind(tempNAA * outer(rep(1, asap$parms$nyears), ind.sel) * ind.q, Year))
  pred.df <- pred.atage %>%
    gather(key = Age, value = PredVal, 1:asap$parms$nages) %>%
    filter(Age %in% seq(start.age, end.age), Year %in% seq(asap$parms$endyr - 2, asap$parms$endyr)) %>%
    mutate(Pred = log(PredVal)) %>%
    select(Year, Age, Pred)
  
  # join the obs and pred
  tab2ind <- left_join(ob.df, pred.df, by = c("Year", "Age")) %>%
    mutate(Index = ind)
  tab2 <- rbind(tab2, tab2ind)
}
tab2final <- tab2 %>%
  arrange(Year, Index, Age) %>%
  select(Year, Index, Age, logObs, Pred)
tab2final
write.csv(tab2final, file = paste0(user.od, "tab2.csv"), row.names = FALSE)

