---
title: 
author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
date: 2019-05-17 15:13
documentclass: article
output:
  pdf_document:
    fig_caption: yes
    number_sections: yes
    toc: yes
tags:
abstract:
license: Creative Commons Attribution-ShareAlike 4.0 International Public License
---


> names(asap.out.est)
[1] "SRtable"    "fn.fit"     "SR.cor.mat" "sr.param"   "sr0"        "MSY.est"    "Estim"      "model"     


the objects are defined as:
SRtable - a flat file with format specified by iago
fn.fit - character to identify whether Ricker or BH was fit
SR.cor.mat - correlation matrix between R and SSB
sr.param - steepness and SSB0 (this could easily be converted to R0 using sr0); NA if no S-R was estimated
sr0 - unexploited spawners per recruit
MSY.est - estimates of MSY quantities; NA if no S-R was estimated


