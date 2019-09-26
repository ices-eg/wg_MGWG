# Time-varying selectivity

## Minutes

### 2019-09-23 Seattle, WA

Pitched an idea for a new project to the MGWG for "investigating methods of estimating time-varying selectivity in stock assessment models". Which led to the following topics of discussion:

1. What algorithms are currently implement for estimating time-varying selectivity in stock assessment models that have been used for management purposes to date?

  * Stock Synthesis: 2D AR process that was investigated using a simulation with lots of good data
  * SAM
  * WHAM

2. When should you use a block (subjective) or allow the model to be time-varying over the full time series (objective)? A simple model may fit the data worse but have more informed forecasts, and a more complex model may fit the data better but have uninformed forecasts. East and west coast US largely use blocks to model time-varying selectivity where the European assessments use random effects. Can random effects or other algorithmic answers suggest the year in which you should have a block?

3. What patterns in the residuals are the result of random processes versus what patterns should be corrected with time-varying selectivity? Can you ever tell the difference between these two situations using bubble plots?
  
  * West coast largely implements blocks based on management eras
  * East coast largely implements blocks to correct residual patterns
  * Do any ICES models implement blocks, not sure if SAM does blocks?

4. How does time-varying selectivity interact with other processes such as other time-varying processes (e.g., time-varying natural mortality) and other model specifications (e.g., data weighting)

5. How do you set selectivity in the forecast period if it is not constant in the estimated time series?

  * Mean selectivity from a user-specified block of years, where using selectivity in the terminal year is a special case of this
  * Continue the estimation of the random process into the forecast years; this was not recommended in the discussion because on average you will return to the long-term mean, which might not be indicative of what the future will be
  * Randomly resample the last x years
  
6. Should we always expect dome-shaped selectivity? Should we always expect the peak of this dome to shift because fishers move to areas of higher CPUE and catch younger fish as the fishery progresses through time. Fishing location and economic drivers can help explain these patterns.

### 2019-09-24 Seattle, WA

 - [ ] contact Cecilia or Paris to see if they can run the a4a models
 - [ ] find Stewart and Monnahan's paper on data weighting and process error
 - [ ] get in touch with members of the ICES MGWG that didn't make it to Seattle to see if they are interested in participating
 - [ ] make a slide for Arni's presentation on Friday after the quant seminar
 - [ ] make a list of potential time blocks based on management for each assessment
 
Talked about estimating breakpoints using an external analysis (suggested by Devora). This was not seen as a favourable way forward. Could be a point for the Discussion section of the manuscript. 

How Stock Synthesis estimates the process variability of the 2D AR process was brought up by Cole. Currently, it has been suggested that the Laplace approximation would be a good way forward. Another suggestion was to use an iterative tuning method, like what is done with $\sigma_r$. 

### 2019-09-25 Seattle, WA



### 2019-09-26 Seattle, WA

