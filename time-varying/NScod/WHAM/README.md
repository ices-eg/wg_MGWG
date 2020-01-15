## WHAM model fit details

Initial run matches state-space project: age-specific selectivity for Index 1 (fix age 5 at 1) and Index 2 (fix ages 3,4 at 1). All models achieved convergence in initial run, no further selectivity parameter fixing/initializing was necessary.

#### Run #1

sel_inits_age <- c(0.5,0.5,0.5,0.5,0.5,0.5)
fix_pars_age <- NULL
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

## Comments

All age-specific models outperformed the corresponding logistic models. Time-varying models much better than time-constant.
