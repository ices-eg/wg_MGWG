####Predict Aopt from Lopt with a4a###
#####################################

library(FLa4a)

########################################################################
#North Sea cod (Froese et al. 2008)
k = 0.14
linf = 129.1
t0 = -0.82
loptNS=2/3*linf
loptNS #86.07

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict Aopt
AoptNS=c(predict(vbObj, len=loptNS))
AoptNS #7.03

########################################################################
#West Baltic (Froese et al. 2008)
k = 0.13
linf = 120
t0 = -0.90
loptWB=2/3*linf
loptWB #80

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptWB=c(predict(vbObj, len=loptWB))
AoptWB #7.55

########################################################################
#Gulf of Maine cod (stock assessment report)
k = 0.11
linf = 150.93
t0 = 0.13
loptGoM=2/3*linf
loptGoM #100.62

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptGoM=c(predict(vbObj, len=loptGoM))
AoptGoM #10.12

########################################################################
#Georges Bank cod (stock assessment report)
k = 0.28
linf = 91.63
t0 = 0.32
loptGB=2/3*linf
loptGB #61.09

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptGB=c(predict(vbObj, len=loptGB))
AoptGB #4.24

########################################################################
#Icelandic cod (Elvarsson pers comm.)
k = 0.104
linf = 153.67
t0 = 0.34
loptIC=2/3*linf
loptIC #102.45

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptIC=c(predict(vbObj, len=loptIC))
AoptIC #10.28

###########################################################################
#summary of Aopts
Aopts <- matrix(c(loptNS,AoptNS,loptWB,AoptWB,loptGoM,AoptGoM,loptGB,AoptGB,loptIC,AoptIC),ncol=2,byrow=TRUE)
colnames(Aopts) <- c("Lopt (cm)","Aopt (y)")
rownames(Aopts ) <- c("North Sea","West Baltic","Gulf of Main","George's Bank","Iceland")
Aopts=round(Aopts,2)
as.table(Aopts)




