## Shift selectivity curve left or right, while maintaining the shape
slide <- function(sel, by=0, scale=FALSE)
{
  x <- as.numeric(names(sel))
  y <- unname(sel)

  ## Add dummy age before selectivity starts, to handle the left
  ## hand side when sliding a short distance (< 1.0) to the right
  x <- c(x[1]-1, x)
  y <- c(0, y)

  ## Interpolate when sliding a non-integer amount
  yout <- approx(x+by, y, xout=x, yleft=0, rule=2)$y
  yout <- yout[-1]  # remove dummy age
  names(yout) <- names(sel)

  ## Scale to one
  if(scale)
    yout <- yout / max(yout)

  yout
}

## Example
## sel <- c(0.1, 0.2, 0.9, 1.0)
## names(sel) <- 1:4
## slide(sel, -1)
## sel
## slide(sel, +1)
## slide(sel, +1, scale=TRUE)
