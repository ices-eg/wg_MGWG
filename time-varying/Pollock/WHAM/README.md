## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: age-specific (fix age 9)
  Index 2: age-specific (fix ALL ages, 1-9)

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

Only m1-m3 converged. Age 3 and 7 in Index 1 estimated high for all models, fix. Also fix age 8 in age-specific models.

#### Run #2

Fix age 8 and Index 1 age 3,7,9

Logistic models estimated selAA = 1 for all ages/years. Unfix Index 1 age 3 and 7.

#### Run #3

Fix age 8.

Logistic: m1-m3 converged. Start m2-m5 at m2 estimates.
Age-specific: time-constant model m6 still hasn't converged. Fix age 7 also (logit_selpars = 5).

#### Run #4

Fix ages 7,8.

All converge except m6 and m8. logit_selpars for Index 1 ages 3 and 7 are still estimated high (really high for age-specific models... 90 and 75)

#### Run #5

Fix Index 1 age 3.

Age-specific models converge. Logistic models estimate selAA = 1 for all ages and m1 doesn't converge...

## Comments

Use Run 4 for now.
