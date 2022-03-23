## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: age-specific (fix age 4)
  Index 2: age-specific (fix age 5) 
  Index 3: age-specific (fix age 3)
  Index 4: age-specific (fix age 3)  

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

m1-7 converge, m8-10 did not (nll and AIC seem reasonable though, so perhaps close). Age 6 logit_selpar estimated high for m7-10, fix.

#### Run #2

Fix age 6.

Looks like age 5 or 7 could be fixed, but which depends on the time-varying model. m6,7,9 want age 7 fixed. m8,10 want age 5 fixed.

#### Run #3

Fix ages 6+7.

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 6:7
sel_inits_age[fix_pars_age] = 1

All converged except for m9. Start m9 at m10 values.

#### Run #4

All converged.

## Comments


