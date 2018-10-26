## Faroe Plateau
Data Source | http://www.ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2017/NWWG/NWWG%202017%20Report.pdf
----------- | ------------------------------------------------------------------------------------------------------------------
ICES. 2017. Report of the North Western Working Group (NWWG). ICES CM 2017/ACOM:08. |

csv      | unit | table | info
-------- | ---- | ----- | --------------------------------------------
catage   | 000s | 4.2.6 | Catch in numbers at age
fatage   | yr-1 | 4.6.2 | Fishing mortality at age from the SAM model
maturity | prop | 4.2.8 | Proportion mature at age
natage   | 000s | 4.6.3 | Stock number at age from the SAM model
natmort  | yr-1 | ?     | ?
wcatch   | kg   | 4.2.7 | Stock weights are set equal to catch weights
wstock   | kg   | 4.2.7 | Stock weights are set equal to catch weights

## Georges Bank
Data Source | https://www.nefsc.noaa.gov/publications/crd/crd1311/crd1311.pdf
----------- | ---------------------------------------------------------------
NEFSC. 2013. 55th Northeast Regional Stock Assessment Workshop (55th SAW). NEFSC Ref Doc 13-11. |

csv     | unit | table | info
------- | ---- | ----- | --------------------------------------------------
fatage  | yr-1 | B23b  | Fishing mortality (F, unweighted, average ages 5+)
natage  | 000s | B23b  | Stock numbers
wcatch  | kg   | B12   | Catch mean weight at age
wstock  | kg   | B17a  | January 1 stock weights at age

## Gulf of Maine
Data Source | https://www.nefsc.noaa.gov/saw/sasi/uploads/GoM_cod_2017_update_supplemental_information_20170817.pdf
----------- | -----------------------------------------------------------------------------------------------------
NEFSC. 2017. Gulf of Maine Atlantic cod 2017 assessment update report supplemental information. Draft working paper. |

csv      | unit | table | info
-------- | ---- | ----- | ----------------------------------------------------------
catage   | 000s | 21     | Catch-at-age individuals converted to 000s
fatage   | yr-1 | 33     | Gulf of Maine Atlantic cod fishing mortality-at-age M=0.2
maturity | prop |        |
natage   | 000s | 35     | January 1 numbers-at-age M=0.2 model
natmort  | yr-1 |        |
wcatch   | kg   | 22     | Mean weights-at-age (kg) of the total catch
wstock   | kg   | 23     | January 1/spawning stock weights-at-age

## Gulf of Maine 2013
Data Source | https://www.nefsc.noaa.gov/publications/crd/crd1311/crd1311.pdf
----------- | ---------------------------------------------------------------
NEFSC. 2013. 55th Northeast Regional Stock Assessment Workshop (55th SAW). NEFSC Ref Doc 13-11. |

csv    | unit | table | info
------ | ---- | ----- | ---------------------------------------
fatage | yr-1 | A.87  | Fishing mortality-at-age
natage | 000s | A.88  | January 1 numbers-at-age
wcatch | kg   | A.49  | Total catch weights-at-age
wstock | kg   | A.50  | January 1 spawning stock weights-at-age

## Icelandic Cod
Data Source | http://www.ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2017/NWWG/NWWG%202017%20Report.pdf
----------- | ------------------------------------------------------------------------------------------------------------------
ICES. 2017. Report of the North Western Working Group (NWWG). ICES CM 2017/ACOM:08. |

csv      | unit | table    | info
-------- | ---- | -------- | -----------------------
catage   | 000s | p201     | converted from millions
fatage   | yr-1 | p216/7   |
maturity | prop | p207/8   |
natage   | 000s | p218/9/0 |
natmort  | yr-1 | ?        | ?
wcatch   | kg   | p203     |
wstock   | kg   | p205/6   |

## NAFO 2J3KL (Northern Cod)
Data Source | http://publications.gc.ca/collections/collection_2018/mpo-dfo/fs70-5/Fs70-5-2018-018-eng.pdf
----------- | --------------------------------------------------------------------------------------------
Brattey et al. 2018. Assessment of the Northern Cod (Gadus morhua) stock in NAFO Divisions 2J3KL in 2016. CSAS Res Doc 2018/018. |

csv      | unit | table  | info
-------- | ---- | ------ | ----------------------------------------------------------------------------------------------------
catage   | 000s | 10     | Catch numbers-at-age (000s)
fatage   | yr-1 | A2-5   | Northern cod F-at-age estimates from the M-shift
maturity | prop | 18     | Proportions mature for female cod from NAFO
natage   | 000s | A2-2   | Abundance-at-age estimates (millions) converted to 000s
natmort  | yr-1 | A2-6   | Northern cod M-at-age estimates from the M-shift
wcatch   | kg   | 11     | Mean annual weights-at-age calculated from lengths-at-age based on samples from commercial fisheries
wstock   | kg   | 15b    | Beginning of year weight-at-age estimates from a generalized Von Bertalanffy (VonB2)

## NAFO 3m ()
Data Source | http://www.repositorio.ieo.es/e-ieo/bitstream/handle/10508/9350/scr15-033.pdf?sequence=1&isAllowed=y
----------- | ------------------------------------------------------
González-Troncoso 2015. Assessment of the Cod Stock in NAFO Division 3M. Serial No. N6458. NAFO SCR |

csv      | unit | table  | info
-------- | ---- | ------ | ----------------------------------------------------------------------------------------------------
catage   | 000s | 2     | Catch-at-age (thousands).
maturity | prop | 7     | Maturity at age and age of first maturation (median values of ogives).
wcatch   | kg   |  3    | Weight-at-age (kg) in catch.
wstock   | kg   | 6     | BWeight-at-age (kg) in stock.  
fatage   |      | 9     | F at age (posterior median).
natage   | 000s |  10   | N at age (posterior median)
natmort  |      |  p6   | Prior over natural mortality, M:
## NAFO 3NO (Southern Grand Bank of Newfoundland)
under moratorium, data not extracted
Data Source | https://archive.nafo.int/open/sc/2015/scr15-034.pdf
----------- | ------------------------------------------------------

## NAFO 3Ps (St Pierre Bank Cod)
Data Source | http://waves-vagues.dfo-mpo.gc.ca/Library/40644777.pdf
----------- | ------------------------------------------------------
Rideout et al. 2017. Assessing the status of the cod (Gadus morhua) stock in NAFO Subdivision 3Ps in 2016. CSAS Res Doc 2017/063. |

csv      | unit | table  | info
-------- | ---- | ------ | ----------------------------------------------------------------------------------------------------
catage   | 000s | 6      | Numbers-at-age (000s) for the commercial cod fishery
maturity | prop | 18     | Proportions mature for female cod from NAFO
wcatch   | kg   | 7a     | Mean annual weights-at-age calculated from lengths-at-age based on samples from commercial fisheries
wstock   | kg   | 7b     | Beginning of the year weights-at-age calculated from commercial

## NE Arctic Cod
Data Source | http://www.ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2018/AFWG/00-AFWG%202018%20Report.pdf
----------- | ---------------------------------------------------------------------------------------------------------------------
ICES. 2018. Report of the Arctic Fisheries Working Group (AFWG). ICES CM 2018/ACOM:06. |

csv      | unit | table | info
-------- | ---- | ----- | -----------------------------------
catage   | kg   | 3.6   | Catch numbers-at-age
fatage   | yr-1 | 3.15  | Fishing mortality
maturity | prop | 3.11  | Proportion mature-at-age
natage   | 000s | 3.16  | Stock number-at-age
natmort  | yr-1 | 3.17  | Natural mortality used in final run
wcatch   | kg   | 3.8   | Catch weights at age
wstock   | kg   | 3.9   | Stock weights at age

## North Sea Cod
Data Source | https://community.ices.dk/ExpertGroups/WGNSSK/_layouts/15/start.aspx#/SitePages/HomePage.aspx
----------- | ---------------------------------------------------------------------------------------------
ICES. 2018. Provisional report of the Working Group on Assessment of Demersal Stocks in the North Sea and Skagerrak (WGNSSK). Draft report. |

csv      | unit | table | info
-------- | ---- | ----- | --------------------------------------------------------------------
catage   | 000s | 4.2c  | Catch numbers at age
fatage   | yr-1 | 4.8   | Estimated fishing mortality at age
maturity | prop | 4.5a  | Proportion mature by age
natage   | 000s | 4.9   | Numbers at age
natmort  | yr-1 | 4.5b  | Natural mortality by age
wcatch   | yr-1 | 4.3c  | Catch weights at age, also assumed to represent stock weights at age
wcatch   | yr-1 | 4.3c  | Catch weights at age, also assumed to represent stock weights at age

## Western Baltic
Data Source | http://www.ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2018/WGBFAS/01%20WGBFAS%20Report%202018.pdf
----------- | ---------------------------------------------------------------------------------------------------------------------------
ICES. 2018. Report of the Baltic Fisheries Assessment Working Group (WGBFAS). ICES CM 2018/ACOM:11. |

csv      | unit | table   | info
-------- | ---- | ------- | ---------------------------------
catage   | 000s | 2.3.14  | Catch at age
fatage   | yr-1 | 2.3.24  | Fishing mortality at age from SAM
maturity | prop | 2.3.19  | Mature at age
natage   | 000s | 2.3.23  | Stock numbers at age from SAM
natmort  | yr-1 | 2.3.20  | Natural mortality at age
wcatch   | kg   | 2.3.17  | Mean weight at age in catch
wstock   | kg   | 2.3.18  | Mean weight at age in stock
