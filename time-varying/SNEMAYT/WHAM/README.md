## WHAM model fit details

Initial run matches state-space project: age-specific selectivity for Index 1 (fix age 4 at 1) and Index 2 (fix ages 2,3,4 at 1). We then undertook the following procedure to achieve convergence of all models:

Logistic selectivity: initialize parameters closer to estimated values from converged models
Age-specific selectivity: Among converged models, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at the estimated value from simplest converged model.

#### Run #1

sel_inits_age <- c(0.5,0.5,0.5,1,1,0.5)
fix_pars_age <- 4:5
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

#### Run #2

sel_inits_age <- c(plogis(-4.0331660),0.5,0.5,1,1,0.5)
fix_pars_age <- c(1,4,5)
sel_inits_logistic <- c(2.1,0.15)
fix_pars_logistic <- NULL

## Comments

Original assessment selectivity: 1 fleet, 6 selectivity time blocks (all age-specific), 5 indices. **Compare time-varying selectivity estimates with the 6-block model.**

Interesting that the logistic ar1_y, age-specific ar1_y, and age-specific 2dar1 models had nearly identical NLL despite having quite different selAA (strong dome in age-specific models). Logistic ar1_y wins by AIC bc fewer parameters used.
