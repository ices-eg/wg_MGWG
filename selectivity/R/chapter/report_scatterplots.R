## Prepare scatterplots

## Before: summary.csv (output)
## After:  abar_vs_a50mat.pdf (report)

library(TAF)

mkdir("report")

# 1  Read summary table
summary <- read.taf("output/summary.csv")

# 2  Prepare plot labels
summary$Label <- c("E Baltic", "Faroe", "Georges", "Greenland", "Maine",
                   "Iceland", "Irish", "Kattegat", "2J3KL", "3M", "3NO", "3Ps",
                   "NE Arctic", "North Sea", "Norway", "Celtic", "W Baltic")

# 3  Plot Abar~A50mat
pdf("report/abar_vs_a50mat.pdf", width=6, height=6)
par(plt=c(0.15, 0.97, 0.15, 0.97))
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Average age in catches")
abline(a=0, b=1, lty=3, lwd=2.5, col="gray")
text(AbarCatch~A50mat, data=summary, labels=Label, cex=0.8)
dev.off()
