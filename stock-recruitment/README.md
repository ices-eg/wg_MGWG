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
Participants that would like to work on this?     | Casper Berg, Chris Legault, Craig Marsh, Dvora Hart, Ernesto Jardim, Jon Deroba, Liz Brooks, Noel Cadigan, Tim Miller, Vanessa Trijoulet, Christoph Konrad
Who would like to lead, what will coauthors do?   |

***

## Proposal Format

* Working title:  Interanl versus external estimation of stock-recruit relationships: can we and should we?
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



