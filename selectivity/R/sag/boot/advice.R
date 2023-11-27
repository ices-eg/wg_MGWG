library(TAF)

message("Downloading advice sheets:")

message("2020 Norway")
download("https://ices-library.figshare.com/ndownloader/files/33415943",
         destfile="advice_norway.pdf")

message("2021 NE Arctic")
download("https://ices-library.figshare.com/ndownloader/files/33417911",
         destfile="advice_ne_arctic.pdf")

message("2022 Faroe")
download("https://ices-library.figshare.com/ndownloader/files/38370326",
         destfile="advice_faroe.pdf")
message("2022 Greenland")
download("https://ices-library.figshare.com/ndownloader/files/35905118",
         destfile="advice_greenland.pdf")
message("2022 North Sea")
download("https://ices-library.figshare.com/ndownloader/files/38140326",
         destfile="advice_north_sea.pdf")

message("2023 E Baltic")
download("https://ices-library.figshare.com/ndownloader/files/41007086",
         destfile="advice_e_baltic.pdf")
message("2023 Iceland")
download("https://ices-library.figshare.com/ndownloader/files/41156720",
         destfile="advice_iceland.pdf")
message("2023 Irish")
download("https://ices-library.figshare.com/ndownloader/files/43001974",
         destfile="advice_irish.pdf")
message("2023 Kattegat")
download("https://ices-library.figshare.com/ndownloader/files/41385474",
         destfile="advice_kattegat.pdf")
message("2023 S Celtic")
download("https://ices-library.figshare.com/ndownloader/files/41412585",
         destfile="advice_s_celtic.pdf")
message("2023 W Baltic")
download("https://ices-library.figshare.com/ndownloader/files/41007074",
         destfile="advice_w_baltic.pdf")
