#/home/konrach/Documents/Work/Projects/ICES/MGWG/stock-recruitment/comparing_recruitment/simulated_stocks/sa/a4a
rm(list =ls(all = T))


library(FLa4a)
library(ggplotFL)

load("a4a.RData")
load("om1.RData")

# runs
#       devs srm traj   model      a         b
# 1    rwdev bhm  rcc bevholt 487.53 155.55556
# 2  lndev03 bhm  rcc bevholt 487.53 155.55556
# 3  lndev06 bhm  rcc bevholt 487.53 155.55556
# 4    rwdev rim  rcc  ricker   1.77   0.00155
# 5  lndev03 rim  rcc  ricker   1.77   0.00155
# 6  lndev06 rim  rcc  ricker   1.77   0.00155
# 7    rwdev gmm  rcc    mean 400.00        NA
# 8  lndev03 gmm  rcc    mean 400.00        NA
# 9  lndev06 gmm  rcc    mean 400.00        NA
# 10   rwdev hsm  rcc  segreg   0.90 450.00000
# 11 lndev03 hsm  rcc  segreg   0.90 450.00000
# 12 lndev06 hsm  rcc  segreg   0.90 450.00000
# 13   rwdev bhm  lfc bevholt 487.53 155.55556
# 14 lndev03 bhm  lfc bevholt 487.53 155.55556
# 15 lndev06 bhm  lfc bevholt 487.53 155.55556
# 16   rwdev rim  lfc  ricker   1.77   0.00155
# 17 lndev03 rim  lfc  ricker   1.77   0.00155
# 18 lndev06 rim  lfc  ricker   1.77   0.00155
# 19   rwdev gmm  lfc    mean 400.00        NA
# 20 lndev03 gmm  lfc    mean 400.00        NA
# 21 lndev06 gmm  lfc    mean 400.00        NA
# 22   rwdev hsm  lfc  segreg   0.90 450.00000
# 23 lndev03 hsm  lfc  segreg   0.90 450.00000
# 24 lndev06 hsm  lfc  segreg   0.90 450.00000
# 25   rwdev bhm  hfc bevholt 487.53 155.55556
# 26 lndev03 bhm  hfc bevholt 487.53 155.55556
# 27 lndev06 bhm  hfc bevholt 487.53 155.55556
# 28   rwdev rim  hfc  ricker   1.77   0.00155
# 29 lndev03 rim  hfc  ricker   1.77   0.00155
# 30 lndev06 rim  hfc  ricker   1.77   0.00155
# 31   rwdev gmm  hfc    mean 400.00        NA
# 32 lndev03 gmm  hfc    mean 400.00        NA
# 33 lndev06 gmm  hfc    mean 400.00        NA
# 34   rwdev hsm  hfc  segreg   0.90 450.00000
# 35 lndev03 hsm  hfc  segreg   0.90 450.00000
# 36 lndev06 hsm  hfc  segreg   0.90 450.00000

#n1mod <- ~s(age, k = 3)
#
#fmod <-  ~s(age, k = 5) + s(year, k = 15) + s(year, k=5, by=as.numeric(age == 2)) + s(year, k=5, by=as.numeric(age==1)) 
#stk <- setPlusGroup(stk, 10)
#idxs <- FLIndices(trim(indices[[r]][,,,,,it], age = 1:6))
#r <- 2
#it <- 1

  if (r %in% c(4:6, 16:18, 28:30)) srmod <- ~ricker(CV = 0.2)
  if (r %in% c(7:9, 19:21, 31:33)) srmod <- ~geomean(CV = 0.2)
  if (r %in% c(10:12, 22:24, 34:36)) srmod <- ~geomean(CV = 0.2)
  if (r %in% c(1:3, 13:15, 25:27))



pdf("Runsb.pdf")

for (it in 1:50){
	stk<- stocks[[r]][,,,,,it]
	stk <- setPlusGroup(stk, 10)
  idxs <- FLIndices(indices[[r]][1:10,,,,,it])

  catch.n(stk)[catch.n(stk) ==0] <- 1e-12


	fmod <-  ~s(age, k= 4) + s(year, k = 20)  #+ te(age, year, k = c(=,10))
	qmod <- list(~s(age, k = 5))
	srmod <- ~bevholt(CV = 0.2)

	fitBH <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel = srmod)
	sBH <- stk+fitBH

		
	plot(sBH) + ggtitle(paste0(r,"--",runs$model[r]))
  plot(residuals(fitBH, stk, idxs))
print(r)
}


dev.off()


sdlog=sqrt(log(1 + ((stock(x) * 0.20)^2 / stock(x)^2)))










proportions
An object of class "FLQuant"
, , unit = unique, season = all, area = unique

    year
age  42       
  1  0.0137226
  2  0.1501008
  3  0.2021456
  4  0.1855441
  5  0.1180917
  6  0.0740541
  7  0.1166987
  8  0.0536747
  9  0.0179835
  10 0.0171598
  11 0.0122848
  12 0.0105443
  13 0.0098773
  14 0.0063465
  15 0.0029771
  16 0.0016160
  17 0.0026774
  18 0.0009702
  19 0.0010905
  20 0.0024403




An object of class "FLQuant"
, , unit = unique, season = all, area = unique

    year
age  42      
  1  0.000000
  2  0.092262
  3  0.000000
  4  0.046131
  5  0.092262
  6  0.092262
  7  0.000000
  8  0.000000
  9  0.046131
  10 0.046131
  11 0.000000
  12 0.000000
  13 0.000000
  14 0.000000
  15 0.046131
  16 0.000000
  17 0.000000
  18 0.000000
  19 0.000000
  20 0.000000

units:   










  stats::rmultinom(1,
          # size
          c(iter(ess[,i], j)),
          # prob)
          c(iter(proportions[,i],j))) / c(iter(ess[,i],j))




  stats::rmultinom(1,
          # size
          10,
          # prob)
          c(iter(proportions[,i],j)))


oms<- om1[,,,,,1]
survey.q <- 3e-3
a50 <- 2.3
slope <- 0.4
survey.sel <- FLQuant(1 / ( 1 + exp(-(seq(1, 20) - a50) / slope)),
  dimnames=dimnames(m(oms)))

its <- 1
timing <- 0



  i1 <-mnlnoise(n=its, numbers=
    
    stock.n(x) * exp(-(harvest(x) * timing + m(x) *  timing)) %*% survey.sel * survey.q,

    sdlog=sqrt(log(1 + ((stock(x) * 0.20)^2 / stock(x)^2))), ess=100)


  i2 <-mnlnoise(n=its, numbers=
    
    stock.n(x) * exp(-(harvest(x) * timing + m(x) *  timing)) %*% survey.sel * survey.q,

    sdlog=sqrt(log(1 + ((stock(x) * 0.20)^2 / stock(x)^2))), ess=10)



  i3 <-window(FLIndex(mnlnoise(n=its, numbers=
    
    stock.n(x) * exp(-(harvest(x) * timing + m(x) *  timing)) %*% survey.sel * survey.q,

    sdlog=sqrt(log(1 + ((stock(x) * 0.20)^2 / stock(x)^2))), ess=400)), start=42)



 catch.no <- FLQuants(   mnlnoise(n=its, numbers=catch.n(x),
  sdlog=sqrt(log(1 + ((catch(x) * 0.10)^2 / catch(x)^2))), ess=200))

catch.n(stk) <- window(catch.no, start=42)

stk <- window(stk, start=42)
   stock.n(stk) <- 0
   harvest(stk) <- 0
 



lapply(oms, function(x) {
    x <- window(x, start=42)
    stock.n(x) <- 0
    harvest(x) <- 0
    return(x)
  })











m3 <- fitBH
for(i in 1){
 # jpeg(paste0("./Plots/Catchability_",i,"_3.jpg"))
  sfrac <- mean(range(idxs[[i]])[c("startf", "endf")])
  Z2 <- (m(stk) + harvest(m3))*sfrac
  lst2 <- dimnames(m3@index[[i]])
  lst2$x <- stock.n(m3)*exp(-Z2)
  stkn2 <- do.call("trim", lst2)
  p<-wireframe(data ~ age + year, data = as.data.frame(index(m3)[[i]]/stkn2),main=paste0("Survey_",i,"_selectivity"), drape = TRUE, screen = list(x = -90, y=-45))
  print(p)
#  dev.off()
}

#### error too big for numbers caught

ggplot(aes(ssb, rec), data=model.frame(FLQuants(sBH, "ssb", "rec"))) +
  geom_point() + geom_smooth(method="loess")

ggplot(aes(ssb, rec), data=model.frame(FLQuants(om1[,,,,,1], "ssb", "rec"))) +
  geom_point() + geom_smooth(method="loess")


fix fbar in om and have a look - why is rec fucked up

s(replace(age, age>5, 5), k=4) + s(year, k=20)




	x11()
	plot(residuals(fitGM, stk, idxs))
	x11()
	plot(residuals(fitR , stk, idxs))
	x11()
	plot(residuals(fitFY, stk, idxs))
plot(FLStocks(OM = om1, BH = sBH, GeoM = sGM,Rick = sR))


	#fmod <-  ~s(age, k = 5, by = breakpts(year, c(60))) + s(year, k = 30)
	qmod <- list(~s(replace(age, age>8, 8), k=4)
srmodGM <- ~geomean(0.2)
	srmodR  <- ~ricker(0.2)
	srmodFY <- ~s(year, k = 17)
	sGM <- stk+fitGM
	sR  <- stk+fitR 
	#sFY <- stk+fitFY


fitGM <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel = srmodGM)
	fitR  <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel = srmodR )
	fitFY <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel = srmodFY)

 load("a4a.RData")

a <- 2
stk<- window(stocks[[1]][,,,,,a], start = 50)
idxs <- window(FLIndices(indices[[1]][,,,,,a]), start = 50)

te(age, year, k = c(4,10)) 

fmod <-  ~s(age, k = 10) + s(year, k = 25)
#fmod <-  ~s(age, k = 15) + s(year, k = 30)
qmod <- list(~s(age, k = 12))
srmod <- ~geomean(0.5)

fit <- sca(stk, idxs, qmodel=qmod)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod)
fit <- sca(stk, idxs, srmodel = srmod)
fit <- sca(stk, idxs, qmodel=qmod, srmodel = srmod)
fit <- sca(stk, idxs, fmodel=fmod, srmodel = srmod)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod, srmodel = srmod)
s1 <- stk+fit
res1 <- residuals(fit, stk, idxs)
pr1 <- predict(fit)

plot(residuals(fit, stk, idxs))

fmod <-  ~s(age, k = 14) + s(year, k = 25)
qmod <- list(~s(age, k = 8))
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod)
plot(residuals(fit, stk, idxs))
moo <- stk + fit

plot(FLStocks(OM = om1, BH = moo)
