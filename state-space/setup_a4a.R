  idxs <- readFLIndices(paste(write.dir, stockdir, survey.file, sep="/"))
  stk <- readFLStock(paste(write.dir, stockdir, index.low, sep="/"), no.discards = TRUE)
  stk <- setPlusGroup(stk, ageplus)
  range(stk)[c('minfbar','maxfbar')] <- Fages

  # replace 0 with half of the minimum
  catch.n(stk)[catch.n(stk)==0] <- min(catch.n(stk)[catch.n(stk)!=0])/2
  idxs <- lapply(idxs, function(x){
  	index(x)[index(x)==0] <- min(index(x)[index(x)!=0])/2
  	x
  })

  #my <- min(unlist(lapply(lapply(idxs, range), '[', 'minyear')))
  #stk <- window(stk, start=my)
