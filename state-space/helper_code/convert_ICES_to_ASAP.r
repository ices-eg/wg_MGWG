# Code to take ICES format and convert to ASAP
#   for ICES-WGMG projects
# assumptions for call to setup.asap begin ~line 742
# Liz Brooks
# Version 1.0
# also uses : SAM read.ices fn modified by Dan Hennen (starting line 422)
##


#rm(list=ls(all.names=F))
#graphics.off()


#==============================================================
## User specify below

#-------------------
#user.wd <- ""   #user: specify path to working directory where ICES files are
#user.od <- ""   #user: specify path to output directory
#model.id <- "CCGOMyt_"   # user: specify prefix found on ICES files (will create same name for ASAP case)
#-------------------
#user.wd <- "C:/liz/SAM/GBhaddock/"  # user: specify path to working directory where ICES files are
#user.od <- "C:/liz/SAM/GBhaddock/"  # user: specify path to output directory
#model.id <- "GBhaddock_"  # user: specify prefix found on ICES files (will create same name for ASAP case)
#-------------------
#user.wd <- "C:/liz/SAM/GBwinter/"  # user: specify path to working directory where ICES files are
#user.od <- "C:/liz/SAM/GBwinter/"  # user: specify path to output directory
#model.id <- "GBwinter_"  # user: specify prefix found on ICES files (will create same name for ASAP case)
#-------------------
#user.wd <- "C:/liz/SAM/Plaice/"  # user: specify path to working directory where ICES files are
#user.od <- "C:/liz/SAM/Plaice/"  # user: specify path to output directory
#model.id <- "Plaice_"  # user: specify prefix found on ICES files (will create same name for ASAP case)
#-------------------
#user.wd <- "C:/liz/SAM/NScod/"  # user: specify path to working directory where ICES files are
#user.od <- "C:/liz/SAM/NScod/"  # user: specify path to output directory
#model.id <- "ICEHerr_"  # user: specify prefix found on ICES files (will create same name for ASAP case)
   ## *** Notes: had to append "NScod_" to all ICES filenames
#-------------------
#user.wd <- "C:/liz/SAM/ICEherring/"  # user: specify path to working directory where ICES files are
#user.od <- "C:/liz/SAM/ICEherring/"  # user: specify path to output directory
#model.id <- "ICEherring_"  # user: specify prefix found on ICES files (will create same name for ASAP case)
 # *** Notes: only VPA files available now; need to convert to ICES format before running this
#-------------------

## End user specification
#==============================================================



#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
# Function to set-up asap3 "west coast style"
# Liz Brooks
# Version 1.0
# Created 30 September 2010
# Last Modified: 18 September 2013
#                16 November 2017 for ices-wgmg
#                21 November 2017: tested & works on CCGOMyt, GBhaddock, GBwinter, Plaice, NScod
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------


"setup.asap.w" <-function(wd, od, model.id, nyears, first.year, asap.nages, nfleets,
        nselblks, n.ind.avail, M.mat, fec.opt, t.spawn, mat.mat, n.waa.mats, waa.array, waa.pointer.vec,
        sel.blks, sel.types, sel.mats, fleet.age1, fleet.age2, F.report.ages, F.report.opt,
        like.const, rel.mort.fleet, caa.mats, daa.mats, rel.prop, units.ind, time.ind,
        fish.ind, sel.ind, ind.age1, ind.age2, ind.use, ind.sel.mats, ind.mat, ind.cv, ind.neff,
        p.Fmult1, p.Fmult.dev, p.recr.dev, p.N1, p.q1, p.q.dev, p.SR, p.h, recr.CV, lam.ind,
        lam.c.wt, lam.disc, catch.CV, disc.CV, Neff.catch, Neff.disc, lam.Fmult.y1,
        CV.Fmult.y1, lam.Fmult.dev, CV.Fmult.dev, lam.N1.dev, CV.N1.dev, lam.recr.dev,
        lam.q.y1, CV.q.y1, lam.q.dev, CV.q.dev, lam.h, CV.h, lam.SSB0, CV.SSB0,
        naa.y1, Fmult.y1, q.y1, SSB0, h.guess, F.max, ignore.guess,
        do.proj, fleet.dir, proj.yr, proj.specs,
        do.mcmc, mcmc.nyr.opt, mcmc.nboot, mcmc.thin, mcmc.seed,
        recr.agepro, recr.start.yr, recr.end.yr, test.val,
        fleet.names, survey.names, disc.flag, catch.ages, survey.ages )    {



#####   Define function variables
  # wd         working directory path (where files are read from)
  # od         output directory path (where files are written)
  # model.id    model identifier
  # nyears      total number of years of data
  # first.year   first year of data
  # nages       number of age classes (age 1 is first age class by default)
  # nfleets      number of fishing fleets
  # nselblks     total number of selectivity blocks (sum for all fleets)
  # n.ind.avail   number of available indices (whether or you "turn them on" to be used)
  # M.mat         matrix of natural mortality by age (col) and year (row)
  # fec.opt      0(use WAA*mat.age)  or 1 (use empirical fecundity at age values)
  # t.spawn      fraction of year elapsed prior to ssb calcs
  # mat.mat       maturity matrix by age (col) and year (row)
  # c.waa         catch weight at age (col) and year (row)
  # ssb.waa       ssb weight at age (col) and year (row)
  # jan1.waa      jan-1 weight at age (col) and year (row)
  # sel.blks    a vertical vector of nselblks*nyears
  # sel.types   vector of length nselblks (1=by age; 2= logistic; 3= double logistic)
  # sel.mats    nselblks X matrix(sel.specs, nrow= nages+6, ncol=4)
  # fleet.age1   starting age for selectivity by fleet
  # fleet.age2    ending age for selectivity by fleet
  # F.report.ages  vector of 2 ages for summarizing F trend
  # F.report.opt  option to report F as unweighted(1), Nweighted(2), Bweighted(3)
  # like.const    flag to use(1) or not(0) likelihood constants
  # rel.mort.fleet  flag for whether there is release mortality by fleet (nfleets entries)
  # caa.mats      nfleets X cbind(matrix(caa, nyears,nages), tot.cat.biomass)
  # daa.mats      nfleets X cbind(matrix(disc.aa, nyears, nages), tot.disc.biomass)
  # rel.prop      nfleets X matrix(release.prop.aa, nyears, nages)
  # units.ind     n.ind.avail vector for units (1=biomass, 2=number)
  # time.ind      n.ind.avail vector for month index sampled
  # fish.ind      link to fleet (-1 if no link, fleet.number otherwise)
  # sel.ind       functional form for indices (n.ind.avail)
  # ind.age1      first age each index selects (n.ind.avail)
  # ind.age2      last age each index selects (n.ind.avail)
  # ind.use       flag to use(1) or not(0) each index
  # ind.sel.mats  n.ind.avail X matrix(sel.specs, nrow= nages+6, ncol=4)
  #     the 6 additional are: Units, month, sel.link.to.fleet, sel.start.age, sel.end.age, use.ind
  # ind.mat       n.ind.avail X matrix(index.stuff, nyears, ncol=nages+4)
  # ***** ICES one-offs (calls function get.index.mat)
  # ind.cv        one-off for ICES (CV assumed for all indices, all years)
  # ind.neff      one-off for ICES (Effectice Number assumed for all indices, all years)
  # *****  end ICES one-offs
  # p.Fmult1      phase for estimating F mult in 1st year
  # p.Fmult.dev   phase for estimating devs for Fmult
  # p.recr.dev    phase for estimating recruitment deviations
  # p.N1          phase for estimating N in 1st year
  # p.q1          phase for estimating q in 1st year
  # p.q.dev       phase for estimating q deviations
  # p.SR          phase for estimating SR relationship
  # p.h           phase for estimating steepness
  # recr.CV       vertical vector of CV on recruitment per year
  # lam.ind    lambda for each index
  # lam.c.wt      lambda for total catch in weight by fleet
  # lam.disc      lambda for total discards at age by fleet
  # catch.CV      matrix(CV.fleet, nyears, nfleets)
  # disc.CV       matrix(CV.fleet, nyears, nfleets)
  # Neff.catch    input effective sample size for CAA (matrix(Neff, nyears, nfleets)
  # Neff.disc     input effective sample size for disc.AA (matrix(Neff, nyears, nfleets)
  # lam.Fmult.y1  lambda for Fmult in first year by fleet (nfleets)
  # CV.Fmult.y1   CV for Fmult in first year by fleet (nfleets)
  # lam.Fmult.dev  lambda for Fmult devs by fleet (nfleets)
  # CV.Fmult.dev  CV for Fmult deviations by fleet (nfleets)
  # lam.N1.dev     lambda for N in 1st year devs
  # CV.N1.dev     CV for N in 1st year devs
  # lam.recr.dev  lambda for recruitment devs
  # lam.q.y1      lambda for q in 1st yr by index (n.ind.avail)
  # CV.q.y1       CV for q in 1st yr by index (n.ind.avail)
  # lam.q.dev      lambda for q devs (n.ind.avail)
  # CV.q.dev       CV for q devs (n.ind.avail)
  # lam.h          lambda for deviation from initial steepness
  # CV.h           CV for deviation from initial steepness
  # lam.SSB0       lambda for deviation from SSB0
  # CV.SSB0        CV for deviation from SSB0
  # naa.y1          vector(nages) of initial stock size
  # Fmult.y1       initial guess for Fmult in yr1 (nfleets)
  # q.y1           q in 1st year vector(n.ind.avail)
  # SSB0           initial unexploited stock size
  # h.guess        guess for initial steepness
  # F.max          upper bound on Fmult
  # ignore.guess   flag to ignore(1) or not(0) initial guesses
  # do.proj        flag to do(1) or not(0) projections
  # fleet.dir      rep(1,nfleets)
  # proj.yr        (nyears+2)
  # proj.specs     matrix(proj.dummy, nrow=2, ncol=5)
  # do.mcmc        0(no) or 1(yes)
  # mcmc.nyr.opt   0(use.NAA.last.yr), 1(use.NAA.T+1)
  # mcmc.nboot     number of mcmc iterations
  # mcmc.thin      thinning rate for mcmc
  # mcmc.seed      random number seed for mcmc routine
  # recr.agepro     0(use NAA), 1 (use S-R), 2(use geometric mean of previous years)
  # recr.start.yr  starting year for calculation of R
  # recr.end.yr    ending year for calculation of R
  # test.val       -23456
  # disc.flag       T if discards present, F otherwise




#---------------------------------------------------------------------
####   SET-UP ASAP FILE

#_________________________________________________________________

out.file = paste(od,"ASAP_", model.id, ".dat", sep="")
write('# ASAP VERSION 3.0 setup by convert_ICES_asap.r', file=out.file, append=F)
write(paste('# MODEL ID ', model.id, sep=''),file=out.file,append=T)
write( '# Number of Years' , file=out.file,append=T)
write(nyears, file=out.file,append=T )
write('# First year', file=out.file,append=T)  #proportion F before spawning
write(first.year, file=out.file,append=T )  #proportion M before spawning
write('# Number of ages', file=out.file,append=T)  #single value for M
write(asap.nages, file=out.file,append=T )  #last year of selectivity
write('# Number of fleets', file=out.file,append=T)     #last year of maturity
write(nfleets, file=out.file,append=T )  #last year of catch WAA
write('# Number of selectivity blocks', file=out.file,append=T)    #last year of stock biomass
write(nselblks, file=out.file,append=T )  #number of F grid values
write('# Number of available indices', file=out.file,append=T)  #
write(n.ind.avail, file=out.file,append=T )  #specifies BH or Ricker
write( '# M matrix' , file=out.file,append=T)   #, ncol=(nyears))
write(t(M.mat), file=out.file,append=T, ncol=asap.nages)
write('# Fecundity option', file=out.file,append=T)  #specifies normal or lognormal error
write(fec.opt, file=out.file,append=T)  #
write('# Fraction of year elapsed before SSB calculation', file=out.file,append=T)  #
write(t.spawn , file=out.file,append=T)  #
write( '# MATURITY matrix' , file=out.file,append=T)   #, ncol=(nyears))
write(t(mat.mat), file=out.file,append=T, ncol=asap.nages)
write( '# Number of WAA matrices' , file=out.file,append=T)   #, ncol=(nyears))
write(n.waa.mats, file=out.file,append=T, ncol=asap.nages)
write( '# WAA matrix-1' , file=out.file,append=T)   #, ncol=(nyears))
write(t(waa.array[,,1]), file=out.file,append=T, ncol=asap.nages)
if (n.waa.mats>1)  {
    for (j in 2:n.waa.mats)  {
    write(paste('# WAA matrix-',j, sep=""), file=out.file,append=T, ncol=asap.nages)
    write(t(waa.array[,,j]), file=out.file,append=T, ncol=asap.nages)

    } # end loop over j (for WAA matrices)
}  # end if-test for n.waa.mat
#write('# test', file=out.file,append=T)
write( '# WEIGHT AT AGE POINTERS' , file=out.file,append=T)   #, ncol=(nyears))
write(waa.pointer.vec, file=out.file,append=T, ncol=1)
write( '# Selectivity blocks (blocks within years)' , file=out.file,append=T)   #, ncol=(nyears))
for(i in 1:nfleets) 
{
  write(paste0('# Fleet ', i, ' Selectivity Block Assignment') , file=out.file,append=T)   #, ncol=(nyears))
  write(sel.blks[(i-1)*nyears + 1:nyears], file=out.file,append=T, ncol=1)
}
write( '# Selectivity options for each block' , file=out.file,append=T)   #, ncol=(nyears))
write(t(sel.types), file=out.file,append=T, ncol=nselblks)
temp = t(sel.mats)
temp = sel.mats
x = asap.nages+6
for(i in 1:nselblks)
{
  write(paste0('# Selectivity Block #', i, " Data") , file=out.file,append=T)   #, ncol=(nyears))
  write(t(temp[(i-1)*x + 1:x,]), file=out.file,append=T, ncol=4)
}
write( '# Selectivity start age by fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(fleet.age1, file=out.file,append=T, ncol=nfleets )
write( '# Selectivity end age by fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(fleet.age2, file=out.file,append=T, ncol=nfleets )
write( '# Age range for average F' , file=out.file, append=T)   #, ncol=(nyears))
write(F.report.ages, file=out.file,append=T, ncol=2)
write( '# Average F report option ' , file=out.file,append=T)   #, ncol=(nyears))
write(F.report.opt, file=out.file,append=T, ncol=2)
write( '# Use likelihood constants?' , file=out.file,append=T)   #, ncol=(nyears))
write(like.const, file=out.file, append=T )
write( '# Release Mortality by fleet' , file=out.file,append=T)   #, ncol=(nyears))
write( rel.mort.fleet, file=out.file,append=T, ncol=nfleets)
#write( '# Catch at age matrices (nyears*nfleets rows)' , file=out.file,append=T)   #, ncol=(nyears))
write( '# Catch Data', file=out.file,append=T)   #, ncol=(nyears))
for(i in 1:nfleets)
{
  write(paste0("# Fleet-", i, " Catch Data"), file=out.file,append=T)
  write(t(caa.mats[(i-1)*nyears + 1:nyears,]), file=out.file,append=T, ncol= (asap.nages+1) )
}
write( '# Discards at age by fleet' , file=out.file,append=T)   #, ncol=(nyears))
for(i in 1:nfleets)
{
  write(paste0("# Fleet-", i, " Discards Data"), file=out.file,append=T)
  write(t(daa.mats[(i-1)*nyears + 1:nyears,]), file=out.file,append=T, ncol= (asap.nages+1) )
}
write( '# Release proportion at age by fleet' , file=out.file,append=T)   #, ncol=(nyears))
for(i in 1:nfleets)
{
  write(paste0("# Fleet-", i, " Release Data"), file=out.file,append=T)
  write(t(rel.prop[(i-1)*nyears + 1:nyears,]), file=out.file,append=T, ncol= asap.nages )
}
write( '# Survey Index Data' , file=out.file,append=T)   #, ncol=(nyears))
write( '# Index units' , file=out.file,append=T)   #, ncol=(nyears))
write(units.ind, file=out.file,append=T, ncol=n.ind.avail )
write( '# Index Age comp. units' , file=out.file,append=T)   #, ncol=(nyears))
write(units.ind, file=out.file,append=T, ncol=n.ind.avail )
write( '# Index WAA matrix' , file=out.file,append=T)   #, ncol=(nyears))
write((rep(1,n.ind.avail)), file=out.file,append=T, ncol=n.ind.avail )

write( '# Index month' , file=out.file, append=T)   #, ncol=(nyears))
write(time.ind, file=out.file,append=T, ncol=n.ind.avail )
write( '# Index link to fleet? ' , file=out.file,append=T)   #, ncol=(nyears))
write(fish.ind, file=out.file,append=T, ncol=n.ind.avail)
write( '# Index selectivity option ' , file=out.file,append=T)   #, ncol=(nyears))
write(sel.ind, file=out.file,append=T, ncol=n.ind.avail)
write( '# Index start age' , file=out.file,append=T)   #, ncol=(nyears))
write(ind.age1, file=out.file, append=T, ncol=n.ind.avail )
write( '# Index end age' , file=out.file,append=T)   #, ncol=(nyears))
write(ind.age2, file=out.file, append=T, ncol=n.ind.avail )

write( '# Index Estimate Proportion (YES=1)' , file=out.file,append=T)   #, ncol=(nyears))
write(t(rep(1,n.ind.avail)), file=out.file, append=T, ncol=n.ind.avail )
write( '# Use Index' , file=out.file,append=T)   #, ncol=(nyears))
write(ind.use, file=out.file, append=T, ncol=n.ind.avail )
x = asap.nages+6
for(i in 1:n.ind.avail)
{
  write(paste0('# Index-', i, ' Selectivity Data') , file=out.file,append=T)   #, ncol=(nyears))
  write(t(ind.sel.mats[(i-1)*x + 1:x,]), file=out.file,append=T, ncol=4)
}
write( '# Index data matrices (n.ind.avail.*nyears)' , file=out.file,append=T)   #, ncol=(nyears))

# ----------one-off for ICES to ASAP
  for ( kk in 1:length(ind.use))  {
     if (ind.use[kk]==1) {
write( paste0('# Index   ', survey.names[kk]) , file=out.file,append=T)   #, ncol=(nyears))
        tmp.s <- ind.mat[[kk]]
        ind.mat2 <- get.index.mat(tmp.s, ind.cv, ind.neff, first.year, nyears, catch.ages, survey.ages[[kk]])
write(t(ind.mat2), file=out.file,append=T, ncol=(asap.nages + 4) )
        } # end ind.use test
  } #end kk loop

# ----------one-off for ICES to ASAP
write( '#########################################' , file=out.file,append=T)   #, ncol=(nyears))
write( '# Phase data' , file=out.file,append=T)   #, ncol=(nyears))
write( '# Phase for Fmult in 1st year' , file=out.file,append=T)   #, ncol=(nyears))
write(p.Fmult1, file=out.file,append=T  )
write( '# Phase for Fmult deviations' , file=out.file, append=T)   #, ncol=(nyears))
write(p.Fmult.dev, file=out.file,append=T  )
write( '# Phase for recruitment deviations ' , file=out.file,append=T)   #, ncol=(nyears))
write(p.recr.dev, file=out.file,append=T )
write( '# Phase for N in 1st year ' , file=out.file,append=T)   #, ncol=(nyears))
write(p.N1, file=out.file,append=T )
write( '# Phase for catchability in 1st year' , file=out.file,append=T)   #, ncol=(nyears))
write(p.q1, file=out.file, append=T  )
write( '# Phase for catchability deviations' , file=out.file,append=T)   #, ncol=(nyears))
write(p.q.dev, file=out.file, append=T )
write( '# Phase for stock recruit relationship' , file=out.file,append=T)   #, ncol=(nyears))
write(p.SR, file=out.file, append=T  )
write( '# Phase for steepness' , file=out.file,append=T)   #, ncol=(nyears))
write(p.h, file=out.file,append=T  )
write( '#########################################' , file=out.file,append=T)   #, ncol=(nyears))
write( '# Lambdas and CVs' , file=out.file,append=T)   #, ncol=(nyears))
write( '# Recruitment CV by year' , file=out.file,append=T)   #, ncol=(nyears))
write(recr.CV, file=out.file,append=T , ncol=1 )
write( '# Lambda for each index' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.ind, file=out.file,append=T, ncol=n.ind.avail  )
write( '# Lambda for Total catch in weight by fleet' , file=out.file, append=T)   #, ncol=(nyears))
write(lam.c.wt, file=out.file,append=T, ncol=nfleets  )
write( '# Lambda for total discards at age by fleet ' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.disc, file=out.file,append=T, ncol=nfleets )
write( '# Catch Total CV by year and fleet ' , file=out.file,append=T)   #, ncol=(nyears))
write(catch.CV, file=out.file,append=T, ncol=nfleets )
write( '# Discard total CV by year and fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(disc.CV, file=out.file, append=T, ncol=nfleets  )
write( '# Input effective sample size for catch at age by year and fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(Neff.catch, file=out.file, append=T, ncol=nfleets )
write( '# Input effective sample size for discards at age by year and fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(Neff.disc, file=out.file, append=T , ncol=nfleets )
write( '# Lambda for Fmult in first year by fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.Fmult.y1, file=out.file,append=T, ncol=nfleets  )
write( '# CV for Fmult in first year by fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.Fmult.y1, file=out.file,append=T, ncol=nfleets  )
write( '# Lambda for Fmult deviations' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.Fmult.dev, file=out.file,append=T, ncol=nfleets  )
write( '# CV for Fmult deviations' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.Fmult.dev, file=out.file,append=T, ncol=nfleets  )
write( '# Lambda for N in 1st year deviations ' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.N1.dev, file=out.file,append=T )
write( '# CV for N in 1st year deviations ' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.N1.dev, file=out.file,append=T  )
write( '# Lambda for recruitment deviations' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.recr.dev, file=out.file, append=T  )
write( '# Lambda for catchability in first year by index' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.q.y1, file=out.file, append=T, ncol=n.ind.avail )
write( '# CV for catchability in first year by index' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.q.y1, file=out.file, append=T , ncol=n.ind.avail )
write( '# Lambda for catchability deviations by index' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.q.dev, file=out.file,append=T, ncol=n.ind.avail  )
write( '# CV for catchability deviations by index' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.q.dev, file=out.file,append=T  )
write( '# Lambda for deviation from initial steepness' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.h, file=out.file,append=T   )
write( '# CV for deviation from initial steepness' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.h, file=out.file,append=T  )
write( '# Lambda for deviation from initial SSB0 ' , file=out.file,append=T)   #, ncol=(nyears))
write(lam.SSB0, file=out.file,append=T )
write( '# CV for deviation from initial SSB0 ' , file=out.file,append=T)   #, ncol=(nyears))
write(CV.SSB0, file=out.file,append=T  )

write( '# NAA Deviations flag (1=   , 0=  ) ' , file=out.file,append=T)   #, ncol=(nyears))
write(1, file=out.file,append=T  )

write('###########################################', file=out.file, append=T)
write('###  Initial Guesses', file=out.file, append=T)
write( '# NAA for year1' , file=out.file,append=T)   #, ncol=(nyears))
write(naa.y1, file=out.file, append=T, ncol=asap.nages  )
write( '# Fmult in 1st year by fleet' , file=out.file,append=T)   #, ncol=(nyears))
write(Fmult.y1, file=out.file, append=T, ncol=nfleets )
write( '# Catchability in 1st year by index' , file=out.file,append=T)   #, ncol=(nyears))
write(q.y1, file=out.file, append=T  )

write( '# S-R Unexploited specification (1=   0=)' , file=out.file,append=T)   #, ncol=(nyears))
write(1, file=out.file,append=T, ncol=n.ind.avail  )

write( '# Unexploited initial guess' , file=out.file,append=T)   #, ncol=(nyears))
write(SSB0, file=out.file,append=T, ncol=n.ind.avail  )
write( '# Steepness initial guess' , file=out.file,append=T)   #, ncol=(nyears))
write(h.guess, file=out.file,append=T  )
write( '# Maximum F (upper bound on Fmult)' , file=out.file,append=T)   #, ncol=(nyears))
write(F.max, file=out.file,append=T  )
write( '# Ignore guesses' , file=out.file,append=T)   #, ncol=(nyears))
write(ignore.guess, file=out.file,append=T  )
write('###########################################', file=out.file, append=T)
write('###  Projection Control data', file=out.file, append=T)
write( '# Do projections' , file=out.file,append=T)   #, ncol=(nyears))
write(do.proj, file=out.file, append=T   )
write( '# Fleet directed flag' , file=out.file,append=T)   #, ncol=(nyears))
write(fleet.dir, file=out.file, append=T, ncol=nfleets )
write( '# Final year of projections' , file=out.file,append=T)   #, ncol=(nyears))
write(proj.yr, file=out.file, append=T   )
write( '# Year, projected recruits, what projected, target, non-directed Fmult ' , file=out.file,append=T)   #, ncol=(nyears))
write(t(proj.specs), file=out.file,append=T, ncol=5 )
write('###########################################', file=out.file, append=T)
write('###  MCMC Control data', file=out.file, append=T)
write( '# do mcmc' , file=out.file,append=T)   #, ncol=(nyears))
write(do.mcmc, file=out.file,append=T  )
write( '# MCMC nyear option' , file=out.file,append=T)   #, ncol=(nyears))
write(mcmc.nyr.opt, file=out.file,append=T  )
write( '# MCMC number of saved iterations desired' , file=out.file,append=T)   #, ncol=(nyears))
write(mcmc.nboot, file=out.file,append=T  )
write( '# MCMC thinning rate' , file=out.file,append=T)   #, ncol=(nyears))
write(mcmc.thin, file=out.file,append=T  )
write( '# MCMC random number seed' , file=out.file,append=T)   #, ncol=(nyears))
write(mcmc.seed, file=out.file,append=T  )
write('###########################################', file=out.file, append=T)
write('###  A few AGEPRO specs', file=out.file, append=T)
write( '# R in agepro.bsn file' , file=out.file,append=T)   #, ncol=(nyears))
write(recr.agepro, file=out.file,append=T  )
write( '# Starting year for calculation of R' , file=out.file,append=T)   #, ncol=(nyears))
write(recr.start.yr, file=out.file,append=T  )
write( '# Ending year for calculation of R' , file=out.file,append=T)   #, ncol=(nyears))
write(recr.end.yr, file=out.file,append=T  )

write( '# Export to R flag (1=  0=)' , file=out.file,append=T)   #, ncol=(nyears))
write(1, file=out.file,append=T  )

write( '# test value' , file=out.file,append=T)   #, ncol=(nyears))
write(test.val, file=out.file,append=T  )
write('###########################################', file=out.file, append=T)
write('###### FINIS ######', file=out.file, append=T)
write( '# Fleet Names', file=out.file, append=T)
write(fleet.names, file=out.file, append=T, ncol=1)
write( '# Survey Names', file=out.file, append=T)
write(survey.names, file=out.file, append=T, ncol=1)



 }     # end asap setup function

#---------------------------------------------------------------------
#---------------------------------------------------------------------
# code to read in ICES file structure and convert to ASAP
#  uses SAM read.ices fn modified by Dan Hennen,
read.ices=function (filen)
{
  if (grepl("^[0-9]", scan(filen, skip = 2, n = 1, quiet = TRUE,
                           what = ""))) {
    head <- scan(filen, skip = 2, n = 5, quiet = TRUE)
    minY <- head[1]
    maxY <- head[2]
    minA <- head[3]
    maxA <- head[4]
    datatype <- head[5]
    if (!is.whole.positive.number(minY)) {
      stop(paste("In file", filen, ": Minimum year is expected to be a positive integer number"))
    }
    if (!is.whole.positive.number(maxY)) {
      stop(paste("In file", filen, ": Maximum year is expected to be a positive integer number"))
    }
    if (!is.whole.positive.number(minA)) {
      stop(paste("In file", filen, ": Minimum age is expected to be a positive integer number"))
    }
    if (!is.whole.positive.number(maxA)) {
      stop(paste("In file", filen, ": Maximum age is expected to be a positive integer number"))
    }
    if (!(datatype %in% c(1, 2, 3, 5))) {
      stop(paste("In file", filen, ": Datatype code is expected to be one of the numbers 1, 2, 3, or 5"))
    }
    if (minY > maxY) {
      stop(paste("In file", filen, ": Minimum year is expected to be less than maximum year"))
    }
    if (minA > maxA) {
      stop(paste("In file", filen, ": Minimum age is expected to be less than maximum age"))
    }
    C <- as.matrix(read.table.nowarn(filen, skip = 5, header = FALSE))
    if (datatype == 1) {
      if ((maxY - minY + 1) != nrow(C)) {
        stop(paste("In file", filen, ": Number of rows does not match the year range given"))
      }
      if ((maxA - minA + 1) > ncol(C)) {
        stop(paste("In file", filen, ": Fewer columns than the age range given"))
      }
    }
    if (datatype == 2) {
      C <- as.matrix(read.table.nowarn(filen, skip = 5,
                                       header = FALSE))
      if (1 != nrow(C)) {
        stop(paste("In file", filen, ": For datatype 2 only one row of data is expected"))
      }
      if ((maxA - minA + 1) > ncol(C)) {
        stop(paste("In file", filen, ": Fewer columns than the age range given"))
      }
      C <- C[rep(1, maxY - minY + 1), ]
    }
    if (datatype == 3) {
      C <- as.matrix(read.table.nowarn(filen, skip = 5,
                                       header = FALSE))
      if (1 != nrow(C)) {
        stop(paste("In file", filen, ": For datatype 3 only one row of data is expected"))
      }
      if (1 != ncol(C)) {
        stop(paste("In file", filen, ": For datatype 3 only one column of data is expected"))
      }
      C <- C[rep(1, maxY - minY + 1), rep(1, maxA - minA +
                                            1)]
    }
    if (datatype == 5) {
      C <- as.matrix(read.table.nowarn(filen, skip = 5,
                                       header = FALSE))
      if ((maxY - minY + 1) != nrow(C)) {
        stop(paste("In file", filen, ": Number of rows does not match the year range given"))
      }
      if (1 != ncol(C)) {
        stop(paste("In file", filen, ": For datatype 5 only one column of data is expected"))
      }
      C <- C[, rep(1, maxA - minA + 1)]
    }
    rownames(C) <- minY:maxY
    C <- C[, 1:length(minA:maxA)]
    colnames(C) <- minA:maxA
    if (!is.numeric(C)) {
      stop(paste("In file", filen, ": Non numeric data values detected (could for instance be comma used as decimal operator)"))
    }
    return(C)
  }
  else {
    return(read.surveys(filen))
  }
}

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
read.surveys=function (filen)
{
  lin <- readLines(filen, warn = FALSE)[-c(1:2)]
  empty <- which(lapply(lapply(strsplit(lin, split = "[[:space:]]+"),
                               paste, collapse = ""), nchar) == 0)
  if (length(empty) > 0) {
    lin <- lin[-empty]
  }
  lin <- sub("^\\s+", "", lin)
  idx1 <- grep("^[A-Z#]", lin, ignore.case = TRUE)
  idx2 <- c(idx1[-1] - 1, length(lin))
  names <- lin[idx1]
  years <- matrix(as.numeric(unlist(strsplit(lin[idx1 + 1],
                                             "[[:space:]]+"))), ncol = 2, byrow = TRUE)
  times <- matrix(as.numeric(unlist(strsplit(lin[idx1 + 2],
                                             "[[:space:]]+"))), ncol = 4, byrow = TRUE)[, 3:4, drop = FALSE]
  ages <- matrix(as.numeric(unlist(lapply(strsplit(lin[idx1 +
                                                         3], "[[:space:]]+"), function(x) x[1:2]))), ncol = 2,
                 byrow = TRUE)
  for (i in 1:length(names)) {
    if (!is.whole.positive.number(years[i, 1])) {
      stop(paste("In file", filen, ": Minimum year is expected to be a positive integer number for fleet number",
                 i))
    }
    if (!is.whole.positive.number(years[i, 2])) {
      stop(paste("In file", filen, ": Maximum year is expected to be a positive integer number for fleet number",
                 i))
    }
    if (years[i, 1] > years[i, 2]) {
      stop(paste("In file", filen, ": Maximum year is expected to be greater than minimum year for fleet number",
                 i))
    }
    if (ages[i, 1] > ages[i, 2]) {
      stop(paste("In file", filen, ": Maximum age is expected to be greater than minimum age for fleet number",
                 i))
    }
    if ((times[i, 1] < 0) | (times[i, 1] > 1)) {
      stop(paste("In file", filen, ": Minimum survey time is expected to be within [0,1] for fleet number",
                 i))
    }
    if ((times[i, 2] < 0) | (times[i, 2] > 1)) {
      stop(paste("In file", filen, ": Maximum survey time is expected to be within [0,1] for fleet number",
                 i))
    }
    if (times[i, 2] < times[i, 1]) {
      stop(paste("In file", filen, ": Maximum survey time is expected greater than minimum survey time for fleet number",
                 i))
    }
  }
  as.num <- function(x, na.strings = "NA") {
    stopifnot(is.character(x))
    na = x %in% na.strings
    x[na] = 0
    x = as.numeric(x)
    x[na] = NA_real_
    x
  }
  onemat <- function(i) {
    lin.local <- gsub("^[[:blank:]]*", "", lin[(idx1[i] +
                                                  4):idx2[i]])
    nr <- idx2[i] - idx1[i] - 3
    ret <- matrix(as.num(unlist((strsplit(lin.local, "[[:space:]]+")))),
                  nrow = nr, byrow = TRUE)[, , drop = FALSE]
    if (nrow(ret) != (years[i, 2] - years[i, 1] + 1)) {
      stop(paste("In file", filen, ": Year range specified does not match number of rows for survey fleet number",
                 i))
    }
    if ((ncol(ret) - 1) < (ages[i, 2] - ages[i, 1] + 1)) {
      stop(paste("In file", filen, ": Fewer columns than indicated by age range for survey fleet number",
                 i))
    }
    if (!is.numeric(ret)) {
      stop(paste("In file", filen, ": Non numeric data values detected for survey fleet number",
                 i))
    }
    ret <- as.matrix(ret[, -1]/ret[, 1])
    rownames(ret) <- years[i, 1]:years[i, 2]
    ret <- ret[, 1:length(ages[i, 1]:ages[i, 2]), drop = FALSE]
    colnames(ret) <- ages[i, 1]:ages[i, 2]
    attr(ret, "time") <- times[i, ]
    ret[ret < 0] <- NA
    ret
  }
  obs <- lapply(1:length(names), onemat)
  names(obs) <- names
  obs
}

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
read.table.nowarn=function (...)
{
  tryCatch.W.E <- function(expr) {
    W <- NULL
    w.handler <- function(w) {
      if (!grepl("incomplete final line", w))
        W <<- w
      invokeRestart("muffleWarning")
    }
    list(value = withCallingHandlers(tryCatch(expr, error = function(e) e),
                                     warning = w.handler), warning = W)
  }
  lis <- tryCatch.W.E(read.table(...))
  if (!is.null(lis$warning))
    warning(lis$warning)
  lis$value
}
is.whole.positive.number=function (x, tol = .Machine$double.eps^0.5)
{
  (abs(x - round(x)) < tol) & (x >= 0)
}

##---end code block for ICES read functions

#---------------------------------------------------------------------
#----helper functions to preprocess arguments for setup.asap function--------
#---------------------------------------------------------------------
get.survey.time=function (x)    #func to grab survey timing from ICES surveys object
{
n.surv <- length(x)
tt <- rep(NA, n.surv)
for (i in 1:n.surv) {
    tt[i] <- attr(x[[i]], 'time') [1]
}
    tt <- round(tt*12, 0)
return(tt)

 }

#---------------------------------------------------------------------
get.survey.ages=function (x)    #func to grab survey ages from ICES surveys object
{
  lapply(x, function(y) 
  {
    r = range(as.numeric(colnames(y)))
    seq(r[1],r[2],1)
  })
}

#---------------------------------------------------------------------
get.peak.age=function (x)    #grab peak age from first couple of rows
{
if (class(x)== "matrix") {
   t.age <- rep(NA, 5)
   for (i in 1:5) {
   t.age[i] <- which(x[i,]==max(x[i,], na.rm=T))
       }
   peak <- round(mean(t.age), 0)
    } #end matrix class

if (class(x)== "list") {
 n.mats <- length(x)
 peak <-rep(NA, n.mats)

 for (i in 1:n.mats) {
    t.mat <- x[[i]] [1:5,]
    t.age <- rep(NA,5)
    for (j in 1:5) {
   t.age[j] <- which(t.mat[j,]==max(t.mat[j,], na.rm=T))
       } # end j loop
   peak[i] <- round(mean(t.age), 0)
        }  # end i loop

    } # end list class

return(peak)

 }

#---------------------------------------------------------------------
setup.surv.sel = function(x, i.peak, catch.ages,survey.ages)  {   #set up matrix specs for index selectivities
 n.ind <- length(x)
 sel.c1 <- rep()
 sel.c2 <- rep()
 sel.c3 <- rep()
 sel.c4 <- rep()
 n.ages = length(catch.ages)
  for (i in 1:n.ind) {
#  tmp.nages <- ind.ages[2,i]-ind.ages[1,i]+1
   tmp.c1 = rep(0,n.ages)
   if(sum(!(survey.ages[[i]] %in% catch.ages))) stop("some survey ages are not in catch.ages")
   ind = which(catch.ages %in% survey.ages[[i]])
   peak.age.class = ind[i.peak[i]] #not necessarily the peak age
   tmp.c1[ind] = seq(0.1,0.9, length.out=length(ind))
   tmp.c1[peak.age.class] <-1
   tmp.c1 <-  c( tmp.c1,  round((peak.age.class)/2,2), 0.9,
              round((peak.age.class)/4,2), 0.6,  round(n.ages/1.5,2), 1.1)
   sel.c1 <- c(sel.c1, tmp.c1)
   tmp.c2 = rep(-1,n.ages)
   tmp.c2[ind] = 1
   tmp.c2[peak.age.class] = -1
   tmp.c2 = c(tmp.c2, 2,3, rep(1,4))
   sel.c2 <- c( sel.c2, tmp.c2)#, 2,3, rep(1, 4)) # phase for estimation
   #sel.c2[peak.age.class+(i-1)*(n.ages+6)] <- -1
   sel.c3 <- c(sel.c3, rep(0, (n.ages+6))  )# lambda for sel parameters
   sel.c4 <- c(sel.c4, rep(1, (n.ages+6)) )# CV for sel parameters (irrelevant if lambda=0)

  }#end i loop

 sel.mats <- cbind(sel.c1, sel.c2, sel.c3, sel.c4)

 return(sel.mats)

} #end  setup

#---------------------------------------------------------------------
#get.index.mat<- function(x, cv, neff, first.year, nyears, asap.nages)  {
get.index.mat<- function(x, cv, neff, first.year, nyears, catch.ages, survey.ages)  {
   n.ages = length(catch.ages)
   last.yr <- first.year+nyears - 1
   
   tmp.yrs <- as.numeric(rownames(x))
   if (tmp.yrs[length(tmp.yrs)]>last.yr)  tmp.yrs <- tmp.yrs[-which(tmp.yrs>last.yr)]
   tmp.ages <- as.numeric(colnames(x))
   tmp.ages = catch.ages
   survey.ages.index = which(catch.ages %in% survey.ages)
   i.mat <- matrix(0, nyears, (n.ages + 4))
   i.mat[,1] <- seq(first.year, last.yr)
   rownames(x) <- c()
   colnames(x) <- c()
   x[is.na(x)] <- 0
   tmp.ind.total <- apply(x[1:length(tmp.yrs),], 1, sum)
   if (tmp.yrs[1]==first.year) {
   i.mat[ , 1:3 ] <- cbind(tmp.yrs, tmp.ind.total, rep(cv, length(tmp.yrs))  )
   i.mat[ , (3+survey.ages.index)]  <- x
   i.mat[ , (n.ages+4)]  <- rep(neff, length(tmp.yrs))
        }

   if (tmp.yrs[1]>first.year) {
   i.mat[(tmp.yrs[1]-first.year+1):nyears, 2:3 ] <- cbind( tmp.ind.total, rep(cv, length(tmp.yrs))  )
   i.mat[(tmp.yrs[1]-first.year+1):nyears, (3+tmp.ages[1]):(3+tmp.ages[length(tmp.ages)]) ]  <- x[1:length(tmp.yrs),]
   i.mat[(tmp.yrs[1]-first.year+1):nyears, (asap.nages+4)]  <- rep(neff, length(tmp.yrs))
      }

 return(i.mat)

}

#---------------------------------------------------------------------


#---------------------------------------------------------------------
#---- Begin translating ICES file format to "vanilla" ASAP input file
#---------------------------------------------------------------------

#omid = model.id
#model.id = ''
#ices.id because sometimes there is no stock id at the beginning of the file names
# set ices.id=model.id by default to facilitate backward compatability
ICES2ASAP <- function(user.wd,user.od,model.id,ices.id=model.id){ 
  cn <- read.ices(paste(user.wd,ices.id,"cn.dat",sep=""))
  cw <- read.ices(paste(user.wd,ices.id,"cw.dat",sep=""))
  dw <- read.ices(paste(user.wd,ices.id,"dw.dat",sep=""))
  #lf <- read.ices(paste(user.wd,ices.id,"lf.dat",sep=""))
  #lw <- read.ices(paste(user.wd,ices.id,"lw.dat",sep=""))
  mo <- read.ices(paste(user.wd,ices.id,"mo.dat",sep=""))
  nm <- read.ices(paste(user.wd,ices.id,"nm.dat",sep=""))
  #propf <- read.ices(paste(user.wd,ices.id,"pf.dat",sep=""))
  pm <- read.ices(paste(user.wd,ices.id,"pm.dat",sep=""))
  sw <- read.ices(paste(user.wd,ices.id,"sw.dat",sep=""))
  surveys <- read.ices(paste(user.wd,ices.id,"survey.dat",sep=""))
  
  t.spawn <- pm[1,1] #assuming time/age invariant spawning time
  
  catch.yy <- as.numeric(c(min(rownames(cn)), max(rownames(cn)) ))  # assuming there is only one CAA matrix
  nfleets <- 1                       # thus, also assuming nfleets=1
  catch.yrs <- seq(catch.yy[1], catch.yy[2])     #assuming catch defines the start/end year
  catch.nyrs <- length(catch.yrs)
  catch.nages <- dim(cn) [2]     #assuming catch matrix defines total number of modeled ages
  # setting Freport as (catch.nages):(catch.nages-1)  ; unweighted F
  catch.ages <- range(as.numeric(colnames(cn)))
  catch.ages = seq(catch.ages[1],catch.ages[2],1)
  asap.ages = 1:catch.nages
  # assuming 3 WAA matrices (catch, discard, and spawning weight); since assuming 1 fleet, cw should equal lw in ASAP)
  waa.array <- array(NA, dim=c(catch.nyrs, catch.nages, 3))
  waa.array[,,1] <- cw[1:catch.nyrs,]
  waa.array[,,2] <- dw[1:catch.nyrs,]
  waa.array[,,3] <- sw[1:catch.nyrs,]
  waa.pointer.vec <- c(1, 2, 1, 2, 3, 3) #assuming spawning weight-jan-1 biomass
  
  f.sel.blks <- rep(1, catch.nyrs) # assuming 1 selectivity block for all years (catch)
  f.sel.type <-  2 # assuming logistic (1=by age; 2=logistic; 3=double logistic)
  f.peak <- get.peak.age(cn)
  f.sel.mats.c1 <- c( seq(0.1,0.9, length.out=(catch.nages)),  round((f.peak)/2,2), 0.9,
                      round((f.peak)/4,2), 0.6,  round((catch.nages)/1.5,2), 1.1)
  f.sel.mats.c1[f.peak] <-1
  f.sel.mats.c2 <- c( rep(1, catch.nages), 2,3, rep(1, 4)) # phase for estimation
  f.sel.mats.c2[f.peak] <- -1
  f.sel.mats.c3 <- rep(0, (catch.nages+6)) # lambda for sel parameters
  f.sel.mats.c4 <- rep(1, (catch.nages+6)) # CV for sel parameters (irrelevant if lambda=0)
  f.sel.mats <- cbind(f.sel.mats.c1, f.sel.mats.c2, f.sel.mats.c3, f.sel.mats.c4)
  
  rel.mort.fleet <- rep(0,nfleets) # assuming release mortality at age (discard) is 0
  rel.prop <- matrix(0,nfleets*catch.nyrs, catch.nages)
  tot.catch <- apply(cn*cw,1,sum)
  
  
  n.surveys <- length(surveys)
  units.ind <- rep(2, n.surveys) # assuming unites=number (1=biomass; 2=number)
  time.ind <- get.survey.time(surveys)
  fish.ind <- rep(-1, n.surveys) #assuming none of the indices link to a fleet (i.e. all fishery-independent indices)
  index.sel.type <-  rep(2, n.surveys) #assuming logistic for simple setup
  ind.ages <- get.survey.ages(surveys)
  #ind.age1 <- sapply(ind.ages, min)
  ind.age1 <- rep(1, length(ind.ages))
  #ind.age2 <-  sapply(ind.ages, max)
  ind.age2 <- rep(length(catch.ages), length(ind.ages))
  ind.use <-  rep(1, n.surveys)
  i.peak <- get.peak.age(surveys)
  ind.sel.mats <- setup.surv.sel(surveys, i.peak, catch.ages, ind.ages)
  ind.cv = 0.2    # assume same CV for all years, all indices to setup ASAP indices matrix
  ind.neff = 50   # assume same Effective sample size for all years, all indices to setup ASAP indices matrix
  #ind.mat <- get.index.mat(x=surveys, a=ind.ages,  cv=0.2, neff=50)  #calculate total index and append CV and Neff columns
  #ind.mat = get.index.mat(x=surveys, cv = 0.2, neff = 50, first.year = catch.yy[1], nyears = catch.nyrs, catch.ages, survey.ages)  {
 
  recr.CV <- rep(0.5, catch.nyrs)
  catch.CV <- rep(0.1, catch.nyrs)
  disc.CV <- rep(0, catch.nyrs)
  Neff.catch <- rep(100, catch.nyrs)
  Neff.disc <- rep(0, catch.nyrs)
  Fmult.y1 <- 0.1
  naa.y1 <- (nm[1,1]/(nm[1,1]+Fmult.y1))*cn[1,]/(1-exp(-nm[1,1]-Fmult.y1))
  if(naa.y1[1]==min(naa.y1) ) naa.y1[1] <-  10*mean(naa.y1)
  naa.y1[which(naa.y1==0)] <- mean(naa.y1)
  q.y1 <-  jitter(rep(0.05, n.surveys) , 30 )
  
  proj.yr=(catch.yy[2]+2) #dummy set up for 2 year projection
  proj.specs <- matrix(NA, nrow=2, ncol=5)
  proj.specs[,1] <- c((catch.yy[2]+1), (catch.yy[2]+2))
  proj.specs[,2] <- rep(-1, 2)
  proj.specs[,3]<- c(1,3)
  proj.specs[,4] <-  c(150,-99)
  proj.specs[,5] <-  rep(0,2)
  
  fleet.names <- "fleet1"
  survey.names <- names(surveys)
  fleet.dir <-  rep(1,nfleets)
  disc.flag =  F
  
  # call the function to setup ASAP
  #phases indicated by p.(param.name) have been set at simple default
  #by default, steepness is fixed at 1 (estimates mean recruitment with deviations)
  #  to change this default, set "h.guess" to a value in [0.21, 0.99] and set p.h to positive integer
  setup.asap.w(wd=user.wd, od=user.od, model.id=model.id, nyears=catch.nyrs,
               first.year=catch.yy[1], asap.nages=catch.nages, nfleets=nfleets,
               nselblks=nfleets, n.ind.avail=n.surveys, M.mat=nm[1:catch.nyrs,],
               fec.opt=0, t.spawn=t.spawn, mat.mat=mo[1:catch.nyrs,],
               n.waa.mats=3, waa.array=waa.array, waa.pointer.vec=waa.pointer.vec,
               sel.blks=f.sel.blks, sel.types=f.sel.type, sel.mats=f.sel.mats,
               fleet.age1=asap.ages[1], fleet.age2=asap.ages[length(asap.ages)],
               F.report.ages=c((catch.nages-1),catch.nages), F.report.opt=1,
               like.const=0, rel.mort.fleet=rel.mort.fleet, caa.mats=cbind(cn, tot.catch), daa.mats=cbind(cn*0, 0*tot.catch),
               rel.prop=rel.prop, units.ind=units.ind, time.ind=time.ind,
               fish.ind=fish.ind, sel.ind=index.sel.type,
               ind.age1, ind.age2, ind.use, ind.sel.mats, ind.mat=surveys, 
               ind.cv=ind.cv, ind.neff=ind.neff,
               p.Fmult1=1, p.Fmult.dev=3, p.recr.dev=3, p.N1=2, p.q1=1, p.q.dev=-1, p.SR=1, p.h=-2,
               recr.CV=rep(0.5,catch.nyrs), lam.ind=rep(1,n.surveys),
               lam.c.wt=rep(1,nfleets), lam.disc=rep(0,nfleets), catch.CV=catch.CV, disc.CV=disc.CV,
               Neff.catch, Neff.disc, lam.Fmult.y1=rep(0, nfleets),
               CV.Fmult.y1=rep(1, nfleets), lam.Fmult.dev=rep(0,nfleets), CV.Fmult.dev=rep(1,nfleets),
               lam.N1.dev=0, CV.N1.dev=1, lam.recr.dev=1,
               lam.q.y1=rep(0, n.surveys), CV.q.y1=rep(1, n.surveys), lam.q.dev=rep(0, n.surveys),
               CV.q.dev=rep(1, n.surveys), lam.h=0, CV.h=1, lam.SSB0=0, CV.SSB0=1,
               naa.y1, Fmult.y1, q.y1, SSB0=1e7, h.guess=1.0, F.max=5, ignore.guess=0,
               do.proj=0, fleet.dir=fleet.dir, proj.yr=proj.yr, proj.specs=proj.specs,
               do.mcmc=0, mcmc.nyr.opt=0, mcmc.nboot=1000, mcmc.thin=200, mcmc.seed=5230547,
               recr.agepro=0, recr.start.yr=(catch.yy[2]-12), recr.end.yr=(catch.yy[2]-2),
               test.val=-23456, fleet.names, survey.names, disc.flag, catch.ages = catch.ages, survey.ages = ind.ages )
}
