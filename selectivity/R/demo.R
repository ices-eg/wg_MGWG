source("functions/applyFmaxJK.R")

setwd("stocks")
source("gulf_of_maine.R")
setwd("..")

applyFmax(Ninit, M, S, mat, FecAA, wcatch)

################################################################################

source("functions/slide.R")
Syoung <- slide(S, -1)
Sold <- slide(S, +1)

applyFmax(Ninit, M, Syoung, mat, FecAA, wcatch)$TPF
applyFmax(Ninit, M, S, mat, FecAA, wcatch)$TPF
applyFmax(Ninit, M, Sold, mat, FecAA, wcatch)$TPF

