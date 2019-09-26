# run2019.R
# run the WGMG 2019 ASAP files (3 for each stock - base, drop3, and retro)
 
# set working directory to source file location to start

library(ASAPplots)
library(dplyr)

mystocks <- c("CCGOMyt", "GBhaddock", "GBwinter", "GOMcod", "GOMhaddock", "ICEherring", "NScod", "Plaice", "Pollock", "SNEMAwinter", "SNEMAyt", "USAtlHerring", "WhiteHake")
nstocks <- length(mystocks)

n.peels <- 5

for (istock in 1:nstocks){
  mystock <- mystocks[istock]
  
  shell(paste0("copy *.exe .\\", mystock))
  
  setwd(paste0(".\\",mystock))
  
  # base run
  fname <- paste0(mystock, "_.dat")
  shell(paste("ASAP3.EXE -ind", fname), intern = TRUE)
  shell(paste0("copy asap3.rdat ", mystock, "_.rdat"))
  asap <- dget(paste0(mystock, "_.rdat"))
  
  # retro run
  retro.first.year <- asap$parms$endyr - n.peels
  fname <- paste0(mystock, "_RETRO.dat")
  shell(paste("ASAPRETRO.exe", fname, retro.first.year), intern=TRUE)
  wd <- getwd()
  asap.name <- paste0(mystock, "_RETRO")
  PlotASAP(wd, asap.name)

  fname <- paste0(mystock, "_DROP3.dat")
  shell(paste("ASAP3.EXE -ind", fname), intern = TRUE)
  shell(paste0("copy asap3.rdat ", mystock, "_DROP3.rdat"))
  
  shell("del *.exe")
  
  setwd("..\\")
}
