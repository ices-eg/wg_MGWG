rm(list = ls())
## Overview plots: weight, biomass per recruit, selectivity, catch, maturity
library(tidyverse)
library(gplots)  # rich.colors
source("selectivity/R/functions/stdline.R")

## 1  Import

setwd("selectivity/R/stocks")

source("e_baltic.R")
source("faroe_plateau.R")
source("georges_bank.R")
##source("greenland.R") ## no ssb
##source("gulf_of_maine.R") ## no ssb
source("iceland.R")
source("irish_sea.R")
# source("kattegat.R")  # no fatage
source("nafo_2j3kl.R")
source("nafo_3m.R")
source("nafo_3no.R")
# source("nafo_3ps.R")  # no fatage
source("ne_arctic.R")
source("north_sea.R")
source("norway.R")
source("s_celtic.R")
source("w_baltic.R")


setwd("..")

## 2  Identify stocks that are actively fished

## lwd <- 2
## stocks <- c("E Baltic", "Faroe Plateau", "Georges Bank", "Greenl inshore",
##             "Gulf of Maine", "Iceland", "Irish Sea", "NAFO 2J3KL", "NAFO 3M",
##             "NAFO 3NO", "NE Arctic", "North Sea", "Norw coastal", "S Celtic",
##             "W Baltic")
## col <- rich.colors(length(stocks))

## ## Fishing mortality
## plot(NA, xlim=c(1,14), ylim=c(0,1.2), yaxs="i",
##      xlab="Age", ylab="Fishing mortality", main="F in recent years")
## stdline(e_baltic$Fmort,      lwd, col[1])
## stdline(faroe_plateau$Fmort, lwd, col[2])
## stdline(georges_bank$Fmort,  lwd, col[3])
## stdline(greenland$Fmort,     lwd, col[4])
## stdline(gulf_of_maine$Fmort, lwd, col[5])
## stdline(iceland$Fmort,       lwd, col[6])
## stdline(irish_sea$Fmort,     lwd, col[7])
## stdline(nafo_2j3kl$Fmort,    lwd, col[8], lty=2)  # moratorium
## stdline(nafo_3m$Fmort,       lwd, col[9])
## stdline(nafo_3no$Fmort,      lwd, col[10], lty=2)  # moratorium
## stdline(ne_arctic$Fmort,     lwd, col[11], from=4, to=14)
## stdline(north_sea$Fmort,     lwd, col[12])
## stdline(norway$Fmort,        lwd, col[13])
## stdline(s_celtic$Fmort,      lwd, col[14])
## stdline(w_baltic$Fmort,      lwd, col[15])
## legend("topright", legend=stocks, bty="n", lty=1, lwd=lwd, col=col,
##        inset=0.02, cex=0.8)
## box()


## Weight
wcatch <- data.frame(t(bind_rows(e_baltic$wcatch,
                                 faroe_plateau$wcatch, georges_bank$wcatch,
                                 ##greenland$wcatch,
                                 ##gulf_of_maine$wcatch,
                                 iceland$wcatch,
                                 irish_sea$wcatch, nafo_2j3kl$wcatch,
                                 nafo_3m$wcatch,
                                 nafo_3no$wcatch, ne_arctic$wcatch,
                                 north_sea$wcatch,
                                 norway$wcatch, s_celtic$wcatch,
                                 w_baltic$wcatch)))
colnames(wcatch) <- c('Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                      ##'West Greenland' , 'Gulf of Maine' ,
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
                           'igf')))))))))))))
                    ##ifelse(Stock == 'Greenland' , 'igf',


pdf(file = '../chapter_plots/Fig1a.pdf')
wcatch %>%
    filter(region == 'ns',
    !is.na(wcatch)) %>%
    ggplot() +
    geom_line(aes(x = age, y = wcatch, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Mean weight (kg)') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 10, by = 1))
dev.off()
pdf(file = '../chapter_plots/Fig1b.pdf')
wcatch %>%
    filter(region == 'nus',
    !is.na(wcatch)) %>%
    ggplot() +
    geom_line(aes(x = age, y = wcatch, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Mean weight (kg)') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 14, by = 1))
dev.off()
pdf(file = '../chapter_plots/Fig1c.pdf')
wcatch %>%
    filter(region == 'igf',
    !is.na(wcatch)) %>%
    ggplot() +
    geom_line(aes(x = age, y = wcatch, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Mean weight (kg)') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 15, by = 1))
dev.off()


## maturity
mat <- data.frame(t(bind_rows(e_baltic$mat, faroe_plateau$mat,
                              georges_bank$mat,
                              ##greenland$mat, gulf_of_maine$mat,
                              iceland$mat,
                              irish_sea$mat, nafo_2j3kl$mat, nafo_3m$mat,
                              nafo_3no$mat, ne_arctic$mat, north_sea$mat,
                              norway$mat, s_celtic$mat, w_baltic$mat)))
colnames(mat) <- c('Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                   ##'West Greenland' , 'Gulf of Maine' ,
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
                           'igf')))))))))))))
                    ##ifelse(Stock == 'Greenland' , 'igf',


pdf(file = '../chapter_plots/Fig2a.pdf')
mat %>%
    filter(region == 'ns',
    !is.na(mat)) %>%
    ggplot() +
    geom_line(aes(x = age, y = mat, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Proportion mature') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 10, by = 1))
dev.off()
pdf(file = '../chapter_plots/Fig2b.pdf')
mat %>%
    filter(region == 'nus',
    !is.na(mat)) %>%
    ggplot() +
    geom_line(aes(x = age, y = mat, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Proportion mature') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 14, by = 1))
dev.off()
pdf(file = '../chapter_plots/Fig2c.pdf')
mat %>%
    filter(region == 'igf',
    !is.na(mat)) %>%
    ggplot() +
    geom_line(aes(x = age, y = mat, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Proportion mature') +
    xlab('Age') +
    scale_x_continuous(breaks = seq(0, 15, by = 1))
dev.off()



## SSB

SSB <-
tibble(left_join(
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
                                            left_join(e_baltic$SSB %>%
                                                      rename(eb = SSB),
                                                      faroe_plateau$SSB %>%
                                                      rename(fp = SSB)),
                                            georges_bank$SSB %>%
                                            rename(gb = SSB)),
                                        iceland$SSB  %>%
                                        rename(ic = SSB)),
                                    irish_sea$SSB  %>%
                                    rename(is = SSB)),
                                nafo_2j3kl$SSB  %>%
                                rename(nafo2j3kl = SSB)),
                            nafo_3m$SSB  %>% rename(nafo3m = SSB)),
                        nafo_3no$SSB  %>% rename(nafo3no = SSB)),
                    ne_arctic$SSB  %>% rename(nea = SSB)),
                north_sea$SSB  %>% rename(ns = SSB)),
            norway$SSB  %>% rename(no = SSB)),
        s_celtic$SSB  %>% rename(sc = SSB)),
    w_baltic$SSB  %>% rename(wb = SSB)))



SSB %>%
    summarize_all(mean)
colMeans(SSB, na.rm = TRUE)
(tibble(mean = round(colMeans(SSB, na.rm = TRUE))[-1])) %>%
     arrange(mean)
##small is, sc, wb, nafo3no, gb, fp,
##larger eb, ic, nafo3m, nea, ns, no, nafo2j3kl
round(colMeans(SSB, na.rm = TRUE))[-1]
    arrange(mean)

colnames(SSB) <- c('Year',
                   'Eastern Baltic', 'Faroe Plateau' , 'Georges Bank',
                   'Iceland',
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
                    ifelse(Stock == 'Georges Bank', 'm',
                    ifelse(Stock == 'Grand Bank', 'm',
                    ifelse(Stock == 'Faroe Plateau', 'm',
                    ifelse(Stock == 'Eastern Baltic', 'l',
                    ifelse(Stock == 'North Sea','m',
                    ifelse(Stock == 'Norway', 'l',
                    ifelse(Stock == 'Newfoundland', 'l',
                    ifelse(Stock == 'Flemish Cap', 'm',
                    ifelse(Stock == 'NE Arctic', 'l', 'l')))))))))))))



## SSB <-
##     SSB %>%
##     pivot_longer(!Year, names_to = 'Stock', values_to = 'SSB') %>%
##     arrange(Stock, Year) %>%
##     mutate(region = ifelse(Stock == 'Eastern Baltic', 'ns',
##                     ifelse(Stock == 'Irish Sea', 'ns',
##                     ifelse(Stock == 'North Sea','ns',
##                     ifelse(Stock == 'Norway', 'ns',
##                     ifelse(Stock == 'Southern Celtic', 'ns',
##                     ifelse(Stock == 'Western Baltic', 'ns',
##                     ifelse(Stock == 'Newfoundland', 'nus',
##                     ##ifelse(Stock == 'Gulf of Maine', 'nus',
##                     ##ifelse(Stock == 'Georges Bank', 'nus',
##                     ifelse(Stock == 'Flemish Cap', 'nus',
##                     ifelse(Stock == 'Grand Bank', 'nus',
##                     ifelse(Stock == 'NE Arctic', 'igf',
##                     ifelse(Stock == 'Faroe Plateau', 'igf',
##                     ifelse(Stock == 'Greenland' , 'igf', 'igf')))))))))))))


pdf(file = '../chapter_plots/Fig4a.pdf')
SSB2 %>%
    filter(region == 's',
    !is.na(SSB)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('SSB') +
    xlab('Year')
dev.off()
pdf(file = '../chapter_plots/Fig4b.pdf')
SSB2 %>%
    filter(region == 'm',
    !is.na(SSB)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('SSB') +
    xlab('Year')
dev.off()
pdf(file = '../chapter_plots/Fig4c.pdf')
SSB2 %>%
    filter(region == 'l',
    !is.na(SSB)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = SSB, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('SSB') +
    xlab('Year')
dev.off()

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
rec <- tibble(
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
    e_baltic$N      %>% select(Year, '3') %>% rename(eb = '3'),
    faroe_plateau$N %>% select(Year, '3') %>% rename(fp = '3')),##1000s
    georges_bank$N  %>% select(Year, '3') %>% rename(gb = '3')),##1000s
    iceland$N %>% select(Year, '3') %>% rename(ic = '3')), ##in 1000s
    irish_sea$N  %>% select(Year, '3') %>% rename(is = '3')),##in 1000s
    nafo_2j3kl$N %>% select(Year, '3') %>% rename(nfl = '3')),#
    nafo_3m$N %>% select(Year, '3') %>% rename(fc = '3')), ##1000s
    nafo_3no$N %>% select(Year, '3') %>% rename(grb = '3')),##1000
    ne_arctic$N %>% select(Year, '3') %>% rename(nea = '3')),##1000
    north_sea$N %>% select(Year, '3') %>% rename(ns = '3')),##1000
    norway$N %>% select(Year, '3') %>% rename(no = '3')),##1000
    s_celtic$N %>% select(Year, '3') %>% rename(sc = '3')),##1000
    w_baltic$N %>% select(Year, '3') %>% rename(wb = '3')##1000
   ) )

colnames(rec) <- c('Year',
                   'Eastern Baltic' , 'Faroe Plateau' , 'Georges Bank',
                   ##'Greenland' , 'Gulf of Maine' ,
                   'Iceland',
                   'Irish Sea' , 'Newfoundland' , 'Flemish Cap',
                   'Grand Bank' , 'NE Arctic' , 'North Sea',
                   'Norway' , 'Southern Celtic' , 'Western Baltic')

rec <-
    rec %>%
    pivot_longer(!Year, names_to = 'Stock', values_to = 'r3') %>%
    arrange(Stock, r3) %>%
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
                                'l')))))))))))))
                    ##ifelse(Stock == 'Greenland' , 'm',


rec <-
    rec %>%
    filter(!is.na(r3)) %>%
    arrange(Stock, Year) %>%
    group_by(Stock) %>%
    mutate(rel3 = r3/first(r3))
pdf(file = '../chapter_plots/Fig5v2a.pdf')
rec %>%
    filter(region == 's',
    !is.na(r3)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = rel3, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Relative change Recruitment Age 3') +
    xlab('Year')
dev.off()
pdf(file = '../chapter_plots/Fig5v2b.pdf')
rec %>%
    filter(region == 'm',
    !is.na(r3)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = rel3, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Relative change Recruitment Age 3') +
    xlab('Year')
dev.off()
pdf(file = '../chapter_plots/Fig5v2c.pdf')
rec %>%
    filter(region == 'l',
    !is.na(r3)) %>%
    ggplot() +
    geom_line(aes(x = Year, y = rel3, linetype = Stock)) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    ylab('Relative change Recruitment Age 3') +
    xlab('Year')
dev.off()



rec <-
    rec %>%
    group_by(Stock) %>%
    mutate(devR3 = r3 - mean(r3)) %>%
    print(n = Inf)

library(scales)

pdf(file = '../chapter_plots/Fig5.pdf')
rec %>%
    ggplot() +
    geom_bar(aes(x = Year, y = devR3), stat='identity') +
    theme_bw() +
    facet_wrap(.~Stock, scales = 'free', ncol = 2) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    scale_x_continuous(breaks= pretty_breaks()) +
    ##scale_y_continuous(breaks= pretty_breaks()) +
    ylab('Relative change Recruitment Age 3') +
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
