wham_write_readme = function()
{
  read.me = paste0(write.dir, "/README.md")
  cat("### WHAM model fit details", file = read.me, fill = TRUE)
  cat("", file = paste0(write.dir, "/README.md"), append = TRUE, fill = TRUE)
  age.sels = which(get(best)$env$data$selblock_models == 1)
  if(length(age.sels))
  {
    cat("Using age-specific selectivity for surveys or fishery catch facilitated convergence for one or more models.", file = read.me, append = TRUE, fill = TRUE)
    cat("All models use the same selectivity assumptions for consistency.", file = read.me, append = TRUE, fill = TRUE)
    cat("Trial fits with all age-specific selectivities free, led to assumed ages for peak selectivity.", file = read.me, append = TRUE, fill = TRUE)
    peaks = lapply(age.sels, function(x) which(m1$rep$selblocks[x,] == max(m1$rep$selblocks[x,])))
    if(1 %in% age.sels) 
    {
      cat(paste0("Age for peak selectivity in fishery was ", paste0(peaks[[1]],collapse = ','), "."), file = read.me, append = TRUE, fill = TRUE)
      age.sels = age.sels[-1]
      peaks = peaks[-1]
    }
    if(length(age.sels)) sapply(1:length(age.sels), function(x)
      cat(paste0("Age for peak selectivity in index ", age.sels[x]-1, " was ", paste0(peaks[[x]],collapse = ','), "."), file = read.me, append = TRUE, fill = TRUE)
    )
  } else
  {
    cat("No age-specific selectivity models were necessary. ", file = read.me, append = TRUE, fill = TRUE)
  }
  cat("", file = read.me, append = TRUE, fill = TRUE)
  cat(paste0("Model ", substr(best,2,2), " is used to provide results for comparison with other model frameworks."), file = read.me, append = TRUE, fill = TRUE)
}
