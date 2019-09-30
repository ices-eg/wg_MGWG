
stop('do not source')
### Some manual code to get FMSY for the different cases of
### selex, do this manually. First run it with the default
### "original" selex setup.
unlink('fmsy', recursive=TRUE)
fmsy0 <- profile_fmsy(om,
                     results_out='fmsy',
                     start=.02, end=.05, by=.001)
## Now manually change the OM .ctl file that is in the O1 case
## file and run it again
unlink('fmsy', recursive=TRUE)
fmsy1 <- profile_fmsy(om,
                     results_out='fmsy',
                     start=.01, end=.025, by=.0001)
## Plot it and check
plot(fmsy0, type='b', ylim=range(c(fmsy0[,2], fmsy1[,2])),
     xlim=range(c(fmsy0[,1], fmsy1[,1])))
lines(fmsy1, col=2, type='b')
abline(v=fmsy0[which.max(fmsy0[,2]),1])
abline(v=fmsy1[which.max(fmsy1[,2]),1], col='red')
### FMSY for cod original is 0.12
### FMSY for cod updated is 0.09
### FMSY for yellow original is 0.04
### FMSY for yellow updated is 0.0202
