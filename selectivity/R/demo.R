source("functions/applyFmax.R")

setwd("stocks")
source("iceland.R")
setwd("..")

applyFmax(Ninit, M, S, mat, wcatch)

################################################################################

source("functions/slide.R")
Syoung <- slide(S, -1)
Sold <- slide(S, +1)

applyFmax(Ninit, M, Syoung, mat, wcatch)$Y
applyFmax(Ninit, M, S, mat, wcatch)$Y
applyFmax(Ninit, M, Sold, mat, wcatch)$Y
