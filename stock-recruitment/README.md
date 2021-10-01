### Internal vs. external stock recruitment

(N Cadigan)

There has been a proliferation of published analyses on stock productivity based on model-estimated time-series of parental stock size and recruitment (e.g. RAM database pubs). However, WGMG in 2013 recommended:

"There is a need to compare internal (i.e. within assessment model) vs. external estimation of stock-recruit parameters. Where possible, estimation should be carried out internally to take proper account of covariance structures, provided there is no evidence of model misspecification in such a process. Model diagnostics should always be carefully explored in such circumstances."

External estimation is affected by covariate measurement error bias, which could include overestimation of the slope-at-the-origin and underestimation of Rmax. This could be bad for sustainable management.

Additional perspective on modelling assessment model outputs is given by Brooks and Deroba (2015) and Conn et al. (2010)

The objectives of this research are: 1) Determine when parameters of stock recruit relationships can be estimated internally to a stock assessment model (e.g., Conn et al., 2010), 2) Determine when parameters of stock recruit relationships can be estimated using estimates of parental stock size and recruitment from a stock assessment, but with the relationship estimated external to the stock assessment.  Ultimately, is it better to use internal or external estimation?

Criteria | Comments
-------- | --------
Important for many stock assessment scientists?   |
Standard papers that people cite for this topic?  | [Brooks and Deroba 2015](https://doi.org/10.1139/cjfas-2014-0231) [Conn et al. 2010 CJFAS](https://doi.org/10.1139/F09-194)
Another working group already working on this?    |
How can this be structured into a journal paper?  |
What kind of work is required, and how much work? |
Participants that would like to work on this?     | Casper Berg, Chris Legault, Craig Marsh, Dvora Hart, Ernesto Jardim, Jon Deroba, Liz Brooks, Noel Cadigan, Tim Miller, Vanessa Trijoulet, Christoph Konrad, Iago Mosqueira, Colin Millar
Who would like to lead, what will coauthors do?   |

***

## Proposal Format

* Working title:  Internal versus external estimation of stock-recruit relationships: can we and should we?
* Participants
  * See below
* Background
  * Brief literature review: [Brooks and Deroba 2015](https://doi.org/10.1139/cjfas-2014-0231) [Conn et al. 2010 CJFAS](https://doi.org/10.1139/F09-194)
* Objectives - See above
  * For Internal Estimation
    * Can correct S-R be identified? (AIC for model selection?) see [Conn et al. 2010 CJFAS](https://doi.org/10.1139/F09-194)
    * How precise are S-R parameters?
    * Should we also try a 3-parameter S-R?
    * How precisely are reference points estimated?
 * For External Estimation 
    * Can correct S-R be identified? (AIC for model selection?)
    * How precise are S-R parameters?
    * Should we also try a 3-parameter S-R?
    * How precisely are reference points estimated?
    * Is this approach improved if you also use the Hessian (from the fitted model)?
* Plan
  * Methods, data
    * Assessment model types
      * SCAA (SR internal, sigma_R known)
      * State-space (SR internal, process error in recruitment only)
      * State-space (SR internal, process error in survival)
      * Other state-space
    * Use state-space model to simulate population with process errors
    * SUGGESTION: CONSIDER USING A COMMON OPERATING MODEL WITH OTHER PROJECTS
      * Stock-recruit types
        * Beverton-Holt
        * Ricker
        * Hockey (not differentiable)
        * Mean recruitment
      * Number of years
        * 25
        * 50
      * variance of log-recruitment
        * 0.4
        * 0.8 
        * random walk
      * Contrast in population/SSB
        * Low F: runif(0.2*Fmsy, 0.4*Fmsy)
        * High F: runif(1.2*Fmsy, 1.4*Fmsy)
        * rollercoaster F
  * Tasks, who's doing what
  * Milestones, timeline
* References
  * [Brooks and Deroba 2015](https://doi.org/10.1139/cjfas-2014-0231) 
  * [Conn et al. 2010 CJFAS](https://doi.org/10.1139/F09-194)
  * [de Valpine and Hastings 2002](https://doi.org/10.1890/0012-9615(2002)072[0057:FPMIPN]2.0.CO;2)
  * [Subbey et al. 2014](https://doi:10.1093/icesjms/fsu148)
  * [Zhou 2007](https://doi.org/10.1016/j.fishres.2007.06.026)
  * [Magnusson and Hilborn 2007](http://dx.doi.org/10.1111/j.1467-2979.2007.00258.x) - Stock‐recruitment steepness, h, was estimated with some reliability when abundance‐index or age‐composition data were available from years of very low abundance.
  * [Francis 1992](https://doi.org/10.1139/f92-102) - Introduces steepness in a reparametrized Beverton-Holt curve.
* Appendix
  * Preliminary diagram, table, plots


***

## At the Ispra meeting...
* Identified what people will contribute
  * Iago Mosqueira - simulating; uploading simulation iterations
  * Christoph Konrad - simulating; ...
  * Colin Millar - simulation design, adding code, a4a runs, fitting SR external, summarizing various fits, ...
  * Liz Brooks - simulation design, code for output collection, ASAP runs, ...  
  * Chris Legault - ASAP runs, ...
  * Casper Berg - ...SAM runs?, ...
  * Chris Legault - ASAP runs, ...
  * Craig Marsh - ...
  * Dvora Hart - CASA runs, ...
  * Ernesto Jardim - a4a runs, ...
  * Jon Deroba - SAM runs?, ... 
  * Noel Cadigan - provide code for SR with ar1 process on parameters (for external fitting)
  * Tim Miller - WHAM, ...
  * Vanessa Trijoulet - output summarization, ...
  
* We have conducted a followup call.  See minutes file.

***

## October 1, 2021 Trying to get moving on this again. Below I catalog where results files are being stored and where the "truth" can be found. Maybe we can process results.

*Liz created a table of true stock-recruit parameters for each of the 36 OMs: https://github.com/ices-eg/wg_MGWG/blob/master/stock-recruitment/evaluate_fit/runs_liz.csv

*Iago posted the true values for a bunch of stuff (e.g., time series of SSB, F, recruitment, etc.) for each OM: https://github.com/ices-eg/wg_MGWG/tree/master/stock-recruitment/comparing_recruitment/simulated_stocks/out
  *From Iago:
  true has the time series of rec, F and SSB by run, year and iteration,
asd follows:

> true
         run year iter     data qname
      1:   1    2    1 0.005723     F
      2:   1    3    1 0.001000     F
      3:   1    4    1 0.001000     F
      4:   1    5    1 0.001000     F
      5:   1    6    1 0.001000     F
     ---
5345996:  36   96  500 2.128085   Rec
5345997:  36   97  500 7.110774   Rec
5345998:  36   98  500 2.508539   Rec
5345999:  36   99  500 1.111324   Rec
5346000:  36  100  500 2.680723   Rec

The params data.frame has a table with the SRR params that went into
each OM

> params
      devs srm traj   model      a         b run
1    rwdev bhm  rcc bevholt 487.53 155.55556   1
2  lndev03 bhm  rcc bevholt 487.53 155.55556   2
3  lndev06 bhm  rcc bevholt 487.53 155.55556   3
4    rwdev rim  rcc  ricker   1.77   0.00155   4
5  lndev03 rim  rcc  ricker   1.77   0.00155   5
6  lndev06 rim  rcc  ricker   1.77   0.00155   6
7    rwdev gmm  rcc    mean 400.00        NA   7
8  lndev03 gmm  rcc    mean 400.00        NA   8
9  lndev06 gmm  rcc    mean 400.00        NA   9
10   rwdev hsm  rcc  segreg   0.90 450.00000  10

The code to save them is at the end of

https://github.com/ices-eg/wg_MGWG/blob/master/stock-recruitment/comparing_recruitment/simulated_stocks/output.R#L101

The recruitment std were set at with a random walk with std=0.05
(rwdev) or lnorm with 0.3 (lndev03) or 0.6 (lndev06)

*Jon Deroba did SAM fits and they can be found here: ftp://ftp.nefsc.noaa.gov/pub/dropoff/jderoba  (as of 10/1/2021 Liz and I need to repost results to these sites, they are empty at the moment)
  *There is a separate RData for each of the stock-recruit assumptions.  I did something similar in structure and naming convention to what Liz previously sent you for her ASAP fits (including srcode is 1=BH, 2=Ricker, and 3=RW; these numbers also ID the RData files).  More specifically, each RData contains a matrix of stock-recruit and MSY parameter estimates, a matrix of time series estimates, and a matrix of the variance-covariance matrix of the SSB and recruitment parameters.  Results in all cases can be uniquely identified based on run, iteration, and sr.code.  One oddity you'll find is that there are not results for all 300 datasets for all of the operating models.  For reasons I can't identify and have no way of trouble shooting at this time, TMB blew up for 1-2 datasets for some of the operating models.  I'll try to etch out time to figure out why, but for now I see no reason to delay progress for the sake of a small handful of odd datasets.
  
*Liz did ASAP fits: ftp://ftp.nefsc.noaa.gov/pub/dropoff/lbrooks

*Tim did WHAM fits: ftp://ftp.nefsc.noaa.gov/pub/dropoff/tmiller2/stock_recruit/

*Ernesto may have done some a4a fits, but I cannot find a record of where those results were stored.





