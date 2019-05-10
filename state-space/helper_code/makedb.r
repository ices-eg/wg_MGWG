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
ggdb <- function(db, i, mytile){
  gg <- ggplot(filter(db, metric == mymetric[i]), aes(x=rho, y=stock, color=model)) +
    geom_point() +
    xlim(c(-1, ifelse(mymetric[i] == "Fbar", 1, 3))) +
    ggtitle(parse(text = myMetric[i])) +
    labs(x = expression(paste("Mohn's ", italic("\u03c1"))), y = "Stock", family="Times") +
    theme_bw()
    if (mytile == TRUE) gg <- gg + facet_wrap(~ model)
  return(gg)
}

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
xlabs = c("bar(italic(F))", "italic(R)", "SSB")
db4$Metric = xlabs[match(db4$metric, levels(db4$metric))]

# cap max rho at 3
#dbp <- dbp %>%
#  mutate(rho = ifelse(rho > 3, 3, rho))

mymetric <- c("Fbar", "SSB", "R")
myMetric = c("bar(italic(F))", "SSB", "italic(R)")

for (imetric in 1:3){
  gg <- ggdb(db4, imetric, mytile = FALSE)
  gg$labels$colour = "Model"
  #print(gg)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], ".png"), gg)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], ".pdf"), gg, width = 8, height = 8, dpi = 500, device = cairo_pdf)
  ggtiled <- ggdb(db4, imetric, mytile = TRUE)
  ggtiled$labels$colour = "Model"
  #print(ggtiled)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], "_tiled.png"), ggtiled)
  ggsave(filename = paste0("../db/gg", mymetric[imetric], "_tiled.pdf"), ggtiled, width = 8, height = 8, dpi = 500, device = cairo_pdf)
}

gg <- ggplot(db4, aes(x=rho, y=stock, color=stock)) +
  geom_point(show.legend = FALSE) +
  xlim(c(-1, 3)) +
  labs(x = expression(paste("Mohn's ", italic("\u03c1"))), y = "Stock", family="Times") +
  theme(strip.background = element_blank(), text = element_text(family = "Times"), strip.text = element_text(size = 20), axis.title = element_text(size = 20)) + #, strip.text.x = element_blank()) +
  facet_grid(model ~ Metric, labeller = label_parsed)
#gg
ggsave(filename = paste0("../db/rho_paper_plot.pdf"), gg, width = 12, height = 8, dpi = 500, device = cairo_pdf)

library(knitr)
library(kableExtra)
#make table of mean and sd of mohn's rho across stocks for each model type.
x = aggregate(rho ~ model*metric, data = db4, FUN = mean)
x = cbind(x, sd = aggregate(rho ~ model*metric, data = db4, FUN = sd)[,3])
x$metric = as.character(x$metric)
x$metric[x$metric == "Fbar"] = "$\\\\overline{F}$"
x$metric[x$metric == "R"] = "$R$"
colnames(x) = c("Model", "Metric", "Mean", "SD")
x = x[,c(2,1,3,4)]
x[,3:4] = round(x[,3:4],2)

starts = (1:length(unique(x$Metric)))*4 - 3
y = kable(x[,-1], 'latex', booktabs = T, escape = FALSE) %>% 
  group_rows(unique(x$Metric)[1], starts[1], starts[1] + 3, escape = FALSE, bold = FALSE) %>%
  group_rows(unique(x$Metric)[2], starts[2], starts[2] + 3, escape = FALSE, bold = FALSE) %>%
  group_rows(unique(x$Metric)[3], starts[3], starts[3] + 3, escape = FALSE, bold = FALSE)
cat(y, sep = "\n", file = "../tex/rho_model_summary.tex")

# spread data to allow SSB vs F Mohn's rho plotting
dbps <- db4[,1:5] %>%
  spread(key = metric, value = rho)

ggs <- ggplot(dbps, aes(x=SSB, y=Fbar, color=model)) +
  geom_point() +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  xlab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", "SSB", ")")))) +
  ylab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", bar(italic(F)), ")")))) +
  theme_bw()
ggs$labels$colour = "Model"
ggs
ggsave(filename = "../db/SSBvsFbarMohnRho.png", ggs)

ggstiled <- ggplot(dbps, aes(x=SSB, y=Fbar, color=stock)) +
  geom_point() +
  facet_wrap(~ model) +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  xlab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", "SSB", ")")))) +
  ylab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", bar(italic(F)), ")")))) +
  theme_bw()
ggstiled$labels$colour = "Stock"
ggstiled
# print(ggstiled)
ggsave(filename = "../db/SSBvsFbarMohnRho_tiled.png", ggstiled)

ggstiled2 <- ggplot(dbps, aes(x=SSB, y=Fbar, color=model)) +
  geom_point() +
  #facet_wrap(model ~ .) +
  facet_wrap(~stock) +
  xlab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", "SSB", ")")))) +
  ylab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", bar(italic(F)), ")")))) +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  theme_bw()
ggstiled2$labels$colour = "Model"
# print(ggstiled2)
ggsave(filename = "../db/SSBvsFbarMohnRho_tiled2.png", ggstiled2)

ggstiled3 <- ggplot(dbps, aes(x=SSB, y=Fbar, color=stock)) +
  geom_point() +
  facet_wrap(~ model) +
  xlim(c(-1, 3)) +
  ylim(c(-1, 3)) +
  xlab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", "SSB", ")")))) +
  ylab(expression(paste("Mohn's ", italic("\u03c1"), bgroup("(", bar(italic(F)), ")")))) +
  #theme_bw()
  theme(strip.background = element_blank(), text = element_text(family = "Times"), strip.text = element_text(size = 20), axis.title = element_text(size = 20))
ggstiled3
ggstiled3$labels$colour = "Stock"
ggsave(filename = "../db/SSBvsFbarMohnRho_paper.pdf", ggstiled3, width = 8, height = 8, dpi = 500, device = cairo_pdf)

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
write.csv(whamdb, file = "../db/WHAMMohnrhodb.csv", row.names = FALSE)

#check the levels of db$stock to make sure they match
#stock.names = c("CC-GOM yellowtail flounder", "GB haddock", "GB winter flounder", "GOM Atlantic cod", "GOM haddock", "Icelandic herring", "NS Atlantic cod",
#  "American Plaice", "Pollock", "SNE winter flounder", "SNE-MA yellowtail flounder", "Atlantic herring", "White hake")
levels(whamdb$stock) = stock.names

model.names = paste0("M[",1:4, "]")
levels(whamdb$model) = model.names
whamdb$Metric = xlabs[match(whamdb$metric, levels(whamdb$metric))]

gg <- ggplot(whamdb, aes(x=rho, y=stock, color=stock)) +
  geom_point(show.legend = FALSE) +
  xlim(c(-1, 3)) +
  labs(x = expression(paste("Mohn's ", italic("\u03c1"))), y = "Stock", family="Times") +
  theme(strip.background = element_blank(), text = element_text(family = "Times"), strip.text = element_text(size = 20), axis.title = element_text(size = 20)) + #, strip.text.x = element_blank()) +
  facet_grid(model ~ Metric, labeller = label_parsed)
gg
ggsave(filename = paste0("../db/wham_rho_paper_plot.pdf"), gg, width = 12, height = 8, dpi = 500, device = cairo_pdf)


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

levels(dc$stock) = stock.names
dc4 = dc[which(dc$model %in% c("a4asca te", "ASAP", "SAM", "WHAM")),]
dc4$model = factor(dc4$model)
#model.names = c("A4A sep sel", "A4A smooth sel", "ASAP", "SAM", "SAM constant F", "SAM fixed CV", "SAM Cor obs", "WHAM")
model.names = c("A4A", "ASAP", "SAM", "WHAM")
levels(dc4$model) = model.names
xlabs = c("Catch", "bar(italic(F))", "italic(R)", "SSB")
dc4$Metric = xlabs[match(dc4$metric, levels(dc4$metric))]


dc4$symtest = log(dc4$high)-log(dc4$value) - log(dc4$value)+log(dc4$low)
head(filter(dc4, model == "A4A"))
dc4$symtest = dc4$high - dc4$value - dc4$value + dc4$low
head(filter(dc4, model == "A4A"))
#not sure how CI is calculated for A4A. SAM is a little off from symmetric on log-scale too.
dc4$CV = log(dc4$high/dc4$value)/qnorm(0.975)


# make plots
cairo_pdf(file="../db/timeseriesplots.pdf", onefile = TRUE)
mymetric <- c("SSB", "Fbar", "R", "Catch")
for (imetric in 1:length(mymetric)){
  for (istock in 1:nstocks){
    tsp <- ggplot(filter(dc4, stock == stock.names[istock], Metric == xlabs[imetric]), 
                  aes(x=year, y=value, color=model)) +
      geom_line() +
      geom_ribbon(aes(ymin=low, ymax=high, fill=model), alpha=0.3, linetype = 0) +
      xlab("Year") +
      ylab(parse(text = xlabs[imetric])) +
      ggtitle(stock.names[istock]) +
      expand_limits(y=0) +
      theme_bw() +
      theme(legend.position = "bottom")
      tsp$labels$colour = tsp$labels$fill = ""
    
    #print(tsp)
    
    tsp_tiled <- tsp +
      facet_wrap(~model)
#      facet_wrap(model ~ .)
    
    print(tsp_tiled)
    
  }
}
dev.off()

cairo_pdf(file="../db/CVs.pdf", onefile = TRUE)
for (imetric in 1:length(xlabs)){
#  for (istock in 1:nstocks){
    tsp <- ggplot(filter(dc4, Metric == xlabs[imetric]),# & stock == stock.names[11]), 
                  aes(x=year, y=CV, color=model)) +
      geom_line() +
      #geom_ribbon(aes(ymin=low, ymax=high, fill=model), alpha=0.3, linetype = 0) +
      xlab("Year") +
      ylab("CV") +
      ggtitle(parse(text = xlabs[imetric])) +
      coord_cartesian(ylim = c(0,0.5)) +
      #ylim(0,0.5) + 
      #expand_limits(y=0) +
      theme_bw() +
      theme(legend.position = "bottom")
      tsp$labels$colour = tsp$labels$fill = ""
    
    #print(tsp)
    
    tsp_tiled <- tsp +
      facet_wrap(~stock)
#      facet_wrap(model ~ .)
    
    print(tsp_tiled)
    
#  }
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
  print(models)
  models = models[which(models != "a4asca")] #until predicted indices get fixed.
  nmodels <- length(models)
  for (imodel in 1:nmodels){
    files <- list.files(path = paste0("../", stocks[istock], "/", models[imodel]), full.names = FALSE)
    files <- files[grep("tab2.csv", files)]
    nfiles <- length(files)
    if (nfiles > 0){
      for (ifile in 1:nfiles){
        myfile <- paste0("../", stocks[istock], "/", models[imodel], "/", files[ifile])
        dat <- read.csv(file = myfile, header = TRUE)
        print(myfile)
        print(dim(dat))
        print(myfile)
        print(dat)
        print(c(istock,imodel,ifile))
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

#NOTE: no standard error of predicted indices at age for ASAP
levels(dd$stock) = stock.names
dd4 = dd[which(dd$model %in% c("a4asca te", "ASAP", "SAM", "WHAM")),]
dd4$model = factor(dd4$model)
#model.names = c("A4A sep sel", "A4A smooth sel", "ASAP", "SAM", "SAM constant F", "SAM fixed CV", "SAM Cor obs", "WHAM")
#model.names = c("A4A", "ASAP", "SAM", "WHAM")
model.names = c("ASAP", "SAM", "WHAM") #until A4A results are corrected
levels(dd4$model) = model.names

write.csv(dd, file = "../db/predmissingdb.csv", row.names = FALSE)

# plot of observed and expected on log scale
# not sure if want to try to fancy this up by including sdprd
pdf(file="../db/predmissing_obsprd.pdf")
for (istock in 1:nstocks){
  #print(filter(dd4, stock == stock == stock.names[istock]))
  mip <- ggplot(filter(dd4, stock == stock.names[istock]),#, 
                       #!model %in% c("WHAM", "WHAM_m4", "WHAM_m5", "WHAM_m6")), 
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

dd4$resid = dd4$obs - dd4$prd
aggregate(resid ~ model * stock, data = dd4, FUN = sd)
aggregate(resid ~ model * stock, data = dd4, FUN = mean)
#aggregate(resid ~ model * stock, data = dd4, FUN = function(x) sqrt(mean(x)^2 + var(x)))
aggregate(resid ~ model, data = dd4, FUN = sd)
aggregate(resid ~ model, data = dd4, FUN = mean)
#aggregate(resid ~ model, data = dd4, FUN = function(x) sqrt(mean(x)^2 + var(x)))

# calculate residuals and resid squared and summarize different ways
dd1 <- dd4 %>%
  mutate(resid = obs - prd, resid2 = (obs - prd)^2)

sapply(stock.names, function(x) unique(dd1$year[dd1$stock == x]))
dd1$yearmiss = (1:3)[match(dd1$year, 2014:2016)]
#terminal years of Atl. herring different
dd1$yearmiss[dd1$stock == stock.names[12]] = (1:3)[match(dd1$year[dd1$stock == stock.names[12]], 2012:2014)]

dd2 <- dd1 %>%
  #filter(!model %in% c("WHAM", "WHAM_m4", "WHAM_m5", "WHAM_m6")) %>%
  group_by(stock, model, year) %>%
  summarize(bias = mean(resid, na.rm = TRUE), rmse = sqrt(mean(resid2, na.rm = TRUE)))

biasplot <- ggplot(dd2, aes(x=year, y=bias, color=model)) +
  geom_point() +
  geom_hline(yintercept=0, color="red", linetype="dashed") +
  facet_wrap(~ stock, scales = "free") +
  xlab("Year") +
  ylab("Bias") +
  theme_bw() +
  theme(legend.position = "bottom")
#print(biasplot)
ggsave(filename = "../db/predmissing_biasplot.png", biasplot)

biasboxplot <- ggplot(filter(dd2, year %in% c(2014, 2015, 2016)), 
                      aes(x=as.factor(year), y=bias, fill=model)) +
  geom_boxplot(position=position_dodge(0.8)) +
  geom_hline(yintercept=0, color="red", linetype="dashed") +
  xlab("Year") +
  ylab("Bias") +
  theme_bw() +
  theme(legend.position = "bottom")
print(biasboxplot)
ggsave(filename = "../db/predmissing_biasboxplot.png", biasboxplot)

rmseplot <- ggplot(dd2, aes(x=year, y=rmse, color=model)) +
  geom_point() +
  facet_wrap(~ stock, scales = "free") +
  xlab("Year") +
  ylab("RMSE") +
  theme_bw() +
  theme(legend.position = "bottom")
#print(rmseplot)
ggsave(filename = "../db/predmissing_rmseplot.png", rmseplot)

rmseboxplot <- ggplot(filter(dd2, year %in% c(2014, 2015, 2016)),
                      aes(x=as.factor(year), y=rmse, fill=model)) +
  geom_boxplot(position = position_dodge(0.8)) +
  xlab("Year") +
  ylab("RMSE") +
  theme_bw() +
  theme(legend.position = "bottom")
#print(rmseboxplot)
ggsave(filename = "../db/predmissing_rmseboxplot.png", rmseboxplot)

dd3 <- dd1 %>%
  #filter(!model %in% c("WHAM", "WHAM_m4", "WHAM_m5", "WHAM_m6")) %>%
  group_by(model, yearmiss) %>%
  summarize(bias = mean(resid, na.rm = TRUE), rmse = sqrt(mean(resid2, na.rm = TRUE)))

avgbiasplot = ggplot(dd3, aes(x=yearmiss, y=bias, color=model)) +
  geom_point() +
  geom_hline(yintercept=0, color="red", linetype="dashed") +
  xlab("Year") +
  ylab("Bias") +
  theme_bw() +
  theme(legend.position = "bottom")
ggsave(filename = "../db/predmissing_avgbiasplot.png", avgbiasplot)

avgrmseplot = ggplot(dd3, aes(x=yearmiss, y=rmse, color=model)) +
  geom_point() +
  xlab("Year") +
  ylab("RMSE") +
  theme_bw() +
  theme(legend.position = "bottom")
ggsave(filename = "../db/predmissing_avgrmseplot.png", avgrmseplot)

modelnumdf <- data.frame(model = sort(unique(dd1$model)), 
                         modelnum = as.factor(1:length(unique(dd1$model))))
print(modelnumdf)
dd5 <- left_join(dd1, modelnumdf, by="model")
mn <- substr(modelnumdf$model, 1, 16)
mytitle <- paste0("1=",mn[1],", 2=",mn[2],", 3=",mn[3],", 4=",mn[4],", 5=",mn[5],", 6=",mn[6],
                  "\n7=",mn[7],", 8=",mn[8],", 9=",mn[9])
residboxplot <- ggplot(dd5, aes(x=model, y=resid)) +
  geom_boxplot() +
  geom_hline(yintercept=0, color="red", linetype="dashed") +
  facet_wrap(~ stock, scales = "free_y") +
  xlab("Model") +
  ylab("Log Scale Residual") +
  #labs(title = NULL, subtitle = mytitle) +
  theme_bw()
#print(residboxplot)
ggsave(filename = "../db/predmissing_residboxplot.png", residboxplot)
