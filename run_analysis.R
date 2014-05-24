cleanData <- function(filePath) {
  if(is.null(filePath)) {
    if(require(httr)) {
      url <- paste("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles",
                   "%2FUCI%20HAR%20Dataset.zip");
      zippedFile <- content(GET(url));
      zidDir <- tempdir();
      
      
      unlink(zidDir, recursive = TRUE, force = TRUE);
    }
    else {
      warning(paste("filePath not specified and cannot download zip file ",
                    "-> httr package needed"));
      return();
    }
  }
  else {
    
  }
  
  url
}