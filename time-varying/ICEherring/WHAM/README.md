## WHAM model fit details

Original assessment and state-space project used logistic selectivity for the fleet, age-specific for Index 1 (fix ages 5,6,7,8 at 1). Initial run matches state-space project. We then undertook the following procedure to achieve convergence of all models:

For time-varying models, selectivity parameters (logit_selpars) are initialized at the estimated values from the time-constant models.

If age-specific selectivity models do not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
fix_pars_age <- NULL
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

#### Run #2

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
sel_inits_age[11] = 1
fix_pars_age <- 11
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

#### Run #3

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 11 ages (starts at age 3, so ages 3-13)
sel_inits_age[10:11] = 1
fix_pars_age <- 10:11
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

## Comments

Can't get age-specific time-varying models to converge. Unfortunate bc NLL is lowest for age-specific 2D AR1 (see run #2 figure with non-converged models). Catch-at-age variance also difficult to estimate. Use Run #1, all parameters freely estimated.
