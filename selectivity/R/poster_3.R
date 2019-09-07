## 1  Import stocks

setwd("stocks")
source("faroe_plateau.R")
source("georges_bank.R")
source("greenland.R")
source("gulf_of_maine.R")
source("iceland.R")
source("irish_sea.R")
source("nafo_2j3kl.R")
source("nafo_3m.R")
source("nafo_3no.R")
source("nafo_3ps.R")
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("s_celtic.R")
source("w_baltic.R")
setwd("..")

## 2  Load packages and functions

library(arni)    # eps, eps2png, install_github("arnima-github/arni")
source("functions/applyF0.1.R")
source("functions/applyFmax.R")
source("functions/slide.R")

## 3  Calculate effect of sliding selectivity to younger or older

id <- c("faroe_plateau", "georges_bank", "greenland", "gulf_of_maine",
        "iceland", "irish_sea", "nafo_2j3kl", "nafo_3m", "nafo_3no", "nafo_3ps",
        "ne_arctic", "north_sea", "norway", "s_celtic", "w_baltic")

effect <- function(id, on="Y", fun=applyF0.1)
{
  stock <- get(id)
  if(is.null(stock$S))
    return(c(NA,1,NA))
  younger <- with(stock, fun(1, M, slide(S, -1), mat, wcatch, wstock))
  current <- with(stock, fun(1, M, slide(S,  0), mat, wcatch, wstock))
  older   <- with(stock, fun(1, M, slide(S, +1), mat, wcatch, wstock))
  if(on == "Y")
    c(younger$Y, current$Y, older$Y) / current$Y
  else
    c(younger$SSB, current$SSB, older$SSB) / current$SSB
}

Y <- as.data.frame(t(sapply(id, effect, "Y", applyF0.1)))
names(Y) <- c("Younger", "Current", "Older")

SSB <- as.data.frame(t(sapply(id, effect, "SSB", applyF0.1)))
names(SSB) <- c("Younger", "Current", "Older")

## 4  Plot

labels <- c("Faroe Plateau", "Georges Bank", "Greenland inshore", "Gulf of Maine",
            "Iceland", "Irish Sea", "NAFO 2J3KL", "NAFO 3M", "NAFO 3NO",
            "NAFO 3PS", "NE Arctic", "North Sea", "Norway coastal", "S Celtic",
            "W Baltic")

dotline <- function(i, quantity=Y)
{
  abline(h=i, lty=3, col="gray")
  points(1, i, cex=1.2)
  points(quantity[i,c(1,3)], rep(i,2), pch=c("<", ">"), cex=1.5)
}

suppressWarnings(dir.create("poster"))

## Yield
filename <- "poster/effect_yield.eps"
eps(filename, width=10, height=6)
par(plt=c(0.26, 0.94, 0.14, 0.89))
plot(NA, xlim=c(0.80, 1.32), ylim=c(15,1), ann=FALSE, axes=FALSE)
sapply(1:15, dotline, Y)
box()
axis(1)
axis(2, 1:15, labels, las=1, tcl=0)
title(main="Effect of changing selectivity on Yield")
title(xlab="Relative change in long-term yield")
dev.off()
eps2png(filename, dpi=600)
file.remove(filename)

## SSB
filename <- "poster/effect_ssb.eps"
eps(filename, width=10, height=6)
par(plt=c(0.26, 0.94, 0.14, 0.89))
plot(NA, xlim=c(0.59, 1.50), ylim=c(15,1), ann=FALSE, axes=FALSE)
sapply(1:15, dotline, SSB)
box()
axis(1, seq(0.6, 1.5, 0.1))
axis(2, 1:15, labels, las=1, tcl=0)
title(main="Effect of changing selectivity on SSB")
title(xlab="Relative change in average spawning biomass")
dev.off()
eps2png(filename, dpi=600)
file.remove(filename)
