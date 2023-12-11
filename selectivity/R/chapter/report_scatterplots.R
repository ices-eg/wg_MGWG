## Prepare scatterplots

## Before: summary.csv (output)
## After:  abar_vs_a50mat.pdf, w5_vs_a50mat.pdf (report)

library(TAF)

mkdir("report")

# Read summary table
summary <- read.taf("output/summary.csv")

# Remove Kattegat and St Pierre
summary <- summary[summary$id != "kattegat",]
summary <- summary[summary$id != "nafo_3ps",]
rownames(summary) <- NULL

# Nudge labels so they don't overlap
p1 <- summary[c("A50mat", "AbarCatch")]  # plot 1
p2 <- summary[c("A50mat", "W5")]         # plot 2
names(p1) <- names(p2) <- c("x", "y")
rownames(p1) <- rownames(p2) <- summary$Label

nudge <- function(x, n, dx=0, dy=0.25)
{
  x[n,] <- x[n,] + c(dx, dy)
  x
}
p1 <- nudge(p1, "E Baltic", -0.25, -0.25)
p1 <- nudge(p1, "Faroe", 0.1, -0.25)
p1 <- nudge(p1, "Flemish", -0.2)
p1 <- nudge(p1, "Georges", -0.5, 0.2)
p1 <- nudge(p1, "Grand")
p1 <- nudge(p1, "Greenland", -0.1)
p1 <- nudge(p1, "Iceland")
p1 <- nudge(p1, "Irish", -0.35, 0)
p1 <- nudge(p1, "Maine", 0.15)
p1 <- nudge(p1, "NE Arctic")
p1 <- nudge(p1, "North Sea", 0.5, -0.25)
p1 <- nudge(p1, "Northern")
p1 <- nudge(p1, "Norway")
p1 <- nudge(p1, "S Celtic", -0.35, 0.2)
p1 <- nudge(p1, "W Baltic")

nudge <- function(x, n, dx=0, dy=0.28)
{
  x[n,] <- x[n,] + c(dx, dy)
  x
}
p2 <- nudge(p2, "E Baltic")
p2 <- nudge(p2, "Faroe", 0.43, 0)
p2 <- nudge(p2, "Flemish")
p2 <- nudge(p2, "Georges", -0.6, 0)
p2 <- nudge(p2, "Grand", 0.1, -0.28)
p2 <- nudge(p2, "Greenland", -0.68, 0)
p2 <- nudge(p2, "Iceland")
p2 <- nudge(p2, "Irish")
p2 <- nudge(p2, "Maine", 0.07, -0.28)
p2 <- nudge(p2, "NE Arctic")
p2 <- nudge(p2, "North Sea")
p2 <- nudge(p2, "Northern", -0.1)
p2 <- nudge(p2, "Norway")
p2 <- nudge(p2, "S Celtic")
p2 <- nudge(p2, "W Baltic", -0.1, -0.28)

pdf("report/Fig3.pdf", width=6, height=12)
# Abar~A50mat
par(mfrow=c(2,1))
par(plt=c(0.15, 0.97, 0.20, 0.97))
plot(NA, xlim=c(0,8), ylim=c(0,8), xlab="Age at 50% maturity",
     ylab="Average age in catches", las=1)
text(0.2, 7.8, "(a)")
abline(a=0, b=1, lty=3, lwd=2.5, col="gray")
points(AbarCatch~A50mat, data=summary, pch=16)
text(y~x, data=p1, labels=rownames(p1), cex=0.8)
# W5~A50mat
par(plt=c(0.15, 0.97, 0.20, 0.97))
plot(NA, xlim=c(0,8), ylim=c(0,10), xlab="Age at 50% maturity",
     ylab="Average weight at age 5 (kg)", las=1)
text(0.2, 9.7, "(b)")
points(W5~A50mat, data=summary, pch=16)
text(y~x, data=p2, labels=rownames(p2), cex=0.8)
dev.off()
