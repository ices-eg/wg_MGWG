
library(FLCore)

# add multinomial error
simAsapObs <- function(n, numbers, sd_totals, effective_sample_size) {

  ## compute annual totals
  totals <- quantSums(numbers)

  ## compute proportion at age
  proportions <- sweep(numbers, 2, totals, "/")

  ## add log normal error to totals
  totals_obs <- rlnorm(n = n, meanlog = log(totals),  sdlog = sd_totals)

  ## add multinomial error to age comps
  proportions_obs <- propagate(proportions, n)
  for (i in 1:dims(proportions)$year) {
    proportions_obs[, i] <-
      rmultinom(n,
                c(effective_sample_size[,i]),
                c(proportions[, i])) /
      c(effective_sample_size[, i])
  }

  # compute observed numbers
  sweep(proportions_obs, c(2,6), totals_obs, "*")
}


# test data
data(ple4)
numbers <- window(catch.n(ple4), start = 2010) / 100

# settings
sd_totals <- quantSums(numbers)
sd_totals[] <- 0.1

effective_sample_size <- quantSums(numbers)
effective_sample_size[] <- 1e6

numbers_sim <- simAsapObs(2, numbers, sd_totals, effective_sample_size)

numbers_sim[numbers_sim == 0] <- NA
apply(log(numbers) - log(numbers_sim), c(1,2), sd, na.rm = TRUE)

