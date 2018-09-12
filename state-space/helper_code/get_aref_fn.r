get_aref_fn = function(paa)
{
  n_years = NROW(paa)
  n_ages = NCOL(paa)
  aref = rep(-1, n_years)
  for(y in 1:n_years)
  {
    temp = paa[y,]
    for(a in 1:n_ages) if(temp[a] < 1.0e-15) temp[a] = 0.0
    if (sum(temp > 1.0e-15)>1)
	  { #both requirements as well as total catch > 0 to include age comp in objective function
	    paa[y,]=temp/sum(temp)
   	  for(a in 1:n_ages) if(paa[y,a] > 1.0e-15) aref[y] = a
   	  for(a in n_ages:1)
   	  {
   	    if(paa[y,a] > 1.0e-15) 
   	    {
   	      aref[y] = a #last positive
   	      break
   	    }
   	  }
   	  #this part is necessary for logistic-normal age comp (type = 5) 
   	  #note the aref can be associated with an observed 0 if needed.
   	  this_aref = aref[y] - 1 #start one less than last positive
   	  for(a in this_aref:1)
   	  {
        if(length(paa[y,a])== 0)
        {
          print(y)
          print(a)
          print(paa[y,])
          print(this_aref)
        }
   	    if(paa[y,a] > 1.0e-15) break #next to last is positive, don't change aref
   	    else aref[y] = a #move aref down one.
   	  }
	  }
    #else  paa[y,]=0.0
  }
      
  return(aref)
}


