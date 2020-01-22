## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: logistic
  Index 2: logistic
  Index 3: logistic

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 9 ages
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

#### Run #2

Try starting m5 at m4 par values. From selAA plot, looks like fixing age 8 at 1 or age 1 at 0 may help age-specific models. logit_selpars[1] = -5, fix age 1 at 0.

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 1
sel_inits_age[fix_pars_age] = 0
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2) # start a50 parameter in middle of age range
fix_pars_logistic <- NULL

m5 converged. m6-10 did not. No bad logit_selpars, but NaN sdrep for logit_selpars, sel_repars, F_devs.

#### Run #3

Fix age 8 at 1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 8
sel_inits_age[fix_pars_age] = 1

Looks better. Age 1 is consistently < 4.5, try fixing age 1 at 0. Could try fixing age 7 at 1: 2.2, 3.4, 8.4, 3.2, 4.5

#### Run #4

Fix age 1 at 0, age 8 at 1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- c(1,8)
sel_inits_age[fix_pars_age] = c(0,1)

#### Run #5

Fix age 7,8 at 1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- 7:8
sel_inits_age[fix_pars_age] = 1

m6 and m10 converge.

#### Run #6

Fix age 7,8 at 1 and age 1 at 0

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- c(1,7:8)
sel_inits_age[fix_pars_age] = c(0,1,1)

m6 does not converge.

## Comments

Much larger dataset than others (86 years, 9 ages) = 200 MB files instead of ~20 MB.
