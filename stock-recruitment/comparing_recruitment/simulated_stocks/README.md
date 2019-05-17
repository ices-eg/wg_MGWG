
# TODO

- Observation & process error in catch composition (CM)
- Scenarios

# Scenarios

## Stock-recruitment models

- Beverton-Holt
- Ricker
- Mean
- Hockey stick

![](png/srm.png)

## Recruitment deviances

- Random walk 
- Lognormal(SD=0.4)
- Lognormal(SD=0.8)

![](png/devs.png)

## Population trajectories

- Roller coaster
- High F
- Low F

![](png/traj.png)






here is a list of OM true values that would help me ensure that i can achieve the true result when configured with the correct values:

index q
index CV
index effective sample size
index selectivity
index timing (month of year)
fleet selectivity
total catch cv
catch at age effective sample size
natural mortality (is this time and age invariant?)
steepness
virgin spawning biomass
recruitment standard deviation (sigmaR)

just looking at the data, were the first 40 or so years burn in?  if so, then it seems i should start with year 44?

to compare the output,  i think it makes sense to compare the following:
steepness
virgin spawning biomass
numbers at age
fleet selectivity
F at age
index selectivity
index q
SSB time series



Scenario	Year	Run	Estim	Recr	SSB	Model
1	1944	1	TRUE	112.8822	302.8774	ASAP
1	1945	1	TRUE	117.4531	333.245	ASAP
1	1946	1	TRUE	118.6393	354.2409	ASAP
1	1947	1	TRUE	133.5095	364.1606	ASAP
1	1948	1	TRUE	136.1276	364.3005	ASAP
1	1949	1	TRUE	134.3044	357.1207	ASAP
1	1950	1	TRUE	140.0082	343.5911	ASAP
1	1951	1	TRUE	142.8973	327.4779	ASAP




#Calculate total index with lognormal error and age comp with multinomial error
# index is a matrix for the true population index
# q.indices is a scalar for catchability (let's use q <- 3e-3)

# index.sel is a vector of index selectivity at age
# (let's use logistic selectivity with a50 <- 2.3 and slope <- 0.4):
#          index.sel=1/(1+exp(-(age-a.50)/slope))

# naa is a matrix of numbers at age by year 
# index.delta.t decrements within-year survival to the point when the survey operates (jan-1 would be 0, feb-1 would be 1/12, etc.)
# F.vector is the F multiplier in year y
# fish.sel is a vector of fishery selectivity at age (the code below assumes fishery selectivity does not vary by year, but if it did so then you would use the appropriate vector for the year of calculation)
# M.age is a vector of natural mortality at age (assuming this doesn't change over years)
# sig.index is the log-scale standard deviation for the index (for a CV of 0.2, sig.index=0.198)
# norm.devs is vector of normal deviations from rnorm 
# Neff.surv is the effective sample size for the survey (I think we agreed to 100?)


#true index at age
index[y,]<-q.indices*index.sel*naa[y,]*exp(-index.delta.t*(F.vector[y]*fish.sel+M.age))

#true index total
index.total[y] <- sum(index[y,])

#observed index (with lognormal error)
index_obs.total[y] <- index.total[y]*exp(sig.index*norm.devs[y])

# true proportion at age
p.survey.aa[y,] <- index[y,]/index.total[y]

# multinomial deviates for survey
mn.devs.surv[y,] <- rmultinom(1,Neff.surv[y], p.survey.aa[y,]) /Neff.surv[y]

#observed index at age    
index_obs[y,]<- index_obs.total[y]*mn.devs.surv[y,]


###
#Note: for vpa, an index value for year (T+1) is required
#if we agree to index.delta.t=0, then you can get the index value for year (T+1) by calculating 
#everything for (T+1) at the end of year T (Dec 31 in year T is the same as Jan-1 in T+1)
#so in the next line, index.delta.t would just be 1
indexT1[y,]<-q.indices*index.sel*naa[y,]*exp(-index.delta.t*(F.vector[y]*fish.sel+M.age))
indexT1.total[y] <- sum(indexT1[y,])
indexT1_obs[y,]<- indexT1_obs.total[y]*mn.devs.surv[y,]
