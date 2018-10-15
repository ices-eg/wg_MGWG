stdplot <- function(x, main=NULL, ylab=NULL, type="l",
                    ylim=c(0,1.1*max(x,na.rm=TRUE)), xlab="Age", cex.main=1,
                    yaxs="i", ...)
{
  plot(as.integer(names(x)), x, type=type, ylim=ylim, main=main, xlab=xlab,
       ylab=ylab, cex.main=cex.main, yaxs=yaxs, ...)
}

## Example
## x <- runif(8)
## names(x) <- 3:10
## stdplot(x, "This", "That")
