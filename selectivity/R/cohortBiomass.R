cohortBiomass <- function(Ninit, w, M, Fvec = 0)
{
  len <- length(w)
  M <- rep(M, length=len)
  Fvec <- rep(Fvec, length=len)
  Z <- Fvec + M
  N <- numeric(len)
  N[1] <- Ninit
  for(i in 1:(len-1))
    N[i+1] <- N[i] * exp(-Z[i])
  B <- N * w
  B
}

## Example
## Ninit <- 136
## w <- c(1.2, 1.7, 2.4, 3.3, 4.3, 5.4, 6.4, 7.4, 8.7, 10.1, 11.6, 14.6)
## names(w) <- 3:14
## M <- 0.2
## B <- cohortBiomass(Ninit, w, M)
## barplot(B)

## For later consideration
## Fsel <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1)
## Ftime <- 0

## Fcalc <- function(Fsel,Ftime){
##   c(Fsel%o%Ftime )
## }

## Fm <- Fcalc(Fsel, Ftime)
## Fm
