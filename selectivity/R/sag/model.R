## Run analysis, write model results

## Before: e_baltic.csv, faroe.csv, greenland.csv, iceland.csv, irish.csv,
##         kattegat.csv, ne_arctic.csv, north_sea.csv, norway.csv, s_celtic.csv,
##         w_baltic.csv (data)
## After:

library(TAF)

mkdir("model")

# Read data
e.baltic <- read.taf("data/e_baltic.csv")
faroe <- read.taf("data/faroe.csv")
greenland <- read.taf("data/greenland.csv")
iceland <- read.taf("data/iceland.csv")
irish <- read.taf("data/irish.csv")
kattegat <- read.taf("data/kattegat.csv")
ne.arctic <- read.taf("data/ne_arctic.csv")
north.sea <- read.taf("data/north_sea.csv")
norway <- read.taf("data/norway.csv")
s.celtic <- read.taf("data/s_celtic.csv")
w.baltic <- read.taf("data/w_baltic.csv")

# Stock       Blim  Btarget  Bcurrent  Notes
# E Baltic    109       122        77  Below Blim
# Faroe        18        25        10  Below Blim
# Greenland     4         6        22  Good
# Iceland     125       265       368  Good
# Irish        12        17        12  Below Blim
# Kattegat      -         -      0.10  Below possible Blim
# NE Arctic   220       460       902  Good
# North Sea    70        98        54  Below Blim
# Norway        -        60        34  Below Btarget
# S Celtic      4         6         1  Below Blim
# W Baltic     15        23         6  Below Blim

Moratorium in Kattegat and perhaps elsewhere?
