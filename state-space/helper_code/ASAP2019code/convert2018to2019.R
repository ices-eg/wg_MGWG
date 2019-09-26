# convert2018to2019.R
# convert the ASAP files used in WGMG2018 to WGMG2019
# change all selectivities from single logistic to double logistic
# use three time blocks for fleet selectivity instead of 1
# uses read and write ASAP functions from WKFORBIAS project

# set working directory to source file location to start

library(ASAPplots)
library(dplyr)

##################################################################
# function to convert WGMG2018 ASAP files to WGMG2019 files
# change from 1 to 3 fleet selectivity blocks
# change all selectivities from single logistic to double logistic
convert2018to2019 <- function(datf){
  
  datf$dat$n_fleet_sel_blocks <- 3
  
  tempselb <- datf$dat$sel_block_assign[[1]]
  ny <- length(tempselb)
  tempselb[(ny-9):ny] <- 3
  tempselb[(ny-19):(ny-10)] <- 2
  datf$dat$sel_block_assign[[1]] <- tempselb
  
  datf$dat$sel_block_option <- rep(3, 3)
  
  datf$dat$sel_ini[[2]] <- datf$dat$sel_ini[[1]]
  datf$dat$sel_ini[[3]] <- datf$dat$sel_ini[[1]]

#  could not get sufficient convergence with any doming in indices  
#  datf$dat$index_sel_option <- rep(3, datf$dat$n_indices)
#  datf$dat$index_sel_option[1] <- 2 # arbirarily make first index to logistic

  nc <- 1:length(datf$comments)
  ncstart <- nc[datf$comments == "# Selectivity Block #1 Data "]
  tempcomments <- c(datf$comments[1:ncstart], 
                    "# Selectivity Block #2 Data ",
                    "# Selectivity Block #3 Data ",
                    datf$comments[(ncstart+1):length(datf$comments)])
  datf$comments <- tempcomments
  
  return(datf)
}
##################################################################

mystocks <- c("CCGOMyt", "GBhaddock", "GBwinter", "GOMcod", "GOMhaddock", "ICEherring", "NScod", "Plaice", "Pollock", "SNEMAwinter", "SNEMAyt", "USAtlHerring", "WhiteHake")
nstocks <- length(mystocks)
mysuffix <- rep("ICES2ASAP", nstocks)
mysuffix[mystocks == "NScod"] <- ""
mysuffix[mystocks == "USAtlHerring"] <- ""

for (istock in 1:nstocks){
  mystock <- mystocks[istock]

  if (!dir.exists(mystock)) dir.create(mystock)
  
  orig.dir <- paste0("..\\..\\2018Mtg\\mylocalruns\\ICES WGMG 2018 my runs\\",
                     mystock, mysuffix[istock], "\\")
  
  runs <- c("", "DROP3", "RETRO")
  
  for (irun in 1:3){
    filef <- paste0(mystock, "_", runs[irun])

    datf <- WKFORBIAS::ReadASAP3DatFile(paste0(orig.dir, "ASAP_", filef, ".DAT"))
    
    datf2019 <- convert2018to2019(datf)
    
    WKFORBIAS::WriteASAP3DatFile(paste0(mystock, "\\", filef, ".dat"),
                                 datf2019, "convert2018to2019")
    
  }
  
}

