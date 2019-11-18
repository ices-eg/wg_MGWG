#### Libraries
library("ggplot2")

#### Read in files
files <- dir(pattern = "tab1\\.csv", recursive = TRUE, full.names = TRUE)
results <- sapply(files, read.csv, header = TRUE, simplify = FALSE)
results <- lapply(results, function(x) {
  colnames(x)[1] <- "Year"
  colnames(x) <- gsub("^Fbar[0-9a-z\\.]+", "Fbar", colnames(x))
  aa <- names(results)[parent.frame()$i[]]
  x[, "name"] <- aa
  x[, "spp"] <- basename(dirname(dirname(aa)))
  x[, "model"] <- basename(dirname(aa))
  x[, "tv"] <- !grepl("constant", aa)
  if(sum(grepl("^F.", colnames(x))) ==0) browser()
  x[, "Fbar"] <- x[, grep("^F.", colnames(x))]
  return(x)
})
fbar <- do.call("rbind", 
  lapply(results, "[", c("Year", "Fbar", "name", "spp", "model", "tv")))

#### Make plots
# ggplot(fbar[grepl("SAM", fbar[,"model"]), ], aes(x = Year, y = Fbar)) + 
# geom_point(aes(col = spp, pch = tv)) + 
# scale_shape_manual(values = c(21, 19))
g <- ggplot(fbar[grepl("SAM", fbar[,"model"]) & fbar[, "spp"] != "GOMhaddock", ], aes(x = Year, y = Fbar)) + 
geom_point(aes(col = tv, pch = tv), cex = 2) + 
scale_shape_manual(values = c(21, 19)) + 
scale_colour_manual(values = c("red", "green")) + 
ylab("Average fishing intensity for ages of interest") + 
facet_wrap(spp ~ .) + theme_bw()
ggsave(file.path("time-varying", "MGWG_time-varying_20190927.jpeg"))
