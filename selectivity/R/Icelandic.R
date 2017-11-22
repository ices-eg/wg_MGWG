#Icelandic Cod

#Read Last Ten Year
w <- read.csv('http://data.hafro.is/assmt/2017/cod/catch_weights.csv', check.names = F)
head(w)

#Average of wieght
last <- w[which(w$Year>'2007'),]
ave <- colMeans(last)
w <- ave[-1]/1000


source('functions/cohortBiomass.R')

cohortBiomass(136, w, 0.2 )

B <- cohortBiomass(Ninit, w, M)
barplot(B)


