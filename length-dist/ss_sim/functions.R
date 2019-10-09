get_poplengthfreq <- function(report){
  fd <- report$natlen
  names(fd)[11] <- 'Beg.Mid' ## couldn't get this to work with dplyr
  fd <- fd %>% filter(Beg.Mid=='B') %>%
    select(-Area, -Bio_Pattern, -BirthSeas, -Morph,
           -Seas, -Era, -Sex, -Settlement,
           -Platoon, -Time, -Beg.Mid)

  d <- gather(fd, length, numbers, -Yr) %>%
    group_by(Yr) %>%   mutate(proportion=numbers/sum(numbers)) %>%
    ungroup() %>%
    mutate(length=as.numeric(length)) %>%
    ## The last year is assumed to be in equilibrium
  filter(Yr == max(Yr))
  return(d)
}
