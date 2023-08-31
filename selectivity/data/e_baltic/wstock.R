library(TAF)

# von Bertalanffy parameters
Linf <- 125.27
k <- 0.10
t0 <- -0.5  # length at age 0.5 will be 12 cm

# Data frame for time-varying a and b
p <- data.frame(Year=1946:2019, Linf, k, t0)
p$a <- NA_real_
p$a[p$Year %in% 1946:1990] <- 6.58E-06
p$a[p$Year %in% 1991:1993] <- 6.58E-06
p$a[p$Year %in% 1994:1996] <- 8.05E-06
p$a[p$Year %in% 1997:1999] <- 6.81E-06
p$a[p$Year %in% 2000:2002] <- 6.78E-06
p$a[p$Year %in% 2003:2005] <- 6.76E-06
p$a[p$Year %in% 2006:2008] <- 7.47E-06
p$a[p$Year %in% 2009:2011] <- 6.70E-06
p$a[p$Year %in% 2012:2014] <- 7.73E-06
p$a[p$Year %in% 2015:2019] <- 8.54E-06
p$b <- NA_real_
p$b[p$Year %in% 1946:1990] <- 3.1353
p$b[p$Year %in% 1991:1993] <- 3.1353
p$b[p$Year %in% 1994:1996] <- 3.0636
p$b[p$Year %in% 1997:1999] <- 3.1062
p$b[p$Year %in% 2000:2002] <- 3.0992
p$b[p$Year %in% 2003:2005] <- 3.0972
p$b[p$Year %in% 2006:2008] <- 3.0637
p$b[p$Year %in% 2009:2011] <- 3.0831
p$b[p$Year %in% 2012:2014] <- 3.0406
p$b[p$Year %in% 2015:2019] <- 3.0169

# Length at age
age <- 1:14
len <- Linf * (1 - exp(-k * (age - t0)))

# Weight at age
wstock <- outer(len, p$b, "^")        #   L^b
wstock <- sweep(wstock, 2, p$a, "*")  # a*L^b
wstock <- data.frame(Year=p$Year, t(round(wstock,2)), check.names=FALSE)

write.taf(wstock)
