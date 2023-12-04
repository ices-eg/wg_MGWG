library(TAF)

message("Downloading publications:")

# NAFO
message("NAFO 2022 Northern")
download("https://waves-vagues.dfo-mpo.gc.ca/library-bibliotheque/41078457.pdf",
         destfile="nafo_northern.pdf")
message("NAFO 2023 Flemish")
download("https://www.nafo.int/Portals/0/PDFs/Advice/2023/cod3m.pdf",
         destfile="nafo_flemish.pdf")
message("NAFO 2021 Grand")
download("https://www.nafo.int/Portals/0/PDFs/Advice/2021/cod3no.pdf",
         destfile="nafo_grand.pdf")
message("NAFO 2022 Pierre")
download("https://waves-vagues.dfo-mpo.gc.ca/library-bibliotheque/41063715.pdf",
         destfile="nafo_pierre.pdf")

# NOAA
smart <- "https://apps-st.fisheries.noaa.gov/sis/docServlet?fileAction=download"
message("NOAA 2021 Georges")
download(paste0(smart, "&fileId=7470"), destfile="noaa_georges.pdf")
message("NOAA 2021 Maine")
download(paste0(smart, "&fileId=7550"), destfile="noaa_maine.pdf")

# Map
message("Map")
download(file.path("https://www.nafo.int/Portals/0/PDFs/GeneralInfo",
                   "NAFO%20map-poster-8.5x11.pdf"), destfile="map.pdf")

