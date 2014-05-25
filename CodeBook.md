## Study design
Please refer to the original documents and hereby bundled README.md (part " Description of experiment provided with original data"). For readers convinience, here is a copy of the original feature description:  

_The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz._

_Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag)._

_Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals)._

_These signals were used to estimate variables of the feature vector for each pattern:_  
_'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions._

The "tidy" dataset produced by this script only transforms these variables by computing grand means and means of standard deviations observed. Further description the steps of transformation provided in README.md.

## Code book
The original names were transformed as described in README.md.  
Example of what corresponds to the original:

* tBodyAccJerk-mean()-X  is transformed to tbodyaccjerkmeanx
* tBodyAccJerk-std()-X is transformed to tbodyaccjerkstdx  

and so on. The names were not further transformed in order to correspond with the description provided with the original data set.

There are only four types of variables:
* subject: the id of the subject/volunteer
* activity: one of the values WALKING, WALKING _ UPSTAIRS, WALKING _ DOWNSTAIRS, SITTING, STANDING, LAYING
* xxxmean : grand means of the original variables, sometimes can end with one of the letter x|y|z when the original measurment was reflecting values of one of the axial angular speeds or linear acceleration
* xxxstd : means of standard deviations, also can end with one letter suffix for reasons described above