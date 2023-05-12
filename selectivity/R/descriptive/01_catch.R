library(TAF)     # read.taf, taf.png
library(gplots)  # rich.colors

## 1  Read data
setwd('selectivity/R/descriptive')
tonnes <- read.taf("../../data/tonnes.csv", row.names=1)
not.na <- !apply(is.na(tonnes), 1, any)
catch <- tonnes[not.na,] / 1e3

## 2 Plot

taf.png("catch")
par(plt=c(0.12, 0.72, 0.18, 0.94))
col <- rich.colors(ncol(catch))
z <- barplot(t(as.matrix(rev(catch))), xlab="Year", ylab="Catch (kt)", col=col)
legend(x=19, y=1070, names(catch), fill=rev(col), bty="n", xpd=NA)
dev.off()
