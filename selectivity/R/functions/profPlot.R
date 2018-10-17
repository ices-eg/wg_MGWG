## Plot results from prof()
profPlot <- function(stock, shift, strategy=applyFmax, focus="Y",
                     xlim=range(shift), ylim=NULL)
{
  main <- deparse(substitute(stock))
  ylab <- switch(focus, Y="Potential yield (kt)", SSB="SSB (kt)")
  stock$profile <- prof(stock, shift, strategy, focus)
  plot(stock$profile, type="l", xlim=xlim, ylim=ylim, yaxs="i",
       xlab="Age shift (yrs)", ylab=ylab, main=main)
  points(stock$profile[stock$profile$shift==0,])
}
