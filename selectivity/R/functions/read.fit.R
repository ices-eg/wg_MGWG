read.fit <- function(url)
{
  ## 1  Download model.RData
  tmp <- paste0(tempdir(), "/model.RData")
  on.exit(file.remove(tmp))
  download.file(url, tmp, mode="wb", quiet=TRUE)

  ## 2  Load and return fit object
  load(tmp)
  fit
}
