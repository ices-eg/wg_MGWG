

# load libraries
library(FLCore)
library(ggplotFL)
library(tidyr)

# read in operating models from wklifeFL package
load("../wklifeFL/data/stks.RData")

# pick a stock
stk_name <- "had-iris_rollercoaster"
stk <- stks[[stk_name]]

# stock summary
metrics(stk)
plot(metrics(stk)) + facet_wrap(qname ~ ., ncol = 2, scales = "free")

# write out stock
i <- 1
stk_i <- stk[,,,,,i]
FLCore::writeFLStock(stk_i, output.file = paste0(stk_name, "_", i))

