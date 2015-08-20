## Getting and Cleaning Data Project CodeBook
This CodeBook describes the variables, the data, and any transformations or work performed to clean up the _Human Activity Recognition Using Smartphones Data Set_

### Source Data
The _Human Activity Recognition Using Smartphones Data Set_ used in this project was collected by the UCI as detailed in <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

As outlined at this url, 

>The Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
<br><br>
>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
<br><br>
>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

>### Attribute Information

>For each record in the dataset the following is provided:

>* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
>* Triaxial Angular velocity from the gyroscope. 
>* A 561-feature vector with time and frequency domain variables. 
>* Its activity label. 
>* An identifier of the subject who carried out the experiment.

If required, the source data is downloaded by run_analysis.R from 
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

### Dataset Description
The following files, provided as part of the dataset, where used as part of this project:

* 'features_info.txt': Shows information about the variables used on the feature vector.

* 'features.txt': List of all features.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'train/X_train.txt': Training set.

* 'train/y_train.txt': Training labels.

* 'test/X_test.txt': Test set.

* 'test/y_test.txt': Test labels.

* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

* 'train/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

### Transformations
On reading the above files as data frames in to R:

* only those fields which measure standard deviation or mean have been used, for example:

```
df.xtrain.subset <- subset(df.xtrain, select = stdMeanfieldIdCharVector)
```

* headings are applied using 'features.txt', for example:

```
names(df.xtrain.subset) <- stdMeanfieldNamesCharVector
```
 
* a common id column is added to each data frame to aid in merging the data frames together creating df.xtrain.subset and df.xtrain.subset, for example:

```
df.xtrain.subset <- mutate(df.xtrain.subset, id = rownames(df.xtrain.subset))
```

### Merging
plyr is used to merge a list of data frames together based on the _"id"_ column creating (df.train and df.test), for example:

```
df.train.list <- list(df.xtrain.subset, df.ytrain, df.subjecttrain)
df.train <- join_all(df.train.list, "id")
```

The resulting data frames are combined in to one dataset by row, using:

```
df <- rbind(df.train, df.test)
```

### Descriptive Activity Names
Fully descriptive activity names are applied using 'activity_labels.txt', for example:

```
df <- left_join(df, activityLabels)
```

### Creating A Tidy Dataset
A second independent tidy data set with the average of each variable for each activity and each subject is created, using:

```
df.ave <- aggregate(df.less, by=list(subject=df.less$subjectid, activity=df.less$labelid), FUN=mean, na.rm=TRUE)
```
and written to file, using:

```
write.table(df.ave, file=fullOutputFilePath, row.name=FALSE)
```
which creates a file named _tidyUCIHARDataset.txt_


### Tidy Data Field Descriptions
The following describes the tidy dataset data frame df.ave:

<h4><i>Data frame:df.ave</i></h4>180 observations and 84 variables, maximum # NAs:0&nbsp;&nbsp;&nbsp;&nbsp;<hr>
<TABLE BORDER>
<tr><td><h5>Name</h5></td><td><h5>Storage</h5></td></tr>
<tr><td>subject</td><td>integer</td></tr>
<tr><td>activity</td><td>integer</td></tr>
<tr><td>tBodyAcc-mean()-X</td><td>double</td></tr>
<tr><td>tBodyAcc-mean()-Y</td><td>double</td></tr>
<tr><td>tBodyAcc-mean()-Z</td><td>double</td></tr>
<tr><td>tBodyAcc-std()-X</td><td>double</td></tr>
<tr><td>tBodyAcc-std()-Y</td><td>double</td></tr>
<tr><td>tBodyAcc-std()-Z</td><td>double</td></tr>
<tr><td>tGravityAcc-mean()-X</td><td>double</td></tr>
<tr><td>tGravityAcc-mean()-Y</td><td>double</td></tr>
<tr><td>tGravityAcc-mean()-Z</td><td>double</td></tr>
<tr><td>tGravityAcc-std()-X</td><td>double</td></tr>
<tr><td>tGravityAcc-std()-Y</td><td>double</td></tr>
<tr><td>tGravityAcc-std()-Z</td><td>double</td></tr>
<tr><td>tBodyAccJerk-mean()-X</td><td>double</td></tr>
<tr><td>tBodyAccJerk-mean()-Y</td><td>double</td></tr>
<tr><td>tBodyAccJerk-mean()-Z</td><td>double</td></tr>
<tr><td>tBodyAccJerk-std()-X</td><td>double</td></tr>
<tr><td>tBodyAccJerk-std()-Y</td><td>double</td></tr>
<tr><td>tBodyAccJerk-std()-Z</td><td>double</td></tr>
<tr><td>tBodyGyro-mean()-X</td><td>double</td></tr>
<tr><td>tBodyGyro-mean()-Y</td><td>double</td></tr>
<tr><td>tBodyGyro-mean()-Z</td><td>double</td></tr>
<tr><td>tBodyGyro-std()-X</td><td>double</td></tr>
<tr><td>tBodyGyro-std()-Y</td><td>double</td></tr>
<tr><td>tBodyGyro-std()-Z</td><td>double</td></tr>
<tr><td>tBodyGyroJerk-mean()-X</td><td>double</td></tr>
<tr><td>tBodyGyroJerk-mean()-Y</td><td>double</td></tr>
<tr><td>tBodyGyroJerk-mean()-Z</td><td>double</td></tr>
<tr><td>tBodyGyroJerk-std()-X</td><td>double</td></tr>
<tr><td>tBodyGyroJerk-std()-Y</td><td>double</td></tr>
<tr><td>tBodyGyroJerk-std()-Z</td><td>double</td></tr>
<tr><td>tBodyAccMag-mean()</td><td>double</td></tr>
<tr><td>tBodyAccMag-std()</td><td>double</td></tr>
<tr><td>tGravityAccMag-mean()</td><td>double</td></tr>
<tr><td>tGravityAccMag-std()</td><td>double</td></tr>
<tr><td>tBodyAccJerkMag-mean()</td><td>double</td></tr>
<tr><td>tBodyAccJerkMag-std()</td><td>double</td></tr>
<tr><td>tBodyGyroMag-mean()</td><td>double</td></tr>
<tr><td>tBodyGyroMag-std()</td><td>double</td></tr>
<tr><td>tBodyGyroJerkMag-mean()</td><td>double</td></tr>
<tr><td>tBodyGyroJerkMag-std()</td><td>double</td></tr>
<tr><td>fBodyAcc-mean()-X</td><td>double</td></tr>
<tr><td>fBodyAcc-mean()-Y</td><td>double</td></tr>
<tr><td>fBodyAcc-mean()-Z</td><td>double</td></tr>
<tr><td>fBodyAcc-std()-X</td><td>double</td></tr>
<tr><td>fBodyAcc-std()-Y</td><td>double</td></tr>
<tr><td>fBodyAcc-std()-Z</td><td>double</td></tr>
<tr><td>fBodyAcc-meanFreq()-X</td><td>double</td></tr>
<tr><td>fBodyAcc-meanFreq()-Y</td><td>double</td></tr>
<tr><td>fBodyAcc-meanFreq()-Z</td><td>double</td></tr>
<tr><td>fBodyAccJerk-mean()-X</td><td>double</td></tr>
<tr><td>fBodyAccJerk-mean()-Y</td><td>double</td></tr>
<tr><td>fBodyAccJerk-mean()-Z</td><td>double</td></tr>
<tr><td>fBodyAccJerk-std()-X</td><td>double</td></tr>
<tr><td>fBodyAccJerk-std()-Y</td><td>double</td></tr>
<tr><td>fBodyAccJerk-std()-Z</td><td>double</td></tr>
<tr><td>fBodyAccJerk-meanFreq()-X</td><td>double</td></tr>
<tr><td>fBodyAccJerk-meanFreq()-Y</td><td>double</td></tr>
<tr><td>fBodyAccJerk-meanFreq()-Z</td><td>double</td></tr>
<tr><td>fBodyGyro-mean()-X</td><td>double</td></tr>
<tr><td>fBodyGyro-mean()-Y</td><td>double</td></tr>
<tr><td>fBodyGyro-mean()-Z</td><td>double</td></tr>
<tr><td>fBodyGyro-std()-X</td><td>double</td></tr>
<tr><td>fBodyGyro-std()-Y</td><td>double</td></tr>
<tr><td>fBodyGyro-std()-Z</td><td>double</td></tr>
<tr><td>fBodyGyro-meanFreq()-X</td><td>double</td></tr>
<tr><td>fBodyGyro-meanFreq()-Y</td><td>double</td></tr>
<tr><td>fBodyGyro-meanFreq()-Z</td><td>double</td></tr>
<tr><td>fBodyAccMag-mean()</td><td>double</td></tr>
<tr><td>fBodyAccMag-std()</td><td>double</td></tr>
<tr><td>fBodyAccMag-meanFreq()</td><td>double</td></tr>
<tr><td>fBodyBodyAccJerkMag-mean()</td><td>double</td></tr>
<tr><td>fBodyBodyAccJerkMag-std()</td><td>double</td></tr>
<tr><td>fBodyBodyAccJerkMag-meanFreq()</td><td>double</td></tr>
<tr><td>fBodyBodyGyroMag-mean()</td><td>double</td></tr>
<tr><td>fBodyBodyGyroMag-std()</td><td>double</td></tr>
<tr><td>fBodyBodyGyroMag-meanFreq()</td><td>double</td></tr>
<tr><td>fBodyBodyGyroJerkMag-mean()</td><td>double</td></tr>
<tr><td>fBodyBodyGyroJerkMag-std()</td><td>double</td></tr>
<tr><td>fBodyBodyGyroJerkMag-meanFreq()</td><td>double</td></tr>
<tr><td>labelid</td><td>double</td></tr>
<tr><td>subjectid</td><td>double</td></tr>
<tr><td>activitylabels</td><td>character</td></tr>
</TABLE>

