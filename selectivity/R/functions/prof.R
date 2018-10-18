## Profile the effect of sliding the selectivity left or right
prof <- function(stock, shift=seq(-2,2), strategy=applyFmax, focus="Y",
                 div=1000)
{
  n <- length(shift)
  result <- numeric(n)
  for(i in 1:n)
    result[i] <- with(stock, strategy(Ninit, M, slide(S,shift[i]),
                                      mat, wcatch, wstock)[[focus]])
  result <- result / div
  data.frame(shift, result)
}

## Example
##
## source("applyFmax.R")
## source("slide.R")
##
## owd <- setwd("../stocks")
## source("iceland.R")
## setwd(owd)
##
## prof(iceland)
