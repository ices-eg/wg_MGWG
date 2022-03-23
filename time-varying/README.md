# Time-varying selectivity

Coordinators: Kelli Johnson, Brian Stock

***

### Working Title

Comparison of approaches to estimate time-varying selectivity

### Participants

  * Kelli Johnson, NWFSC
  * Tim Miller, NEFSC
  * Chris Legault, NEFSC
  * Brian Stock, NEFSC
  * Claudio Castillo-Jordan, UW
  * Rick Methot, NWFSC
  * Daniel Howell, IMR
  * Mark Muander, IATTC

### Background

Many factors can cause selectivity to change over time (e.g. changes in regulations, growth, and spatial distributions of stocks or fishing effort), and assessment frameworks provide scientists with a range of options to allow for time-varying selectivity. Not allowing modelled selectivity to change when changes have occurred in reality can result in biased estimates of key parameters. Including too much flexibility to estimate time-varying selectivity, however, can also come at a cost. Guidance on when and how to allow for time-varying selectivity is needed and should be based on expected effects on assessment output (accuracy and precision of reference points, catch advice)

##### Objectives

  1. For the assessments that include selectivity time blocks, does a more flexible method reduce retrospective or residual patterns (which would indicate including selectivity blocks)?
  2. Does the more flexible method recreate selectivity time blocks that were included in the assessments or correspond to known fishing behavior changes?
  3. Quantify the tradeoffs in catch advice vs. model fit. Possible that fitting the data better does not result in better management (e.g. could increase uncertainty of forecasts).

### Plan

##### Methods

Selectivity options are model-dependent:

  * SS
    * age-specific (time-invariant)
    * age-specific with time blocks
    * exponential logistic with 2D AR
  * WHAM
    * logistic time-invariant
    * logistic IID (RE on sel pars, no correlation)
    * logistic AR1 (correlation across ages/parameters)
    * logistic AR1_y (correlation across years)
    * logistic 2D AR1 (correlation across ages/pars and years)
    * age-specific time-invariant
    * age-specific IID (RE on sel pars, no correlation)
    * age-specific AR1 (correlation across ages/parameters)
    * age-specific AR1_y (correlation across years)
    * age-specific 2D AR1 (correlation across ages/pars and years)    
  * SAM
    * age-specific (time-invariant)
    * 2D RW on F(a,y)
  * a4a

This project will leverage work from the state-space project. We will use the same 13 stocks (data already compiled):

  * North Sea cod (Nscod)
  * Gulf of Maine Cod (GOMcod)
  * Georges Bank Haddock (GBhaddock)
  * Gulf of Maine Haddock (GOMhaddock)
  * US Pollock
  * Southern New England-Mid-Atlantic yellowtail (SNEMAYT)
  * Cape Cod-Gulf of Maine yellowtail (CCGOMYT)
  * Georges Bank winter flounder
  * Southern New England-Mid-Atlantic winter flounder (SNEMAwinter)
  * American Plaice
  * White Hake
  * Icelandic herring (ICEherring)
  * US Atlantic Herring (USAtlHerring)

##### Phase 1

Fit each model to each stock with 1) time-constant (no blocks) and 2) time-varying selectivity. For which stocks does time-varying selectivity make a big difference (need to define)? Does time-varying selectivity seem to approximate time blocks (with constant selectivity in each block)? 

Stock | SS | WHAM | Comments
------| ---- | --- | ---
North Sea cod (Nscod) ||X|
Gulf of Maine Cod (GOMcod) |||
Georges Bank Haddock (GBhaddock) |||
Gulf of Maine Haddock (GOMhaddock) |||
US Pollock |||
Southern New England-Mid-Atlantic yellowtail (SNEMAYT) ||X|
Cape Cod-Gulf of Maine yellowtail (CCGOMYT) |||
Georges Bank winter flounder |||
Southern New England-Mid-Atlantic winter flounder (SNEMAwinter) |||
American Plaice |||
White Hake |||
Icelandic herring (ICEherring) |||
US Atlantic Herring (USAtlHerring) |||

##### Phase 2

Fit models with time blocks on selectivity:

1. Time blocks used in production assessment (if done)
2. Time blocks based on management changes (ask experts)
3. Time blocks based on shifts in selectivity from runs with time-varying selectivity. TBD how to determine this...

    * in production model?
    * across models?
    * each model individually?

Define performance metrics

Output to save for each model run:

  * same as in state-space project
    * Mohn's rho: Rec, SSB, Fbar (7 peels)
    * Survey residuals: log(observed) - log(predicted), project 3 years w/o survey observations but w/ catch
    * SSB (95% CI)
    * Recruitment (95% CI)
    * Fbar (95% CI)
    * Predicted Catch (95% CI)
  * matrix of selectivity (age x time)

Future work

* Simulation study to look at simultaneously estimating time-varying M and time-varying selectivity?

##### Task list

Task | Who | By when
---- | --- | -------
Contact SAM and a4a about involvement | Kelli | Nov 20 - [ ]
SS fits (phase 1) | Kelli | Nov 20 - [ ]
WHAM forecasts + time-varying sel | Brian | Nov 20 - [ ]
WHAM fits (phase 1) | Brian  | Nov 20 - [ ]
Literature review | Claudio/?  | Nov 20 - [ ]
-------- | --------
Decide how to handle blocks | group | Nov 20 - [ ]
SS fits (phase 2) | Kelli | Jan 15 - [ ]
WHAM fits (phase 2) | Tim | Jan 15 - [ ]
SAM fits (phase 2) | ? | Jan 15 - [ ]
a4a fits (phase 2) | ? | Jan 15 - [ ]
-------- | --------
Outline paper | group | Nov 20 - [ ]
ICES abstract | ? | early March - []

### References

See CAPAM special issue

### Appendix

Preliminary diagram, table, plots

***

## After Seattle meeting

We will have a Skype call 3rd Wed each month to discuss progress and timeline:

Date | To discuss
-------- | --------
Dec 18 7am PST / 10am EST / 4pm Eu | Phase 1 results, how to handle blocks
Jan 15 7am PST / 10am EST / 4pm Eu | Phase 2 results (blocks), outline paper

