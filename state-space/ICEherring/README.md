# Icelandic herring 2017 assessment

Model:
* VPA (http://nft.nefsc.noaa.gov/VPA.html)

Data:
* Catch at age: 1987-2016
* Survey indices: 1987-2016

Notes:
* M is 0.1, except during a 2009-2011 Ichthyophonus infection
* Run model: `vpa2 run1nwwg.dat`
* Run retrospective: `vparetro run1nwwg.dat`

References:
* http://data.hafro.is/assmt/2017/herring/
* https://www.hafogvatn.is/en/harvesting-advice/herring
* http://dt.hafogvatn.is/astand/2017/30_sild.html

File | Content
---- | -------
convert.R | script to convert data VPA -> ICES format
RUN1NWWG.AUX |
RUN1NWWG.CV |
RUN1NWWG.DAT | catch, weight, M, maturity, survey
RUN1NWWG.LOG |
RUN1NWWG.OUT | catch, weight, M, maturity, survey, N, F, Fbar, B, SSB
RUN1NWWG.PP2 |
RUN1NWWG.RDAT | R object, `x <- dget("RUN1NWWG.RDAT")`
RUN1NWWG.RSD |
