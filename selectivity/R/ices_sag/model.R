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

# Stock       Blim  Bpa  Bcurrent   Notes           Reference
# Greenland      4    6        22   Above Bpa       ICES 2022 21.1
# NE Arctic    220  460       902   Above Bpa       ICES 2021 27.1-2
# Iceland      125  160       368   Above Bpa       ICES 2023 27.5a
# Faroe         18   25        10   Below Blim (+)  ICES 2022 27.5b1
# Norway         -   60        34   Below Btarget   ICES 2020 27.1-2coast
# North Sea     70   98        54   Below Blim      ICES 2022 27.47d20
# Kattegat       -    -      0.10*  Below Bref (+)  ICES 2023 27.21
# W Baltic      15   23         6   Below Blim      ICES 2022 27.22-24
# E Baltic     109  122        77   Below Blim (+)  ICES 2023 27.24-32
# Irish         12   17        12   Below Blim (+)  ICES 2023 27.7a
# S Celtic       4    6         1   Below Blim (+)  ICES 2023 27.7e-k
#
# *: Spawning stock biomass for Kattegat is relative to the average of the stock
#    size in the period from 1997 to 2023.
#
# +: Scientific advice is zero catch.
