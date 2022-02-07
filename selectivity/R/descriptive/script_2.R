## 1  Import stocks

source("stocks.R")

## 2  Load packages and functions

library(arni)    # eps, eps2pdf, eps2png, install_github("arni-magnusson/arni")
library(gplots)  # rich.colors
source("../functions/stdline.R")

## 3  Prepare labels and graphical parameters

stocks <- c("Greenland inshore", "Iceland", "Northeast Arctic",
            "Norway coastal", "Faroe Plateau", "Southern Celtic",
            "Irish Sea", "North Sea", "Kattegat", "Western Baltic")
col <- rich.colors(length(stocks))
lwd <- 2

## 4  Plot weights

suppressWarnings(dir.create("out"))

filename <- "out/weight.eps"
eps(filename, width=6, height=6)
plot(NA, xlim=c(1,14), ylim=c(0,15), yaxs="i",
     xlab="Age", ylab="Weight in catches (kg)", main="Weight")
stdline(greenland$wcatch,     lwd, col[1])
stdline(iceland$wcatch,       lwd, col[2])
stdline(ne_arctic$wcatch,     lwd, col[3], to=14)
stdline(norway$wcatch,        lwd, col[4])
stdline(faroe_plateau$wcatch, lwd, col[5])
stdline(s_celtic$wcatch,      lwd, col[6])
stdline(irish_sea$wcatch,     lwd, col[7])
stdline(north_sea$wcatch,     lwd, col[8])
stdline(kattegat$wcatch,      lwd, col[9])
stdline(w_baltic$wcatch,      lwd, col[10])
legend("topleft", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
dev.off()
eps2pdf(filename)
## eps2png(filename, dpi=600)
file.remove(filename)

## 5  Plot selectivity and maturity

## Maturity
filename <- "out/maturity.eps"
eps(filename, width=12, height=6)
plot(NA, xlim=c(1,15), ylim=c(0,1.05), yaxs="i",
     xlab="Age", ylab="Proportion mature", main="Maturity")
stdline(greenland$mat,     lwd, col[1])
stdline(iceland$mat,       lwd, col[2])
stdline(ne_arctic$mat,     lwd, col[3], from=4, to=14)
stdline(norway$mat,        lwd, col[4])
stdline(faroe_plateau$mat, lwd, col[5])
stdline(s_celtic$mat,      lwd, col[6])
stdline(irish_sea$mat,     lwd, col[7])
stdline(north_sea$mat,     lwd, col[8])
stdline(kattegat$mat,      lwd, col[9])
stdline(w_baltic$mat,      lwd, col[10])
legend("bottomright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
       inset=0.02, cex=0.8)
box()
dev.off()
eps2pdf(filename)
## eps2png(filename, dpi=600)
file.remove(filename)
