library(TAF)

## 1  Read data

faroe_plateau <- read.taf("../../data/faroe_plateau/fatage.csv")
georges_bank <- read.taf("../../data/georges_bank/fatage.csv")
greenland <- read.taf("../../data/greenland/fatage.csv")
gulf_of_maine <- read.taf("../../data/gulf_of_maine/fatage.csv")
iceland <- read.taf("../../data/iceland/fatage.csv")
irish_sea <- read.taf("../../data/irish_sea/fatage.csv")
# kattegat <- read.taf("../../data/kattegat/fatage.csv")
nafo_2j3kl <- read.taf("../../data/nafo_2j3kl/fatage.csv")
nafo_3m <- read.taf("../../data/nafo_3m/fatage.csv")
nafo_3no <- read.taf("../../data/nafo_3no/fatage.csv")
# nafo_3ps <- read.taf("../../data/nafo_3ps/fatage.csv")
ne_arctic <- read.taf("../../data/ne_arctic/fatage.csv")
north_sea <- read.taf("../../data/north_sea/fatage.csv")
norway <- read.taf("../../data/norway/fatage.csv")
s_celtic <- read.taf("../../data/s_celtic/fatage.csv")
w_baltic <- read.taf("../../data/w_baltic/fatage.csv")

fmort <- list(faroe_plateau=faroe_plateau,
              georges_bank=georges_bank,
              greenland=greenland,
              gulf_of_maine=gulf_of_maine,
              iceland=iceland,
              irish_sea=irish_sea,
              nafo_2j3kl=nafo_2j3kl,
              nafo_3m=nafo_3m,
              nafo_3no=nafo_3no,
              ne_arctic=ne_arctic,
              north_sea=north_sea,
              norway=norway,
              s_celtic=s_celtic,
              w_baltic=w_baltic)

## 2  Calculate Fbar

faroe_plateau_fbar <- with(
  x<-faroe_plateau, data.frame(Year=Year, Fbar=rowMeans(x[c("4","5","6")])))
georges_bank_fbar <- with(
  x<-georges_bank, data.frame(Year=Year, Fbar=rowMeans(x[c("4","5","6")])))
greenland_fbar <- with(
  x<-greenland, data.frame(Year=Year, Fbar=rowMeans(x[c("4","5","6")])))
gulf_of_maine_fbar <- with(
  x<-gulf_of_maine, data.frame(Year=Year, Fbar=rowMeans(x[c("4","5","6")])))
iceland_fbar <- with(
  x<-iceland, data.frame(Year=Year, Fbar=rowMeans(x[c("4","5","6")])))
irish_sea_fbar <- with(
  x<-irish_sea, data.frame(Year=Year, Fbar=rowMeans(x[c("4","5","6")]))
