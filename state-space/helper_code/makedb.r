# makedb.r
# create databases of state-space results for Mohn's rho and time series of F, SSB, R, and Catch

library(ggplot2)
library(dplyr)
library(tidyr)

stocks <- list.dirs(path = "../", full.names = FALSE, recursive = FALSE)
stocks <- stocks[!(stocks %in% c("ASAP_3_year_projection_test", "helper_code", "plots_for_README", "tex", "USWCLingcod", "db"))]
nstocks <- length(stocks)

# Mohn's rho first
db <- data.frame(stock = character(),
                 model = character(),
                 file = character(),
                 metric = character(),
                 rho = double())

for (istock in 1:nstocks){
  models <- list.dirs(path = paste0("../", stocks[istock]), full.names = FALSE, recursive = FALSE)
  nmodels <- length(models)
  for (imodel in 1:nmodels){
    files <- list.files(path = paste0("../", stocks[istock], "/", models[imodel]), full.names = FALSE)
    files <- files[grep("ohn.txt", files)]
    nfiles <- length(files)
    if (nfiles > 0){
      for (ifile in 1:nfiles){
        myfile <- paste0("../", stocks[istock], "/", models[imodel], "/", files[ifile])
        if (models[imodel] %in% c("a4asca", "ASAP")){
          dat <- read.csv(file = myfile, header = TRUE)
          if (models[imodel] == "a4asca") colnames(dat) <- c("Fbar", "SSB", "R")
        }else{
          dat <- read.table(file = myfile, skip = 1, sep = "")
          colnames(dat) <- c("R", "SSB", "Fbar")
        }
        thisdb <- data.frame(stock = stocks[istock],
                             model = models[imodel],
                             file = files[ifile],
                             metric = colnames(dat),
                             rho = as.numeric(dat))
        db <- rbind(db, thisdb)
      }
    }
  }
}
write.csv(db, file = "../db/Mohnrhodb.csv", row.names = FALSE)

# function to make graphs of Mohn's rho database
ggdb <- function(db, mymetric, mytile){
  gg <- ggplot(filter(db, metric == mymetric), aes(x=rho, y=stock, color=model)) +
    geom_point() +
    xlim(c(-1, 3)) +
    ggtitle(mymetric) +
    {if (mytile == TRUE) facet_wrap(model ~ .)} +
    theme_bw()
  return(gg)
}


# for plotting rename a4a models according to filename
db1 <- db %>%
  filter(model == "a4asca") %>%
  mutate(model = ifelse(file == "sep-mohn.txt", "a4asca sep", "a4asca te"))
db2 <- db %>%
  filter(model != "a4asca")
dbp <- rbind(db1, db2)

# cap max rho at 3
dbp <- dbp %>%
  mutate(rho = ifelse(rho > 3, 3, rho))

mymetric <- c("Fbar", "SSB", "R")

for (imetric in 1:3){
  gg <- ggdb(dbp, mymetric[imetric], mytile = FALSE)
  #print(gg)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], ".png"), gg)
  ggtiled <- ggdb(dbp, mymetric[imetric], mytile = TRUE)
  #print(ggtiled)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], "_tiled.png"), ggtiled)
}

# spread data to allow SSB vs F Mohn's rho plotting
dbps <- dbp %>%
  spread(key = metric, value = rho)

ggs <- ggplot(dbps, aes(x=SSB, y=Fbar, color=model)) +
  geom_point() +
  xlab("Mohn's rho SSB") +
  ylab("Mohn's rho Fbar") +
  theme_bw()
# print(ggs)
ggsave(filename = "../db/SSBvsFbarMohnRho.png", ggs)

ggstiled <- ggplot(dbps, aes(x=SSB, y=Fbar, color=model)) +
  geom_point() +
  facet_wrap(model ~ .) +
  xlab("Mohn's rho SSB") +
  ylab("Mohn's rho Fbar") +
  theme_bw()
# print(ggstiled)
ggsave(filename = "../db/SSBvsFbarMohnRho_tiled.png", ggstiled)

ggstiled2 <- ggplot(dbps, aes(x=SSB, y=Fbar, color=stock)) +
  geom_point() +
  facet_wrap(model ~ .) +
  xlab("Mohn's rho SSB") +
  ylab("Mohn's rho Fbar") +
  theme_bw()
# print(ggstiled2)
ggsave(filename = "../db/SSBvsFbarMohnRho_tiled2.png", ggstiled)

#########################
# now for the time series
dc <- data.frame(stock = character(),
                 model = character(),
                 file = character(),
                 metric = character(),
                 year = integer(),
                 value = double(),
                 low = double(),
                 high = double())

for (istock in 1:nstocks){
  models <- list.dirs(path = paste0("../", stocks[istock]), full.names = FALSE, recursive = FALSE)
  nmodels <- length(models)
  for (imodel in 1:nmodels){
    files <- list.files(path = paste0("../", stocks[istock], "/", models[imodel]), full.names = FALSE)
    files <- files[grep("tab1.csv", files)]
    nfiles <- length(files)
    if (nfiles > 0){
      for (ifile in 1:nfiles){
        myfile <- paste0("../", stocks[istock], "/", models[imodel], "/", files[ifile])
        dat <- read.csv(file = myfile, header = TRUE)
        nyears <- length(dat[,1])
        if (models[imodel] == "ASAP"){
          thisdb <- data.frame(stock = stocks[istock],
                               model = models[imodel],
                               file = files[ifile],
                               metric = rep(c("Fbar", "SSB", "R", "Catch"), each=nyears),
                               year = rep(dat$Year, 4),
                               value = c(dat$Frep, dat$SSB, dat$R, dat$PredCatch),
                               low = c(dat$Low, dat$Low.1, dat$Low.2, rep(NA, nyears)),
                               high = c(dat$High, dat$High.1, dat$High.2, rep(NA, nyears)))
        } else if (models[imodel] == "a4asca"){
          mymodelname <- ifelse(files[ifile] == "sep-tab1.csv", "a4asca sep", "a4asca te")
          thisdb <- data.frame(stock = stocks[istock],
                               model = mymodelname,
                               file = files[ifile],
                               metric = rep(c("R", "SSB", "Catch", "Fbar"), each=nyears),
                               year = rep(dat$X, 4),
                               value = c(dat$R, dat$SSB, dat$Catch, dat$Fbar),
                               low = c(dat$Low, dat$Low.1, dat$Low.2, dat$Low.3),
                               high = c(dat$High, dat$High.1, dat$High.2, dat$High.3))
        } else {
          if (models[imodel] == "SAM") modelyears <- dat$Year
          # for some reason SAM did extra year for NScod relative to WHAM
          if (models[imodel] == "WHAM" && stocks[istock] == "NScod"){
            modelyears <- modelyears[-length(modelyears)] 
          }
          mymodelname <- ifelse(nfiles > 1, 
                                paste0(models[imodel],"_",substr(files[ifile],1,2)), 
                                models[imodel])
          thisdb <- data.frame(stock = stocks[istock],
                               model = mymodelname,
                               file = files[ifile],
                               metric = rep(c("R", "SSB", "Fbar", "Catch"), each=nyears),
                               year = rep(modelyears, 4),
                               value = c(dat[,2], dat$SSB, dat[,8], dat[,11]),
                               low = c(dat$Low, dat$Low.1, dat$Low.2, dat$Low.3),
                               high = c(dat$High, dat$High.1, dat$High.2, dat$High.3))
        }
        # add to the database
        dc <- rbind(dc, thisdb)
      }
    }
  }
}
write.csv(dc, file = "../db/timeseriesdb.csv", row.names = FALSE)

# make plot
for (istock in 1:nstocks){
  tsp <- ggplot(filter(dcp1, stock == stocks[istock], metric == "SSB"), 
                aes(x=year, y=value, color=model)) +
    geom_line() +
    geom_ribbon(aes(ymin = low, ymax = high)) +
    facet_wrap(model ~ .) +
    ggtitle(stocks[istock]) +
    theme_bw()
  
  print(tsp)
}
