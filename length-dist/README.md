# Working title
Can length distributions complement stock status reference points?

Coordinators: Christoph Konrad and Maite Pons

## Participants

Arni Magnusson (ICES),
Cecilia Pinto (JRC),
Christoph Konrad (JRC),
Cole Monnahan (UW),
Daniel Howell (IMR),
Dvora Hart (NOAA),
Ernesto Jardim (JRC),
Jacob Kasper (UConn),
Lee Qi (UW),
Maite Pons (UW),
Rick Methot (NOAA).


## Background

[Area of research]
Extending diagnostics for stock health.

[Brief literature review]

WKSHARK4 ([ICES 2018a](https://ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2018/WKSHARK4/WKSHARK4_Report2018.pdf)) reviewed the use of length-based indicators to infer stock status and provide management advice.

The ICES ([2018b](https://ices.dk/sites/pub/Publication%20Reports/Guidelines%20and%20Policies/16.04.03.02_Category_3-4_Reference_Points.pdf)) technical guidelines cover the use of (1) length-based indicators [LBI], (2) mean length Z [MLZ], and (3) length-based spawner per recruit [LBSPR] to calculate reference points for data-limited stocks, with instructions for stock assessors.

[Miethe et al. (2019)](https://doi.org/10.1093/icesjms/fsz158) focus on Lmax5%, the mean length of the largest 5% of individuals in the catch.

[Chrysafi and Kuparinen 2016](https://doi.org/10.1139/er-2015-0044) review length-based indicators to define stock status.

[Froese et al. 2018](https://doi.org/10.1093/icesjms/fsy078) present a new approach for estimating stock status from length frequency data.

[Gaps in the literature]

[Why is this important]
Policy demands EU side
 Maritime Strategy Framework Directive
 Common Fisheries Policy
Length based reference points are often preferred in data poor situations.
The aim is to extend the ecological theory of trunctated size structure to diagnostics for stock status. The LD based reference points/diagnostics are expected to complement exisiting reference points/diagnostics to capture length structure such as large fish, mega-spawners etc
Avoidance of loss of yield due to fishing trunkated stocks.


## Objective
definition of healthy length distribution
reference points that can be applied

## Methods
The ICES_MSY package (https://github.com/ices-tools-dev/ICES_MSY) has some length-based indicator code that might be relevant: LBindicators.R, LBI.R, LBSPR.R, mean-length_Z.R. These look like scripts (not functions) and are not currently maintained. The package [README.md](https://github.com/ices-tools-dev/ICES_MSY/blob/master/README.md) looks well organized and informative.

## Plan
Perspective paper
  What is a healthy length distribution?
       Model output LD (length distribution):
            Tracking LDs of several stocks from around the globe:
                        Pac Halibut, NEA Cod, George's Bank haddock
                        NWWG, AFWG, Northern Hake, Southern Hake,
                        Tuna, WGNSSK, Orange Roughy 
                        (all pending data availability)


  Simulate/Demonstrate the problem of Ref points.
      2 stocks same Bmsy and Fmsy but different LD. I.E. different selectivity, introduce nat mort events. Check if one is more resilient/resistent. 
      Cole + Maite: SS3 simulation based on Yelloweye Rockfish
      Dvora: population at equilibrium approach


                
Diagnostic Development
  Depending on Perspective paper's results
  Can we use input data rather than model output

  Quantiles, Number of MegaSpawner, proportion above a given length                    maturity at length/ fecundity at length ~ absolute numbers/relative            ranges of length/ quantile.
  Virgin/Equilibrium vs current status
  B@length vs N@length

Reference Points
  Global-, species-, stock-, sub-stock-specific?
            
Future issues
  length distrbutions ~ measure of health
  the role of growth (model) 
  Maturity, fecundity
  Speak to Fisheries Induced Evolution people?
  age vs length

* Data
  LD of many Stocks, preferably with crash/rebuild dynamics and long time series 


## Tasks
#Simulations:

Cole with SS3sim, try to get 2 populations with same MSY ref points but different length distributions.

Dvora: theoretical length distributions vs realized/observed

Christoph: simulations with a4a (2 sims)

Maite: simulations with SS (not ss3Sim)

#Get data sets: all

Lee Qi: ask Cody about Invertebrates

Fin-fish:

Christoph: contact NWWG 

Daniel: North Sea, Norwegian and arctic fish stock as applicable

Maite+Lee Qi +Cole: west pacific stocks

Maite: tunas

#Literature review:

-          existing metrics

-          correlation of those metrics with F and B

#Other
Length-based metrics in data-limited world

Maybe create a google doc folder with references and data and results

Next Skype meeting: November 4th 1700 CET
* Milestones, timeline
  Skype meetings
  Perspective Manuscript Q3
  Rest TBC
  
## References

* Berkeley et al. 2004, Fisheries Sustainability via Protection of Age Structure and Spatial Distribution of Fish Populations, Fisheries, 29:8, 23-32, https://doi.org/10.1577/1548-8446(2004)29[23:FSVPOA]2.0.CO;2 
* Brunel & Piet 2013, Is age structure a relevant criterion for the health of fish stocks? ICES Journal of Marine Science 70(2):270–283, https://doi.org/10.1093/icesjms/fss184
* Chrysafi and Kuparinen 2016, Assessing abundance of populations with limited data: Lessons learned from data-poor fisheries stock assessment, Environmental Reviews 24:25-38, https://doi.org/10.1139/er-2015-0044
* Cope & Punt 2009, Length-Based Reference Points for Data-Limited Situations: Applications and Restrictions. Marine and Coastal Fisheries: Dynamics, Management, and Ecosystem Science, 1(1):169-186, https://doi.org/10.1577/C08-025.1
* Froese, R. 2004, Keep it simple: three indicators to deal with overfishing. Fish and Fisheries 5:86-91.  https://doi.org/10.1111/j.1467-2979.2004.00144.x
* Froese et al. 2018, A new approach for estimating stock status from length frequency data, https://doi.org/10.1093/icesjms/fsy078
* Froese, R. et al. 2016, Minimizing the impact of fishing. Fish and Fisheries, 17:785-802. https://doi.org/10.1111/faf.12146
* Garcia et al. 2016, Balanced harvesting in fisheries: a preliminary analysis of management implications. ICES Journal of Marine Science, 73(6):1668–1678, https://doi.org/10.1093/icesjms/fsv156
* Hordyk et al. 2015, A novel length-based empirical estimation method of spawning potential ratio (SPR), and tests of its performance, for small-scale, data-poor fisheries. ICES Journal of Marine Science 72(1):217–231, https://doi.org/10.1093/icesjms/fsu004
* International Council for the Exploration of the Sea (ICES), 2018a, Report of the Workshop on Length-Based Indicators and Reference Points for Elasmobranchs (WKSHARK4), ICES CM 2018/ACOM:37, https://ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2018/WKSHARK4/WKSHARK4_Report2018.pdf
* International Council for the Exploration of the Sea (ICES), 2018b, ICES reference points for stocks in categories 3 and 4, In: ICES Technical Guidelines, https://ices.dk/sites/pub/Publication%20Reports/Guidelines%20and%20Policies/16.04.03.02_Category_3-4_Reference_Points.pdf
* Jardim et al. 2015, Harvest control rules for data limited stocks using length-based reference points and survey biomass indices. Fisheries Research 171:12-19, https://doi.org/10.1016/j.fishres.2014.11.013
* Kvamme & Bogstad 2007, The effect of including length structure in yield-per-recruit estimates for northeast Arctic cod. ICES Journal of Marine Science 64(2):357–368, https://doi.org/10.1093/icesjms/fsl027
* Lewis et al. 2017, Old-Growth Fishes Become Scarce under Fishing. Current Biology 27(18):2843-2848, https://doi.org/10.1016/j.cub.2017.07.069
* Miethe et al. 2019, Reference points for the length-based indicator Lmax5% for use in the assessment of data-limited stocks, ICES Journal of Marine Science fsz158, https://doi.org/10.1093/icesjms/fsz158
* Murua et al. 2017, Fast versus slow growing tuna species: age, growth,and implications for population dynamics and fisheries management. Rev Fish Biol Fisheries 27:733, https://doi.org/10.1007/s11160-017-9474-1
* Rudd & Thorson 2018, Accounting for variable recruitment and fishing mortality in length-based stock assessments for data-limited fisheries. Canadian Journal of Fisheries and Aquatic Sciences, 75(7):1019-1035, https://doi.org/10.1139/cjfas-2017-0143
* Secor et al. 2015, Depressed resilience of bluefin tuna in the western atlantic and age truncation. Conservation Biology, 29: 400-408, https://doi.org/10.1111/cobi.12392
* Tu et al 2018, Fishing and temperature effects on the size structure of exploited fish stocks. Scientific Reports 8:7132  https://doi.org/10.1038/s41598-018-25403-x
* Vasilakopoulos & Maravelias 2016, Application of data‐limited assessment methods on black anglerfish (Lophius budegassa; Spinola, 1807) stocks in the Mediterranean Sea. J. Appl. Ichthyol., 32: 277-287. doi:10.1111/jai.12968
* Vasilakopoulos et al. 2014, The Alarming Decline of Mediterranean Fish Stocks, Current Biology. 24(14):1643-1648, https://doi.org/10.1016/j.cub.2014.05.070.
* Vasilakopoulos et al. 2016, The unfulfilled potential of fisheries selectivity to promote sustainability. Fish & Fisheries, 17:399-416.  https://doi.org/10.1111/faf.12117
* Wolfgang et al. 2016, A proposal for restructuring Descriptor 3 of the Marine Strategy Framework Directive (MSFD). Marine Policy 74:128-135, https://doi.org/10.1016/j.marpol.2016.09.026.
* Zimmermann et al. 2011, Does size matter? A bioeconomic perspective on optimal harvesting when price is size-dependent. Canadian Journal of Fisheries and Aquatic Sciences, 68(9):1651-1659, https://doi.org/10.1139/f2011-093


## Appendix

* Preliminary diagram, table, plots
