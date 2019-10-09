This code was used to modify the 2018 ASAP runs to produce a new set of runs in 2019.  
The 2018 ASAP runs used a single time block and logistic selectivity for the fishery and all indices.  
The 2018 ASAP runs are located in folders named "ASAP".  
The 2019 ASAP runs used three time blocks with double logistic selectivity for the fishery, but all indices remained single logistic with a single time block.  
The three time blocks are set such that the third block is the final 10 years, the second block is the previous 10 years, and the first block is the remaining years.  
These blocks were applied to all stocks without regard for management actions or residual patterns.  
They are just a demonstration of what happens when both time blocks and the possibility of doming are included in the fishery selectivity.  
The 2019 ASAP runs are located in folders named "ASAP_dome_block_sel".  


The ASAP runs are done remotely and not saved on the GitHub site to prevent overloading the site.  
The order of the R code runs is:  
\- convert2018to2019.R - makes the three time blocks and uses double logistic selectivity  
\- run2019.R - does three sets of ASAP runs, a base run, a retrospective run, and a run with the final 3 years of indices removed (takes a while to run)  
\- gather2019.R - compiles the Mohn's rho values, time series of F, SSB, and R, and model predictions of missing indices for all stocks  


Note that for two stocks (GOMhaddock and SNEMAwinter) the fourth peel produced wildly different estimates of SSB that were orders or magnitude larger than any of the other peels. This caused the Mohn's rho estimates for SSB to be in the thousands for these two stocks. These two peels were removed from the Mohn's rho calculations, resulting in large but reasonable values for both stocks.  

  
During development of gather2019.R code, an error was found in how tab2.csv was calculated in 2018. This error was fixed in  
\- redo2018tab2.R - calculates tab2.csv values correctly for the ASAP runs  
  
