read.sao <- function(url)
{
  txt <- readLines(url)

  ## 1  Select lines
  txt <- grep("<tr>", txt, value=TRUE)
  txt <- grep("colspan", txt, value=TRUE, invert=TRUE)

  ## 2a  Remove junk
  txt <- gsub("\\t", "", txt)
  txt <- gsub("</?b>", "", txt)
  txt <- gsub("</?tr>", "", txt)
  txt <- gsub("</td>", "", txt)

  ## 2b  Simplify column name
  txt <- gsub("Year\\\\Age", "Year", txt)

  ## 2c  Remove initial <td>
  txt <- gsub("^ *<td.*?>", "", txt)

  ## 2d  Replace remaining <td> with comma
  txt <- gsub("<td.*?>", ",", txt)

  ## 3  Parse to table
  read.csv(text=txt, check.names=FALSE)
}
