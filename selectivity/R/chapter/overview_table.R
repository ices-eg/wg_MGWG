## 1  Import stocks

source("stocks.R")

## 2  Load functions

library(arni)   # eps, eps2pdf, eps2png, install_github("arni-magnusson/arni")
library(gdata)  # write.fwf
source("../functions/Abar.R")  # average age in catches
source("../functions/A50.R")   # age of 50% maturity

## 3  Prepare table
tonnes <- read.csv("../../data/tonnes.csv")
out <- data.frame(id=names(tonnes)[-1])
out$Stock <- c("Eastern Baltic", "Faroe Plateau", "Georges Bank",
               "Greenland inshore", "Gulf of Maine", "Iceland", "Irish Sea",
               "Kattegat", "NAFO 2J3KL", "NAFO 3M", "NAFO 3NO", "NAFO 3Ps",
               "Northeast Arctic", "North Sea", "Norway coastal",
               "Southern Celtic", "Western Baltic")

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

## 5  Calculate summary statistics

abar <- function(x) weighted.mean(as.numeric(names(x)), x)
abar_catch <- function(id)
{
  stock <- get(id)
  if(!is.null(stock$C))
    abar(stock$C)
  else
    NA_real_
}
a50 <- function(x) A50(as.numeric(names(x)), x)
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
out$AbarCatch <- sapply(out$id, abar_catch)
out$A50mat <- sapply(out$id, a50mat)
out$W5 <- sapply(out$id, w5)

## 6  Export table

suppressWarnings(dir.create("out"))

out.clean <- out[c("Stock", "Catch", "AbarCatch", "A50mat", "W5")]
out.clean$Catch <- round(out.clean$Catch, -2)
out.clean$AbarCatch <- round(out.clean$AbarCatch, 1)
out.clean$A50mat <- round(out.clean$A50mat, 1)
out.clean$W5 <- round(out.clean$W5, 1)

head.1 <- c("",      "",          "Average Age",  "Age at 50%", "Weight at")
head.2 <- c("Stock", "Catch (t)", "in Catches",   "Maturity",   "age 5 (kg)")
fwf <- capture.output(write.fwf(rbind(head.1, head.2, format(out.clean)), "",
                                colnames=FALSE))
writeLines(trimws(fwf, "right"), "out/table.txt")

## 7  Plot

out$Label <- c("E Baltic", "Faroe", "Georges", "Greenland", "Maine", "Iceland",
               "Irish", "Kattegat", "2J3KL", "3M", "3NO", "3Ps", "NE Arctic",
               "North Sea", "Norway", "Celtic", "W Baltic")

filename <- "out/a50.eps"
eps(filename, width=6, height=6)
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Average age in catches")
title(main="Age in catches vs. Maturity")
abline(a=0, b=1, lty=3, col="gray")
text(AbarCatch~A50mat, data=out, labels=Label, cex=0.8)
dev.off()
eps2pdf(filename)
## eps2png(filename, dpi=600)
file.remove(filename)
