# redo2018tab2.R
# error in tab2 from 2018 ICES WGMG fixed
# was not using DROP3 results to estimate predicted index values

# set working directory to source file location to begin

library(dplyr)
library(tidyr)
library(ggplot2)

mystocks <- c("CCGOMyt", "GBhaddock", "GBwinter", "GOMcod", "GOMhaddock", "ICEherring", "NScod", "Plaice", "Pollock", "SNEMAwinter", "SNEMAyt", "USAtlHerring", "WhiteHake")
nstocks <- length(mystocks)
mysuffix <- rep("ICES2ASAP", nstocks)
mysuffix[mystocks == "NScod"] <- ""
mysuffix[mystocks == "USAtlHerring"] <- ""

out.dir <- "C:\\Users\\chris.legault\\Desktop\\redo2018tab2\\"

get_tab2 <- function(asap, asapd3, mystock){
  Year <- seq(asap$parms$styr, asap$parms$endyr)
  PredCatch <- as.numeric(asap$catch.pred)
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
  
  return(tab2final)
}

for (istock in 1:nstocks){
  
  mystock <- mystocks[istock]

  orig.dir <- paste0("..\\..\\2018Mtg\\mylocalruns\\ICES WGMG 2018 my runs\\",
                     mystock, mysuffix[istock], "\\")
  
  # read in the two rdat files
  myasap <- dget(paste0(mystock, "\\", mystock, "_.rdat"))
  myasapd3 <- dget(paste0(mystock, "\\", mystock, "_DROP3.rdat"))
  
  tab2final <- get_tab2(myasap, myasapd3, mystock)
  
  tt2 <- tab2final
  tt2$stock <- mystock
  if (istock == 1){
    tab2.all <- tt2
  }else{
    tab2.all <- rbind(tab2.all, tt2)
  }
  
  tab2finalbad <- get_tab2(myasap, myasap, mystock)
  
  tt2bad <- tab2finalbad
  tt2bad$stock <- mystock
  if (istock == 1){
    tab2.all.bad <- tt2bad
  }else{
    tab2.all.bad <- rbind(tab2.all.bad, tt2bad)
  }
  
  
}
write.csv(tab2.all, file = paste0(out.dir, "tab2_all.csv"), row.names = FALSE)
write.csv(tab2.all.bad, file = paste0(out.dir, "tab2_all_bad.csv"), row.names = FALSE)

good.plot <- ggplot(tab2.all, aes(x=logObs, y=Pred, color=stock)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()
print(good.plot)

bad.plot <- ggplot(tab2.all.bad, aes(x=logObs, y=Pred, color=stock)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()
print(bad.plot)

# compare Pred
cc <- data.frame(good = tab2.all$Pred, 
                 bad = tab2.all.bad$Pred) %>%
  mutate(diff = good - bad)
summary(cc)

# Yup, got it wrong the first time, so need to overwrite the 2018 tab2 files
out2018.dir <- "C:\\Users\\chris.legault\\Desktop\\qqq\\wg_MGWG\\state-space\\"

for (istock in 1:nstocks){
  
  mystock <- mystocks[istock]
  
  orig.dir <- paste0(out2018.dir, mystock, "\\ASAP\\")
  
  od <- paste0(out2018.dir, mystock, "\\ASAP")
  
  # read in the two rdat files
  myasap <- dget(paste0(orig.dir, "ASAP_", mystock, "_.rdat"))
  myasapd3 <- dget(paste0(orig.dir, "ASAP_", mystock, "_DROP3.rdat"))
  
  tab2final <- get_tab2(myasap, myasapd3, mystock)
  
  write.csv(tab2final, file = paste0(od, "\\tab2.csv"), row.names = FALSE)
  
}
