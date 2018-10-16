# makedb.r
# create database of state-space results for Mohn's rho

library(ggplot2)
library(dplyr)

stocks <- list.dirs(path = "../", full.names = FALSE, recursive = FALSE)
stocks <- stocks[!(stocks %in% c("ASAP_3_year_projection_test", "helper_code", "plots_for_README", "tex", "USWCLingcod"))]
nstocks <- length(stocks)

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
