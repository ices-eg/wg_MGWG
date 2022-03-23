## WHAM model fit details

State-space project selectivity:
  Fleet: logistic
  Index 1: age-specific (fix age 3,8)
  Index 2: age-specific (fix age 3,8)   

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages)
fix_pars_age <- NULL
sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

m3, m6-10 did not converge. Couple index logit_selpars were > 20, try fixing them.

#### Run #2

Fix additional age-specific sel in Index 1 (3,4,8) and Index 2 (3,6,8).

m3, m6-10 did not converge. Try fixing age 6. Try starting m3 at m2 values.

#### Run #3

Start m3 at m2 values. Fix age 6.

m6 converged, others did not. Try fixing age 7 too.

#### Run #4

Start m3 at m5 values. Fix age 6+7.

Logistic: Not sure what else to try for m3. Could try fixing Index 2 age 5.
Age-specific: m6 and m10 converged, others did not. m6 NLL did not change much from run3 (good). Could try fixing Index 2 age 5 or Fleet age 1 at m6 estimate (sel-age1 = 0.9%)

#### Run #5

Fix Index 2 age 3,5,6,8. Fix Fleet age 6,7.

Worse. m1,2,4,5,6 converge.

#### Run #6

Fix Fleet age 1 at estimate from m6, logit_selpars = plogis(-4.8).

m6 and m8 converge but m7,m9,m10 do not (and m10 converged without fixing age 1, lower NLL).

## Comments

Use Run 4 for now.
