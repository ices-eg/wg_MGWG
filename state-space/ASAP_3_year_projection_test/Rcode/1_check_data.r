source("0_functions.r")

# 1_check_data.r
# check to make sure have the two runs needed 
# - one with all years and the other dropping the recent 3 years, the latter needs an MCMC run also
# does some simple checks on the data as well

# remember to set the working directory to source file location to begin

# assumes the following directory structure and files
# main
# - data   # contains <asap.file.name>.rdat, <>_DROP3.rdat, and <>_DROP3_MCMC.BSN
# - Rcode  # all the R code needed for analyses
# - output # where all the resulting plots and csv files are put

### important user selection ###
asap.file.name <- "SNEMAYT_ASAP"

# check to see if the three files are in the data directory
if (!file.exists(paste0("..\\data\\", asap.file.name, ".rdat"))){
  stop("Missing original asap rdat file")
}

if (!file.exists(paste0("..\\data\\", asap.file.name, "_DROP3.rdat"))){
  stop("Missing asap rdat file when recent 3 years dropped")
}

if (!file.exists(paste0("..\\data\\", asap.file.name, "_DROP3_MCMC.BSN"))){
  stop("Missing asap MCMC BSN file when recent 3 years dropped")
}

# read the files
asap.full <- dget(paste0("..\\data\\", asap.file.name, ".rdat"))
asap <- dget(paste0("..\\data\\", asap.file.name, "_DROP3.rdat"))
bsn <- read.table(paste0("..\\data\\", asap.file.name, "_DROP3_MCMC.BSN"), header = FALSE)

# check to make sure catch time series are the same
catch.check <- cbind(apply(asap.full$catch.obs, 2, sum), c(apply(asap$catch.obs, 2, sum), rep(NA, 3)))  
catch.check2 <- catch.check[1:(length(catch.check[,1]) - 3),]
catch.check3 <- catch.check2[,2] - catch.check2[,1]
if (sum(abs(catch.check3)) != 0){
  stop("Catch from the two rdat files not equal - see catch.check")
}

# get catch for the 3 projection years from asap.full
catch3proj <- catch.check[(asap.full$parms$nyears - 2):asap.full$parms$nyears, 1]

# get observed indices and indices at age for the 3 projection years from asap.full
# note: need to add checks for missing indices in 3 projection years and indices at age less than all ages
nindices <- asap.full$parms$nindices
indices3proj <- matrix(NA, nrow = nindices, ncol = 3)
indicesatage3proj <- data.frame(Index = integer(),
                                Year = integer(),
                                Age = integer(),
                                IndexAtAge = double())
for (ind in 1:nindices){
  tempind <- data.frame(Year = asap.full$index.year[[ind]], 
                        Indx = asap.full$index.obs[[ind]])
  indices3proj[ind,] <- tempind %>%
    filter(Year %in% seq(asap.full$parms$endyr - 2, asap.full$parms$endyr)) %>%
    select(Indx) %>%
    unlist()
  tempindatage <- asap.full$index.comp.mats[[(ind - 1) * 2 + 1]]
  thisiaadf <- data.frame(Index = ind,
                          ProjYear = rep(1:3, each = asap.full$parms$nages),
                          Age = rep(seq(1, asap.full$parms$nages), 3),
                          ObsIndexAtAge = c(tempindatage[asap.full$parms$nyears-2,],
                                            tempindatage[asap.full$parms$nyears-1,],
                                            tempindatage[asap.full$parms$nyears,]))
  indicesatage3proj <- rbind(indicesatage3proj, thisiaadf)
}

# turn into data frames for easier ggplotting
indices3proj.df <- data.frame(ProjYear = rep(1:3, each = nindices),
                              Index = rep(1:nindices, 3),
                              ObsIndex = as.numeric(indices3proj))

# get Mohn's rho - assumed ASAPplots has been applied to retro run 
# assumes Retro.rho.values_<asap.file.name>_DROP3_RETRO_000.csv copied into data directory
mohn.rho.dat <- read.csv(paste0("..\\data\\Retro.rho.values_", asap.file.name, "_DROP3_RETRO_000.csv"), header = TRUE)


mohns.rho.Freport <- mohn.rho.dat$f.rho[mohn.rho.dat$X == "Mohn.rho"]
mohns.rho.ssb <- mohn.rho.dat$ssb.rho[mohn.rho.dat$X == "Mohn.rho"]
# alternatively can select age specific Mohn's rho values
mohns.rho.naa <- mohn.rho.dat[mohn.rho.dat$X == "Mohn.rho", seq(8, 7 + asap$parms$nages)]

### important user selection ###
mohn.rho.option <- "SSB" # alternatively can be "NAA" to use mohns.rho.naa to adjust projections

# get 90% CI from MCMC runs for SSB and Freport - assumes ASAPplots has been applied to MCMC run
# assumes Freport.90pi_ and ssb.90pi_ <asap.file.name>_DROP3_MCMC.csv files copied to data directory
FreportMCMC <-  read.csv(paste0("..\\data\\Freport.90pi_", asap.file.name, "_DROP3_MCMC.csv"), header = TRUE)
SSBMCMC <- read.csv(paste0("..\\data\\ssb.90pi_", asap.file.name, "_DROP3_MCMC.csv"), header = TRUE)

FreportCI <- as.numeric(FreportMCMC[length(FreportMCMC[,1]), c(2, 4)])
SSBCI <- as.numeric(SSBMCMC[length(SSBMCMC[,1]), c(2, 4)])

# determine whether Mohn's rho adjustment should be applied or not
# based on whether rho adusted values for SSB and Frepor within 90% CI (Brooks and Legault 2017)
mohns.rho <- 0
Freportpoint <- asap$F.report[length(asap$F.report)]
SSBpoint <- asap$SSB[length(asap$SSB)]
Freportadj <- Freportpoint / (1 + mohns.rho.Freport)
SSBadj <- SSBpoint / (1 + mohns.rho.ssb)
if (Freportadj < FreportCI[1] | Freportadj > FreportCI[2]){
  if (mohn.rho.option == "SSB") mohns.rho <- mohns.rho.ssb
  if (mohn.rho.option == "NAA") mohns.rho <- mohns.rho.naa
} 
if (SSBadj < SSBCI[1] | SSBadj > SSBCI[2]){
  if (mohn.rho.option == "SSB") mohns.rho <- mohns.rho.ssb
  if (mohn.rho.option == "NAA") mohns.rho <- mohns.rho.naa
} 

# make the Mohn's rho plot
mohn.rho.df <- data.frame(Source = c("Point", "Adjusted"),
                          SSB = c(SSBpoint, SSBadj),
                          Freport = c(Freportpoint, Freportadj))
mohn.rho.CI.df <- data.frame(Source = "MCMC",
                             SSB = c(SSBCI, rev(SSBCI)),
                             Freport = rep(FreportCI, each = 2))

mohn.rho.plot <- ggplot(mohn.rho.df, aes(x=SSB, y=Freport, group="Source")) +
  geom_point() +
  geom_line() +
  geom_point(data = filter(mohn.rho.df, Source == "Adjusted"), aes(x=SSB, y=Freport, color="red"), show.legend = FALSE) +
  geom_polygon(data = mohn.rho.CI.df, aes(x=SSB, y=Freport), fill = "blue", alpha = 0.3) +
  expand_limits(x = 0, y = 0) +
  theme_bw()

#print(mohn.rho.plot)
ggsave("..\\output\\Mohns.rho.plot.png", mohn.rho.plot)
