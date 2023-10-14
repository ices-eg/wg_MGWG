years <- function(id, tab=tonnes)
{
  x <- na.omit(tab[c("year",id)])
  rng <- paste(range(tail(x$year, 10)), collapse="-")
  rng
}

catch <- function(id, tab=tonnes)
{
  x <- na.omit(tab[c("year",id)])
  avg <- mean(tail(x[[2]], 10))
  avg
}

abar <- function(x) weighted.mean(as.numeric(names(x)), x)

abar_catch <- function(id)
{
  stock <- get(id)
  if(!is.null(stock$C))
    abar(stock$C)
  else
    NA_real_
}

a50 <- function(x) A50(as.numeric(names(x)), x)

a50mat <- function(id)
{
  stock <- get(id)
  a50(stock$mat)
}

w5 <- function(id)
{
  stock <- get(id)
  stock$wcatch[["5"]]
}
