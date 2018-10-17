## Profile the effect of sliding the selectivity left or right
profSlide <- function(stock, shift=seq(-2,2), strategy=applyFmax, focus="Y",
                      div=1000)
{
  n <- length(shift)
  yield <- numeric(n)
  for(i in 1:n)
    yield[i] <-
      with(stock, strategy(Ninit, M, slide(S,shift[i]), mat, wcatch)[[focus]])
  yield <- yield / div
  data.frame(shift, yield)
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
## profSlide(iceland)
