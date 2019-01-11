# Skype meeting minutes

Second Thursday of every month

## 11 Oct 2018

Alejandro, Arni, Cecilia, Jacob, Paris

**Agenda**

1. Examine, summarize, and interpret the results so far
2. Review gaps in data, identify stocks that could be added
3. Status update on side stories
   (Lopt, Norwegian literature, historical changes)
4. Prepare a list of next tasks, decide who will report on what next meeting

**Action items**

To be presented at next meeting

[x] Take a closer look at which cod fisheries are active today. [Arni, Jacob]

[x] Add natural mortality in data folder. [Arni]

[x] Experiment with `applyFmax`. What is the potential yield of the Icelandic
    cod given the (1) current selectivity, (2) current selectivity shifted one
    age younger, and (3) current selectivity shifted one age higher?
    [Arni, Cecilia]

[x] Compare selectivity with maturity. [Paris]

## 10 Jan 2019

Arni, Cecilia, Jacob, Paris

**Agenda**

1. Overview of datasets, recently added stocks, summary plots
2. Profile results from `applyFmax` and `applyF0.1` across all stocks, shifting
   selectivity to younger/older fish, effects on catch and SSB
3. To summarize the results, focus on the effect of shifting one year up or down
4. Comparison of maturity and selectivity

**Action items**

New:

[ ] Tabulate the optimal age of capture, given the life history (growth, natural
    mortality) of each stock. [Alejandro, Arni, Cecilia, Jacob, Paris]

[ ] Create journal-quality plots of main results.
    [Alejandro, Arni, Cecilia, Jacob, Paris]

[ ] Draft the overall structure of the paper, subsections within intro, methods,
    results, and discussion. [Alejandro, Arni, Cecilia, Jacob, Paris]

[ ] Compare A50 calculations using linear interpolation vs. logistic
    interpolation. We can expect A50 to be a better descriptive statistic using
    the logistic, but let's compare just to make sure that things are working
    like we hope. [Arni, Paris]

From previous meetings:

[ ] Think about approaches other than applying Fmax or F0.1, e.g. applying
    Fcurrent but changing the selectivity. Given the F-at-age vector for the
    most recent year, how would the next year look if F at age 2 would decrease,
    for example? [Paris]

[ ] Look into egg production / fecundity aspects. Might be practical to use one
    conversion for Atlantic cod as a species, same for all stocks. [Jacob]

[ ] Look at long-term trends in weight at age. How is it different to plot by
    cohort or year? Are neighboring regions showing similar trends? Is there an
    overall trend across the Atlantic? [Alejandro, Arni, Cecilia, Paris]
