
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

