library(RMGWG)
library(parallel)
library(foreach)
library(doParallel)
# convert Lowestoft input files to vanilla ASAP
myCluster <- makeCluster(5, # number of cores to use
  type = "PSOCK") # type of cluster
registerDoParallel(myCluster)

work.dir = "~/work/ICES/MGWG/SS_vs_SCAA/R"
write.dir = "~/work/ICES/MGWG/MGWG/state-space"
index.low = "index.low"
get.cvs = function(fit=fitte, stk)
{
  fits = foreach(i = 1:500) %dopar% {  
    x <- FLa4a::simulate(fit, 1)
    mets = FLCore::metrics(stk+x)	
    mets <- lapply(mets, '[', drop=TRUE)
    mets <- do.call('cbind', mets)
  }
  CV = sapply(1:4, function(z) {
    res = sapply(fits, function(y) y[,z])
    apply(res,1,sd)/apply(res,1,median)
  })
  colnames(CV) = colnames(fits[[1]])
  return(CV)
}

#############
#CCGOMyt
stockdir = "CCGOMyt"
survey.file = "CCGOMYT_survey.dat"
ageplus = 6
Fages = c(4,5)
source(paste0(write.dir,"/setup_a4a.R"))

qmod <- list(~s(age, k=3), ~s(age, k=3), ~s(age, k=3), ~s(age, k=3))
fmodte <- ~ te(age, year, k=c(4, 23)) + s(age, k=4)
fmodsep <- ~s(age, k=4) + s(year, k=23)
srmod <- ~geomean(CV=0.1)
fitte <- sca(stk, idxs, qmodel=qmod, fmodel=fmodte, srmodel=srmod)
fitsep <- sca(stk, idxs, qmodel=qmod, fmodel=fmodsep, srmodel=srmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#GBhaddock
stockdir = "GBhaddock"
survey.file = "GBHADDOCK_survey.dat"
ageplus = 9
Fages = c(5,7)
source(paste0(write.dir,"/setup_a4a.R")) 
#warning message thrown on line 7: 
#In .local(x, i, ...) : Selected elements do not form a coherent 6D array

qmod <- list(~s(age, k=3), ~s(age, k=3), ~s(age, k=3))
fmodsep <- ~s(age, k=5) + s(year, k=25)
#stk <- window(stk, start=1964)

fitte <- sca(stk, idxs, qmodel=qmod)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#GBwinter
stockdir = "GBwinter"
survey.file = "GBWINTER_survey.dat"
ageplus = 7
Fages = c(4,6)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3), ~s(age, k=3), ~s(age, k=3))
fmodsep <- ~s(age, k=5) + s(year, k=17)

fitte <- sca(stk, idxs, qmodel=qmod)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#GOMcod
stockdir = "GOMcod"
survey.file = "GOMCOD_survey.dat"
ageplus = 9
Fages = c(5,9)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3), ~s(age, k=3), ~s(age, k=3))
fmodte <- ~te(age, year, k = c(4, 17), bs = "tp") + s(age, k = 6)
fmodsep <- ~s(age, k=5) + s(year, k=17)

fitte <- sca(stk, idxs, qmodel=qmod, fmodel=fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#GOMhaddock
stockdir = "GOMhaddock"
survey.file = "GOMHADDOCK_survey.dat"
ageplus = 9
Fages = c(5,7)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3), ~s(age, k=3))
fmodsep <- ~s(age, k=5) + s(year, k=20)


fitte <- sca(stk, idxs, qmodel=qmod)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#ICEherring
stockdir = "ICEherring/ices_data"
survey.file = "survey.dat"
ageplus = 11
Fages = c(5,10)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3))
fmodsep <- ~s(age, k=6) + s(year, k=15)


fitte <- sca(stk, idxs, qmodel=qmod)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)
stockdir = "ICEherring"

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#NScod
stockdir = "NScod"
survey.file = "survey.dat"
ageplus = 6
Fages = c(2,4)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=4), ~s(age, k=3))
fmodte <- ~te(age, year, k = c(4, 17), bs = "tp") + s(age, k = 5)
fmodsep <- ~s(age, k=5) + s(year, k=17)


fitte <- sca(stk, idxs, qmodel=qmod, fmodel = fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#Plaice
stockdir = "Plaice"
survey.file = "PLAICE_survey.dat"
ageplus = 11
Fages = c(6,9)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=4), ~s(age, k=3), ~s(age, k=3), ~s(age, k=3))
fmodte <- ~te(age, year, k = c(3, 18), bs = "tp") + s(age, k = 5)
fmodsep <- ~s(age, k=5) + s(year, k=18)

fitte <- sca(stk, idxs, qmodel=qmod, fmodel = fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#Pollock
stockdir = "Pollock"
survey.file = "POLLOCK_survey.dat"
ageplus = 9
Fages = c(5,7)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3), ~s(age, k=3))
fmodte <- ~te(age, year, k=c(5, 17)) + s(age, k=5)
fmodsep <- ~s(age, k=6) + s(year, k=17)

fitte <- sca(stk, idxs, qmodel=qmod, fmodel = fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#SNEMAwinter
stockdir = "SNEMAwinter"
survey.file = "SNEMAWINTER_survey.dat"
ageplus = 7
Fages = c(4,5)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=4), ~s(age, k=3), ~s(age, k=3))
fmodte <- ~te(age, year, k = c(4, 18), bs = "tp") + s(age, k = 5)
fmodsep <- ~s(age, k=5) + s(year, k=18)

fitte <- sca(stk, idxs, qmodel=qmod, fmodel = fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#SNEMAYT
stockdir = "SNEMAYT"
survey.file = "SNEMAYT_survey.dat"
ageplus = 6
Fages = c(4,5)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3), ~s(age, k=3))
fmodsep <- ~s(age, k=4) + s(year, k=20)

fitte <- sca(stk, idxs, qmodel=qmod)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#USAtlHerring
stockdir = "USAtlHerring"
survey.file = "USAtHERRING_survey.dat"
ageplus = 8
Fages = c(7,8)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=3), ~s(age, k=3))
fmodte <- ~te(age, year, k = c(3, 14)) + s(year, k = 3)
#fmodte <- ~te(age, year, k = c(3, 14)) + s(year, k = 3, by=as.numeric(age==1))
fmodsep <- ~s(age, k=7) + s(year, k=25)

fitte <- sca(stk, idxs, qmodel=qmod, fmodel = fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))

#############
#whitehake
stockdir = "WhiteHake"
survey.file = "WHITEHAKE_survey.dat"
index.low = "WHITEHAKE_index.low"
ageplus = 9
Fages = c(5,8)
source(paste0(write.dir,"/setup_a4a.R")) 

qmod <- list(~s(age, k=4), ~s(age, k=4))
fmodte <- ~te(age, year, k = c(4, 14), bs = "tp") + s(age, k = 6)
fmodsep <- ~s(age, k=5) + s(year, k=17)

fitte <- sca(stk, idxs, qmodel=qmod, fmodel = fmodte)
fitsep <- sca(stk, idxs, fmodel=fmodsep, qmodel=qmod)

CV = get.cvs(fit = fitte, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","te_CVs.csv", sep = "/"))
CV = get.cvs(fit = fitsep, stk)
write.csv(CV, file = paste(write.dir, stockdir, "a4asca","sep_CVs.csv", sep = "/"))
