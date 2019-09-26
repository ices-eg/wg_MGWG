# gather2019.R
# gather the needed info from all the 2019 ASAP runs for ICES WGMG

# set working directory to source file location to begin

library(dplyr)
library(tidyr)

mystocks <- c("CCGOMyt", "GBhaddock", "GBwinter", "GOMcod", "GOMhaddock", "ICEherring", "NScod", "Plaice", "Pollock", "SNEMAwinter", "SNEMAyt", "USAtlHerring", "WhiteHake")
nstocks <- length(mystocks)

out.dir <- "C:\\Users\\chris.legault\\Desktop\\qqq\\MGWG\\state-space\\"
#out.dir <- "C:\\Users\\chris.legault\\Desktop\\tempowgmg\\"

mohns.rho.fixed <- rep("No", nstocks)

for (istock in 1:nstocks){
  mystock <- mystocks[istock]
  
  od <- paste0(out.dir, mystock, "\\ASAP_dome_block_sel")
  if (!dir.exists(paste0(out.dir, mystock))) dir.create(paste0(out.dir, mystock))
  if (!dir.exists(od)) dir.create(od)
  
  # create Mohn.txt
  mohns.rho <- read.csv(paste0(mystock,"\\plots\\Retro.rho.values_",mystock,"_RETRO_000.csv"), header = TRUE)
  
  # check for ridiculous peels
  nrows <- length(mohns.rho[,1])
  if (max(mohns.rho$ssb.rho, na.rm = TRUE) >= 1000){
    mohns.rho.fixed[istock] <- "Yes"
    mohns.rho[mohns.rho$ssb.rho >= 1000, ] <- NA
    mohns.rho$X[nrows] <- "Mohn.rho"
    mohns.rho$f.rho[nrows] <- mean(mohns.rho$f.rho, na.rm = TRUE)
    mohns.rho$ssb.rho[nrows] <- mean(mohns.rho$ssb.rho, na.rm = TRUE)
    mohns.rho$recr.rho[nrows] <- mean(mohns.rho$recr.rho, na.rm = TRUE)
  }
  mohns.rho.table <- data.frame(R = mohns.rho$recr.rho[nrows], 
                                SSB = mohns.rho$ssb.rho[nrows], 
                                Fbar = mohns.rho$f.rho[nrows])
  #mohns.rho.table
  write.csv(mohns.rho.table, file = paste0(od, "\\Mohn.txt"), row.names = FALSE)
  
  # create tab1.csv time series of F, SSB, Recruits, and Predicted Catch with 95% CI (except PredCatch)
  asap <- dget(paste0(mystock, "\\", mystock, "_.rdat"))
  Year <- seq(asap$parms$styr, asap$parms$endyr)
  PredCatch <- as.numeric(asap$catch.pred)
  cvfile <- paste0(mystock,"\\plots\\CV.All.Params.",mystock,"_RETRO_000.csv")
  if (file.exists(cvfile)){
    res <- read.csv(cvfile, header = TRUE)
    #res
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
  }else{
    res.f <- data.frame(Frep = asap$F.report,
                        Low = NA,
                        High = NA)
    res.ssb <- data.frame(SSB = asap$SSB,
                          Low = NA,
                          High = NA)
    res.r <- data.frame(R = asap$N.age[,1],
                        Low = NA,
                        High = NA)
  }
  res.table <- cbind(Year, res.f, res.ssb, res.r, PredCatch)
  write.csv(res.table, file = paste0(od, "\\tab1.csv"), row.names = FALSE)
  
  # create tab2.csv observed (but dropped) and predicted indices from last 3 years (no SD available)

  # read in DROP3 rdat file to estimate predicted indices for missing years
  asapd3 <- dget(paste0(mystock, "\\", mystock, "_DROP3.rdat"))
  tab2 <- data.frame(Year = integer(),
                     Index = integer(),
                     Age = integer(),
                     logObs = double(),
                     Pred = double())
  
  for (ind in 1:asapd3$parms$nindices){
    
    start.age <- asapd3$control.parms$index.sel.start.age[ind]
    end.age <- asapd3$control.parms$index.sel.end.age[ind]
    # start with observed values from original run
    # note: using asap not asapd3 here
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
    
    # now compile the info needed to calculate the predicted indices
    ind.sel <- asapd3$index.sel[ind, ]
    ind.q <- asapd3$q.indices[ind]
    ind.timing <- asapd3$control.parms$index.month[ind]
    ind.units.aggregate <- asapd3$control.parms$index.units.aggregate[ind] # 1=biomass, 2=numbers
    ind.units.props <- asapd3$control.parms$index.units.proportions[ind]   # 1=biomass, 2=numbers
    ind.age.comps.flag <- asapd3$control.parms$index.age.comp.flag[ind]
    
    # check to make sure using indices in numbers not biomass (should be due to ICES2ASAP)
    if (ind.units.aggregate == 1 | ind.units.props == 1){
      stop("Index Units in Biomass not Numbers")
    }
    
    # adjust for timing of survey
    if (ind.timing == -1){
      tempNAA <- asapd3$N.age * (1 - exp(-asapd3$Z.age)) / asapd3$Z.age
    }else{
      tempNAA <- asapd3$N.age * exp(-1.0 * asapd3$Z.age * (ind.timing - 1) / 12)
    }
    
    # compute predicted index values by applying survey sel and catchability
    pred.atage <- as.data.frame(cbind(tempNAA * outer(rep(1, asapd3$parms$nyears), ind.sel) * ind.q, Year))
    pred.df <- pred.atage %>%
      gather(key = Age, value = PredVal, 1:asapd3$parms$nages) %>%
      filter(Age %in% seq(start.age, end.age), Year %in% seq(asapd3$parms$endyr - 2, asapd3$parms$endyr)) %>%
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
  #tab2final
  write.csv(tab2final, file = paste0(od, "\\tab2.csv"), row.names = FALSE)
  
  
  # some summary tables
  mm <- mohns.rho.table
  mm$stock <- mystock
  if (istock == 1){
    mohn.rho.table.all <- mm
  }else{
    mohn.rho.table.all <- rbind(mohn.rho.table.all, mm)
  }
  
  tt1 <- res.table
  tt1$stock <- mystock
  if (istock == 1){
    tab1.all <- tt1
  }else{
    tab1.all <- rbind(tab1.all, tt1)
  }
  
  tt2 <- tab2final
  tt2$stock <- mystock
  if (istock == 1){
    tab2.all <- tt2
  }else{
    tab2.all <- rbind(tab2.all, tt2)
  }
  
}
mohn.rho.table.all$fixed <- mohns.rho.fixed
write.csv(mohn.rho.table.all, file = paste0(out.dir, "Mohn_all.csv"), row.names = FALSE)
write.csv(tab1.all, file = paste0(out.dir, "tab1_all.csv"), row.names = FALSE)
write.csv(tab2.all, file = paste0(out.dir, "tab2_all.csv"), row.names = FALSE)

# a little extra plot just to take a quick look
library(ggplot2)
ggplot(tab2.all, aes(x=logObs, y=Pred, color=stock)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()
