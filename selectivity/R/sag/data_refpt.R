## Preprocess data, list reference points

## Before: e_baltic.csv, faroe.csv, greenland.csv, iceland.csv, irish.csv,
##         kattegat.csv, ne_arctic.csv, north_sea.csv, norway.csv, s_celtic.csv,
##         w_baltic.csv (data)
## After:  assessments_refpt.rds (data)

library(TAF)

mkdir("data")

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

refpt <- list(
  e.baltic=e.baltic[1,-(2:11)],
  faroe=faroe[1,-(2:11)],
  greenland=greenland[1,-(2:11)],
  iceland=iceland[1,-(2:11)],
  irish=irish[1,-(2:11)],
  kattegat=kattegat[1,-(2:11),drop=FALSE],
  ne.arctic=ne.arctic[1,-(2:11)],
  north.sea=north.sea[1,-(2:11)],
  norway=norway[1,-(2:11)],
  s.celtic=s.celtic[1,-(2:11)],
  w.baltic=w.baltic[1,-(2:11)])

saveRDS(refpt, "data/assessments_refpt.rds")
