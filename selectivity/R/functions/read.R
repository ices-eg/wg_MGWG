read <- function(name, path=".", plus=FALSE)
{
  tab <- read.csv(paste0(file.path(path,name),".csv"), check.names=FALSE)
  if(plus)
    names(tab) <- sub("\\+$", "", names(tab))
  tab
}

## Example
## path <- "../data/iceland"
## plus <- FALSE
## read("catage", path, plus)
##
## The 'plus' argument indicates whether the last column is a plus group that
## will be treated as a normal age class.
