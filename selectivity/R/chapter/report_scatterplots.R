## Prepare scatterplots

## Before: summary.csv (output)
## After:  abar_vs_a50mat.pdf, w5_vs_a50mat.pdf (report)

library(TAF)

mkdir("report")

# Read summary table
summary <- read.taf("output/summary.csv")

# Plot Abar~A50mat
pdf("report/abar_vs_a50mat.pdf", width=6, height=6)
par(plt=c(0.15, 0.97, 0.15, 0.97))
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Average age in catches")
abline(a=0, b=1, lty=3, lwd=2.5, col="gray")
text(AbarCatch~A50mat, data=summary, labels=Label, cex=0.8)
dev.off()

# Plot W5~A50mat
pdf("report/w5_vs_a50mat.pdf", width=6, height=6)
par(plt=c(0.15, 0.97, 0.15, 0.97))
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Average weight at age 5 (kg)")
text(W5~A50mat, data=summary, labels=Label, cex=0.8)
dev.off()
