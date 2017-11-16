# Proposal Format

### Working title
-To Be or Not To Be Complex (sucky, please suggest better options)

-Complexity models: Evaluating two/three case studies... 


### Participants

- alejandro.yanez@ifop.cl,
- deborah.hart@noaa.gov,
- geirs@math.uio.no,
- htakade-heumacher@edf.org,
- knutk@imr.no,
- liz.brooks@noaa.gov
- daniel.hennen@noaa.gov
- patrick.lynch@noaa.gov
- Brandon Chasco
- Jose.deoliveira@cefas.co.uk?

### Leader(s)

...

### Background

More complex models are coming into practice, and additional complexity is often suggested by some while others advocate 
for keeping things simple.  What is the appropriate level of complexity for a given set of data?  
We intend to simulate 2 case studies of “data rich” stocks and compare whether there are telltale diagnostics 
that enable the user to determine if their model requires additional complexity.  Furthermore, we want to evaluate whether 
information criteria (such as AIC and predictive cross validation) are reliable tools for model selection.
  
- how to explain the complex models to the public (words and pictures)

- if you have length and age, use one or both? pros/cons?

### Area of research

This group proposes to perform a simulation and evaluate diagnostics to address the question. 
Diagnostics to consider include residuals, whether there is support for model assumptions, parameter identifiability, ...

### Brief literature review

## Remaining questions

### Why is this important

### Objectives

### Plan

Simulate data corresponding to the profiles described below

Fit suite of stock assessment models 

Test performance of complex vs. simple configurations

Develop general advice 


### Methods, data

We propose two/three case studies:

1. Typical groundfish: possibly cod-like
- \~25 year life span (M\~0.2)
- Growth: protracted
- Maturity: protracted
2. Typical pelagic: herring-like (other options: anchovy?) 
- Life span <15? (M ~ 0.55) [anchovy: <5 years, with M ~ 0.8-0.9]
- Growth: more rapid   [anchovy: growth curve is shows ~ sine curve VonBert]
- Maturation: more rapid [fully mature at age 0.5-1.0]
3. An Invertebrate: Surfclam 
- 35 year life span (M~0.15)
- Growth - K/M faster than for fish
- Maturation - fully mature by 1 year 


### Tasks, who's doing what

The suite of data rich models to be applied, and working group members able to run them:
VPA -Liz, Helen?
SCAA (ASAP? a4a) -Liz, Helen? Ernesto
SS (SAM?) - Geir
CASA/SAMS -Dvora
CASAL - (Craig in group 1)
Gadget - (Arni Magnusson)
SS-(Dan)

### Milestones, timeline
### References

* Cotter et al (2004)
[Are stock assessment methods too complicated?]
(http://onlinelibrary.wiley.com/doi/10.1111/j.1467-2679.2004.00157.x/full)

* Wilberg and Bence (2008)
[Performance of deviance information criterion model selection in statistical catch-at-age analysis]
(http://www.sciencedirect.com/science/article/pii/S0165783608001343)

Discuss DIC as an alternative to AIC/BIC claiming it is better in taking into account random effects.


* Butterworth and Rademeyer (2008)
[Statistical catch-at-age analysis vs. ADAPT-VPA: the case of Gulf of Maine cod: Compare SCAA and VPA on ground fish (cod)](https://academic.oup.com/icesjms/article/65/9/1717/632337)

Do compare SCAA and VPA but mot state space models

* Butterworth and Rademeyer (2012)
[A comparison of initial statistical catch-at-age and catch-at- length assessments of eastern atlantic bluefin tuna](http://www.iccat.es/Documents/CVSP/CV069_2013/n_2/CV069020710.pdf)

* Anderson et al (2014)
[ss3sim: an R package for fisheries stock assessment simulation with Stock Synthesis](http://journals.plos.org/plosone/article/file?id=10.1371/journal.pone.0092725&type=printable)

* Kokkalis etal (2017)
[Estimating uncertainty of data limited stock assessments](https://academic.oup.com/icesjms/article/74/1/69/2669561)

* Deroba and Schueller (2013)
[Performance of stock assessments with misspecified age- and time varying natural mortality](http://www.sciencedirect.com/science/article/pii/S0165783613000830)

* Kuparinen et al (2012)
[Increasing biological realism of fisheries stock assessment: towards hierarchical Bayesian methods](http://www.nrcresearchpress.com/doi/abs/10.1139/a2012-006#.Wg1pF7aZNZ0)

* Book
Newman et al (2014): Modelling Population Dynamics 

### Appendix

### Preliminary diagram, table, plots

