library(TAF)

# Logistic shape parameter
slope <- -0.23

# Data frame for time-varying L50
p <- data.frame(Year=1946:2019, slope)
p$L50 <- NA_real_
p$L50[p$Year %in% 1946:1990] <- 38
p$L50[p$Year %in% 1991:1997] <- 38
p$L50[p$Year %in% 1998:2000] <- 36
p$L50[p$Year %in% 2001:2007] <- 31
p$L50[p$Year %in% 2008:2014] <- 26
p$L50[p$Year %in% 2015:2019] <- 21

# Length at age
Linf <- 125.27
k <- 0.10
t0 <- -0.5  # length at age 0.5 will be 12 cm
age <- 1:14
len <- Linf * (1 - exp(-k * (age - t0)))

# Maturity at length (example)
# plot(1 / (1 + exp(slope*((1:100)-38))), xlab="Length (cm)", ylab="Maturity")
# abline(v=38)
# abline(h=0.5)

# Maturity at age
maturity <- outer(len, p$L50, "-")    #                     L-L50
maturity <- 1 / (1 + exp(slope*maturity))  # 1 / (1 + exp(slope*(L-L50)))
maturity <- data.frame(Year=p$Year, t(round(maturity,2)), check.names=FALSE)
# a 3-year-old is 37 cm, so around 50% mature in the mid to late 1990s
# a 1-year-old is 17 cm, so a large proportion is mature in 2015-2019

write.taf(maturity)
