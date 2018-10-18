## Plot results from prof()
profPlot <- function(stock, shift, strategy=applyFmax, focus="Y",
                     xlim=range(shift), ylim=NULL)
{
  main <- deparse(substitute(stock))
  ylab <- switch(focus, Y="Potential yield (kt)", SSB="SSB (kt)")
  profile <- prof(stock, shift, strategy, focus)
  plot(profile, type="l", xlim=xlim, ylim=ylim, yaxs="i",
       xlab="Age shift (yrs)", ylab=ylab, main=main)
  points(profile[profile$shift==0,])
  profile
}
