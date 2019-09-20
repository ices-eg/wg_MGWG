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

########################################################################
#NA Arctic cod (Yaragina pers comm.)
k = 0.055
linf = 196
t0 = -0.94
loptBS=2/3*linf
loptBS #130.67

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptBS=c(predict(vbObj, len=loptBS))
AoptBS #19.03


########################################################################
#Faroe plateau cod (Petur pers comm.)
k = 0.096
linf = 148.3
t0 = -1.53
loptFP=2/3*linf
loptFP #98.87

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptFP=c(predict(vbObj, len=loptFP))
AoptFP #9.91

########################################################################
#NAFO 2J 
k = 0.150
linf = 103.7
t0 = 0
lopt2J=2/3*linf
lopt2J #69.13

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
Aopt2J=c(predict(vbObj, len=lopt2J))
Aopt2J #7.32

########################################################################
#NAFO 3K 
k = 0.138
linf = 107.7
t0 = 0
lopt3K=2/3*linf
lopt3K #71.8

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
Aopt3K=c(predict(vbObj, len=lopt3K))
Aopt3K #7.96

########################################################################
#NAFO 3L
k = 0.087
linf = 153.35
t0 = 0
lopt3L=2/3*linf
lopt3L #92.4

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
Aopt3L=c(predict(vbObj, len=lopt3L))
Aopt3L #12.6

########################################################################
#NE Arctic Lofoten_17
k = 0.152
linf = 124.1
t0 = 1.037
loptBS17=2/3*linf
loptBS17 #82.7

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptBS17=c(predict(vbObj, len=loptBS17))
AoptBS17 #8.26

########################################################################
#NE Arctic Lofoten_18
k = 0.051
linf = 190.9
t0 = -2.93
loptBS18=2/3*linf
loptBS18 #127.27

#Create the von Bertalanffy object
vbObj <- a4aGr(
  grMod=~linf*(1-exp(-k*(t-t0))),      
  grInvMod=~t0-1/k*log(1-len/linf),      
  params=FLPar(linf=linf, k=k, t0=t0, units=c('cm','year-1','year')))

# Predict
AoptBS18=c(predict(vbObj, len=loptBS17))
AoptBS18 #8.21

# ###########################################################################
# #summary of Aopts
# Aopts <- matrix(c(loptNS,AoptNS,loptWB,AoptWB,loptGoM,AoptGoM,loptGB,AoptGB,loptIC,AoptIC,loptBS,AoptBS,loptFP,AoptFP),ncol=2,byrow=TRUE)
# colnames(Aopts) <- c("Lopt (cm)","Aopt (y)")
# rownames(Aopts ) <- c("North Sea","West Baltic","Gulf of Main","George's Bank","Iceland","NE Arctic","Faroes plateau")
# Aopts=round(Aopts,2)
# as.table(Aopts)




