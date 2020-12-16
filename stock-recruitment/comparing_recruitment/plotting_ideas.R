
library(dplyr)

# read in some stock and recuit data
# https://doi.org/10.7489/12085-1
sr_data <-
  read.csv("https://data.marine.gov.scot/sites/default/files/Ova_to_ova_SR.csv") %>%
  filter(Site == "Girnock") %>%
  rename(year = Year, ssb = Ova.Stock, rec = Ova.Recruit) %>%
  select(year, ssb, rec) %>%
  mutate(ssb = ssb * 10^-5, rec = rec * 10^-5) %>%
  filter(complete.cases(.))

plot(rec ~ ssb,
     data = sr_data,
     ylim = c(0, max(sr_data$ssb)),
     xlim = c(0, max(sr_data$rec)),
     las = 1, pch = 16, cex = 0.7)

# fit a few models (externally)

mods <- c("Ricker", "Bevholt", "smooth_hockey", "Segreg")

pred_data <-
  data.frame(
    ssb = seq(.1, max(sr_data$ssb), length.out = 100)
  )


preds <-
  sapply(mods,
         function(mod) {
    func <- get(mod, asNamespace("msy"))
    # fit
    opt <-
      stats::nlminb(
        msy:::initial(mod, sr_data),
        function(param, ...) -1 * msy::llik(param, ...),
        data = sr_data,
        model = func,
        logpar = TRUE)

    # predict
    par <- with(opt, list(a = exp(par[1]), b = exp(par[2]), cv = exp(par[3])))
    exp( func(par, pred_data$ssb) )
})

# plot
plot(rec ~ ssb,
     data = sr_data,
     ylim = c(0, max(sr_data$ssb)),
     xlim = c(0, max(sr_data$rec)),
     las = 1, pch = 16, cex = 0.7)

for (i in 1:ncol(preds)) {
  lines(preds[,i] ~ pred_data$ssb,
        type = "l", col = "blue")
}
