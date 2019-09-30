library(r4ss)
out <- SS_output("~/BFAS_Final")  # BFAS_Final.zip from ICES sharepoint

catage <- out$catage

dim(catage)
head(catage)
table(catage$Area)
table(catage$Fleet)
table(catage$Sex)
table(catage$Type)
table(catage$Morph)
table(catage$Yr)
table(catage$Seas)
table(catage$Era)

catage <- catage[c("Yr",0:15)]
catage <- aggregate(.~Yr, catage, sum)
round(catage)

ll(out)

################################################################################

dat <- SS_readdat("~/BFAS_Final/EBcod_wgbfas19_dat.ss")
