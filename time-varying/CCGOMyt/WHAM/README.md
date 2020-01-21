## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: logistic
  Index 2: age-specific (fix ages 2,3)
  Index 3: logistic
  Index 4: age-specific (fix ages 1,2,3)

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
fix_pars_age <- NULL
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

## Comments

All models converged except for m5: logistic 2D AR1. Tried starting m5 at sel par values from m4, still did not converge.

Age-specific 2D AR1, logistic 2D AR1, and logistic AR1_y estimated similar selectivity patterns, decreasing selectivity of middle ages (2-4) over time. These models had clearly lower NLL and AIC. Models 7-9 (age-specific IID, AR1_a, and AR1_y) estimated time-constant patterns.
