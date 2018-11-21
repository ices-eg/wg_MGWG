####Predict Aopt from Lopt with a4a###
#####################################

library(FLa4a)


########################################################################
#West Baltic (Froese et al. 2008)
k = 0.13
linf = 120
t0 = -0.90
M=0.2
FM=0.92

AoptWB=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptWB

########################################################################
#NE Arctic cod (Yaragina pers comm.)
k = 0.055
linf = 196
t0 = -0.94
M=0.2
FM=0.30

AoptBS=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptBS #7.74


########################################################################
#NE Arctic Lofoten_17
k = 0.152
linf = 124.1
t0 = 1.037
M=0.21
FM=0.30

AoptBS17=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptBS17 #6.91

########################################################################
#NE Arctic Lofoten_18
k = 0.051
linf = 190.9
t0 = -2.93
M=0.21
FM=0.30

AoptBS18=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptBS18 #5.93


########################################################################
#Gulf of Maine cod (stock assessment report)
k = 0.11
linf = 150.93
t0 = 0.13
M=0.2
FM=1.073
  
AoptGoM=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptGoM #8.23

########################################################################
#Georges Bank cod (stock assessment report)
k = 0.28
linf = 91.63
t0 = 0.32
M=0.2
FM=0.544

AoptGB=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptGB #5.067


########################################################################
#North Sea cod (Froese et al. 2008)
k = 0.14
linf = 129.1
t0 = -0.82
M=0.2
FM=0.504

AoptNS=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptNS #5.96

########################################################################
#Icelandic cod (Elvarsson pers comm.)
k = 0.104
linf = 153.67
t0 = 0.34
M=0.2
FM=0.336

AoptIC=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptIC #7.67

########################################################################
#Faroe plateau cod (Petur pers comm.)
k = 0.096
linf = 148.3
t0 = -1.53
M=0.2
FM=0.533

AoptF=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
AoptF #6.48

########################################################################
#NAFO 2J 
k = 0.150
linf = 103.7
t0 = 0
M=0.42
FM=0.059

Aopt2J=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
Aopt2J #3.04

########################################################################
#NAFO 3K 
k = 0.138
linf = 107.7
t0 = 0
M=0.42
FM=0.059

Aopt3K=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
Aopt3K #3.14

########################################################################
#NAFO 3L
k = 0.087
linf = 153.35
t0 = 0
M=0.42
FM=0.059

Aopt3L=t0+(log(((FM+M)*(3*k+M))/(M*(FM+k+M)))/k)
Aopt3L #3.14


# ###########################################################################
# #summary of Aopts
# Aopts <- matrix(c(loptNS,AoptNS,loptWB,AoptWB,loptGoM,AoptGoM,loptGB,AoptGB,loptIC,AoptIC,loptBS,AoptBS,loptFP,AoptFP),ncol=2,byrow=TRUE)
# colnames(Aopts) <- c("Lopt (cm)","Aopt (y)")
# rownames(Aopts ) <- c("North Sea","West Baltic","Gulf of Main","George's Bank","Iceland","NE Arctic","Faroes plateau")
# Aopts=round(Aopts,2)
# as.table(Aopts)




