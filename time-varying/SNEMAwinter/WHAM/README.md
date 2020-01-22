## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: logistic
  Index 2: age-specific (fix age 4)   
  Index 3: logistic 

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

m1-m6 converged. Index 3 selectivity pars are near bounds, sel at all ages estimated at 1 in (fleet) age-specific models, increases 0.6 to 1 in (fleet) logistic models.
Age-specific looks like age 4 should be fixed at 1 (logit_selpars about 4).

#### Run #2

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 4
sel_inits_age[fix_pars_age] = 1

m7-10 still not converged but look closer (NLL, AIC are reasonable). Age-specific looks like age 5 could be fixed at 1 (m6-10: 1.6, 3, 4.3, 5, 9). Possible that models with time-varying age-specific selectivity will need to fix more mean selectivity parameters (logit_selpars) to converge. To discuss: currently if mean sel-at-age is fixed (usually at 1), we do not estimate RE deviates... but we could.

#### Run #3

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 4:5
sel_inits_age[fix_pars_age] = 1

m7-10 still do not converge. Try fixing age 1 at m6 estimate (logit_selpars = -4.6).

#### Run #4

All models converge, but m7-m10 over-constricted (half ages fixed).

## Comments


