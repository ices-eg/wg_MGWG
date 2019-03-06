library(reshape)
library(minpack.lm)

#Greenland cod

fm <-read.csv('../../selectivity/data/greenland/fatage.csv',
                header = TRUE)
mat <-read.csv('../../selectivity/data/greenland/maturity.csv',
                header = TRUE)
fm
mat
#stock-specific adjustments; e.g. making sure fm and mat have same years, sorting out NAs
#fm
#mat=mat[-c(1:21,55:57),-2]
#mat[is.na(mat)] <- 0.001
fm$X2=0
fm=fm[,c(1,10,2:9)]

age=seq(2,10)#adjust to stock ages
ny=nrow(fm)

S <- fm
S[, -1] <- fm[, -1] / apply(fm[, -1], 1, max) #generates selectivity matrix

#to avoid the disproportionate effect of reduced selection of older ages on the A50 of the curve
#selectivities after the fully selected age-class (S=1) are replaced by 1
mod <- t(apply(S[, -1], 1, function(x) {
  temp = if (any(x == 1, na.rm = T))
    which(x == 1)
  else
    length(x)
  x[temp:length(x)] <- 1
  x
}))
S <- data.frame(cbind(min(fm$Year):max(fm$Year), mod))


###Storage including selectivity and maturity
agesel <- data.frame(array(NA, dim = c(ncol(S)-1, 2))) 
colnames(agesel) <- c("age", "S")
agesel[, 1] <- age
agesel$M <- NA

store <- data.frame(A50 = rep(NA, ny),
                    SR = rep(NA, ny),
                    Am50 = rep(NA, ny),
                    r =rep(NA, ny))

#Fit nonlinear least-squares for selectivity
vonbf.minpack.S <- function(wk.p) {
  wk.A50 <- wk.p[1]
  wk.SR <- wk.p[2]
  age <- 1 / (1 + exp(log(9) * (wk.A50 - agesel$age) / wk.SR)) #MacLennan's selectivity formula (MacLennan 1995)
  age.diff <- agesel$S - age # Residuals NOT squared!
  age.diff
}

#Fit nonlinear least-squares for maturity
vonbf.minpack.M <- function(wk.p) {
  wk.Am50 <- wk.p[1]
  wk.r <- wk.p[2]
  age <- 1/(1+exp(wk.r*(agesel$age-wk.Am50)))
  age.diff <- agesel$M - age # Residuals NOT squared!
  age.diff
}

# set starting values for selectivity and maturity parameters. check S and mat to decide
A50.S <- 5  
SR.S <- 1
params.S <- c(A50.S, SR.S)

Am50.M <- 5
r.M <- 1 
params.M <- c(Am50.M, r.M)

mqdt.control <- list(ftol = 0.00001,ptol = 0.00001,gtol = 0,diag = numeric(),factor = 100,
                     maxfev = 100 * (length(params.M) + 1))

### Run the loop

for (i in 1:ny) {
  
  agesel[,2] <- unname(as.data.frame(t(S[i,c(2:ncol(S))])))
  agesel[,3] <- unname(as.data.frame(t(mat[i,c(2:ncol(mat))])))
  
  vb.minpack.S <-nls.lm(params.S, fn = vonbf.minpack.S, control = mqdt.control)
  vb.minpack.M <-nls.lm(params.M, fn = vonbf.minpack.M, control = mqdt.control)
  
  store$A50[i] <- vb.minpack.S$par[1]
  store$SR[i] <- vb.minpack.S$par[2]
  store$Am50[i] <- vb.minpack.M$par[1]
  store$r[i] <- vb.minpack.M$par[2]
}
store$A50[store$A50 < 0] <- 0
store$Am50[store$Am50 < 0] <- 0
diffA50 <- store$A50 - store$Am50

fbar=rowMeans(fm[,c(4:8)]) # ages 4-8

df<-data.frame('diffA50'=mean(tail(diffA50,10)), 'Am50'=mean(tail(store$Am50,10)),'As50'=mean(tail(store$A50,10)), 'SR'=mean(tail(store$SR,10)),'fbar'=mean(tail(fbar,10)))

df=round(df,3)
df

###########################################################
#NAFO 3m

fm <-read.csv('../../selectivity/data/nafo_3m/fatage.csv',
              header = TRUE)
mat <-read.csv('../../selectivity/data/nafo_3m/maturity.csv',
               header = TRUE)
fm
mat
#stock-specific adjustments; e.g. making sure fm and mat have same years, sorting out NAs
#fm
#mat=mat[-c(1:21,55:57),-2]
#mat[is.na(mat)] <- 0.001
#fm$X2=0
#fm=fm[,c(1,10,2:9)]

age=seq(1,8)#adjust to stock ages
ny=nrow(fm)

S <- fm
S[, -1] <- fm[, -1] / apply(fm[, -1], 1, max) #generates selectivity matrix

#to avoid the disproportionate effect of reduced selection of older ages on the A50 of the curve
#selectivities after the fully selected age-class (S=1) are replaced by 1
mod <- t(apply(S[, -1], 1, function(x) {
  temp = if (any(x == 1, na.rm = T))
    which(x == 1)
  else
    length(x)
  x[temp:length(x)] <- 1
  x
}))
S <- data.frame(cbind(min(fm$Year):max(fm$Year), mod))


###Storage including selectivity and maturity
agesel <- data.frame(array(NA, dim = c(ncol(S)-1, 2))) 
colnames(agesel) <- c("age", "S")
agesel[, 1] <- age
agesel$M <- NA

store <- data.frame(A50 = rep(NA, ny),
                    SR = rep(NA, ny),
                    Am50 = rep(NA, ny),
                    r =rep(NA, ny))

#Fit nonlinear least-squares for selectivity
vonbf.minpack.S <- function(wk.p) {
  wk.A50 <- wk.p[1]
  wk.SR <- wk.p[2]
  age <- 1 / (1 + exp(log(9) * (wk.A50 - agesel$age) / wk.SR)) #MacLennan's selectivity formula (MacLennan 1995)
  age.diff <- agesel$S - age # Residuals NOT squared!
  age.diff
}

#Fit nonlinear least-squares for maturity
vonbf.minpack.M <- function(wk.p) {
  wk.Am50 <- wk.p[1]
  wk.r <- wk.p[2]
  age <- 1/(1+exp(wk.r*(agesel$age-wk.Am50)))
  age.diff <- agesel$M - age # Residuals NOT squared!
  age.diff
}

# set starting values for selectivity and maturity parameters. check S and mat to decide
A50.S <- 4  
SR.S <- 2
params.S <- c(A50.S, SR.S)

Am50.M <- 5
r.M <- 1 
params.M <- c(Am50.M, r.M)

mqdt.control <- list(ftol = 0.00001,ptol = 0.00001,gtol = 0,diag = numeric(),factor = 100,
                     maxfev = 100 * (length(params.M) + 1))

### Run the loop

for (i in 1:ny) {
  
  agesel[,2] <- unname(as.data.frame(t(S[i,c(2:ncol(S))])))
  agesel[,3] <- unname(as.data.frame(t(mat[i,c(2:ncol(mat))])))
  
  vb.minpack.S <-nls.lm(params.S, fn = vonbf.minpack.S, control = mqdt.control)
  vb.minpack.M <-nls.lm(params.M, fn = vonbf.minpack.M, control = mqdt.control)
  
  store$A50[i] <- vb.minpack.S$par[1]
  store$SR[i] <- vb.minpack.S$par[2]
  store$Am50[i] <- vb.minpack.M$par[1]
  store$r[i] <- vb.minpack.M$par[2]
}
store$A50[store$A50 < 0] <- 0
store$Am50[store$Am50 < 0] <- 0
diffA50 <- store$A50 - store$Am50

fbar=rowMeans(fm[,c(4:6)]) # ages 3-5

df<-data.frame('diffA50'=mean(tail(diffA50,10)), 'Am50'=mean(tail(store$Am50,10)),'As50'=mean(tail(store$A50,10)), 'SR'=mean(tail(store$SR,10)),'fbar'=mean(tail(fbar,10)))

df=round(df,3)
df

###########################################################
#NAFO 3no

fm <-read.csv('../../selectivity/data/nafo_3no/fatage.csv',
              header = TRUE)
mat <-read.csv('../../selectivity/data/nafo_3no/maturity.csv',
               header = TRUE)
fm
mat
#stock-specific adjustments; e.g. making sure fm and mat have same years, sorting out NAs
#fm
#mat=mat[-c(1:21,55:57),-2]
#mat[is.na(mat)] <- 0.001
fm$X1=0
fm=fm[,c(1,13,2:12)]
mat=mat[6:64,1:13]

age=seq(1,12)#adjust to stock ages
ny=nrow(fm)

S <- fm
S[, -1] <- fm[, -1] / apply(fm[, -1], 1, max) #generates selectivity matrix

#to avoid the disproportionate effect of reduced selection of older ages on the A50 of the curve
#selectivities after the fully selected age-class (S=1) are replaced by 1
mod <- t(apply(S[, -1], 1, function(x) {
  temp = if (any(x == 1, na.rm = T))
    which(x == 1)
  else
    length(x)
  x[temp:length(x)] <- 1
  x
}))
S <- data.frame(cbind(min(fm$Year):max(fm$Year), mod))


###Storage including selectivity and maturity
agesel <- data.frame(array(NA, dim = c(ncol(S)-1, 2))) 
colnames(agesel) <- c("age", "S")
agesel[, 1] <- age
agesel$M <- NA

store <- data.frame(A50 = rep(NA, ny),
                    SR = rep(NA, ny),
                    Am50 = rep(NA, ny),
                    r =rep(NA, ny))

#Fit nonlinear least-squares for selectivity
vonbf.minpack.S <- function(wk.p) {
  wk.A50 <- wk.p[1]
  wk.SR <- wk.p[2]
  age <- 1 / (1 + exp(log(9) * (wk.A50 - agesel$age) / wk.SR)) #MacLennan's selectivity formula (MacLennan 1995)
  age.diff <- agesel$S - age # Residuals NOT squared!
  age.diff
}

#Fit nonlinear least-squares for maturity
vonbf.minpack.M <- function(wk.p) {
  wk.Am50 <- wk.p[1]
  wk.r <- wk.p[2]
  age <- 1/(1+exp(wk.r*(agesel$age-wk.Am50)))
  age.diff <- agesel$M - age # Residuals NOT squared!
  age.diff
}

# set starting values for selectivity and maturity parameters. check S and mat to decide
A50.S <- 3  
SR.S <- 1
params.S <- c(A50.S, SR.S)

Am50.M <- 6
r.M <- 1 
params.M <- c(Am50.M, r.M)

mqdt.control <- list(ftol = 0.00001,ptol = 0.00001,gtol = 0,diag = numeric(),factor = 100,
                     maxfev = 100 * (length(params.M) + 1))

### Run the loop

for (i in 1:ny) {
  
  agesel[,2] <- unname(as.data.frame(t(S[i,c(2:ncol(S))])))
  agesel[,3] <- unname(as.data.frame(t(mat[i,c(2:ncol(mat))])))
  
  vb.minpack.S <-nls.lm(params.S, fn = vonbf.minpack.S, control = mqdt.control)
  vb.minpack.M <-nls.lm(params.M, fn = vonbf.minpack.M, control = mqdt.control)
  
  store$A50[i] <- vb.minpack.S$par[1]
  store$SR[i] <- vb.minpack.S$par[2]
  store$Am50[i] <- vb.minpack.M$par[1]
  store$r[i] <- vb.minpack.M$par[2]
}
store$A50[store$A50 < 0] <- 0
store$Am50[store$Am50 < 0] <- 0
diffA50 <- store$A50 - store$Am50

fbar=rowMeans(fm[,c(5:7)]) # ages 4-6

df<-data.frame('diffA50'=mean(tail(diffA50,10)), 'Am50'=mean(tail(store$Am50,10)),'As50'=mean(tail(store$A50,10)), 'SR'=mean(tail(store$SR,10)),'fbar'=mean(tail(fbar,10)))

df=round(df,3)
df

###########################################################
#Norway

fm <-read.csv('../../selectivity/data/norway/fatage.csv',
              header = TRUE)
mat <-read.csv('../../selectivity/data/norway/maturity.csv',
               header = TRUE)
fm
mat
#stock-specific adjustments; e.g. making sure fm and mat have same years, sorting out NAs
#fm
#mat=mat[-c(1:21,55:57),-2]
#mat[is.na(mat)] <- 0.001
fm$X10=fm$X9
#fm=fm[,c(1,13,2:12)]
mat=mat[25:34,]

age=seq(2,10)#adjust to stock ages
ny=nrow(fm)

S <- fm
S[, -1] <- fm[, -1] / apply(fm[, -1], 1, max) #generates selectivity matrix

#to avoid the disproportionate effect of reduced selection of older ages on the A50 of the curve
#selectivities after the fully selected age-class (S=1) are replaced by 1
mod <- t(apply(S[, -1], 1, function(x) {
  temp = if (any(x == 1, na.rm = T))
    which(x == 1)
  else
    length(x)
  x[temp:length(x)] <- 1
  x
}))
S <- data.frame(cbind(min(fm$Year):max(fm$Year), mod))


###Storage including selectivity and maturity
agesel <- data.frame(array(NA, dim = c(ncol(S)-1, 2))) 
colnames(agesel) <- c("age", "S")
agesel[, 1] <- age
agesel$M <- NA

store <- data.frame(A50 = rep(NA, ny),
                    SR = rep(NA, ny),
                    Am50 = rep(NA, ny),
                    r =rep(NA, ny))

#Fit nonlinear least-squares for selectivity
vonbf.minpack.S <- function(wk.p) {
  wk.A50 <- wk.p[1]
  wk.SR <- wk.p[2]
  age <- 1 / (1 + exp(log(9) * (wk.A50 - agesel$age) / wk.SR)) #MacLennan's selectivity formula (MacLennan 1995)
  age.diff <- agesel$S - age # Residuals NOT squared!
  age.diff
}

#Fit nonlinear least-squares for maturity
vonbf.minpack.M <- function(wk.p) {
  wk.Am50 <- wk.p[1]
  wk.r <- wk.p[2]
  age <- 1/(1+exp(wk.r*(agesel$age-wk.Am50)))
  age.diff <- agesel$M - age # Residuals NOT squared!
  age.diff
}

# set starting values for selectivity and maturity parameters. check S and mat to decide
A50.S <- 4  
SR.S <- 1
params.S <- c(A50.S, SR.S)

Am50.M <- 5
r.M <- 1 
params.M <- c(Am50.M, r.M)

mqdt.control <- list(ftol = 0.00001,ptol = 0.00001,gtol = 0,diag = numeric(),factor = 100,
                     maxfev = 100 * (length(params.M) + 1))

### Run the loop

for (i in 1:ny) {
  
  agesel[,2] <- unname(as.data.frame(t(S[i,c(2:ncol(S))])))
  agesel[,3] <- unname(as.data.frame(t(mat[i,c(2:ncol(mat))])))
  
  vb.minpack.S <-nls.lm(params.S, fn = vonbf.minpack.S, control = mqdt.control)
  vb.minpack.M <-nls.lm(params.M, fn = vonbf.minpack.M, control = mqdt.control)
  
  store$A50[i] <- vb.minpack.S$par[1]
  store$SR[i] <- vb.minpack.S$par[2]
  store$Am50[i] <- vb.minpack.M$par[1]
  store$r[i] <- vb.minpack.M$par[2]
}
store$A50[store$A50 < 0] <- 0
store$Am50[store$Am50 < 0] <- 0
diffA50 <- store$A50 - store$Am50

fbar=rowMeans(fm[,c(4:7)]) # ages 4-7

df<-data.frame('diffA50'=mean(tail(diffA50,10)), 'Am50'=mean(tail(store$Am50,10)),'As50'=mean(tail(store$A50,10)), 'SR'=mean(tail(store$SR,10)),'fbar'=mean(tail(fbar,10)))

df=round(df,3)
df

###########################################################
#South Celtic

fm <-read.csv('../../selectivity/data/s_celtic/fatage.csv',
              header = TRUE)
mat <-read.csv('../../selectivity/data/s_celtic/maturity.csv',
               header = TRUE)
fm
mat
#stock-specific adjustments; e.g. making sure fm and mat have same years, sorting out NAs
#fm
#mat=mat[-c(1:21,55:57),-2]
#mat[is.na(mat)] <- 0.001
#fm$X10=fm$X9
#fm=fm[,c(1,13,2:12)]
#mat=mat[25:34,]

age=seq(1,7)#adjust to stock ages
ny=nrow(fm)

S <- fm
S[, -1] <- fm[, -1] / apply(fm[, -1], 1, max) #generates selectivity matrix

#to avoid the disproportionate effect of reduced selection of older ages on the A50 of the curve
#selectivities after the fully selected age-class (S=1) are replaced by 1
mod <- t(apply(S[, -1], 1, function(x) {
  temp = if (any(x == 1, na.rm = T))
    which(x == 1)
  else
    length(x)
  x[temp:length(x)] <- 1
  x
}))
S <- data.frame(cbind(min(fm$Year):max(fm$Year), mod))


###Storage including selectivity and maturity
agesel <- data.frame(array(NA, dim = c(ncol(S)-1, 2))) 
colnames(agesel) <- c("age", "S")
agesel[, 1] <- age
agesel$M <- NA

store <- data.frame(A50 = rep(NA, ny),
                    SR = rep(NA, ny),
                    Am50 = rep(NA, ny),
                    r =rep(NA, ny))

#Fit nonlinear least-squares for selectivity
vonbf.minpack.S <- function(wk.p) {
  wk.A50 <- wk.p[1]
  wk.SR <- wk.p[2]
  age <- 1 / (1 + exp(log(9) * (wk.A50 - agesel$age) / wk.SR)) #MacLennan's selectivity formula (MacLennan 1995)
  age.diff <- agesel$S - age # Residuals NOT squared!
  age.diff
}

#Fit nonlinear least-squares for maturity
vonbf.minpack.M <- function(wk.p) {
  wk.Am50 <- wk.p[1]
  wk.r <- wk.p[2]
  age <- 1/(1+exp(wk.r*(agesel$age-wk.Am50)))
  age.diff <- agesel$M - age # Residuals NOT squared!
  age.diff
}

# set starting values for selectivity and maturity parameters. check S and mat to decide
A50.S <- 2  
SR.S <- 1
params.S <- c(A50.S, SR.S)

Am50.M <- 2
r.M <- 1 
params.M <- c(Am50.M, r.M)

mqdt.control <- list(ftol = 0.00001,ptol = 0.00001,gtol = 0,diag = numeric(),factor = 100,
                     maxfev = 100 * (length(params.M) + 1))

### Run the loop

for (i in 1:ny) {
  
  agesel[,2] <- unname(as.data.frame(t(S[i,c(2:ncol(S))])))
  agesel[,3] <- unname(as.data.frame(t(mat[i,c(2:ncol(mat))])))
  
  vb.minpack.S <-nls.lm(params.S, fn = vonbf.minpack.S, control = mqdt.control)
  vb.minpack.M <-nls.lm(params.M, fn = vonbf.minpack.M, control = mqdt.control)
  
  store$A50[i] <- vb.minpack.S$par[1]
  store$SR[i] <- vb.minpack.S$par[2]
  store$Am50[i] <- vb.minpack.M$par[1]
  store$r[i] <- vb.minpack.M$par[2]
}
store$A50[store$A50 < 0] <- 0
store$Am50[store$Am50 < 0] <- 0
diffA50 <- store$A50 - store$Am50

fbar=rowMeans(fm[,c(3:6)]) # ages 2-5

df<-data.frame('diffA50'=mean(tail(diffA50,10)), 'Am50'=mean(tail(store$Am50,10)),'As50'=mean(tail(store$A50,10)), 'SR'=mean(tail(store$SR,10)),'fbar'=mean(tail(fbar,10)))

df=round(df,3)
df
