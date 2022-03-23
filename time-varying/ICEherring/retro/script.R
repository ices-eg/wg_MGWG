## 1 Run model
dat <- "RUN1NWWG.DAT"
system(paste("VPA2", dat))

## 2 Run retro
system(paste("VPARETRO", dat))

## 3 Read retro
write(dat, "LIST.TXT")
system("VPA2R LIST.TXT")
retro <- dget("RUN1NWWG.RDAT")
