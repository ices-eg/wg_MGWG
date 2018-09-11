# ASAP 3 year projection test

This directory demonstrates one way to test the three year projections from ASAP. It uses Southern New England Mid-Atlantic yellowtail flounder (SNEMAYT) as an example. The directory is arranged so that the analyses can be repeated by others and applied to other stocks relatively easily. This is a work in progress, any feedback is welcomed (Chris.Legault@noaa.gov).

## Before you begin
The ASAP program can be downloaded from the NOAA Fisheries Toolbox (http://nft.nefsc.noaa.gov/). It is a statistical catch-at-age model with a nice graphical user interface (GUI). The selected stock is run in ASAP saving the rdat file. The naming conventions are assumed to follow a specific pattern in this analysis. The name of the full model run is denoted <asap.file.name> here. For this example, <asap.file.name> is SNEMAYT_ASAP. The <asap.file.name>.dat and <asap.file.name>.rdat files are copied into the data directory. The selected stock then has the most recent three years removed by changin the end year in the GUI. This run is named <asap.file.name>_DROP3 and is run in basic, retro (as <asap.file.name>_DROP3_RETRO) and in MCMC (as <asap.file.name>_DROP3_MCMC) modes. The following files are then copied into the data directory: <asap.file.name>_DROP3.rdat and <asap.file.name>_DROP3_MCMC.BSN. The ASAPplots R package (available at https://github.com/cmlegault/ASAPplots) is run on all three cases and the following files are copied into the data directory: Retro.rho.values_<asap.file.name>_DROP3_RETRO_000.csv, Freport.90pi_<asap.file.name>_DROP3_MCMC.csv, and ssb.90pi_<asap.file.name>_DROP3_MCMC.csv. This provides the all the necessary starting conditions for the analyses.

## Running the R code
The R code is set up to be able to be run by sourcing the highest number file. Remember to set the working directory to the source file location before beginning. There are a few user selections that have to be handled for each stock. Most importantly, in 1_check_data.r the user needs to define asap.file.name. In that same file, there is the ability to replace Mohn's rho for SSB with a vector of age-specific Mohn's rho values for the retrospective adjustment. In 2_get_recent_average_info.r the user needs to ensure that the average of the recent five years for M, selectivity, and weight at age is reasonable for the stock (the standard approach used in the Northeast US is a five year average). In that same file, the years used to create an empirical cdf for sampling to generate stochastic recruitment in the projection years is determined. For the SNEMAYT case, the poor recent recruitment was selected to continue. Other stocks may use all years of historical recruitment. Finally, in 3_project_three_years.r, the user needs to set the maximum F multiplier allowed when searching for the F to match the catch in the projection years. 

There are currently only two output graphics. The first shows the Mohn's rho plot for the stock with the point estimates of SSB and Freport surrounded by a box of the 90% confidence intervals from the MCMC. The rho-adjusted (= point estimate / (1 + Mohn's rho value)) SSB and F point is also shown. The standard approach in the Northeast US is to apply the Mohn's rho adjustment when the adjusted point is outside the box (meaning either the SSB or the Freport is outside the 90% CI). In the SNEMAYT case, the adjusted point is outside the 90%CI for both, so the rho-adjustment is applied.

## SNEMAYT example
The rho-adjusted SSB and Freport were both outside the 90% CI, as seen in the following plot where the rho-adjusted point is shown in red, so the rho-adjustment was applied to the starting population.  
<img src=".\\output\\Mohns.rho.plot.png" width="800">  

The distribution of predicted aggregate indices (black circles) are well above the observed index values (red circles) for all three years in both indices (the two panels).  
<img src=".\\output\\aggregate_index_plot.png" width="800">  

The index proportions at age are fit a bit better (index as columns, projection year as rows, black and red circles as in the plot above).  
<img src=".\\output\\index_proportions_at_age.png" width="800">  

## To do
There are still a number of items on the to do list. 
* ~~Include the predicted indices at age comparison.~~
* ~~Add option for adjusting starting population in projections by Mohn's rho at age.~~
* Add a number of checks to prevent crashing when data are missing.
* If program starts to take too long to run, figure out the matrix multiplication in projections.

