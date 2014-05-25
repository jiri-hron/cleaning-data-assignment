cleanData = function(filePath = "", prefer.df = TRUE) {
  # if file path is not specified or is pointing to unzipped file, this is working dir
  tmpDir = tempdir();
  on.exit(function() unlink(tmpDir, T, T));
  # ensure it's created
  dir.create(tmpDir, recursive=T, showWarnings=F);
  # number of features extracted from the observations, except subject and activity
  noOfCol = 561;
  # number of observations in testing and training set
  testRows = 2947;
  trainRows = 7352;
  
  # download the file if no path specified
  if((is.null(filePath) | nchar(filePath) == 0)) {
    if(require(httr)) {
      message("no path specified, starting download, this may take a while ...");
      file = content(GET(paste0("https://d396qusza40orc.cloudfront.net/",
                                "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")));
      message("file downloaded");
      message(paste("time downloaded:", date()));
      zipped = file.path(filePath, "data.zip");
      file.create(zipped);
      writeBin(file, zipped);
      
      # few rows below is handling for passed zip files
      filePath = zipped;
    }
    else {
      stop(paste("wrong file-path", 
                 filePath,
                 "and cannot access the httr library to download it instead"));
    }
  }
  
  # if path not specified (handling above) or is pointing to zip file
  if(grepl(".*?\\.zip$", filePath, ignore.case=T)) {
    unzippedDir = file.path(tmpDir, "unzipped");
    # recursive to ensure also tmp
    dir.create(unzippedDir, showWarnings=F);
    message("unzipping file");
    unzip(zipfile=filePath,exdir=unzippedDir);
    
    filePath = file.path(unzippedDir, "UCI HAR Dataset");
  }
  
  # read all features
  con = file(file.path(filePath,"features.txt"));
  doc = readLines(con, skipNul = T);
  close(con);
  
  # get original column names according to features.txt
  colNames = sapply(strsplit(doc, " "), function(x) x[2], USE.NAMES = F);
  
  # select only the columns which we are interested in -> faster file read
  kept = grepl("mean\\(\\)|std\\(\\)", colNames);
  colClasses = rep("numeric", noOfCol);
  colClasses[!kept] = "NULL";
  
  # columns names of interest
  cNames = colNames[kept];
  
  # adjust the column names to the right format
  cNames = tolower(cNames);
  cNames =  gsub("[^a-z0-9]", "", cNames);
  cNames = gsub("bodybody", "body", cNames);
  
  # read both training and testing sets
  testSet = read.table(file.path(filePath, "test", "X_test.txt"),
                       comment.char="",
                       colClasses=colClasses,
                       nrows = testRows,
                       sep = "");
  trainSet = read.table(file.path(filePath, "train", "X_train.txt"),
                        comment.char="",
                        colClasses=colClasses,
                        nrows = trainRows,
                        sep = "");
  # add column names
  colnames(testSet) = cNames;
  colnames(trainSet) = cNames;
  
  # utility function reading all lines as factor values and returning the vector
  readAsFactor <- function(path) {
    subsFile = file(path);
    subjects = as.factor(readLines(subsFile));
    close(subsFile);
    
    subjects;
  }
  
  # add information about the subject of the activity carried out
  testSet$subject = readAsFactor(file.path(filePath, "test", "subject_test.txt"));
  trainSet$subject = readAsFactor(file.path(filePath, "train", "subject_train.txt"));
  
  # add information about the activity performed - number representation
  testSet$activity = readAsFactor(file.path(filePath, "test", "y_test.txt"));
  trainSet$activity = readAsFactor(file.path(filePath, "train", "y_train.txt"));
  
  # merge both sets
  complSet = rbind(trainSet, testSet);
  
  # load the codebook for activities
  codebook = read.table(file.path(filePath, "activity_labels.txt"), col.names=c("subject","activity"));
  
  # get activity names as factor sorted by corresponding activities numbers
  codebook[order(codebook$subject),];
  codebook = codebook[,"activity"];
  
  # rewrite activities columns as the name of activities performed
  complSet$activity = as.factor(sapply(complSet$activity, function(i) codebook[i]));
  
  # order the data set by subject number and split to groups by activity and subject
  tidySet = complSet[order(as.numeric(as.character(complSet$subject))),];  
  byPerson = split(tidySet, list(tidySet$subject, tidySet$activity));
  
  # calculate means of all columns except from the descriptive ones
  getSubsColMeans = function(x) {
    y = x[,-which(names(x) %in% c("activity","subject"))];
    means = colMeans(y);
  }
  
  # return a list with each item corresponding to mean values for one particular
  # person on one particular activity
  listed = lapply(byPerson, getSubsColMeans);
  
  ret = listed;
  
  if(prefer.df) {
    # get back the names and activity performed
    rowNames = names(listed);
    listNames = strsplit(x=rowNames, split="\\.");
    baseDF = data.frame(matrix(unlist(listNames), nrow = 180, byrow=T, dimnames=list(NULL, c("subject","activity"))));
    
    # get one person activity per row
    personActArray = simplify2array(listed);
    personActArray = t(personActArray);
    
    # add subject and activity to each row
    ret = cbind(baseDF, personActArray);
    ret$subject = as.numeric(as.character(ret$subject));
    
    # order by subject
    ret = ret[order(ret$subject),];
  }
  
  ret;
}