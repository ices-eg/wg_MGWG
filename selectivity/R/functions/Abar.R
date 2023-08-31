Abar <- function(x)
{
  if(any(names(x) == "Year"))
  {
    row.names(x) <- x$Year
    x$Year <- NULL
  }

  names(x) <- gsub("+", "", names(x), fixed=TRUE)  # rename "14+" to "14"
  a <- as.integer(names(x))
  cp <- drop(crossprod(a, t(x)))
  abar <- cp / rowSums(x)
  abar
}
