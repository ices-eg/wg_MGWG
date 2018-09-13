applyF0.1 <- function(Ninit, M, sel, mat, wcatch, wstock=wcatch)
{
  len <- length(sel)
  M <- rep(M, length=len)

  stock <- function(Fmult)
  {
    Fvec <- Fmult * sel
    Z <- Fvec + M
    N <- numeric(len)
    N[1] <- Ninit
    for(i in 1:(len-1))
      N[i+1] <- N[i] * exp(-Z[i])
    names(N) <- names(sel)
    C <- Fvec/Z * N *(1-exp(-Z))
    Y <- sum(C * wcatch)
    list(Fmult=Fmult, N=N, Fvec=Fvec, C=C,
         B=sum(N*wstock), SSB=sum(N*wstock*mat), Y=Y)
  }
  yield <- function(Fmult) stock(Fmult)$Y
  slope <- function(Fmult, dx=1e-6) (yield(Fmult+dx/2) - yield(Fmult-dx/2)) / dx

  Fmult <- 0
  step <- 1e-4
  while(slope(Fmult) > 0.1*slope(0))
    Fmult <- Fmult + step
  stock(Fmult)
}

## Example
## Ninit <- 136
## M <- 0.2
## sel <- c(0.05, 0.19, 0.40, 0.63, 0.78, 0.89, 0.94, 1.00, 0.96, 0.97, 0.89, 0.89)
## mat <- c(0.00, 0.04, 0.21, 0.50, 0.75, 0.85, 0.82, 0.93, 0.91, 1.00, 1.00, 1.00)
## w <- c(1.2, 1.7, 2.4, 3.3, 4.3, 5.4, 6.4, 7.4, 8.7, 10.1, 11.6, 14.6)
## applyF0.1(Ninit, M, sel, mat, w)
