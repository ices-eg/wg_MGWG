read <- function(basename, plus=FALSE)
{
  tab <- read.csv(paste0(file.path(path,basename),".csv"), check.names=FALSE)
  if(plus)
    names(tab) <- sub("\\+$", "", names(tab))
  tab
}
