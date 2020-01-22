## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: age-specific (fix age 7)
  Index 2: age-specific (fix age 3,4,5)
  Index 3: age-specific (fix age 1)   

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

All but m7 converged. All time-varying age-specific models have logit_selpars > 20 for age 5. Fix age 5 in age-specific models.

#### Run #2

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 5
sel_inits_age[fix_pars_age] = 1

All models converged.

## Comments

Logistic AR1_y / 2D AR1 preferred by AIC. Surprising: for all but constant and 2D AR1, the logistic analog had lower NLL than its age-specific partner (i.e. m2 > m7, m3 > m8, m4 > m9).
