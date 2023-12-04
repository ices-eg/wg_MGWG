rm(list = ls())
## Overview plots: weight, biomass per recruit, selectivity, catch, maturity
library(tidyverse);library(gplots)  # rich.colors
library(scales); library(gridExtra)
source("selectivity/R/functions/stdline.R")

## 1  Import
##sag stocks
setwd("selectivity/R/sag/data")
temp <- list.files(pattern="\\.csv$")
temp <- setdiff(temp, "assessments.csv")
temp <- setdiff(temp, "assessments_all.csv")
sagstocks <- lapply(temp, read_csv)

temp <- str_remove(temp, "\\.csv$")
temp <- sub("faroe", "faroe_plateau", temp)
temp <- sub("irish", "irish_sea", temp)
names(sagstocks) <- temp

setwd("../../stocks")
source("e_baltic.R")
source("faroe_plateau.R")
source("georges_bank.R")
source("greenland.R")
##source("gulf_of_maine.R") ## no ssb
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



setwd("..")

## Weight
wcatch <- data.frame(t(bind_rows(e_baltic$wcatch,
                                 faroe_plateau$wcatch, georges_bank$wcatch,
                                 greenland$wcatch,
                                 ##gulf_of_maine$wcatch,
                                 iceland$wcatch,
                                 irish_sea$wcatch, nafo_2j3kl$wcatch,
                                 nafo_3m$wcatch,
                                 nafo_3no$wcatch, ne_arctic$wcatch,
                                 north_sea$wcatch,
                                 norway$wcatch, s_celtic$wcatch,
                                 w_baltic$wcatch)))
colnames(wcatch) <- c('Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                      'Greenland' , ##'Gulf of Maine' ,
                      'Iceland',
                      'Irish Sea' , 'Newfoundland' , 'Flemish Cap',
                      'Grand Bank' , 'NE Arctic' , 'North Sea',
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
                    ifelse(Stock == 'Newfoundland', 'nus',
                    ##ifelse(Stock == 'Gulf of Maine', 'nus',
                    ifelse(Stock == 'Georges Bank', 'nus',
                    ifelse(Stock == 'Flemish Cap', 'nus',
                    ifelse(Stock == 'Grand Bank', 'nus',
                    ifelse(Stock == 'NE Arctic', 'igf',
                    ifelse(Stock == 'Faroe Plateau', 'igf',
                    ifelse(Stock == 'Greenland' , 'igf',
                           'igf'))))))))))))))



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

pdf(file = 'chapter_plots/Fig1.pdf')
grid.arrange(wcns, wcnus, wcigf)
dev.off()


## maturity
mat <- data.frame(t(bind_rows(e_baltic$mat, faroe_plateau$mat,
                              georges_bank$mat,
                              greenland$mat, ##gulf_of_maine$mat,
                              iceland$mat,
                              irish_sea$mat, nafo_2j3kl$mat, nafo_3m$mat,
                              nafo_3no$mat, ne_arctic$mat, north_sea$mat,
                              norway$mat, s_celtic$mat, w_baltic$mat)))
colnames(mat) <- c('Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                   'Greenland' , ##'Gulf of Maine' ,
                   'Iceland',
                   'Irish Sea' , 'Newfoundland' , 'Flemish Cap',
                   'Grand Bank' , 'NE Arctic' , 'North Sea',
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
                    ifelse(Stock == 'Newfoundland', 'nus',
                    ##ifelse(Stock == 'Gulf of Maine', 'nus',
                    ifelse(Stock == 'Georges Bank', 'nus',
                    ifelse(Stock == 'Flemish Cap', 'nus',
                    ifelse(Stock == 'Grand Bank', 'nus',
                    ifelse(Stock == 'NE Arctic', 'igf',
                    ifelse(Stock == 'Faroe Plateau', 'igf',
                    ifelse(Stock == 'Greenland' , 'igf',
                           'igf'))))))))))))))

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
          panel.grid.major = element_blank()) +
    ylab('Proportion mature') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 15, by = 1))


pdf(file = 'chapter_plots/Fig2.pdf')
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
                                            left_join(sagstocks$e_baltic %>% select(Year, SSB) %>%
                                                      rename(eb = SSB),
                                                      sagstocks$faroe_plateau %>% select(Year, SSB) %>%
                                                      rename(fp = SSB)),
                                            sagstocks$greenland %>% select(Year, SSB) %>%
                                            rename(gl = SSB) %>%
                                        filter(Year < 2021)),
                                            georges_bank$SSB %>%
                                            rename(gb = SSB)),
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
                   'Georges Bank', 'Iceland',
                   'Irish Sea' , 'Newfoundland' , 'Flemish Cap',
                   'Grand Bank' , 'NE Arctic' , 'North Sea',
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
                    ifelse(Stock == 'Grand Bank', 'm',
                    ifelse(Stock == 'Faroe Plateau', 'm',
                    ifelse(Stock == 'Eastern Baltic', 'l',
                    ifelse(Stock == 'North Sea','l',
                    ifelse(Stock == 'Norway', 'm',
                    ifelse(Stock == 'Newfoundland', 'l',
                    ifelse(Stock == 'Flemish Cap', 'm',
                    ifelse(Stock == 'NE Arctic', 'l', 'l'))))))))))))))


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

pdf(file = 'chapter_plots/Fig4.pdf')
grid.arrange(ssbs, ssbm, ssbl)
dev.off()


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
 sagstocks$e_baltic %>% select(Year, Rec, RecAge) %>% rename(ebR = Rec, ebRA = RecAge),
 sagstocks$faroe_plateau %>% select(Year, Rec, RecAge) %>%  rename(fpR = Rec, fpRA = RecAge)),
 georges_bank$N  %>% select(Year, '1') %>% rename(gbR = '1') %>% mutate(gbRA = 1)),##1000s
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
                      'Georges Bank (age 1)',
                      'Greenland (age 1)', ##'Gulf of Maine' ,
                      'Iceland (age 3)',
                      'Irish Sea (age 0)' , 'Newfoundland (age 2)', 'Flemish Cap (age 1)',
                      'Grand Bank (age 3)', 'NE Arctic (age 3)', 'North Sea (age 1)',
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
                    ifelse(Stock == 'Faroe Plateau', 'm',
                    ifelse(Stock == 'Eastern Baltic', 'l',
                    ifelse(Stock == 'North Sea','m',
                    ifelse(Stock == 'Norway', 'l',
                    ifelse(Stock == 'Newfoundland', 'l',
                    ##ifelse(Stock == 'Gulf of Maine', 's',
                    ifelse(Stock == 'Flemish Cap', 'm',
                    ifelse(Stock == 'NE Arctic', 'l',
                    ifelse(Stock == 'Greenland' , 's', 'l')))))))))))))) %>%
        arrange(Stock, Year)

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



pdf(file = 'chapter_plots/Fig5.pdf')
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


## pdf(file = '../chapter_plots/Fig5v3a.pdf')
## rec %>%
##     filter(region == 's') %>%
##     ggplot() +
##     geom_bar(aes(x = Year, y = devR3), stat='identity') +
##     facet_wrap(.~Stock, ncol = 1) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Deviations from mean Recruitment Age 3') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig5v3b.pdf')
## rec %>%
##     filter(region == 'm') %>%
##     ggplot() +
##     geom_bar(aes(x = Year, y = devR3), stat='identity') +
##     facet_wrap(.~Stock, ncol = 1) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Deviations from mean Recruitment Age 3') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig5v3c.pdf')
## rec %>%
##     filter(region == 'l') %>%
##     ggplot() +
##     geom_bar(aes(x = Year, y = devR3), stat='identity') +
##     facet_wrap(.~Stock, ncol = 1) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Deviations from mean Recruitment Age 3') +
##     xlab('Year')
## dev.off()


## rec <-
##     rec %>%
##     group_by(Stock) %>%
##     mutate(devR3v2 = devR3/ mean(r3)) %>%
##     print(n = Inf)
## pdf(file = '../chapter_plots/Fig5v4a.pdf')
## rec %>%
##     filter(region == 's') %>%
##     ggplot() +
##     geom_bar(aes(x = Year, y = devR3v2), stat='identity') +
##     facet_wrap(.~Stock, ncol = 1) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Deviations from mean Recruitment Age 3') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig5v4b.pdf')
## rec %>%
##     filter(region == 'm') %>%
##     ggplot() +
##     geom_bar(aes(x = Year, y = devR3v2), stat='identity') +
##     facet_wrap(.~Stock, ncol = 1) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Deviations from mean Recruitment Age 3') +
##     xlab('Year')
## dev.off()
## pdf(file = '../chapter_plots/Fig5v4c.pdf')
## rec %>%
##     filter(region == 'l') %>%
##     ggplot() +
##     geom_bar(aes(x = Year, y = devR3v2), stat='identity') +
##     facet_wrap(.~Stock, ncol = 1) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Deviations from mean Recruitment Age 3') +
##     xlab('Year')
## dev.off()


## pdf(file = '../../chapter_plots/Fig5a.pdf')
## rec %>%
##     filter(region == 'ns',
##     !is.na(r3)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = r3, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Recruitment Age 3 (1000s)') +
##     xlab('Year')
## dev.off()
## pdf(file = '../../chapter_plots/Fig5b.pdf')
## rec %>%
##     filter(region == 'nus',
##     !is.na(r3)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = r3, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Recruitment Age 3 (1000s)') +
##     xlab('Year')
## dev.off()
## pdf(file = '../../chapter_plots/Fig5c.pdf')
## rec %>%
##     filter(region == 'igf',
##     !is.na(r3)) %>%
##     ggplot() +
##     geom_line(aes(x = Year, y = r3, linetype = Stock)) +
##     theme_bw() +
##     theme(panel.grid.minor = element_blank(),
##           panel.grid.major = element_blank()) +
##     ylab('Recruitment Age 3 (1000s)') +
##     xlab('Year')
## dev.off()