## WHAM model fit details

Initial run matches state-space project: age-specific selectivity for Fleet (fix ages 2,3,4,5,6,7,8), Index 1 (fix ages 3,4,5,6,7,8), and Index 2 (fix ages 3,4,5,6,7,8). We then undertook the following procedure to achieve convergence of all models:

1. Fit time-constant models.

2. Initialize selectivity parameters for time-varying models at estimated values from time-constant models.

3. If age-specific selectivity models did not converge, look for logit_selpars consistently estimated > 4 or < -4. Fix the worst one at 0 or 1.

#### Run #1

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
fix_pars_age <- 2:8
sel_inits_age[fix_pars_age] = 1
sel_inits_logistic <- c(2,0.2)
fix_pars_logistic <- NULL

#### Run #2

Logistic selectivity was able to achieve lower NLL than age-specific, which seems wrong.
Models 1, 4, and 5 had non-zero selectivity for age 2.
Un-fix age 2 selectivity for age-specific models

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
fix_pars_age <- 3:8
sel_inits_age[fix_pars_age] = 1

Models 2 and 3 did not converge (logistic sel). Start parameter 1 closer to estimate from models 1, 4, 5.

sel_inits_logistic <- c(1.5,0.2)
fix_pars_logistic <- NULL

#### Run #3

Age-specific time-varying selectivity did not converge.
Age 1 selectivity was -3.797185 in time-constant model 6. Try fixing age 1 at 0 and estimating age 2.

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
fix_pars_age <- c(1,3:8)
sel_inits_age[fix_pars_age] = 1
sel_inits_age[1] = 0

Models 2 and 3 converged with starting par values in Run #2, but models 1, 4, 5 did not. Start all models at values that achieve convergence.

sel_inits_logistic <- list(c(2,0.2),c(1.5,0.2),c(1.5,0.2),c(2,0.2),c(2,0.2))
fix_pars_logistic <- NULL

#### Run #4

1. Fit time-constant models.

2. Initialize selectivity parameters for time-varying models at estimated values from time-constant models.

Age-specific time-varying selectivity did not converge.
Go back to Run #1 (fix age 2 at 1).

sel_inits_age <- rep(0.5,asap3$dat$n_ages) # 8 ages
fix_pars_age <- c(1,3:8)
sel_inits_age[fix_pars_age] = 1
sel_inits_age[1] = 0

Start a50 parameter at middle of age range.

sel_inits_logistic <- c(floor(asap3$dat$n_ages/2),0.2)
fix_pars_logistic <- NULL

## Comments

Age-specific selectivity with only 1 age estimated, rho_a is not estimable. WHAM correctly identifies this and maps rho_a to NA. Identical models: 7 and 8, 9 and 10.

Logistic time-varying best bc age-specific did not converge with age 2 estimated.

