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
    xlim(c(-1, ifelse(mymetric == "Fbar", 1, 3))) +
    ggtitle(mymetric) +
    labs(x = expression(paste("Mohn's ", rho)), y = "Stock") +
    theme_bw()
    if (mytile == TRUE) gg <- gg + facet_wrap(~ model)
  return(gg)
}
ggdb(dbp, mymetric[2], mytile = FALSE)

# for plotting rename a4a models according to filename
db1 <- db %>%
  filter(model == "a4asca") %>%
  mutate(model = ifelse(file == "sep-mohn.txt", "a4asca sep", "a4asca te"))
db2 <- db %>%
  filter(model != "a4asca")
dbp <- rbind(db1, db2)

#check the levels of db$stock to make sure they match
stock.names = c("CC-GOM yellowtail flounder", "GB haddock", "GB winter flounder", "GOM Atlantic cod", "GOM haddock", "Icelandic herring", "NS Atlantic cod",
  "American Plaice", "Pollock", "SNE winter flounder", "SNE-MA yellowtail flounder", "Atlantic herring", "White hake")
levels(dbp$stock) = stock.names

#Just look at 4 model types. Which of hte A4A, SAM, WHAM models to use here can change.
db4 = dbp[which(dbp$model %in% c("a4asca te", "ASAP", "SAM", "WHAM")),]
db4$model = factor(db4$model)
#model.names = c("A4A sep sel", "A4A smooth sel", "ASAP", "SAM", "SAM constant F", "SAM fixed CV", "SAM Cor obs", "WHAM")
model.names = c("A4A", "ASAP", "SAM", "WHAM")
levels(db4$model) = model.names

# cap max rho at 3
#dbp <- dbp %>%
#  mutate(rho = ifelse(rho > 3, 3, rho))

mymetric <- c("Fbar", "SSB", "R")

for (imetric in 1:3){
  gg <- ggdb(db4, mymetric[imetric], mytile = FALSE)
  #print(gg)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], ".png"), gg)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], ".pdf"), gg, width = 8, height = 8, dpi = 500)
  ggtiled <- ggdb(db4, mymetric[imetric], mytile = TRUE)
  #print(ggtiled)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], "_tiled.png"), ggtiled)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], "_tiled.pdf"), ggtiled, width = 8, height = 8, dpi = 500)
}

library(kableExtra)
#make table of mean and sd of mohn's rho across stocks for each model type.
x = aggregate(rho ~ model*metric, data = db4, FUN = mean)
x = cbind(x, sd = aggregate(rho ~ model*metric, data = db4, FUN = sd)[,3])
x$metric = as.character(x$metric)
x$metric[x$metric == "Fbar"] = "$\\overline{F}$"
x$metric[x$metric == "R"] = "$R$"
colnames(x) = c("Model", "Metric", "Mean", "SD")
x = x[,c(2,1,3,4)]
x[,3:4] = round(x[,3:4],2)

kable(x[,-1], "latex", caption = "Group Rows", booktabs = T) %>% kable_styling() %>% group_rows("Group 1", 4, 7) %>% group_rows ("Group 2", 8, 10)
y = latex(x[-1], file = "../tex/rho_model_summary.tex", n.rgroup = c(4,4,4), rgroup = unique(x$Metric), table.env = FALSE, rowname = x$Model, booktabs = TRUE)
y = latex(x[-1], file = "../tex/rho_model_summary.tex", n.rgroup = c(4,4,4), rgroup = unique(x$Metric), table.env = FALSE, rowname = NULL, booktabs = TRUE)

# spread data to allow SSB vs F Mohn's rho plotting
dbps <- db4 %>%
  spread(key = metric, value = rho)

ggs <- ggplot(dbps, aes(x=SSB, y=Fbar, color=model)) +
  geom_point() +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  xlab(expression(paste("Mohn's ", rho, bgroup("(", "SSB", ")")))) +
  ylab(expression(paste("Mohn's ", rho, bgroup("(", bar(italic(F)), ")")))) +
  theme_bw()
# print(ggs)
ggsave(filename = "../db/SSBvsFbarMohnRho.png", ggs)

ggstiled <- ggplot(dbps, aes(x=SSB, y=Fbar, color=stock)) +
  geom_point() +
  #facet_wrap(model ~ .) +
  facet_wrap(~ model) +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  xlab(expression(paste("Mohn's ", rho, bgroup("(", "SSB", ")")))) +
  ylab(expression(paste("Mohn's ", rho, bgroup("(", bar(italic(F)), ")")))) +
  theme_bw()
# print(ggstiled)
ggsave(filename = "../db/SSBvsFbarMohnRho_tiled.png", ggstiled)

ggstiled2 <- ggplot(dbps, aes(x=SSB, y=Fbar, color=model)) +
  geom_point() +
  #facet_wrap(model ~ .) +
  facet_wrap(~stock) +
  xlab("Mohn's rho SSB") +
  ylab("Mohn's rho Fbar") +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  theme_bw()
# print(ggstiled2)
ggsave(filename = "../db/SSBvsFbarMohnRho_tiled2.png", ggstiled2)


# WHAM models rho
whamdb <- data.frame(stock = character(),
                 model = character(),
                 metric = character(),
                 rho = double())

for (istock in 1:nstocks){
  wham.compare = read.csv(file = paste0("../", stocks[istock], "/WHAM/model_compare.csv"), row.names = 1, as.is = TRUE)[,-1]
  models = rownames(wham.compare)
  nmodels = length(models)
  for (imodel in 1:nmodels){
    thisdb <- cbind.data.frame(
      stock = stocks[istock],
      model = models[imodel],
      metric = colnames(wham.compare),
      rho = as.numeric(wham.compare[imodel,]))
  whamdb <- rbind(whamdb, thisdb)
  }
}
#write.csv(whamdb, file = "../db/WHAMMohnrhodb.csv", row.names = FALSE)

mymetric <- c("Fbar", "SSB", "R")

for (imetric in 1:3){
  gg <- ggdb(whamdb, mymetric[imetric], mytile = FALSE)
  #print(gg)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], ".png"), gg)
  ggtiled <- ggdb(whamdb, mymetric[imetric], mytile = TRUE)
  #print(ggtiled)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], "_tiled.png"), ggtiled)
}

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

# make plots
pdf(file="../db/timeseriesplots.pdf")
mymetric <- c("SSB", "Fbar", "R", "Catch")
for (imetric in 1:length(mymetric)){
  for (istock in 1:nstocks){
    tsp <- ggplot(filter(dc, stock == stocks[istock], metric == mymetric[imetric]), 
                  aes(x=year, y=value, color=model)) +
      geom_line() +
      geom_ribbon(aes(ymin=low, ymax=high, fill=model), alpha=0.3, linetype = 0) +
      xlab("Year") +
      ylab(mymetric[imetric]) +
      ggtitle(stocks[istock]) +
      expand_limits(y=0) +
      theme_bw() +
      theme(legend.position = "bottom")
    
    #print(tsp)
    
    tsp_tiled <- tsp +
      facet_wrap(~model)
#      facet_wrap(model ~ .)
    
    print(tsp_tiled)
    
  }
}
dev.off()

###################################################
# now for the predictions of missing recent indices

dd <- data.frame(stock = character(),
                 model = character(),
                 file = character(),
                 index = integer(),
                 year = integer(),
                 age = integer(),
                 obs = double(),
                 prd = double(),
                 sdprd = double())

for (istock in 1:nstocks){
  models <- list.dirs(path = paste0("../", stocks[istock]), full.names = FALSE, recursive = FALSE)
  nmodels <- length(models)
  for (imodel in 1:nmodels){
    files <- list.files(path = paste0("../", stocks[istock], "/", models[imodel]), full.names = FALSE)
    files <- files[grep("tab2.csv", files)]
    nfiles <- length(files)
    if (nfiles > 0){
      for (ifile in 1:nfiles){
        myfile <- paste0("../", stocks[istock], "/", models[imodel], "/", files[ifile])
        dat <- read.csv(file = myfile, header = TRUE)
        if (names(dat)[4] != "V3"){  # skip problem with WHAM GOMcod tab2.csv
          if (models[imodel] == "ASAP"){
            thisdb <- data.frame(stock = stocks[istock],
                                 model = models[imodel],
                                 file = files[ifile],
                                 index = dat$Index,
                                 year = dat$Year,
                                 age = dat$Age,
                                 obs = dat$logObs,
                                 prd = dat$Pred,
                                 sdprd = NA)
          } else if (models[imodel] == "a4asca"){
            mymodelname <- ifelse(files[ifile] == "sep-tab1.csv", "a4asca sep", "a4asca te")
            thisdb <- data.frame(stock = stocks[istock],
                                 model = mymodelname,
                                 file = files[ifile],
                                 index = dat$Index,  #herehere need to update this once files are available
                                 year = dat$Year,
                                 age = dat$Age,
                                 obs = dat$logObs,
                                 prd = dat$Pred,
                                 sdprd = NA)
          } else if (models[imodel] == "WHAM"){
            mymodelname <- ifelse(nfiles > 1, 
                                  paste0(models[imodel],"_",substr(files[ifile],1,2)), 
                                  models[imodel])
            thisdb <- data.frame(stock = stocks[istock],
                                 model = mymodelname,
                                 file = files[ifile],
                                 index = dat$fleet,  
                                 year = dat$year,
                                 age = dat$age,
                                 obs = dat$logObs,
                                 prd = dat$pred,
                                 sdprd = dat$predSd)
          } else { # the SAM variants
            thisdb <- data.frame(stock = stocks[istock],
                                 model = models[imodel],
                                 file = files[ifile],
                                 index = dat$fleet - 1,  # SAM fleet 1 is catch  
                                 year = dat$year,
                                 age = dat$age,
                                 obs = dat$logObs,
                                 prd = dat$pred,
                                 sdprd = dat$predSd)
          }
          # add to the database
          dd <- rbind(dd, thisdb)
          thisdb <- NULL
          dat <- NULL
        }
      }
    }
  }
}
write.csv(dd, file = "../db/predmissingdb.csv", row.names = FALSE)

# note years are wrong in WHAM tab1 and tab2 csv files, asked Tim to fix

# plot of observed and expected on log scale
# not sure if want to try to fancy this up by including sdprd
pdf(file="../db/predmissing_obsprd.pdf")
for (istock in 1:nstocks){
  mip <- ggplot(filter(dd, stock == stocks[istock], 
                       !model %in% c("WHAM", "WHAM_m4", "WHAM_m5", "WHAM_m6")), 
                aes(x=year, y=prd, color=model)) +
    geom_line() +
    geom_point(aes(y=obs)) +
    xlab("Year") +
    ylab("Index") +
    ggtitle(stocks[istock]) +
    facet_grid(index ~ age) +
    expand_limits(y=0) +
    theme_bw() +
    theme(legend.position = "bottom")
  
  print(mip)
}
dev.off()

# calculate residuals and resid squared and summarize different ways
dd1 <- dd %>%
  mutate(resid = prd - obs, resid2 = (prd - obs)^2)

dd2 <- dd1 %>%
  filter(!model %in% c("WHAM", "WHAM_m4", "WHAM_m5", "WHAM_m6")) %>%
  group_by(stock, model, year) %>%
  summarize(bias = mean(resid), rmse = sqrt(mean(resid2)))

biasplot <- ggplot(dd2, aes(x=year, y=bias, color=model)) +
  geom_point() +
  geom_hline(yintercept=0, color="red", linetype="dashed") +
  facet_wrap(stock ~ ., scales = "free") +
  xlab("Year") +
  ylab("Bias") +
  theme_bw() +
  theme(legend.position = "bottom")
#print(biasplot)
ggsave(filename = "../db/predmissing_biasplot.png", biasplot)

rmseplot <- ggplot(dd2, aes(x=year, y=rmse, color=model)) +
  geom_point() +
  facet_wrap(stock ~ ., scales = "free") +
  xlab("Year") +
  ylab("RMSE") +
  theme_bw() +
  theme(legend.position = "bottom")
#print(rmseplot)
ggsave(filename = "../db/predmissing_rmseplot.png", rmseplot)

modelnumdf <- data.frame(model = sort(unique(dd1$model)), 
                         modelnum = as.factor(1:length(unique(dd1$model))))
print(modelnumdf)
dd3 <- left_join(dd1, modelnumdf, by="model")
mn <- substr(modelnumdf$model, 1, 16)
mytitle <- paste0("1=",mn[1],", 2=",mn[2],", 3=",mn[3],", 4=",mn[4],", 5=",mn[5],", 6=",mn[6],
                  "\n7=",mn[7],", 8=",mn[8],", 9=",mn[9])
residboxplot <- ggplot(dd3, aes(x=modelnum, y=resid)) +
  geom_boxplot() +
  geom_hline(yintercept=0, color="red", linetype="dashed") +
  facet_wrap(stock~., scales = "free_y") +
  xlab("Model Number") +
  ylab("Log Scale Residual") +
  labs(title = NULL, subtitle = mytitle) +
  theme_bw()
#print(residboxplot)
ggsave(filename = "../db/predmissing_residboxplot.png", residboxplot)
