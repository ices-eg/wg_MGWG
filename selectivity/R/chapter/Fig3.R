## 1  Import stocks

source("selectivity/R/chapter/boot/stocks.R")
## 2  Load functions
library(tidyverse)
library(arni)   # eps, eps2pdf, eps2png, install_github("arni-magnusson/arni")
library(gdata)  # write.fwf
source("selectivity/R/functions/A50.R")

## 3  Prepare table
tonnes <- read.csv("selectivity/data/tonnes.csv")
tonnes$kattegat <- NULL
tonnes$nafo_3ps <- NULL
out <- data.frame(id=names(tonnes)[-1])
out$Stock <- c("Eastern Baltic",
               "Faroe Plateau", "Georges Bank", "Greenland",
               "Gulf of Maine",
               "Iceland", "Irish Sea", "Newfoundland",
               "Flemish Cap",
               "Grand Bank", "Northeast Arctic", "North Sea",
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

#suppressWarnings(dir.create("selectivity/chapter_plots/outChapter"))

out.clean <- out[c("Stock", "Catch", "A50sel", "A50mat", "W5")]
out.clean$Catch <- round(out.clean$Catch, -2)
out.clean$A50sel <- round(out.clean$A50sel, 1)
out.clean$A50mat <- round(out.clean$A50mat, 1)
out.clean$W5 <- round(out.clean$W5, 1)

head.1 <- c("",       "",         "Age at 50%",  "Age at 50%", "Weight at")
head.2 <- c("Stock", "Catch (t)", "Selectivity", "Maturity",   "age 5 (kg)")
write.fwf(rbind(head.1, head.2, format(out.clean)),
          "selectivity/chapter_plots/outChapter/table.txt",
          colnames=FALSE)

## 7  Plot
out <-
    out %>%
    filter(id != 'gulf_of_maine')
out$Label <- c('Eastern Baltic', "Faroe", "Georges Bank",
               "Greenland", ##"Gulf of Maine",
               "Iceland", "Irish",
               "Newfoundland", "Flemish Cap", "Grand Bank", "NE Arctic",
               "North Sea", "Norway",
               "Celtic", "Western Baltic")
#setwd('outChapter')
## out <-
##     out %>%
##     mutate(Region = ifelse(Stock == 'Eastern Baltic', 'NSA',
##                     ifelse(Stock == 'Irish Sea', 'NSA',
##                     ifelse(Stock == 'North Sea','NSA',
##                     ifelse(Stock == 'Norway coastal', 'NSA',
##                     ifelse(Stock == 'Southern Celtic', 'NSA',
##                     ifelse(Stock == 'Western Baltic', 'NSA',
##                     ifelse(Stock == 'Newfoundland', 'CUS',
##                     ##ifelse(Stock == 'Gulf of Maine', 'CUS',
##                     ifelse(Stock == 'Georges Bank', 'CUS',
##                     ifelse(Stock == 'Flemish Cap', 'CUS',
##                     ifelse(Stock == 'Grand Bank', 'CUS',
##                     ifelse(Stock == 'Northeast Arctic', 'FGI',
##                     ifelse(Stock == 'Faroe Plateau', 'FGI',
##                     ##ifelse(Stock == 'Greenland inshore' , 'FGI',
##                            'FGI')))))))))))))))

pdf('selectivity/chapter_plots/Fig3.pdf', width=6, height=6)
ggplot(data = out, aes(x = A50mat, y = A50sel)) +
    geom_point() +
    geom_text(aes(label = Label), hjust=0, vjust = 1.5, cex = 3.5) +
    geom_abline(slope = 1, intercept = 0, linetype = 'dashed') +
    xlab("Age at 50% maturity") +
    ylab("Age at 50% selectivity") +
    scale_x_continuous(limits = c(0, 8), breaks = seq(0, 8, by = 1)) +
    scale_y_continuous(limits = c(0, 8), breaks = seq(0, 8, by = 1)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank())
dev.off()



pdf('selectivity/chapter_plots/Fig3.pdf', width=6, height=6)
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Age at 50% selectivity", las = 1)
title(main="Selectivity vs. Maturity")
abline(a=0, b=1, lty=3, col="gray")
points(A50sel~A50mat, data=out, pch = 16, cex = 0.5)
text((A50sel-0.3)~A50mat, data=out, labels=Label, cex=0.6)
dev.off()

eps2pdf(filename)
## eps2png(filename, dpi=600)
file.remove(filename)
