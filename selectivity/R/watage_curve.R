rm(list=ls())

library(ggplot2)
library(gridExtra)

##Faroe Plateau
##catch data
wc<-read.csv("../data/Faroe_Plateau/wcatch.csv") #no information for age 1

wc2<-as.matrix(wc[,c(1,3:dim(wc)[2])])
pdf("../weight_year_plots/Faroe_Plateau/watage_year.pdf")
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Faroe Plateau")
dev.off()

w2<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()

pdf("../weight_year_plots/Faroe_Plateau/wy_age.pdf")
grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9,w10, nrow=3)
dev.off()

##Faroe Plateau
##cohorts data
wc<-read.csv("../data/Faroe_Plateau/wcatchCohorts.csv")
wc[wc==0]<-NA

wc2<-as.matrix(wc[,c(1,3:dim(wc)[2])])
pdf("../weight_year_plots/Faroe_Plateau/watage_cohort.pdf")
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Cohorts", ylab="Mean weight at cohort (kg)", main="Faroe Plateau")
dev.off()

w2<-ggplot(wc, aes(Cohort, wc[,3])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Cohort, wc[,4])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Cohort, wc[,5])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Cohort, wc[,6])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Cohort, wc[,7])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Cohort, wc[,8])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Cohort, wc[,9])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Cohort, wc[,10])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Cohort, wc[,11])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()

pdf("../weight_year_plots/Faroe_Plateau/wc_age.pdf")
grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9,w10, nrow=3)
dev.off()

##Georges bank
##catch data
wc<-read.csv("../data/georges_bank/wcatch.csv")
head(wc)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/georges_bank/watage_year.pdf")
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Georges bank")
dev.off()

w2<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()

pdf("../weight_year_plots/georges_bank/wy_year.pdf")
grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9,w10, nrow=3)
dev.off()

##Georges bank
##cohorts data
wc<-read.csv("../data/georges_bank/wcatchCohorts.csv")
wc[wc==0]<-NA

wc2<-as.matrix(wc[,c(1,2:dim(wc)[2])])
pdf("../weight_year_plots/georges_bank/watage_cohort.pdf")
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Cohorts", ylab="Mean weight at cohort (kg)", main="Georges bank")
dev.off()

w2<-ggplot(wc, aes(Cohort, wc[,3])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Cohort, wc[,4])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Cohort, wc[,5])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Cohort, wc[,6])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Cohort, wc[,7])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Cohort, wc[,8])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Cohort, wc[,9])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Cohort, wc[,10])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Cohort, wc[,11])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()

pdf("../weight_year_plots/georges_bank/wy_cohort.pdf")
grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9,w10, nrow=3)
dev.off()

##Gulf of Maine
##catch data
# wc<-read.csv("../data/gulf_of_maine/wcatch.csv")
# head(wc)
# 
# wc2<-as.matrix(wc)
# matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Gulf of Maine")
# 
# w2<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
# w3<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
# w4<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
# w5<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
# w6<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
# w7<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
# w8<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
# w9<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
# 
# grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9, nrow=3)

##Gulf of Maine
##catch data
wc<-read.csv("../data/gulf_of_maine_2017/wcatch.csv")
head(wc)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/gulf_of_maine/watage_year.pdf")
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Gulf of Maine")
dev.off()

w2<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()

pdf("../weight_year_plots/gulf_of_maine/wy_age.pdf")
grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9, nrow=3)
dev.off()

#cohort data
wc<-read.csv("../data/gulf_of_maine_2017/wcatchCohort.csv")
head(wc)
wc[wc==0]<-NA

wc2<-as.matrix(wc)
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Cohorts", ylab="Mean weight at age (kg)", main="Gulf of Maine")

w2<-ggplot(wc, aes(Cohort, wc[,4])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Cohort, wc[,5])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Cohort, wc[,6])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Cohort, wc[,7])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Cohort, wc[,8])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Cohort, wc[,9])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Cohort, wc[,10])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Cohort, wc[,11])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()

grid.arrange(w2,w3,w4,w5,w6,w7,w8,w9, nrow=3)


##North East Arctic
##catch data
wc<-read.csv("../data/NEArctic_cod/wcatch.csv")
head(wc)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/NEArctic/watage_year.pdf")
matplot(wc2[,1],wc2[,2:(dim(wc2)[2]-1)], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="North East Arctic")
dev.off()

w3<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()
w11<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 11") + geom_point() + geom_smooth()
w12<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 12") + geom_point() + geom_smooth()
w13<-ggplot(wc, aes(Year, wc[,12])) + labs(y="Mean weight", title="Age 13") + geom_point() + geom_smooth()
w14<-ggplot(wc, aes(Year, wc[,13])) + labs(y="Mean weight", title="Age 14") + geom_point() + geom_smooth()

pdf("../weight_year_plots/NEArctic/wy_age_3_11.pdf")
grid.arrange(w3,w4,w5,w6,w7,w8,w9,w10,w11, nrow=3)
dev.off()

pdf("../weight_year_plots/NEArctic/wy_age_6_14.pdf")
grid.arrange(w6,w7,w8,w9,w10,w11,w12,w13,w14, nrow=3)
dev.off()

##cohort data
wc<-read.csv("../data/NEArctic_cod/wcatchCohorts.csv")
head(wc)
wc[wc==0]<-NA

wc2<-as.matrix(wc)
pdf("../weight_year_plots/NEArctic/watage_cohort.pdf")
matplot(wc2[,1],wc2[,2:(dim(wc2)[2]-1)], type="l", xlab="Cohorts", ylab="Mean weight at age (kg)", main="North East Arctic")
dev.off()

w3<-ggplot(wc, aes(Cohort, wc[,2])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Cohort, wc[,3])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Cohort, wc[,4])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Cohort, wc[,5])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Cohort, wc[,6])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Cohort, wc[,7])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Cohort, wc[,8])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Cohort, wc[,9])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()
w11<-ggplot(wc, aes(Cohort, wc[,10])) + labs(y="Mean weight", title="Age 11") + geom_point() + geom_smooth()
w12<-ggplot(wc, aes(Cohort, wc[,11])) + labs(y="Mean weight", title="Age 12") + geom_point() + geom_smooth()
w13<-ggplot(wc, aes(Cohort, wc[,12])) + labs(y="Mean weight", title="Age 13") + geom_point() + geom_smooth()
w14<-ggplot(wc, aes(Cohort, wc[,13])) + labs(y="Mean weight", title="Age 14") + geom_point() + geom_smooth()

pdf("../weight_year_plots/NEArctic/wc_age_3_11.pdf")
grid.arrange(w3,w4,w5,w6,w7,w8,w9,w10,w11, nrow=3)
dev.off()

pdf("../weight_year_plots/NEArctic/wc_age_6_14.pdf")
grid.arrange(w6,w7,w8,w9,w10,w11,w12,w13,w14, nrow=3)
dev.off()

##Western Baltic
##catch data
wc<-read.csv("../data/western_baltic/wcatch.csv")
head(wc)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/western_baltic/watage_year.pdf")
matplot(wc2[,1],wc2[,2:(dim(wc2)[2])], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Western Baltic")
dev.off()

w1<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 1") + geom_point() + geom_smooth()
w2<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()

pdf("../weight_year_plots/western_baltic/wy_age.pdf")
grid.arrange(w1,w2,w3,w4,w5,w6,w7, nrow=3)
dev.off()

##Western Baltic
##stock data
wc<-read.csv("../data/western_baltic/wstock.csv")
head(wc)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/western_baltic/watage_year_stockData.pdf")
matplot(wc2[,1],wc2[,2:(dim(wc2)[2])], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Western Baltic_stock data")
dev.off()

w1<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 1") + geom_point() + geom_smooth()
w2<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()

pdf("../weight_year_plots/western_baltic/wy_age_stockData.pdf")
grid.arrange(w1,w2,w3,w4,w5,w6,w7, nrow=3)
dev.off()

##cohort data
wc<-read.csv("../data/western_baltic/wstockCohorts.csv")
head(wc)
wc[wc==0]<-NA

wc2<-as.matrix(wc)
pdf("../weight_year_plots/western_baltic/watage_cohort_stockdata.pdf")
matplot(wc2[,1],wc2[,2:(dim(wc2)[2])], type="l", xlab="Cohorts", ylab="Mean weight at age (kg)", main="Western Baltic_stock data")
dev.off()

#w1<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 1") + geom_point() + geom_smooth()
w2<-ggplot(wc, aes(Cohort, wc[,3])) + labs(y="Mean weight", title="Age 1") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Cohort, wc[,4])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Cohort, wc[,5])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Cohort, wc[,6])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Cohort, wc[,7])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Cohort, wc[,8])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Cohort, wc[,9])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()

pdf("../weight_year_plots/western_baltic/wc_age_stockData.pdf")
grid.arrange(w2,w3,w4,w5,w6,w7,w8, nrow=3)
dev.off()

##Iceland
url <- "http://data.hafro.is/assmt/2017/cod/"
wc <- read.csv(paste0(url, "catch_weights.csv"), check.names = FALSE)
#wc <- colMeans(wc[-1]/1000)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/Iceland/watage_year.pdf")
matplot(wc2[,1],wc2[,2:(dim(wc2)[2])]/1000, type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Iceland")
dev.off()

w3<-ggplot(wc, aes(Year, wc[,2]/1000)) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,3]/1000)) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,4]/1000)) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,5]/1000)) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,6]/1000)) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,7]/1000)) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,8]/1000)) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,9]/1000)) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()
w11<-ggplot(wc, aes(Year, wc[,10]/1000)) + labs(y="Mean weight", title="Age 11") + geom_point() + geom_smooth()
w12<-ggplot(wc, aes(Year, wc[,11]/1000)) + labs(y="Mean weight", title="Age 12") + geom_point() + geom_smooth()
w13<-ggplot(wc, aes(Year, wc[,12]/1000)) + labs(y="Mean weight", title="Age 13") + geom_point() + geom_smooth()
w14<-ggplot(wc, aes(Year, wc[,13]/1000)) + labs(y="Mean weight", title="Age 14") + geom_point() + geom_smooth()

pdf("../weight_year_plots/Iceland/wy_age_3_11.pdf")
grid.arrange(w3,w4,w5,w6,w7,w8,w9,w10,w11, nrow=3)
dev.off()

pdf("../weight_year_plots/Iceland/wy_age_6_14.pdf")
grid.arrange(w6,w7,w8,w9,w10,w11,w12,w13,w14, nrow=3)
dev.off()

##North Sea
library(stockassessment)
#stock data
url <- "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/nscod_ass06_fc17/"
wc <- read.ices(paste0(url, "data/sw.dat"))
wc[wc==0] <- NA

wc2<-as.matrix(wc[,1:12])
pdf("../weight_year_plots/NorthSea/watage_year_stockData.pdf")
matplot(wc2, type="l", xlab="Years", ylab="Mean weight at age (kg)", main="North Sea", xaxt="n")
axis(1, at=seq(1,55,5), labels=seq(1963,2017,5))
dev.off()


wc<- data.frame(wc2)
wc$Year<-as.numeric(row.names(wc))

w2<-ggplot(wc, aes(Year,wc[,1])) + labs(y="Mean weight", title="Age 1") + geom_point() + geom_smooth()
w3<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w11<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()
w12<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 11") + geom_point() + geom_smooth()
w13<-ggplot(wc, aes(Year, wc[,12])) + labs(y="Mean weight", title="Age 12") + geom_point() + geom_smooth()
 
pdf("../weight_year_plots/NorthSea/wy_age_2_7_stockData.pdf")
grid.arrange(w3,w4,w5,w6,w7,w8, nrow=3)
dev.off()

pdf("../weight_year_plots/NorthSea/wy_age_7_12_stockData.pdf")
grid.arrange(w8,w9,w10,w11,w12,w13, nrow=3)
dev.off()

##Newfoundland
#NAFO2J3KL
#catch data
wc <- read.csv("../data/nafo2j3kl/wcatch.csv", check.names = FALSE)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/nafo2j3kl/watage_2to10_year.pdf")
matplot(wc2[,1],wc2[,2:10], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Newfoundland\n age class 2 to 10")
dev.off()

pdf("../weight_year_plots/nafo2j3kl/watage_11to20_year.pdf")
matplot(wc2[,1],wc2[,11:20], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Newfoundland\n age class 11 to 20")
dev.off()

w3<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 2") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w11<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()
w12<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 11") + geom_point() + geom_smooth()
w13<-ggplot(wc, aes(Year, wc[,12])) + labs(y="Mean weight", title="Age 12") + geom_point() + geom_smooth()
w14<-ggplot(wc, aes(Year, wc[,13])) + labs(y="Mean weight", title="Age 13") + geom_point() + geom_smooth()
w15<-ggplot(wc, aes(Year, wc[,14])) + labs(y="Mean weight", title="Age 14") + geom_point() + geom_smooth()
w16<-ggplot(wc, aes(Year, wc[,15])) + labs(y="Mean weight", title="Age 15") + geom_point() + geom_smooth()
w17<-ggplot(wc, aes(Year, wc[,16])) + labs(y="Mean weight", title="Age 16") + geom_point() + geom_smooth()
w18<-ggplot(wc, aes(Year, wc[,17])) + labs(y="Mean weight", title="Age 17") + geom_point() + geom_smooth()
w19<-ggplot(wc, aes(Year, wc[,18])) + labs(y="Mean weight", title="Age 18") + geom_point() + geom_smooth()
w20<-ggplot(wc, aes(Year, wc[,19])) + labs(y="Mean weight", title="Age 19") + geom_point() + geom_smooth()
w21<-ggplot(wc, aes(Year, wc[,20])) + labs(y="Mean weight", title="Age 20") + geom_point() + geom_smooth()

pdf("../weight_year_plots/nafo2j3kl/wy_age_2_10.pdf")
grid.arrange(w3,w4,w5,w6,w7,w8,w9,w10,w11, nrow=3)
dev.off()

pdf("../weight_year_plots/nafo2j3kl/wy_age_11_20.pdf")
grid.arrange(w6,w7,w8,w9,w10,w11,w12,w13,w14, nrow=3)
dev.off()

##Newfoundland
#NAFO3p
#catch data
wc <- read.csv("../data/nafo3p/wcatch.csv", check.names = FALSE)

wc2<-as.matrix(wc)
pdf("../weight_year_plots/nafo3p/watage_year.pdf")
matplot(wc2[,1],wc2[,2:dim(wc2)[2]], type="l", xlab="Years", ylab="Mean weight at age (kg)", main="Newfoundland\nnafo3p")
dev.off()

w3<-ggplot(wc, aes(Year, wc[,2])) + labs(y="Mean weight", title="Age 3") + geom_point() + geom_smooth()
w4<-ggplot(wc, aes(Year, wc[,3])) + labs(y="Mean weight", title="Age 4") + geom_point() + geom_smooth()
w5<-ggplot(wc, aes(Year, wc[,4])) + labs(y="Mean weight", title="Age 5") + geom_point() + geom_smooth()
w6<-ggplot(wc, aes(Year, wc[,5])) + labs(y="Mean weight", title="Age 6") + geom_point() + geom_smooth()
w7<-ggplot(wc, aes(Year, wc[,6])) + labs(y="Mean weight", title="Age 7") + geom_point() + geom_smooth()
w8<-ggplot(wc, aes(Year, wc[,7])) + labs(y="Mean weight", title="Age 8") + geom_point() + geom_smooth()
w9<-ggplot(wc, aes(Year, wc[,8])) + labs(y="Mean weight", title="Age 9") + geom_point() + geom_smooth()
w10<-ggplot(wc, aes(Year, wc[,9])) + labs(y="Mean weight", title="Age 10") + geom_point() + geom_smooth()
w11<-ggplot(wc, aes(Year, wc[,10])) + labs(y="Mean weight", title="Age 11") + geom_point() + geom_smooth()
w12<-ggplot(wc, aes(Year, wc[,11])) + labs(y="Mean weight", title="Age 12") + geom_point() + geom_smooth()
w13<-ggplot(wc, aes(Year, wc[,12])) + labs(y="Mean weight", title="Age 13") + geom_point() + geom_smooth()
w14<-ggplot(wc, aes(Year, wc[,13])) + labs(y="Mean weight", title="Age 14+") + geom_point() + geom_smooth()

pdf("../weight_year_plots/nafo3p/wy_age_3_8.pdf")
grid.arrange(w3,w4,w5,w6,w7,w8, nrow=3)
dev.off()

pdf("../weight_year_plots/nafo3p/wy_age_9_14.pdf")
grid.arrange(w9,w10,w11,w12,w13,w14, nrow=3)
dev.off()

