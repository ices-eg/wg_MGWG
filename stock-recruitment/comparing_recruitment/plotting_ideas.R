
library(dplyr)

# read in some stock and recuit data
# https://doi.org/10.7489/12085-1
sr_data <-
  read.csv("https://data.marine.gov.scot/sites/default/files/Ova_to_ova_SR.csv") %>%
  filter(Site == "Girnock") %>%
  rename(year = Year, ova = Ova.Stock, rec = Ova.Recruit) %>%
  select(year, ova, rec)

