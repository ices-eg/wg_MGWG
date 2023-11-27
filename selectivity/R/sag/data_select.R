## Preprocess data, combine summary tables and reference points

## Before: refpt_2020.csv, refpt_2021.csv, refpt_2022.csv, refpt_2023.csv,
##         sumtab_2020.csv, sumtab_2021.csv, sumtab_2022.csv, sumtab_2023.csv
##         (boot/data/sag)
## After:  e_baltic.csv, faroe.csv, greenland.csv, iceland.csv, irish.csv,
##         kattegat.csv, ne_arctic.csv, north_sea.csv, norway.csv, s_celtic.csv,
##         w_baltic.csv (data)

library(TAF)

mkdir("data")

# Read SAG data
sumtab.2020 <- readRDS("boot/data/sag/sumtab_2020.rds")
sumtab.2021 <- readRDS("boot/data/sag/sumtab_2021.rds")
sumtab.2022 <- readRDS("boot/data/sag/sumtab_2022.rds")
sumtab.2023 <- readRDS("boot/data/sag/sumtab_2023.rds")
refpt.2020 <- readRDS("boot/data/sag/refpt_2020.rds")
refpt.2021 <- readRDS("boot/data/sag/refpt_2021.rds")
refpt.2022 <- readRDS("boot/data/sag/refpt_2022.rds")
refpt.2023 <- readRDS("boot/data/sag/refpt_2023.rds")

# Specify columns of interest from the summary table
columns <- c("fishstock", "Year", "recruitment", "SSB", "F", "catches",
             "landings", "recruitment_age", "Fage", "AssessmentYear")
colnames <- c("Code", "Year", "Rec", "SSB", "F", "Catches", "Landings",
              "RecAge", "FAge", "Assmt")

# Greenland 2022
greenland <- sumtab.2022$"cod.21.1"[columns]
names(greenland) <- colnames
greenland.refpt <-
  refpt.2022$"cod.21.1"[c("Blim", "Bpa", "MSYBtrigger", "FMSY")]
greenland <- data.frame(Stock="Greenland", greenland, greenland.refpt)

# NE Arctic 2021
ne.arctic <- sumtab.2021$"cod.27.1-2"[columns]
names(ne.arctic) <- colnames
ne.arctic.refpt <-
  refpt.2021$"cod.27.1-2"[c("Blim", "Bpa", "MSYBtrigger", "Bmanagement",
                            "FMSY", "Fmanagement", "Fpa", "FLim")]
names(ne.arctic.refpt)[names(ne.arctic.refpt) == "FLim"] <- "Flim"
ne.arctic <- data.frame(Stock="NE Arctic", ne.arctic, ne.arctic.refpt)

# Norway 2020
norway <- sumtab.2020$"cod.27.1-2coast"[columns]
names(norway) <- colnames
norway.refpt <- refpt.2020$"cod.27.1-2coast"["Bmanagement"]
norway <- data.frame(Stock="Norway", norway, norway.refpt)

# Kattegat 2023
kattegat <- sumtab.2023$"cod.27.21"[columns]
names(kattegat) <- colnames
kattegat.refpt <- NULL
kattegat <- data.frame(Stock="Kattegat", kattegat)

# W Baltic 2023
w.baltic <- sumtab.2023$"cod.27.22-24"[columns]
names(w.baltic) <- colnames
w.baltic.refpt <- refpt.2023$"cod.27.22-24"[c("Blim", "MSYBtrigger")]
w.baltic <- data.frame(Stock="W Baltic", w.baltic, w.baltic.refpt)

# E Baltic 2023
e.baltic <- sumtab.2023$"cod.27.24-32"[columns]
names(e.baltic) <- colnames
e.baltic.refpt <- refpt.2023$"cod.27.24-32"[c("Blim", "Bpa")]
e.baltic <- data.frame(Stock="E Baltic", e.baltic, e.baltic.refpt)

# North Sea 2022
north.sea <- sumtab.2022$"cod.27.47d20"[columns]
names(north.sea) <- colnames
north.sea.refpt <- refpt.2022$"cod.27.47d20"[c("Blim", "Bpa", "MSYBtrigger",
                                               "FMSY", "Fpa", "FLim")]
names(north.sea.refpt)[names(north.sea.refpt) == "FLim"] <- "Flim"
north.sea <- data.frame(Stock="North Sea", north.sea, north.sea.refpt)

# Iceland 2023
iceland <- sumtab.2023$"cod.27.5a"[columns]
names(iceland) <- colnames
iceland.refpt <-
  refpt.2023$"cod.27.5a"[c("Blim", "Bpa", "Bmanagement", "MSYBtrigger")]
iceland <- data.frame(Stock="Iceland", iceland, iceland.refpt)

# Faroe 2022
faroe <- sumtab.2022$"cod.27.5b1"[columns]
names(faroe) <- colnames
faroe.refpt <- refpt.2022$"cod.27.5b1"[c("Blim", "Bpa", "MSYBtrigger", "FMSY",
                                         "Fpa", "FLim")]
names(faroe.refpt)[names(faroe.refpt) == "FLim"] <- "Flim"
faroe <- data.frame(Stock="Faroe", faroe, faroe.refpt)

# Irish 2023
irish <- sumtab.2023$"cod.27.7a"[columns]
names(irish) <- colnames
irish.refpt <-
  refpt.2023$"cod.27.7a"[c("Blim", "Bpa", "MSYBtrigger", "Fpa", "FMSY", "FLim")]
names(irish.refpt)[names(irish.refpt) == "FLim"] <- "Flim"
irish <- data.frame(Stock="Irish", irish, irish.refpt)

# S Celtic 2023
s.celtic <- sumtab.2023$"cod.27.7e-k"[columns]
names(s.celtic) <- colnames
s.celtic.refpt <- refpt.2023$"cod.27.7e-k"[c("Blim", "Bpa", "MSYBtrigger",
                                             "FMSY", "Fpa", "FLim")]
names(s.celtic.refpt)[names(s.celtic.refpt) == "FLim"] <- "Flim"
s.celtic <- data.frame(Stock="S Celtic", s.celtic, s.celtic.refpt)

# Write TAF tables
write.taf(greenland, dir="data")
write.taf(ne.arctic, dir="data")
write.taf(norway, dir="data")
write.taf(kattegat, dir="data")
write.taf(w.baltic, dir="data")
write.taf(e.baltic, dir="data")
write.taf(north.sea, dir="data")
write.taf(iceland, dir="data")
write.taf(faroe, dir="data")
write.taf(irish, dir="data")
write.taf(s.celtic, dir="data")
