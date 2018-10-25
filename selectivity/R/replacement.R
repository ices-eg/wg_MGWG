## Demo of replacement line,
## loosely based on Legault and Brooks (2013)

stock <- function(Ninit, M, wcatch, wstock, mat, Fvec)
{
  len <- length(wcatch)
  Z <- Fvec + M
  N <- numeric(len)
  N[1] <- Ninit
  for(i in 1:(len-1))
    N[i+1] <- N[i] * exp(-Z[i])
  names(N) <- names(wcatch)
  C <- Fvec/Z * N *(1-exp(-Z))
  Y <- sum(C * wcatch)
  list(Fmult=Fmult, N=N, Fvec=Fvec, C=C,
       B=sum(N*wstock), SSB=sum(N*wstock*mat), Y=Y)
}

bevholt <- function (a, b, S)
  a*S / (b+S)

dat <- read.table(text="
a       M       w       mat     S
1       0.2     0.087   0.1     0.0
2       0.2     0.459   0.5     0.1
3       0.2     1.045   0.9     0.2
4       0.2     1.706   1.0     0.5
5       0.2     2.344   1.0     0.8
6       0.2     2.908   1.0     0.9
7       0.2     3.379   1.0     1.0
8       0.2     3.759   1.0     1.0
9       0.2     4.058   1.0     1.0
10      0.2     4.290   1.0     1.0
11      0.2     4.467   1.0     1.0
12      0.2     4.601   1.0     1.0
13      0.2     4.702   1.0     1.0
14      0.2     4.778   1.0     1.0
15      0.2     4.835   1.0     1.0
16      0.2     4.878   1.0     1.0
17      0.2     4.909   1.0     1.0
18      0.2     4.933   1.0     1.0
19      0.2     4.950   1.0     1.0
20      0.2     4.963   1.0     1.0
", header=TRUE)

################################################################################

a <- 10
b <- 10
Svec <- seq(0, 120)
Rvec <- bevholt(a, b, Svec)

plot(Svec, Rvec, type="l")

################################################################################

Fmult <- seq(0, 2, by=0.1)
n <- length(Fmult)
spr <- numeric(n)
ypr <- numeric(n)

for(i in 1:n)
{
  spr[i] <- stock(1, dat$M, dat$w, dat$w, dat$mat, Fmult[i]*dat$S)$SSB
  ypr[i] <- stock(1, dat$M, dat$w, dat$w, dat$mat, Fmult[i]*dat$S)$Y
}

par(mfrow=c(2,1))
plot(Fmult, spr, ylim=c(0,1.1*max(spr)), type="l", lwd=2, col="firebrick",
     main="Yield and SSB per recruit", xlab="F", ylab="YPR and SPR (kg)")
lines(Fmult, ypr, lwd=2, col="darkgreen")

################################################################################

rps <- 1 / spr

i <- 2
main <- paste("Replacement line when F=", Fmult[i])
plot(Svec, Rvec, type="l", xaxs="i", yaxs="i", lwd=2,
     main=main, xlab="SSB", ylab="Rec")
abline(a=0, b=rps[i], lty=3, lwd=2)
