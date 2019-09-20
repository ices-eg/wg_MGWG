####Extract von Bertalanffy params###
#####################################

#2017
alk <-read.csv('../../Aopt_estimates/data/ALK_BS_17.csv',header = TRUE)
str(alk)

library(ggplot2)
library(FSA)
library(nlstools)

qplot(Age, Length, data = alk, xlab = "Age (yrs)", ylab = "Length (mm)", xlim = c(5, 14))

parvb=vbStarts(Length~Age, data=alk, param="Typical")
unlist(parvb)
svTypical=list(Linf=1293, K=0.128, t0=0.404) #starting parameters

#formal estimation
vbTypical <- Length~Linf*(1-exp(-K*(Age-t0)))
fitTypical <- nls(vbTypical,data=alk,start=svTypical)
ftiTypical_17=fitTypical
ftiTypical_17

#plot
fitPlot(fitTypical,xlab="Age",ylab="Total Length (cm)",main="")

#compare with starting values curve (green)
age <- 5:14
lp <- parvb$Linf * (1 - exp(-parvb$K * (age - parvb$t0)))
fitPlot(fitTypical,xlab="Age",ylab="Total Length (cm)",main="")
lines(sort(age), sort(lp), col = 3, lwd = 2)

overview(fitTypical) # gives the vB parameters with confidence intervals

residPlot(fitTypical)
hist(residuals(fitTypical),main="")

#2018
alk <-read.csv('../../Aopt_estimates/data/ALK_BS_18.csv',header = TRUE)
str(alk)


qplot(Age, Length, data = alk, xlab = "Age (yrs)", ylab = "Length (mm)", xlim = c(5, 14))

parvb=vbStarts(Length~Age, data=alk, param="Typical")
unlist(parvb)
svTypical=list(Linf=1293, K=0.128, t0=0.404) #starting parameters from 2017

#formal estimation
vbTypical <- Length~Linf*(1-exp(-K*(Age-t0)))
fitTypical <- nls(vbTypical,data=alk,start=svTypical)
ftiTypical_18=fitTypical
ftiTypical_18

#plot
fitPlot(fitTypical,xlab="Age",ylab="Total Length (cm)",main="")

#compare with starting values curve (green)
age <- 5:14
lp <- parvb$Linf * (1 - exp(-parvb$K * (age - parvb$t0)))
fitPlot(fitTypical,xlab="Age",ylab="Total Length (cm)",main="")
lines(sort(age), sort(lp), col = 3, lwd = 2)

overview(fitTypical) # gives the vB parameters with confidence intervals

residPlot(fitTypical)
hist(residuals(fitTypical),main="")













