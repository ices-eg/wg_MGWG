stocks <- list.dirs(path = "../", full.names = FALSE, recursive = FALSE)
stocks <- stocks[!(stocks %in% c("ASAP_3_year_projection_test", "helper_code", "plots_for_README", "tex", "USWCLingcod", "db"))]
m1 = m2 = m3 = matrix(NA, nrow = length(stocks), ncol = 2)
mods = list(m1,m2,m3)
remove(m1,m2,m3)
names(mods) = c("a4asca", "a4asca_constantFSelectivity", "a4asca_noblks")
for(s  in stocks) for(i in names(mods)) if(length(dir(paste0("../", s, "/", i))))
{
  x = readLines(paste0("../", s, "/", i, "/algorithm.R"))
  gml = grep("geomean", x, value = TRUE)
  #print(gml)
  if(length(gml)) mods[[i]][stocks == s, 1] = as.numeric(substr(strsplit(gml, "CV=")[[1]][2],1,3)) 
  blcksv = grep("by=breakpts(year", x, value = TRUE, fixed = TRUE)
  print(blcksv)
  if(length(blcksv)) 
  {
    print(strsplit(blcksv, "year, ")[[1]][2])
    mods[[i]][stocks == s, 2] = as.numeric(substr(strsplit(blcksv, "year, ")[[1]][2],1,4)) 
  }
  #get standard errors of predicted rec, catch, ssb, etc.
  load(paste0("../", s, "/", i, "/.RData"))
  fitmet = metrics(stk+fits)
  fitmet = lapply(fitmet,function(x) sqrt(iterVars(log(x))))
	fitmet = lapply(fitmet, '[', drop=TRUE)
	fitmet = do.call('cbind', fitmet)
  write.csv(fitmet, file = paste0("../", s, "/", i, "/log_R_SSB_Catch_F_SE.csv"))
  remove(fitmet)
}
