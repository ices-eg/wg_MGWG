####Extract von Bertalanffy params###
#####################################

alk <-read.csv('../../Aopt_estimates/data/ALK_FP.csv',header = TRUE)
str(alk)

library(ggplot2)
library(FSA)
library(nlstools)

#check for duplicates
n_occur <- data.frame(table(alk$Length, alk$Age))
n_occur[n_occur$Freq > 1,]
#no duplicates

#expand
alk <- alk[rep(row.names(alk), alk$Count), 1:2]
str(alk)

qplot(Age, Length, data = alk, xlab = "Age (yrs)", ylab = "Length (mm)", xlim = c(0, 14))

parvb=vbStarts(Length~Age, data=alk, param="Typical")
unlist(parvb)
svTypical=list(Linf=1251, K=0.15, t0=-0.69) #starting parameters

#formal estimation
vbTypical <- Length~Linf*(1-exp(-K*(Age-t0)))
fitTypical <- nls(vbTypical,data=alk,start=svTypical)

#plot
fitPlot(fitTypical,xlab="Age",ylab="Total Length (cm)",main="")

#compare with starting values curve (green)
age <- 0:14
lp <- parvb$Linf * (1 - exp(-parvb$K * (age - parvb$t0)))
fitPlot(fitTypical,xlab="Age",ylab="Total Length (cm)",main="")
lines(sort(age), sort(lp), col = 3, lwd = 2)

overview(fitTypical) # gives the vB parameters with confidence intervals

residPlot(fitTypical)
hist(residuals(fitTypical),main="")









