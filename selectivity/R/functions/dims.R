dims <- function(path)
{
  peek <- function(csv)
  {
    tab <- read.csv(csv, check.names=FALSE)
    if(!any(names(tab)=="Year"))
      return()
    yrs <- range(tab$Year)
    ages <- names(tab)[c(2,ncol(tab))]
    name <- tools::file_path_sans_ext(basename(csv))
    cat(format(name,width=10))
    cat(paste(yrs, collapse="-"), "  ", sep="")
    cat(paste(ages, collapse="-"), "\n", sep="")
  }
  files <- dir(path, full.names=TRUE)
  cat(path, "\n", sep="")
  for(i in 1:length(files))
    peek(files[i])
}

## Example
## path <- "../data/iceland"
## dims(path)
