## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: logistic
  Index 2: age-specific (fix age 1)
  Index 3: logistic    

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

Looks like peak age-specific selectivity is age 4, and logit_selpars is > 7 for m10.

#### Run #2

Try fixing age 4 at 1.

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 4
sel_inits_age[fix_pars_age] = 1
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

## Comments

Time-varying age-specific models do not converge.
