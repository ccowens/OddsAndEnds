Google.read.csv <- function(sheetID) {
# read.csv version for reading Google spreadsheets into data frames 
# using trick of appending export?format=csv to the URL
# Based on discussion in:
#   http://stackoverflow.com/questions/22873602/importing-data-into-r-from-google-spreadsheet
# The sheetID is best copied from your browser URL bar. For example:
#   1CO8L7ly0U1CO8L7ly0U
# out of:
#   https://docs.google.com/spreadsheets/d/1CO8L7ly0U1CO8L7ly0U/edit#g
# The sheet has to be public (just the link).

  # Combine the pieces to make the URL
  fileURL <- paste0("https://docs.google.com/spreadsheets/d/",
                   sheetID, 
                   "/export?format=csv")
  
  # Use getURL from the RCurl package so you can read an HTTPS page.
  require(RCurl)
  
  # Put the content into the sheet variable.
  sheet <- getURL(fileURL, ssl.verifypeer=FALSE)
  print(sheet)
  
  # Cheeck the beginning to see if it looks like HTML or XML (not good) 
  if (substr(sheet,1,10) == "<!DOCTYPE>" | substr(sheet,1,6) == "<HTML>") {
    stop("The file text looks like the beginning of an HTML file, not a CSV file. You mave the wrong ID for the sheet, or this may not be a public link.")
  }
  
  # Use textConnect to treat reading from the variable as if 
  # it were reading from a CSV file and return a data frame 
  read.csv(textConnection(sheet))
}