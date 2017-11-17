w <- c(1.2, 1.7, 2.4, 3.3, 4.3, 5.4, 6.4, 7.4, 8.7, 10.1, 11.6, 14.6)
M <- 0.2

Fsel <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1)
Ftime <- 0

Fcalc <- function(Fsel,Ftime){
  c(  Fsel %o% Ftime )
}
Fm <- Fcalc(Fsel, Ftime)
Fm

Z <- Fm + M
Ninit <- 136

N[1] <- Ninit
for(i in 2:length(Z))
{
  N[i] <- N[i-1]*exp(-Z[i])
}

N
foo <- function(N, w)
{
  c(N*w)
}

foo(N, w)
