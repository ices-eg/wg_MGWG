# Appropriate level of model complexity

## Meeting Information
Date: Monday 29 October 2018

Time: 14:00 GMT / 16:00 Oslo & Copenhagen / 10:00 EDT / 7:00 PDT 

Connection Method: Skype 

[Notes](Notes.md#29-Oct-2018)  will be posted after meeting


***
## Task List (identify lackey and date for completion)

- [x] Schedule first meeting: 29 October 2019 
- [ ] Simulate test data set with Gadget, post on Git site
* Daniel Howell 
* date?
- [ ] Convert GADGET output into format for each EM 
* Daniel Howell? Dan Hennen? Liz Brooks? 
* date?
- [ ] Test each EM with test data (make sure we can recover 'truth' before commencing with many data sets and different complexity levels) 
- [ ] Schedule next meeting after we reach this point?
- [ ] Develop code to compare EM output with OM truth
- [ ] Simulate full suite of data sets (need to discuss best way to manage sharing of these data sets)
- [ ] Run each EM on all data sets
- [ ] Evaluate results
- [ ] Manuscript preparation

***

## Outline
The objective of this project shifted during the meeting from the original ideas generated during the 2017 Woods Hole meeting. The current objective of this subgroup is to focus on model evaluation/model selection metrics and their relative performance in helping to select a model that corresponds to the true level of complexity.  At the same time, we are interested in how catch recommendations may vary within complexity levels for a given assessment model framework as well as between different model frameworks, with a goal of developing “good” catch recommendations.  We will track the project here; the original Readme file has been reanamed [Readme_old](https://github.com/ices-eg/MGWG/blob/master/model-complexity/README_old.md) in case we want to easily see the previous thinking on this project.

### The project will involve
1.	3 operating models (OMs): low, medium, and high levels of complexity
2.	3 estimation model (EM) structures matching the OM complexity
3.	Multiple EM frameworks: length-based, age-based, and integrated (and maybe state-space)
4.	For each OM complexity level, each EM will fit low, medium, and high complexity models
5.  We will evaluate various validation/selection metrics and diagnostics for their ability to identify the correct model complexity
    * Information theoretic – AIC, BIC, DIC, WAIC?
    * Prediction-based – cross-validation and/or something that systematically predicts a quantity (e.g., survey biomass) by stepping back through data omission (n, n-1, n-2, etc.)
    *	Retrospective analysis – Mohn’s rho
    *	Residuals – QQ?, residual trends/distribution/RMSE – all fits; a low level of thinking toward Patrick’s random RMSE thing; component likelihoods 
    *	Some combination of metrics? Correlation matrix between metrics?
5.	Management performance
    *	Each EM will provide an estimate of MSY, and these estimates will be compared with the OM MSY so that we can evaluate within and between model ability to produce unbiased catch advice.  (old ideas: Need some value for “true” FMSY so we can compare FMSYs (proxies) estimated by the models – perhaps YPR to get F0.1 from operating model and compare using relative error (direction seems important, so maybe not absolute)…maybe SPR instead of YPR?...)
    *	Does anyone remember what this sentence is about (if not, it will be deleted): Also, consider a model averaging approach related to FMSY (averaged within models over complexity and across models at a given level of complexity)?
    
### Details for the simulated case study 
The first case study OM will be based on a gadoid-like fish.  While we initially had discussed multiple life-histories (including a pelagic and invertebrate), we are thinking that a scaled back project focused on one life history will be more manageable, and more likely to produce results for the 2019 meeting.  A follow-up study (and manuscript) could build on our conclusions from this case study, and we could explore additional issues that would be presented by the other two life-histories.

[GADGET](https://github.com/Hafro/gadget) will be used for the OM.
The OM will simulate data for 100 years (1940-2040).  The first 30 years of simulated data will have no fishing, and simply allow the model to equilibrate.  Catches will be removed beginning in 1970.  Data through 2015 will be used in the estimation models (45 years of data), and data for years 2016-2040 will be reserved in case we want to test projection skill or harvest control rules (no plans for this yet).


OM complexity levels will be simulated with the following configuration:
1.	Low complexity: time invariant biological parameters; observation error only (catch and indices), deterministic stock-recruit (Question: is this too simple?), single selectivity function for all years 
2.	Medium complexity: same as (1) but with 2 selectivity blocks (1970 to 1995 is logistic, 1996-2015 is dome-shaped); stock-recruit with process error/devs (Give Gadget the actual dev vector in real space)
3.	High complexity: same as (2) + increasing M (2 time steps) (maybe: time varying growth/decreasing Linf?)

Some parameter details:
* Observation error on total catch:  
* Observation error on catch at age:
* Observation error on total index: CV=0.25?
* Observation error on index numbers at age: 
* Process error on stock recruitment: CV=0.5?
* Stock-recruit function: Beverton-Holt?
* Natural mortality: time-invariant M=0.2; with step change, second M=0.4?
* other details..?

### Estimating models and who will perform runs
1.	Age-based, non state space (ASAP) – Liz Brooks; ...
2. Age-based, maybe state space? (a4a) - Ernesto Jardim?
3.	Age-based (SS) – Dan Hennen?
3.	Length-based (CASA? or CASAL? or..?) – Question: will we explore this model? If so, what additional simulated output is needed?

### Output needed from the operating model (to be used in estimating models)
1.	Total catch in biomass
2. Catch at age in numbers
3. Total index in numbers with age composition OR indices in number at age (can be summed to get total index)
4.	maturity at age, weight at age in stock and catch
5. Length comps? ALK? eff. sample size=?; multinomial dist; apply to index and catch after obs error

### What gets specified vs estimated in estimating models
1.	Start by specifying correct error/structure/eff sample size throughout (single test case at low complexity only or do a test case at each complexity?
2.	Estimate selectivity parameters, q (catchability), recruitment deviations
3. For M, start with “true” M correctly specified, and with time-varying (in high complexity case), use diagnotics to guide value for second M ; similarly, rely on diagnostics and model selection criteria for when to estimate second selectivity stanza
4.	Probably fix these: true effective sample size for composition data; true CVs for indices, catch, and recruitment devs

***

### Some random comments that I cannot interpret (we will delete if no one can explain; discuss on our call)
1.	For time blocks, perhaps truth is not exact, but rapidly changing; thus, estimation models treat the change coarser than OM – not for ASAP
2.	Index correlated with true trend, but with error?


### Other thoughts:
- how to explain the complex models to the public (words and pictures)
- if you have length and age, use one or both? pros/cons?
- ...


***
## List of references
Provide a link to the reference if possible.
Can we store pdfs in a folder for this project?

* [Cotter et al (2004) Fish and Fisheries “Are stock assessments too complicated?”](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-2679.2004.00157.x)
* others...

## After Ispra meeting

* We need to identify day of week and frequency for touching base. 
* Proposed first contact: October 29, 2019 
* Identify what each person will work on between now and the first call, and overall what each person will contribute
  * Liz Brooks - simulation design, code to convert Gadget to ASAP, ASAP runs, code to gather output, ...  
  * Patrick Lynch - simulation design, random idea generation, SS runs?, ...
  * Daniel Howell - simulation design, generate simulated data from Gadget, ...
  * Dvora Hart - simulation design, CASA runs, ...
  * Daniel Hennen - SS runs, code to convert Gadget to EM input files, ...
  * Ernesto Jardim - a4a runs, ...
  * Alejandro Yanez - ...
  * No response yet from the names below:
    * Geir Olve Sorvik - ...
    * Helen Takade-Heumacher - ...
    * Knut Korsbrekke - ... 
    * Brandon Chasco - ...
    * Jose De Oliveira - ...
 
## Seattle 2019 meeting

* Decided to put this project on hold to allow focus on other ongoing projects and the addition of two new projects.
* Will evaluate whether to restart this project at 2020 meeting.


