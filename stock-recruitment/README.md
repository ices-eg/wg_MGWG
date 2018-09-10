### Internal vs. external stock recruitment

(N Cadigan)

There has been a proliferation of published analyses on stock productivity based on model-estimated time-series of parental stock size and recruitment (e.g. RAM database pubs). However, WGMG in 2013 recommended:

"There is a need to compare internal (i.e. within assessment model) vs. external estimation of stock-recruit parameters. Where possible, estimation should be carried out internally to take proper account of covariance structures, provided there is no evidence of model misspecification in such a process. Model diagnostics should always be carefully explored in such circumstances."

External estimation is affected by covariate measurement error bias, which could include overestimation of the slope-at-the-origin and underestimation of Rmax. This could be bad for sustainable management.

Additional perspective on modelling assessment model outputs is given by Brooks and Deroba (2015)

Criteria | Comments
-------- | --------
Important for many stock assessment scientists?   |
Standard papers that people cite for this topic?  | [Brooks and Deroba 2015](https://doi.org/10.1139/cjfas-2014-0231)
Another working group already working on this?    |
How can this be structured into a journal paper?  |
What kind of work is required, and how much work? |
Participants that would like to work on this?     | Casper Berg, Chris Legault, Craig Marsh, Dvora Hart, Ernesto Jardim, Jon Deroba, Liz Brooks, Noel Cadigan, Tim Miller, Vanessa Trijoulet
Who would like to lead, what will coauthors do?   |


Proposal: WGMG provide some analyses of this issue, and recommendations on potential problems with external vs internal estimation of SR functions.

***

## Proposal Format

* Working title
* Participants
  * Leader(s)
  * Casper Berg DTU Aqua
  * Chris Legault NEFSC
  * Craig Marsh NIWA
  * Dvora Hart  NEFSC
  * Ernesto Jardim
  * Jon Deroba NEFSC
  * Liz Brooks NEFSC
  * Noel Cadigan  Memorial University
  * Tim Miller NEFSC
  * Vanessa Trijoulet NEFSC
* Background
  * Area of research
  * Brief literature review
  * Remaining questions
  * Why is this important
* Objectives - Set of Questions to Answer
  * For Internal Estimation
    * Can correct S-R be identified? (AIC for model selection?)
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
      * VPA (SR external)
      * SCAA (SR internal, sigma_R known)
      * State-space (SR internal, process error in recruitment only)
      * State-space (SR internal, process error in survival)
      * Other state-space
    * Use state-space model to simulate population with process errors
    * SUGGESTION: CONSIDER USING A COMMON OPERATING MODEL WITH OTHER PROJECTS
      * Stock-recruit types
        * Beverton-Holt
        * Ricker
        * None
        * Hockey (not differentiable)
      * Number of years
        * 20
        * 40
      * variance of log-recruitment
        * 0.3
        * 0.6 
        * 0.9
      * Contrast in population/SSB
        * Low F
        * High F
        * variation in F
  * Tasks, who's doing what
  * Milestones, timeline
* References
  * [Brooks and Deroba 2015](https://doi.org/10.1139/cjfas-2014-0231)
* Appendix
  * Preliminary diagram, table, plots

***
