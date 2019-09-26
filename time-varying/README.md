# Time-varying selectivity

Coordinator: Kelli Johnson

Criteria | Comments
-------- | --------
Important for many stock assessment scientists?   | 
Standard papers that people cite for this topic?  | 
Another working group already working on this?    | 
How can this be structured into a journal paper?  | 
What kind of work is required, and how much work? | 
Participants that would like to work on this?     | 
Who would like to lead, what will coauthors do?   | Kelli Johnson

***

### Working Title

Time-varying selectivity

### Participants

  * Kelli Johnson, NWFSC
  * Tim Miller, NEFSC
  * Chris Legault, NEFSC
  * Brian Stock, NEFSC
  * Claudio Castillo-Jordan, UW
  * Rick Methot, NWFSC

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
    * age-specific (time-invariant)
    * age-specific with time blocks
    * AR process on selectivity parameters in assessment
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

Phase 1: fit each model to each stock with 1) time-constant and 2) time-varying selectivity. For stocks in which time-varying selectivity makes a big difference (need to define), run models with selectivity time blocks.

Phase 2: fit models with time blocks on selectivity:

1. Time blocks used in production assessment (if done)
2. Time blocks based on management changes (ask experts)
3. Time blocks based on shifts in selectivity from runs with time-varying selectivity. TBD how to determine this...

    * in production model?
    * across models?
    * each model individually?

Define performance metrics

Output to save for each model run:

  * same as in state-space project
  * matrix of selectivity (age x time)

Future work

* Simulation study to look at simultaneously estimating time-varying M and time-varying selectivity?

##### Tasks, who's doing what

##### Milestones, timeline

### References

See CAPAM special issue

### Appendix

Preliminary diagram, table, plots

***

## After Seattle meeting

We will have a Skype call 1x/month to discuss progress and timeline

