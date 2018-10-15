cohortBiomass <- function(Ninit, M, w, Fvec=0)
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
## M <- 0.2
## w <- c(1.2, 1.7, 2.4, 3.3, 4.3, 5.4, 6.4, 7.4, 8.7, 10.1, 11.6, 14.6)
## names(w) <- 3:14
## B <- cohortBiomass(Ninit, M, w)
## barplot(B)
