# Eastern Baltic cod
# Calculate maturity and weight at age from length-based SS3 estimates
# 09 Mar 2019 WGBFAS created SS3 output files
# 24 Sep 2023 Arni Magnusson created this script

library(r4ss)
library(TAF)  # xtab2taf

SSgrowth <- function(ages=1:10, L1=10, L2=100, K=0.2, a1=1, a2=999)
{
  if(a2 < 999)
    L2 <- L1 + (L2-L1) / (1-exp(-K*(a2-a1)))
  L2 + (L1-L2) * exp(-K*(ages-a1))
}

SSmaturity <- function(len=1:60, L50=20, slope=-0.20)
{
  1 / (1 + exp(slope*(len-L50)))
}

# Download 2019 stock assessment results
if(!file.exists("BFAS_Final.zip"))
{
  download.file(file.path("https://github.com/ices-eg/wg_MGWG/releases",
                          "download/file/BFAS_Final_E_Baltic_Cod_2019.zip"),
                destfile="BFAS_Final.zip")
}
if(!dir.exists("BFAS_Final.zip"))
  unzip("BFAS_Final.zip")

# Import results
results <- SS_output("BFAS_Final")

# Extract weight at age
wfull <- results$mean_body_wt
wfull$Morph <- wfull$Seas <- wfull$"0" <- wfull$"15" <- NULL
w <- sapply(split(wfull, wfull$Yr), colMeans)  # average over seasons
w <- as.data.frame(t(w))
names(w)[names(w) == "Yr"] <- "Year"
w <- w[w$Year %in% 1946:2019,]
rownames(w) <- NULL

# Calculate length at age
vb <- results$MGparmAdj
vb <- vb[c("Yr", "L_at_Amin_Fem_GP_1", "L_at_Amax_Fem_GP_1",
           "VonBert_K_Fem_GP_1")]
names(vb) <- c("Year", "L1", "L2", "K")
rownames(vb) <- NULL
vb$a1 <- results$Growth_Parameters$A1
vb$a2 <- results$Growth_Parameters$A2
vb <- vb[vb$Year<=2019,]
len <- t(mapply(SSgrowth, L1=vb$L1, L2=vb$L2, K=vb$K, a1=vb$a1, a2=vb$a2,
                MoreArgs=list(ages=1:14)))
dimnames(len) <- list(vb$Year, 1:14)

# Calculate maturity at age
logistic <- results$MGparmAdj
logistic <- logistic[c("Yr", "Mat50%_Fem_GP_1", "Mat_slope_Fem_GP_1")]
names(logistic) <- c("Year", "L50", "slope")
rownames(logistic) <- NULL
logistic <- logistic[logistic$Year<=2019,]
mat <- matrix(NA_real_, nrow=nrow(logistic), ncol=14,
              dimnames=list(logistic$Year, 1:14))
for(i in seq_len(nrow(mat)))
  mat[i,] <- SSmaturity(len[i,], L50=logistic$L50[i], slope=logistic$slope[i])

# Format data frames
mat <- round(xtab2taf(mat), 3)
len <- round(xtab2taf(len), 1)
w <- round(w, 3)

# Write TAF tables
write.taf(w, "wstock.csv")
write.taf(mat, "maturity.csv")
