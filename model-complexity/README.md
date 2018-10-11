# Appropriate level of model complexity

...

***

Criteria | Comments
-------- | --------
Important for many stock assessment scientists?   |
Standard papers that people cite for this topic?  | See list of references at bottom of page
Another working group already working on this?    |
How can this be structured into a journal paper?  |
What kind of work is required, and how much work? |
Participants that would like to work on this?     | Alejandro Yanez, Brandon Chasco, Dvora Hart, Geir Olve Sorvik, Helen Takade-Heumacher, Liz Brooks, Patrick Lynch, Ernesto Jardim
Who would like to lead, what will coauthors do?   |

## Outline
•	The objective of this project shifted during the meeting to focus on model evaluation/model selection metrics and their relative performance in helping to select a model that corresponds to the true level of complexity AND develop “good” catch recommendations.  The old Readme file was a poor match, so it was reanamed "Readme_old" in case we want to easily see the previous thinking on this project.

•	The project will involve
1.	3 operating models: low, medium, and high levels of complexity
2.	3 estimation model classes matching the operating model complexity
3.	Potentially multiple estimating model frameworks: length-based, age-based, and integrated (and maybe state-space)
4.	Various validation/selection metrics
   * Information theoretic – AIC, BIC, DIC, WAIC?
   * Prediction-based – cross-validation and/or something that systematically predicts a quantity (e.g., survey biomass) by stepping back through data omission (n, n-1, n-2, etc.)
   *	Retrospective analysis – Mohn’s rho
   *	Residuals – QQ?, residual trends/distribution/RMSE – all fits; a low level of thinking toward Patrick’s random RMSE thing; component likelihoods 
   *	Some combination of metrics? Correlation matrix between metrics?
5.	Management performance
   *	Need some value for “true” FMSY so we can compare FMSYs (proxies) estimated by the models – perhaps YPR to get F0.1 from operating model and compare using relative error (direction seems important, so maybe not absolute)…maybe SPR instead of YPR?...REVISE: use catch recommendation (MSY) for comparison
   *	Also, consider a model averaging approach related to FMSY (averaged within models over complexity and across models at a given level of complexity)?
   * other...
 
•	Operating model scenarios (gadoid-like) – error consistent across scenarios?
1.	Low complexity: simple base configuration (no time variation); obs error only (catch/indices), deterministic stock-recruit – time = 1940-2040, catch starts in 1970
2.	Medium complexity: add 2 selectivity blocks (1975 to 1995-logistic, then domed); stock-recruit with process error/devs (Give Gadget the actual dev vector in real space)
3.	High complexity: 2 selectivity blocks; stock-recruit with devs + increasing M (2 time steps) (time varying growth/dec Linf?)

•	Consider another OM life history? –faster, herring-like? Either/or multiple estimating model frameworks…TENTATIVE: do gadoid first then evaluate whether warrants

•	Estimating models
1.	Age-based (ASAP?) – low, medium, high complexity; model years: 1975-2015
2.	Length-based (CASA?) – low, medium, high complexity
3.	Integrated (SS?) – low, medium, high complexity

•	Input data from the operating model 
1.	Catch data across scenarios (w/obs error=0.1)? Full retention?
2.	Abundance indices: apply selectivity with sigma=0.2
3.	Age, length comps, ALK…: eff. sample size=?; multinomial dist; apply to index and catch after obs error

•	Specifying the error in estimating models
1.	Start by specifying correct error/structure/eff sample size throughout

•	What parameters should be estimated/specified in the estimating models?
1.	Selectivity/q/rec devs
2.	For M, start with “true”, and with time-varying, use diagnotics to guide M2 (fixed), and when to estimate selectivity 2 

•	What informs the time-varying parameters?
1.	For time blocks, perhaps truth is not exact, but rapidly changing; thus, estimation models treat the change coarser than OM – not for ASAP
2.	Index correlated with true trend, but with error?

•	Weighting – start with true





### Other thoughts:
- how to explain the complex models to the public (words and pictures)
- if you have length and age, use one or both? pros/cons?
- ...



*References can be found here:*
* Cotter et al (2004) Fish and Fisheries “Are stock assessments too complicated?” 

## After Ispra meeting

* We need to identify day of week and frequency for touching base. 
* Proposed first contact: October 29, 2019 (can send doodle poll if needed)
* Connection details: (will be posted here....)
* Identify what we will have accomplished by this first call
* Identify what each person will work on between now and the first call, and overall what each person will contribute
  * Liz Brooks - simulation design, code to convert Gadget to ASAP, ASAP runs, code to gather output, ...  
  * Patrick Lynch - simulation design, random idea generation, ...
  * Daniel Howell - simulation design, generate simulated data from Gadget, ...
  * Dvora Hart - simulation design, CASA runs, ...
  * Ernesto Jardim - a4a runs, ...
  * Alejandro Yanez - ...
  * Geir Olve Sorvik - ...
  * Helen Takade-Heumacher - ...
  * Knut Korsbrekke - ... 
  * Daniel Hennen - ...
  * Brandon Chasco - ...
  * Jose De Oliveira - ...
 


