## Prepare scatterplots

## Before: stocks.rds (data)
## After:  abar.pdf, w5.pdf, a50mat.pdf (report)

library(TAF)
source("boot/software/stdline.R")

stocks <- readRDS("data/stocks.rds")

col <- rich.colors(length(stocks))
lwd <- 2

# Plot

foo <- function(x, ...)
{
  lines(as.integer(names(x)), x, ...)
}

plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight in catches (kg)", main="Weight")
sapply(

stdline(stocks$e_baltic$wcatch,      lwd, col[1], to=14)
stdline(stocks$faroe_plateau$wcatch, lwd, col[1])
stdline(stocks$georges_bank$wcatch,  lwd, col[2])
stdline(stocks$greenland$wcatch,     lwd, col[3])
stdline(stocks$gulf_of_maine$wcatch, lwd, col[4])
stdline(stocks$iceland$wcatch,       lwd, col[5])
stdline(stocks$irish_sea$wcatch,     lwd, col[6])
stdline(stocks$nafo_2j3kl$wcatch,    lwd, col[7])
stdline(stocks$nafo_3m$wcatch,       lwd, col[8])
stdline(stocks$nafo_3no$wcatch,      lwd, col[9])
stdline(stocks$nafo_3ps$wcatch,      lwd, col[10])
stdline(stocks$ne_arctic$wcatch,     lwd, col[11], to=14)
stdline(stocks$north_sea$wcatch,     lwd, col[12])
stdline(stocks$norway$wcatch,        lwd, col[13])
stdline(stocks$s_celtic$wcatch,      lwd, col[14])
stdline(stocks$w_baltic$wcatch,      lwd, col[15])
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
