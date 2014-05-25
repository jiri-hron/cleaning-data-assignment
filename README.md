README for Course Project on Getting and Cleaning Data
======================================================
### Notes:
Author: Jiri Hron  
email: jiri.m.hron@gmail.com  
Date 05/25/2014 (MM/dd/YYYY)  

## Basic information
This script was created during Getting and Cleaning Data course on <a href="https://www.coursera.org/">Coursera</a>.
Basic purpose of this script is to take the data from adress below and transform it:
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
Original dataset name:
_Human Activity Recognition Using Smartphones Dataset, Version 1.0_

For a thorough description of the original data set and of the original study design please refer to the the documentation bundled with the above mentioned zip file.

## Description of experiment provided with original data
_The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING _ UPSTAIRS, WALKING _ DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data._

_The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain_

## Feature selection
According to the description provided in features_info in the original folder
only a small subset of variables estimated from the signals are:

* mean(): Mean value
* std(): Standard deviation

These values were selected based on the assignment description. Mean frequencies were left out because they reflect more of how the observed features were evolving during the experiment than of their actual values.

The original number of 561 different variables is reduced to only 66 variables and 2 new variables are added:
* subject: the id of the subject/volunteer performing the activity
* activity: textual representation of the activity performed (one of the values WALKING, WALKING _ UPSTAIRS, WALKING _ DOWNSTAIRS, SITTING, STANDING, LAYING)

All names of the variables were described as specified in the ninth number of "Steps of transformation". Further description on the mean meaning of the variables can be found in CodeBook.md bundled hereby.

## Steps of transformation
The transformation is made up of several steps:
<ol>
<li>Download the data from the URL specified above</li>
<li>Unpack the data from the zip file to temporary folder named "UCI HAR Dataset"</li>
<li>Get the names of the columns in original data set and pick only mean() and std() columns with descriptive statistics of means of standard deviations for each of the observed values in the original data set.</li>
<li>Read the data from the file "UCI HAR Dataset/test/X _ test.txt" and add columns identifying subject of the activity and activity perfomed from files "UCI HAR Dataset/test/subject _ test.txt" and "UCI HAR Dataset/test/y _ test.txt" respectively. Skip the columns that are not of interest according to step 3.</li>
<li>Do the same steps described in step four for the "UCI HAR Dataset/train" folder</li>
<li>Bind the two sets of collected in steps four and five.</li>
<li>Transform the names of the columns to the style described in lectures (lower case, no hyphens/undersores/dots/parenthesis included -> column names must match regex "[a-z0-9]+"). Also some of the original typos like "fBodyBodyAccJerkMag-mean()" were corrected to "fbodyaccjerkmagmean".</li>
<li>Replace the values in the activity column for its textual representations, which are derived from the "UCI HAR Dataset/activity_labels.txt"</li>
<li>Transform the data into data frame with 180 rows (30 volunteers performing 6 activities each) with 66 + 2 columns (66 descriptive statistics of mean and standard deviation + subject/volunteer id + activity performed). The description of the exact form of transformation is given in the "Restul set" part of this file.</li>
</ol>

## Result set
The transformation takes all of the original 2.56 sec windows from which the original values are stemming and computes means for each value, each activity and each subject. In other words all the observations were grouped by their subject/volunteer id and activity performed and column means were calculated to get one row o grand means (means of the original means) and means of standard deviations for each activity performed by each of the volunteers.

Result set therefore includes 180 rows, one per each volunteer and activity performed consisting of:
* subject/voluntee id: who performed the activity
* activity: which activity was measured
* 66 columns of grand means and means of standard deviations for each of the variables described in the CodeBook.md

## Running the script
There are two optional parameters to the script only method _cleanData_:
* filePath: references the file system path to zip or unzipped folder containing the file with all the original contents
* prefer.df: if set to TRUE, a data frame is returned, otherwise a list structure is returned (refer to Details)

### Details
If no _filePath_ is specified, the script will download the original data set from the internet adress mentioned in the beginning of this README file. If the file path specified ends with _.zip_ suffix, the script first unzips the file to a temporary folder and thenafter performs the data clean up. If a regular path is passed the script assumes it points to the same folder as one would get by downloading the zip and extracting it to the folder specifed (please do not change the structure and any names of the files and directories included).

For the _prefer.df_ argument (by default set to TRUE), there is a possibility for user to specify if data frame or list structure of the result is preferred. The data frame is consisted of 180 rows and 68 columns desribed in greater detail previously. The list consists of 180 items, one for each activity performed by each of the subjects of the experiment. Each item on the list is consisted of a numeric vector of the 66 observed variables, each variable is named. The name of the item is in form #.ACTIVITY, where # is the volunteer id and the ACTIVITY is the literal name of the activity peformed.

Acknowledgement:
================
The original data set was provided by [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
