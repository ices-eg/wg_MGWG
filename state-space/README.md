### State-space vs. traditional models

(Tim Miller and Anders Nielsen)

There is now a table to keep track of the stocks that have been run for each model.
Please tick the box after running and uploading the outputs file.
John and Vanessa currently working on creating a script which standardizes and plots the outputs of the three models at once. When a stock has the three ticks (one for each model), then the output script can be run.

Stock | ASAP | SAM | WHAM | a4a sca | Comments
------| ---- | --- | ---  | ------- | --------
North Sea cod (Nscod) | |X|X|X| Priority
Gulf of Maine Cod (GOMcod) |X|X|X|X| Priority
US West Coast lingcod (USWCLingcod) | | | | | 
Icelandic herring (ICEherring) | |X| | | 
Southern New England-Mid-Atlantic yellowtail (SNEMAYT) | |X|X|X| 
Cape Cod-Gulf of Maine yellowtail (CCGOMYT) | |X|X|X| 
Georges Bank winter flounder | |X|X|X|
Plaice | |X|X| |
Georges Bank Haddock (GBhaddock) | |X|X|X| 
Gulf of Maine Haddock (GOMhaddock)  | |X|X|X| 
White Hake | |X|X|X|
Pollock | |X|X| |
US Atlantic Herring (USAtlHerring) | |X| | |
Mid-Atlantic Winter Flounder (SNEMAwinter) | |X| | |

Comparison of merits and issues for traditional SCAA and state-space
age-structured models. This could include different varieties of each class of
models.

Perhaps we can contribute:

* Recommended diagnostics for process error terms: plots, thresholds, etc.

***

Criteria | Comments
-------- | --------
Important for many stock assessment scientists?   | Yes
Standard papers that people cite for this topic?  | [Szuwalski et al. 2017: Reducing retrospective patterns](https://doi.org/10.1093/icesjms/fsx159), [Cadigan 2015](https://doi.org/10.1139/cjfas-2015-0047), [Nielsen and Berg 2014](https://doi.org/10.1016/j.fishres.2014.01.014), [Miller and Hyun In press](https://doi.org/10.1139/cjfas-2017-0035), [Miller and Legault 2017](https://doi.org/10.1016/j.fishres.2016.08.002)
Another working group already working on this?    | Not likely
How can this be structured into a journal paper?  | Part I: Apply various models to real data for stocks that have bad retrospective patterns. Stocks to tackle: SNE yellowtail flounder, GB yellowtail flounder, (US) Atlantic herring, Icelandic herring, North Sea cod (no retro, control), other European stocks TBD, New Zealand stock TBD. Also forecasting ability of different models for stock with and without retrospective patterns. Part II: Simulation study with different sources of model mis-specficiation and fit various models to these simulated data. The possible models to fit to real or simulated data are: SAM, Miller model, ASAP, SS3, VPA, a4a. Factors to consider in simulation study scenarios: Mis-specification of catch, q, M, precision of catch or indices. Quantify uncertainty in Mohn's rho?
What kind of work is required, and how much work? | Part II: Simulate data for each scenario using Miller and/or SAM state-space models.
Participants that would like to work on this?     | Tim Miller, Anders Nielsen, Arni  Magnusson, Casper Berg, Chris Legault, Cole Monahan, Craig Marsh, Jacob Kasper, Vanessa Trijoulet, Kelli Johnson, Jon Deroba, Niels Hintzen, Noel Cadigan, Ernesto Jardim, Dan Hennen, Olav Nikolai Breivik
Who would like to lead, what will coauthors do?   | Tim Miller


How will we want to correspond

Do we want to tackle items on this outline that Arni provided?

## Proposal Format

* Working Title: Do state-space assessment models consistently provide better retrospective patterns than others?
* Participants
  * Tim Miller, NEFSC
  * Jon Deroba, NEFSC
  * Vanessa Trijoulet, NEFSC
  * Chris Legault, NEFSC
  * Anders Nielsen DTU Aqua
  * Casper Berg DTU Aqua
  * Arni  Magnusson ICES
  * Kelli Johnson NWFSC
  * Cole Monnahan NWFSC/UW?
  * Craig Marsh NIWA
  * Jacob Kasper UConn
  * Niels Hintzen  ?
  * Noel Cadigan Memorial University
  * Ernesto Jardim JRC
  * Dan Hennen NEFSC
  * Olav Nikolai Breivik NCC
* Background
  * Area of research
  * Brief literature review
  * Remaining questions
  * Why is this important
* Objectives
* Plan
  * Part I: Real Data
    * Start with these stocks:
      * SNEMA yellowtail
      * North Sea cod
      * US West Coast lingcod (California stock; USWCLingcod)
      * Icelandic herring
    * In the end, we may focus on a few stocks that have a good story to tell.
    * Uploader of data can specify setting of original model for the specific stock.
    * No special cases for models such as catch scaling in SAM.
    * Table with stock by model and check marks or Mohn's rho to keep track of which have been.  F and SSB Mohn's rho.
    * Define the level of fiddling for each stock.
      * We should try to minimize the number of knobs to improve the retro for a given model
      * This would save time and make comparisons easier.
    * Define the diagnostics for each stock.
      * Survey and Catch Residuals (log(observed) - log(predicted))
        * remove 3 years of survey data, keep 3 years of catch data
        * root-mean square error of log-scale residuals
        * remove residuals where index (at age) = 0 
      * Get plot functions used in SAM
    * Define output (table)
      * Mohn's rho SSB, F (7 peels)
      * 3 year predictions (MSE) of survey observations. Fix catch. Remove surveys. Essentially one 3 year peel.
      * SSB (CIs)
      * Recruitment (CIs)
      * F-bar stock-specific (CIs)
      * Predicted Catch (CIs)
    * Self-test for each stock/model.
  * Part II: Simulations
    * Based on conclusions of Part I, evaluate hypotheses for differences generated in Part I.
    * Exotic features examples?
    * Estimate reference points? Decide later.
    * Define the sources of mis-specfication.
      * Multiplier of catch/missing catch
      * Changes in M
      * Changes in q
      * Changes gradual or abrupt?
    * Again, no fiddling would be wanted here.
* Methods, data
* Tasks, who's doing what
  * Data converters:
    * Tim writing converter from his state-space models to ASAP3
    * Liz writing converter from SAM to ASAP3 and VPA to ASAP3
    * Chris provided ASAP to ICES and VPA to ICES converters, Jon and Dan modified
  * Model fitting
    * Tim fitting his state-space models
    * Chris, Jon, Anders, Casper fitting ASAP3 and SAM models
    * Kelli fitting SS3 models
  * Others fitting
* Milestones, timeline
* References
  * [Miller and Hyun In press](https://doi.org/10.1139/cjfas-2017-0035)
  * [Szuwalski et al. 2017: Reducing retrospective patterns](https://doi.org/10.1093/icesjms/fsx159)
  * [Miller and Legault 2017](https://doi.org/10.1016/j.fishres.2016.08.002)
  * [Brooks and Legault 2016](https://doi.org/10.1139/cjfas-2015-0163)
  * [Cadigan 2015](https://doi.org/10.1139/cjfas-2015-0047)
  * [Hurtado-Ferro et al. 2015](https://doi.org/10.1093/icesjms/fsu198)
  * [Nielsen and Berg 2014](https://doi.org/10.1016/j.fishres.2014.01.014)
  * [Legault 2009](https://www.nefsc.noaa.gov/publications/crd/crd0901/)
* Appendix
  * Preliminary diagram, table, plots
  * [Mohn's rho for SSB](./plots_for_README/rho_comparison_ssb.png)
  * [Mohn's rho for Average F](./plots_for_README/rho_comparison_avgf.png)
  * [Mohn's rho for Recruitment](./plots_for_README/rho_comparison_rec.png)

Ages to average for F results

Stock | Ages
------| ----  
North Sea cod | 2-4
Gulf of Maine Cod | 5+ 
US West Coast lingcod | ? 
Icelandic herring | 5-10 
Southern New England-Mid-Atlantic yellowtail | 4-5
Cape Cod-Gulf of Maine yellowtail | 4-5
Georges Bank winter flounder | 4-6
Plaice | 6-9
Georges Bank Haddock | 5-7 
Gulf of Maine Haddock | 5-7
White Hake | 5-8
Pollock | 5-7

***

