wham_output_sdrep = function()
{
  for(i in paste0("m", 1:4)) 
  {
    temp = list(data = get(i)$env$data, par = get(i)$parList, map = get(i)$env$map,
      random = unique(names(get(i)$env$par[get(i)$env$random])))
    out = summary(get(i)$sdrep)
    write.csv(out, file = paste0(write.dir, "/", i, "_sdreport_full.csv"))
  }
}
