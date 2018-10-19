## Interpolate age at 50%, e.g. maturity or selectivity
A50 <- function(age, value)
{
  ## Only two datapoints are included in the analysis:
  inc <- match(TRUE, value>=0.5)  # the first point above 0.5
  inc <- c(inc-1, inc)            # and the point before it
  approx(value[inc], age[inc], 0.5)$y
}

## Example
age <- 1:4
sel <- c(0.2, 0.4, 0.9, 1)
A50(age, sel)