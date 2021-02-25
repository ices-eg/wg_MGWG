### Minutes for Skype calls of the stock-recruit group

## 31 October 2018
Attendees:   Jon Deroba, Chris Legault, Liz Brooks, Dvora Hart, Colin Millar, Arni

We clarified and refined the objectives for this research and these have been added to the github repository.  Mostly for Jon's sake, we reviewed progress made in Ispra.

Iago could not be on the call, but we corresponded via email and he agreed to develop a common operating model to be used for data generation.  Colin agreed to assist with this as needed.  Developing this operating model and generating data is a crucial first step because no other work can advance without it.

Someone (Jon?) needs to followup with Noel Cadigan to see if he is able to fully participate.  He has at least offered some code to conduct external estimation of stock recruit relationships.

Jon will clean the github site a bit and post minutes.

Jon will setup the next meeting, but will wait for some progress on operating model development so that we can report something signigicant on the next call.

## 17 June 2019
Attendees: Jon Deroba, Liz Brooks, Iago, Chris Legault, Tim Miller, Dvora Hart, Vanessa Trijoulet

We reviewed the github site as a group and updated everyone on the contents of the folders, next steps, and approximate timing.

A single, test data set is located here: wg_MGWG/stock-recruitment/comparing_recruitment/simulated_stocks/test/
The true values for SSB, recruitment, and F-bar (ages 4-7) are also in this folder.  This dataset is intended to be used to calibrate and run an inital stock assessment setup to ensure that everything is relatively well fit and functional before fitting to many thousands.  If you fit to the test case, then please post your results in this folder.

Thousands of simulated data sets are located here: wg_MGWG/stock-recruitment/comparing_recruitment/simulated_stocks/sa/
Each folder used a different operating model to generate the data (e.g., different F pattern, stock-recruit curve, or noise level).  None of the OMs had time varying selectivity and the true values for M are provided.  Iago may write-up a brief descirption of approximate life history and fleet characteristics for each folder, but otherwise analysts will be "blind".  Various folks will fit various assessment models (see below) to these datasets and record the estimates of SSB, recruitment, F-bar (ages 4-7), fully selected F, and estimates of stock-recruit parameters (alpha, beta, steepness, unfished).  We (Jon or Liz) will check with Colin to ensure that the recorded output listed is sufficient for him to conduct external SR fits.  Each assessment model will be fit assuming a range of stock-recruit model assumptions (e.g., Ricker, BH, RW, mean) and a model selection criterion (e.g., AIC) recorded to determine if the correct shape can be identified.  At some point, the true underlying shape will be revealed to determine, if given the true shape, then can we estimate the stock-recruit parameters.

Assessment model : personnel;
WHAM : Tim Miller;
ASAP : Liz;
SAM  : Me/Iago to check on FLSAM;
a4a  : Ernesto;
SS   : Jon will see if Kelli Johnson has conversion code, but not a priority;

Iago and Vanessa agreed to post-process all the estimates and make comparisons to the underlying true values from the OMs.

We, Dvora in particular, also raised some points that will make good Discussion section fodder.  Doing assessment model fitting in a Bayesian context with a prior on the underlying shape of the stock-recruit relationship.  Would strictly length-based assessments perform differently?  We could conduct a sensitity with incorrect M and evaluate the consequence (Jon thinks falsely time-varying M would be interesting).

We hope to have some results processed before the fall Working Group meeting in Seattle.

Jon will schedule the next meeting for late July/early August.

## 13 November 2020

## updated 25 February 2021

To do list
1. External SR fitting (with and without using variance-covariance; Maybe Noel's nonparametric method; also test what EQSim package identifies for Bmsy, Fmsy, MSY) (Colin)
2. Comparisons of estimated values with true values - recruitment parameters (e.g., "alpha" "beta"), MSY reference points, selectivity, recruitment, SSB, and F time series and recruitment variance when possible (Iago to provide true values; Liz, Tim, Jon to do comparisons)
3. For external fits, evaluation of whether AIC selects the correct OM (colin)
4. For internal fits, evaluation of whether AIC selects the correct OM. Thinking table of scenario, iter, Ricker AIC, BH AIC, "winner", is the "winner" correct. Summary stats likely necessary to ID how frequently AIC worked. Evaluate effect of deviation type (ln03, ln06, RW) and Fhistory.  (Jon, Liz, Tim).
5. Maybe someday evaluate the ability of prediction skill in identifying the correct model (as an alternative to AIC).







