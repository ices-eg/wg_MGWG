rm(list = ls())
## Overview plots: weight, biomass per recruit, selectivity, catch, maturity
library(tidyverse);library(gplots)  # rich.colors
library(scales); library(gridExtra)
source("../functions/stdline.R")

## 1  Import
##sag stocks

temp <- list.files("../ices_sag/data", pattern="\\.csv$", full=TRUE)
temp <- temp[basename(temp) != "assessments.csv"]
temp <- temp[basename(temp) != "assessments_all.csv"]
sagstocks <- lapply(temp, read_csv)

temp <- basename(str_remove(temp, "\\.csv$"))
temp <- sub("faroe", "faroe_plateau", temp)
temp <- sub("irish", "irish_sea", temp)
names(sagstocks) <- temp

##need ssb and landings for
##georges bank ssb mt landings mt
##nafo_2j3kl ssb tonnes landings tonnes
##nafo_3m ssb tonnes landings tonnes
##nafo_3no SSB and landings tonnes
owd <- setwd("../stocks")
source("e_baltic.R")
source("faroe_plateau.R")
source("georges_bank.R")
source("greenland.R")
source("gulf_of_maine.R") ## no ssb
source("iceland.R")
source("irish_sea.R")
# source("kattegat.R")  # no fatage
source("nafo_2j3kl.R") ##newfoundland
source("nafo_3m.R") ##flemish
source("nafo_3no.R") ##grand bank
# source("nafo_3ps.R")  # no fatage
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("s_celtic.R")
source("w_baltic.R")
setwd(owd)






## Weight
wcatch <- data.frame(t(bind_rows(e_baltic$wcatch,
                                 faroe_plateau$wcatch, georges_bank$wcatch,
                                 greenland$wcatch,
                                 gulf_of_maine$wcatch,
                                 iceland$wcatch,
                                 irish_sea$wcatch, nafo_2j3kl$wcatch,
                                 nafo_3m$wcatch,
                                 nafo_3no$wcatch, ne_arctic$wcatch,
                                 north_sea$wcatch,
                                 norway$wcatch, s_celtic$wcatch,
                                 w_baltic$wcatch)))
colnames(wcatch) <- c('Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                      'Greenland' , 'Gulf of Maine' ,
                      'Iceland',
                      'Irish Sea' , 'Northern' , 'Flemish Cap',
                      'Grand Bank' , 'Northeast Arctic' , 'North Sea',
                      'Norway' , 'Southern Celtic' , 'Western Baltic')

wcatch <-
    wcatch %>%
    mutate(age = 1:15) %>%
    relocate(age) %>%
    pivot_longer(!age, names_to = 'Stock', values_to = 'wcatch') %>%
    arrange(Stock, age) %>%
    mutate(region = ifelse(Stock == 'Eastern Baltic', 'ns',
                    ifelse(Stock == 'Irish Sea', 'ns',
                    ifelse(Stock == 'North Sea','ns',
                    ifelse(Stock == 'Norway', 'ns',
                    ifelse(Stock == 'Southern Celtic', 'ns',
                    ifelse(Stock == 'Western Baltic', 'ns',
                    ifelse(Stock == 'Northern', 'nus',
                    ifelse(Stock == 'Gulf of Maine', 'nus',
                    ifelse(Stock == 'Georges Bank', 'nus',
                    ifelse(Stock == 'Flemish Cap', 'nus',
                    ifelse(Stock == 'Grand Bank', 'nus',
                    ifelse(Stock == 'Northeast Arctic', 'igf',
                    ifelse(Stock == 'Faroe Plateau', 'igf',
                    ifelse(Stock == 'Greenland' , 'igf',
                           'igf')))))))))))))))



wcns <-
    wcatch %>%
    filter(region == 'ns') %>%
    ggplot() +
    geom_line(aes(x = age, y = wcatch, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Mean weight (kg)') +
    xlab('') +
    scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, by = 2)) +
    scale_x_continuous(breaks = seq(1, 15, by = 1)) +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank())
wcnus <-
    wcatch %>%
    filter(region == 'nus') %>%
    ggplot() +
    geom_line(aes(x = age, y = wcatch, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Mean weight (kg)') +
    xlab('') +
    scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, by = 2)) +
    scale_x_continuous(breaks = seq(1, 15, by = 1)) +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          legend.title=element_blank())
wcigf <-
    wcatch %>%
    filter(region == 'igf') %>%
    ggplot() +
    geom_line(aes(x = age, y = wcatch, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Mean weight (kg)') +
    xlab('Age') +
    scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, by = 2)) +
    scale_x_continuous(breaks = seq(1, 15, by = 1)) +
    theme(legend.title=element_blank())

pdf(file = '../../chapter_plots/Fig1.pdf')
grid.arrange(wcns, wcnus, wcigf)
dev.off()


## maturity
mat <- data.frame(t(bind_rows(e_baltic$mat, faroe_plateau$mat,
                              georges_bank$mat,
                              greenland$mat, gulf_of_maine$mat,
                              iceland$mat,
                              irish_sea$mat, nafo_2j3kl$mat, nafo_3m$mat,
                              nafo_3no$mat, ne_arctic$mat, north_sea$mat,
                              norway$mat, s_celtic$mat, w_baltic$mat)))
colnames(mat) <- c('Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                   'Greenland' , 'Gulf of Maine' ,
                   'Iceland',
                   'Irish Sea' , 'Northern' , 'Flemish Cap',
                   'Grand Bank' , 'Northeast Arctic' , 'North Sea',
                   'Norway' , 'Southern Celtic' , 'Western Baltic')

mat <-
    mat %>%
    mutate(age = 1:15) %>%
    relocate(age) %>%
    pivot_longer(!age, names_to = 'Stock', values_to = 'mat') %>%
    arrange(Stock, age) %>%
    mutate(region = ifelse(Stock == 'Eastern Baltic', 'ns',
                    ifelse(Stock == 'Irish Sea', 'ns',
                    ifelse(Stock == 'North Sea','ns',
                    ifelse(Stock == 'Norway', 'ns',
                    ifelse(Stock == 'Southern Celtic', 'ns',
                    ifelse(Stock == 'Western Baltic', 'ns',
                    ifelse(Stock == 'Northern', 'nus',
                    ifelse(Stock == 'Gulf of Maine', 'nus',
                    ifelse(Stock == 'Georges Bank', 'nus',
                    ifelse(Stock == 'Flemish Cap', 'nus',
                    ifelse(Stock == 'Grand Bank', 'nus',
                    ifelse(Stock == 'Northeast Arctic', 'igf',
                    ifelse(Stock == 'Faroe Plateau', 'igf',
                    ifelse(Stock == 'Greenland' , 'igf',
                           'igf')))))))))))))))

matns <-
    mat %>%
    filter(region == 'ns') %>%
    ggplot() +
    geom_line(aes(x = age, y = mat, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Proportion mature') +
    xlab('') +
    scale_x_continuous(breaks = seq(0, 15, by = 1)) +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank())
matnus <-
    mat %>%
    filter(region == 'nus') %>%
    ggplot() +
    geom_line(aes(x = age, y = mat, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Proportion mature') +
    xlab('') +
    scale_x_continuous(breaks = seq(0, 15, by = 1)) +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          legend.title=element_blank())
matigf <-
    mat %>%
    filter(region == 'igf') %>%
    ggplot() +
    geom_line(aes(x = age, y = mat, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          legend.title=element_blank()) +
    ylab('Proportion mature') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 15, by = 1))

getwd()
pdf(file = '../../chapter_plots/Fig2.pdf')
grid.arrange(matns, matnus, matigf)
dev.off()

## SSB



SSB <-
    tibble(
        left_join(
            left_join(
            left_join(
            left_join(
        left_join(
            left_join(
                left_join(
                    left_join(
                        left_join(
                            left_join(
                                left_join(
                                    left_join(
                                        left_join(
                                            left_join(sagstocks$e_baltic %>% select(Year, SSB) %>%
                                                      rename(eb = SSB),
                                                      sagstocks$faroe_plateau %>% select(Year, SSB) %>%
                                                      rename(fp = SSB)),
                                            sagstocks$greenland %>% select(Year, SSB) %>%
                                            rename(gl = SSB) %>%
                                        filter(Year < 2021)),
                                            georges_bank$SSB %>%
                                            rename(gb = SSB)),
                                            gulf_of_maine$SSB %>%
                                            rename(gm=SSB)),
                                    sagstocks$iceland %>% select(Year, SSB) %>% rename(ic = SSB)),
                                sagstocks$irish_sea %>% select(Year, SSB) %>% rename(is = SSB)),
                            nafo_2j3kl$SSB  %>% rename(nafo2j3kl = SSB)),
                        nafo_3m$SSB  %>% rename(nafo3m = SSB)),
                    nafo_3no$SSB  %>% rename(nafo3no = SSB)),
                sagstocks$ne_arctic %>% select(Year, SSB) %>% rename(nea = SSB)),
            sagstocks$north_sea %>% select(Year, SSB) %>% rename(ns = SSB)),
        sagstocks$norway %>% select(Year, SSB) %>% rename(no = SSB)),
        sagstocks$s_celtic %>% select(Year, SSB) %>% rename(sc = SSB)),
        sagstocks$w_baltic %>% select(Year, SSB) %>% rename(wb = SSB)))


colnames(SSB) <- c('Year',
                   'Eastern Baltic', 'Faroe Plateau' , 'Greenland',
                   'Georges Bank', 'Gulf of Maine', 'Iceland',
                   'Irish Sea' , 'Northern' , 'Flemish Cap',
                   'Grand Bank' , 'Northeast Arctic' , 'North Sea',
                   'Norway' , 'Southern Celtic' , 'Western Baltic')

SSB2 <-
    SSB %>%
    pivot_longer(!Year, names_to = 'Stock', values_to = 'SSB') %>%
    arrange(Stock, Year) %>%
    mutate(region = ifelse(Stock == 'Southern Celtic', 's',
                    ifelse(Stock == 'Western Baltic', 's',
                    ifelse(Stock == 'Irish Sea', 's',
                    ifelse(Stock == 'Greenland', 's',
                    ifelse(Stock == 'Georges Bank', 'm',
                    ifelse(Stock == 'Gulf of Maine', 's',
                    ifelse(Stock == 'Grand Bank', 'm',
                    ifelse(Stock == 'Faroe Plateau', 'm',
                    ifelse(Stock == 'Eastern Baltic', 'l',
                    ifelse(Stock == 'North Sea','l',
                    ifelse(Stock == 'Norway', 'm',
                    ifelse(Stock == 'Northern', 'l',
                    ifelse(Stock == 'Flemish Cap', 'm',
                    ifelse(Stock == 'Northeast Arctic', 'l', 'l')))))))))))))))


ssbs <-
    SSB2 %>%
    filter(region == 's',
    !is.na(SSB)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    scale_y_continuous(labels = scientific) +
    lims(x = c(1946, 2023)) +
    ylab('SSB') +
    xlab('')  +
    theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
ssbm <-
    SSB2 %>%
    filter(region == 'm',
    !is.na(SSB)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    scale_y_continuous(labels = scientific) +
    lims(x = c(1946, 2023)) +
    ylab('SSB') +
    xlab('')  +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          legend.title=element_blank())
ssbl <-
    SSB2 %>%
    filter(region == 'l',
    !is.na(SSB)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    lims(x = c(1946, 2023)) +
#    scale_y_continuous(labels = scientific) +
    ylab('SSB') +
    xlab('Year') +
    theme(legend.title=element_blank()) +
    scale_x_continuous(breaks = seq(1950, 2020, by = 10)) +
    scale_y_continuous(breaks = seq(0, 2e6, by = 1e6))

pdf(file = '../../chapter_plots/Fig4.pdf')
grid.arrange(ssbs, ssbm, ssbl)
dev.off()

SSB2 %>%
    group_by(Stock) %>%
    filter(!is.na(SSB)) %>%
    mutate(maxSSB = max(SSB)) %>%
    mutate(prSSB = SSB/maxSSB) %>%
    summarize(min = min(prSSB)) %>%
    arrange(min)

SSB2 %>%
    ggplot(aes(x = Year, y = SSB))+
    geom_line() +
    facet_wrap(.~Stock, scales = 'free')

SSB2 %>%
    filter(region == 'l',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/1e5) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB > 1)

SSB2 %>%
    filter(region == 'l',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/5e5) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB < 1)


SSB2 %>%
    filter(region == 'm',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/5e5) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB > 1)


SSB2 %>%
    filter(region == 'm',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/2e5) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB < 1)


SSB2 %>%
    filter(region == 'm',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/1e4) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB < 1)



SSB2 %>%
    filter(region == 's',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/1e5) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB > 1)


SSB2 %>%
    filter(region == 's',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/1e4) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB > 1)


SSB2 %>%
    filter(region == 's',
           !is.na(SSB)) %>%
    mutate(SSB = SSB/1e4) %>%
    group_by(Stock) %>%
    summarize(SSB = mean(SSB)) %>%
    filter(SSB < 1)


## pdf(file = '../chapter_plots/Fig4a.pdf')
## SSB %>%
##     filter(region == 'ns',
##     !is.na(SSB)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('SSB') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig4b.pdf')
## SSB %>%
##     filter(region == 'nus',
##     !is.na(SSB)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('SSB') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig4c.pdf')
## SSB %>%
##     filter(region == 'igf',
##     !is.na(SSB)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('SSB') +
##     xlab('Year')
## dev.off()








##recruitment
rec <- tibble(full_join(
    full_join(
        full_join(
            full_join(
                full_join(
                    full_join(
                        full_join(
                            full_join(
                                full_join(
                                    full_join(
                                        full_join(
                                            full_join(
                                                full_join(
                                                full_join(
 sagstocks$e_baltic %>% select(Year, Rec, RecAge) %>% rename(ebR = Rec, ebRA = RecAge),
 sagstocks$faroe_plateau %>% select(Year, Rec, RecAge) %>%  rename(fpR = Rec, fpRA = RecAge)),
 georges_bank$N  %>% select(Year, '1') %>% rename(gbR = '1') %>% mutate(gbRA = 1)),##1000s
 gulf_of_maine$N %>% select(Year, '1') %>% rename(gmR = '1') %>% mutate(gmRA = 1)),##1000s
 sagstocks$greenland %>% select(Year, Rec, RecAge) %>%  rename(glR = Rec, glRA = RecAge)),
 sagstocks$iceland   %>% select(Year, Rec, RecAge) %>%  rename(icR = Rec, icRA = RecAge)),
 sagstocks$irish_sea %>% select(Year, Rec, RecAge) %>%  rename(isR = Rec, isRA = RecAge)),
 nafo_2j3kl$N %>% select(Year, '2') %>% rename(nflR = '2') %>% mutate(nflRA = 2)),#
 nafo_3m$N    %>% select(Year, '1') %>% rename(fcR = '1') %>% mutate(fcRA = 1) ), ##1000s
 nafo_3no$N %>% select(Year, '3') %>% rename(grbR = '3') %>% mutate(grbRA = 3)),##1000
 sagstocks$ne_arctic %>% select(Year, Rec, RecAge) %>%  rename(neaR = Rec, neaRA = RecAge)),
 sagstocks$north_sea %>% select(Year, Rec, RecAge) %>%  rename(nsR = Rec, nsRA = RecAge)),
 sagstocks$norway %>% select(Year, Rec, RecAge) %>%   rename(noR = Rec, noRA = RecAge)),
 sagstocks$s_celtic %>% select(Year, Rec, RecAge) %>%  rename(scR = Rec, scRA = RecAge)),
 sagstocks$w_baltic %>% select(Year, Rec, RecAge) %>%  rename(wbR = Rec, wbRA = RecAge)))

tail(rec) %>%
    print(width = Inf)

recAge <-
    rec %>%
     select(Year, contains("RA"))
rec <-
    rec %>%
    select(!contains("RA"))
colnames(rec) <-    c('Year',
                      'Eastern Baltic (age 0)', 'Faroe Plateau  (age 1)',
                      'Georges Bank (age 1)', 'Gulf of Maine (age 1)',
                      'Greenland (age 1)',
                      'Iceland (age 3)',
                      'Irish Sea (age 0)' , 'Northern (age 2)', 'Flemish Cap (age 1)',
                      'Grand Bank (age 3)', 'Northeast Arctic (age 3)', 'North Sea (age 1)',
                      'Norway (age 2)', 'Southern Celtic (age 1)', 'Western Baltic (age 1)')

rec <-
    rec %>%
    pivot_longer(!Year, names_to = 'Stock', values_to = 'R') %>%
    arrange(Stock, R) %>%
    mutate(region = ifelse(Stock == 'Southern Celtic', 's',
                    ifelse(Stock == 'Western Baltic', 's',
                    ifelse(Stock == 'Irish Sea', 's',
                    ifelse(Stock == 'Georges Bank', 'm',
                    ifelse(Stock == 'Grand Bank', 'm',
                    ifelse(Stock == 'Gulf of Maine', 'm',
                    ifelse(Stock == 'Faroe Plateau', 'm',
                    ifelse(Stock == 'Eastern Baltic', 'l',
                    ifelse(Stock == 'North Sea','m',
                    ifelse(Stock == 'Norway', 'l',
                    ifelse(Stock == 'Northern', 'l',
                    ifelse(Stock == 'Gulf of Maine', 's',
                    ifelse(Stock == 'Flemish Cap', 'm',
                    ifelse(Stock == 'Northeast Arctic', 'l',
                    ifelse(Stock == 'Greenland' , 's', 'l')))))))))))))))) %>%
        arrange(Stock, Year)


rec %>%
    group_by(Stock) %>%
    filter(!is.na(R)) %>%
    mutate(maxR = max(R)) %>%
    mutate(prR = R/maxR) %>%
    summarize(min = min(prR)) %>%
    arrange(min)

#rec <-
    rec %>%
    filter(!is.na(R)) %>%
    arrange(Stock, Year) %>%
    group_by(Stock) %>%
    mutate(relR = R/first(R))

## pdf(file = '../chapter_plots/Fig5v2a.pdf')
## rec %>%
##     filter(region == 's',
##     !is.na(r3)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = rel3, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Relative change Recruitment Age 3') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig5v2b.pdf')
## rec %>%
##     filter(region == 'm',
##     !is.na(r3)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = rel3, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Relative change Recruitment Age 3') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig5v2c.pdf')
## rec %>%
##     filter(region == 'l',
##     !is.na(r3)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = rel3, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Relative change Recruitment Age 3') +
##     xlab('Year')
## dev.off()



recdev <-
    rec %>%
    group_by(Stock) %>%
    mutate(devR = R - mean(R, na.rm = TRUE)) %>%
    print(n = Inf)



pdf(file = '../../chapter_plots/Fig5.pdf')
recdev %>%
    ggplot() +
    geom_hline(yintercept = 0, color = 'grey') +
    geom_bar(aes(x = Year, y = devR), stat='identity') +
    theme_bw() +
    facet_wrap(.~Stock, scales = 'free_y', ncol = 2) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    scale_y_continuous(labels = scientific) +
    scale_x_continuous(breaks = seq(1950, 2020, by = 10)) +
    ylab('Recruitment deviations from mean') +
    xlab('Year')
dev.off()


##landings
sagstocks

gbland  <- read_csv('../../data/georges_bank/landings.csv')
gmland  <- read.csv('../../data/gulf_of_maine/landings.csv')
nflland <- read_csv('../../data/nafo_2j3kl/landings.csv')
flland  <- read_csv('../../data/nafo_3m/landings.csv')
grbland <- read_csv('../../data/nafo_3no/landings.csv')
grlland <- read_csv('../../data/greenland/landings.csv')
##georges bank ssb and landings mt
##nafo_2j3kl nfl ssb and landings tonnes
##nafo_3m flemish ssb tonnes landings tonnes
##nafo_3no grand bank SSB and landings tonnes



##landings
land <- tibble(full_join(
    full_join(
        full_join(
            full_join(
                full_join(
                    full_join(
                        full_join(
                            full_join(
                                full_join(
                                    full_join(
                                        full_join(
                                            full_join(
                                                full_join(
                                                full_join(
 sagstocks$e_baltic %>% select(Year, Landings) %>% rename(ebL = Landings), ##tonnes
 sagstocks$faroe_plateau %>% select(Year, Landings) %>%  rename(fpL = Landings)), ##tonnes
 gbland  %>%  select(Year, Landings) %>% rename(gbL = Landings)), ##tonnes
 grlland  %>%  rename(glL = Landings)), ##tonnes
 gmland  %>%  select(Year, Landings) %>% rename(gmL = Landings)), ##tonnes
 sagstocks$iceland   %>% select(Year, Landings) %>% rename(icL = Landings)), ##tonnes
 sagstocks$irish_sea %>% select(Year, Landings) %>%  rename(isL = Landings)), ##??
 nflland %>% rename(nflL = Landings)),  ##tonnes
 flland %>% rename(fcL = Landings)),  ##tonnes
 grbland %>% rename(grbL = Landings)),  ##tonnes
 sagstocks$ne_arctic %>% select(Year, Landings) %>%  rename(neaL = Landings)),
 sagstocks$north_sea %>% select(Year, Landings) %>%  rename(nsL = Landings)), ##tonnes
 sagstocks$norway %>% select(Year, Landings) %>%   rename(noL = Landings)), ##tonnes
 sagstocks$s_celtic %>% select(Year, Landings) %>%  rename(scL = Landings)), ##tonnes
 sagstocks$w_baltic %>% select(Year, Landings) %>%  rename(wbL = Landings))) ##tonnes

tail(land, 13) %>%
    print(width = Inf)


colnames(land) <-    c('Year',
                       'Eastern Baltic', 'Faroe Plateau',
                       'Georges Bank',
                       'Greenland', 'Gulf of Maine',
                       'Iceland',
                       'Irish Sea' , 'Northern', 'Flemish Cap',
                       'Grand Bank', 'Northeast Arctic', 'North Sea',
                       'Norway', 'Southern Celtic', 'Western Baltic')
land <-
land %>%
    pivot_longer(!Year, names_to = 'Stock', values_to = 'Landings') %>%
    arrange(Stock, Landings)


landdev <-
    land %>%
    group_by(Stock) %>%
    mutate(devL = Landings - mean(Landings, na.rm = TRUE)) %>%
    print(n = Inf)


pdf(file = '../../chapter_plots/Fig6.pdf')
landdev %>%
    ggplot() +
    geom_hline(yintercept = 0, color = 'grey') +
    geom_bar(aes(x = Year, y = Landings), stat='identity') +
    theme_bw() +
    facet_wrap(.~Stock, scales = 'free_y', ncol = 2) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    scale_y_continuous(labels = scientific) +
    scale_x_continuous(breaks = seq(1950, 2020, by = 10)) +
    ylab('Landings (tonnes)') +
    xlab('Year')
dev.off()


#pdf(file = 'chapter_plots/Fig5.pdf')
landdev %>%
    ggplot() +
    geom_hline(yintercept = 0, color = 'grey') +
    geom_bar(aes(x = Year, y = devL), stat='identity') +
    theme_bw() +
    facet_wrap(.~Stock, scales = 'free_y', ncol = 2) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    scale_y_continuous(labels = scientific) +
    scale_x_continuous(breaks = seq(1950, 2020, by = 10)) +
    ylab('Landings deviations from mean') +
    xlab('Year')



##fbar for 2j
ebf <- read_csv('../../data/e_baltic/fbar.csv')      %>% rename(eb = F4_6)
fpf <- read_csv('../../data/faroe_plateau/fbar.csv') %>% rename(fp = F3_7)
gbf <- read_csv('../../data/georges_bank/fbar.csv')  %>% rename(gb = F5_8)
glf <- read_csv('../../data/greenland/fbar.csv')     %>% rename(gl = F4_8)
gmf <- read_csv('../../data/gulf_of_maine/fbar.csv') %>% rename(gm = F7_9)
icf <- read_csv('../../data/iceland/fbar.csv')       %>% rename(ic = F5_10)
isf <- read_csv('../../data/irish_sea/fbar.csv')     %>% rename(is = F2_4)
fcf <- read_csv('../../data/nafo_3m/fbar.csv')       %>% rename(fc = F3_5)
grf1 <- read_csv('../../data/nafo_3no/fbar.csv')     %>% rename(gr1 = F4_6) %>% select(-F6_9)
#grf2 <- read_csv('../../data/nafo_3no/fbar.csv')     %>% rename(gr1 = F6_9) %>% select(-F4_6)
neaf <- read_csv('../../data/ne_arctic/fbar.csv')   %>% rename(nea = F5_10)
nflf <- read_csv('../../data/nafo_2j3kl/fbar.csv')  %>% rename(nfl = F7_9)
nsf <- read_csv('../../data/north_sea/fbar.csv')    %>% rename(ns = F2_4)
nof <- read_csv('../../data/norway/fbar.csv')       %>% rename(no = F4_7)
scf <- read_csv('../../data/s_celtic/fbar.csv')     %>% rename(sc = F2_5)
wbf <- read_csv('../../data/w_baltic/fbar.csv')     %>% rename(wb = F3_5)
fbar <-
    left_join(
    left_join(
    left_join(
    left_join(
    left_join(
        left_join(
            left_join(
                left_join(
                    left_join(
                        left_join(
                            left_join(
                                left_join(
                                    left_join(
                            left_join(ebf, fpf), gbf), glf), gmf), icf), isf), fcf), grf1), neaf), nflf), nsf),
        nof), scf), wbf)


colnames(fbar) <-    c('Year',
                       'Eastern Baltic (F4-6)',
                       'Faroe Plateau  (F3-7)',
                      'Georges Bank (F5-8)',
                      'Greenland (F4-8)', 'Gulf of Maine (F7-9)' ,
                      'Iceland (F5-10)',
                      'Irish Sea (F2-4)' ,
                      'Flemish Cap (F3-5)',
                      'Grand Bank (F4-6)', 'Northeast Arctic (F5-10)',  'Northern (F7-9)', 'North Sea (F2-4)',
                      'Norway (F4-7)', 'Southern Celtic (F2-5)', 'Western Baltic (F3-5)')

getwd()

pdf(file = '../../chapter_plots/Fig7.pdf')
fbar %>%
    pivot_longer(!Year, names_to = 'Stock', values_to = 'fbar') %>%
    ggplot(aes(y = fbar, x = Year)) +
    geom_line() +
    facet_wrap(.~Stock, ncol = 2) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
              panel.grid.major = element_blank()) +
    scale_x_continuous(breaks = seq(1950, 2020, by = 10)) +
    ylab('Fbar') +
    xlab('Year')
dev.off()



## ebfba <- read_csv('../data/e_baltic/fbar.csv')      %>% mutate(fbarage = 'F4-6') %>% select(Year, fbarage)
## fpfba <- read_csv('../data/faroe_plateau/fbar.csv') %>% mutate(fbarage = 'F3-7') %>% select(Year, fbarage)
## gbfba <- read_csv('../data/georges_bank/fbar.csv')  %>% mutate(fbarage = 'F5-8') %>% select(Year, fbarage)
## glfba <- read_csv('../data/greenland/fbar.csv')     %>% mutate(fbarage = 'F4-8') %>% select(Year, fbarage)
## icfba <- read_csv('../data/iceland/fbar.csv')       %>% mutate(fbarage = 'F5-10') %>% select(Year, fbarage)
## isfba <- read_csv('../data/irish_sea/fbar.csv')     %>% mutate(fbarage = 'F5-10') %>% select(Year, fbarage)
## fcfba <- read_csv('../data/nafo_3m/fbar.csv')       %>% mutate(fbarage = 'F3-5') %>% select(Year, fbarage)
## grf1ba <- read_csv('../data/nafo_3no/fbar.csv')     %>% mutate(fbarage = 'F4-6') %>%
##     select(-F6_9) %>% select(Year, fbarage)
## grf2ba <- read_csv('../data/nafo_3no/fbar.csv')    %>% mutate(fbarage = 'F6-9') %>%
##     select(-F4_6) %>% select(Year, fbarage)
## neafba <- read_csv('../data/ne_arctic/fbar.csv')   %>% mutate(fbarage = 'F5-10') %>% select(Year, fbarage)
## nsfba <- read_csv('../data/north_sea/fbar.csv')    %>% mutate(fbarage = 'F2-4') %>% select(Year, fbarage)
## nofba <- read_csv('../data/norway/fbar.csv')       %>% mutate(fbarage = 'F4-7') %>% select(Year, fbarage)
## scfba <- read_csv('../data/s_celtic/fbar.csv')     %>% mutate(fbarage = 'F2-5') %>% select(Year, fbarage)
## wbfba <- read_csv('../data/w_baltic/fbar.csv')     %>% mutate(fbarage = 'F3-5') %>% select(Year, fbarage)

## fbarage <-
##     bind_rows(
##     bind_rows(
##     bind_rows(
##         bind_rows(
##             bind_rows(
##                 bind_rows(
##                     bind_rows(
##                         bind_rows(
##                             bind_rows(
##                                 bind_rows(
##                                     bind_rows(
##                                         bind_rows(ebfba, fpfba), gbfba), glfba), icfba), isfba), fcfba), grf1ba),
##                 neafba), nsfba),
##         nofba), scfba), wbfba)
## fbarage
