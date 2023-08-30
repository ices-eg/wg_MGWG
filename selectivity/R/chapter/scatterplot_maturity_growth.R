## 1  Import stocks

source("stocks.R")

## 2  Load functions

library(arni)   # eps, eps2pdf, eps2png, install_github("arni-magnusson/arni")
library(gdata)  # write.fwf
source("../functions/A50.R")

## 3  Prepare table
tonnes <- read.csv("../../data/tonnes.csv")
tonnes$kattegat <- NULL
out <- data.frame(id=names(tonnes)[-1])
out$Stock <- c("Faroe Plateau", "Georges Bank", "Greenland inshore",
               "Gulf of Maine", "Iceland", "Irish Sea", "NAFO 2J3KL", "NAFO 3M",
               "NAFO 3NO", "NAFO 3Ps", "Northeast Arctic", "North Sea",
               "Norway coastal", "Southern Celtic", "Western Baltic")

## 4  Look up year range and average catch

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
out$Years <- sapply(out$id, years)
out$Catch <- sapply(out$id, catch)

## 5  Calculate A50

a50 <- function(x) A50(as.numeric(names(x)), x)
a50sel <- function(id)
{
  stock <- get(id)
  if(!is.null(stock$S))
    a50(stock$S)
  else
    NA_real_
}
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
out$A50sel <- sapply(out$id, a50sel)
out$A50mat <- sapply(out$id, a50mat)
out$W5 <- sapply(out$id, w5)

## 6  Export table

suppressWarnings(dir.create("out"))

out.clean <- out[c("Stock", "Catch", "A50sel", "A50mat", "W5")]
out.clean$Catch <- round(out.clean$Catch, -2)
out.clean$A50sel <- round(out.clean$A50sel, 1)
out.clean$A50mat <- round(out.clean$A50mat, 1)
out.clean$W5 <- round(out.clean$W5, 1)

head.1 <- c("",       "",         "Age at 50%",  "Age at 50%", "Weight at")
head.2 <- c("Stock", "Catch (t)", "Selectivity", "Maturity",   "age 5 (kg)")
write.fwf(rbind(head.1, head.2, format(out.clean)), "out/table.txt",
          colnames=FALSE)

## 7  Plot

out$Label <- c("Faroe", "Georges", "Greenland", "Maine", "Iceland", "Irish",
               "2J3KL", "3M", "3NO", "3Ps", "NE Arctic", "North Sea", "Norway",
               "Celtic", "Baltic")

filename <- "out/a50.eps"
eps(filename, width=6, height=6)
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Age at 50% selectivity")
title(main="Selectivity vs. Maturity")
abline(a=0, b=1, lty=3, col="gray")
text(A50sel~A50mat, data=out, labels=Label, cex=0.8)
dev.off()
eps2pdf(filename)
## eps2png(filename, dpi=600)
file.remove(filename)
