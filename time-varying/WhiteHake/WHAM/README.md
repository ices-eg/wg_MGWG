## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: age-specific (fix age 4)
  Index 2: age-specific (fix age 3)

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

Models 3, 6, 7, and 9 did not converge. For logistic, looks like all index selpars are estimated far from bounds. Try starting m3 at estimates from m2. For age-specific, selAA plot looks like age 5 should be fixed. logit_selpars age 5 is high for the converged age-specific models.

#### Run #2

Start m2-5 at m2 estimates. Fix age 5 in age-specific models.

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 5
sel_inits_age[fix_pars_age] = 1

m5 now does NOT converge (but has lower NLL by 8). m3 still doesn't converge (NLL similar, 0.3 worse)
m6 converges. m8 and m10 converged both with and without fixing age 5 but have worse NLL now, by nontrivial amounts (4 and 7). m7 and m9 still do not converge.
Age 6 should be fixed (logit_selpars = 20).

#### Run #3

Start m3 at m5 estimate from run1. Fix age 5+6 in age-specific models.

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 5:6
sel_inits_age[fix_pars_age] = 1

Same as before: m3, m7, and m9 do not converge. Not sure what else to try...

## Comments


