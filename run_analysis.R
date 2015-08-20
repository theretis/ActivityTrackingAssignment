## run_analysis.R
## Assignment: Getting and Cleaning Data Course Project
## This R script does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for 
##    each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.

#assumes plyr/dplyr package installed
#required libraries
library(plyr)
library(dplyr)


#set output file name
outputFileName <- "tidyUCIHARDataset.txt"

#set working directory
workingDir <- getwd()
print(workingDir)

#set data folders
dataFolder <- "data"
dataSourceFolder <- "UCI HAR Dataset"

#sub-folders list
dataSubFolders <- c("test", "train")

#set data source
dataSource <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#local zip file name
localZipFile <- "UCIHARDataset.zip"

#get the data and unzip it to data folder
if(!file.exists(dataFolder)){
        dir.create(dataFolder)
        
        #download file
        fullPathZipFile <- file.path(dataFolder, localZipFile)
        print(fullPathZipFile)
        
        download.file(dataSource, fullPathZipFile, method="curl", mode = "wb")
        unzip(fullPathZipFile, exdir=dataFolder)
        
        #data download date
        UCIHARDownloadDate <- date()
        
        #remove zip file - no longer needed
        file.remove(fullPathZipFile)
}

#test download and unzip successful and stop if not
if (!file.exists(file.path(dataFolder, dataSourceFolder))) {
        stop("Stopping - download was unsuccessful")
}

#set working directory to access data source
setwd(file.path(dataFolder, dataSourceFolder))
print(getwd())

#read in activity_labels file
activityLabels <- read.table("activity_labels.txt", sep = "", col.names=c("labelid","activitylabels"), colClasses=c("integer","character")) #[,1]

#read in features (fields) file
fields <- read.table("features.txt", sep = "", col.names=c("fieldid","fieldNames"), colClasses=c("integer","character")) #[,1]

#get all fields containing std (standard deviation) and mean
stdMeanLabels<-fields[grepl("std", fields$fieldNames) | grepl("mean", fields$fieldNames),]
stdMeanfieldNamesCharVector <- as.vector(stdMeanLabels$fieldNames)
stdMeanfieldIdCharVector <- as.vector(stdMeanLabels$fieldid)

#read in files to merge
df.xtrain <- read.table("train/X_train.txt")
df.ytrain <- read.table("train/y_train.txt", col.names=c("labelid"), colClasses=c("integer"))
df.subjecttrain <- read.table("train/subject_train.txt", col.names=c("subjectid"), colClasses=c("integer"))

df.xtest <- read.table("test/X_test.txt")
df.ytest <- read.table("test/y_test.txt", col.names=c("labelid"), colClasses=c("integer"))
df.subjecttest <- read.table("test/subject_test.txt", col.names=c("subjectid"), colClasses=c("integer"))

#add fieldid as column headings, as there is a duplicate heading in base data features.txt
names(df.xtrain) <- as.vector(fields$fieldid)
names(df.xtest) <- as.vector(fields$fieldid)

#extract only the columns required from training and test sets, using fieldid
df.xtrain.subset <- subset(df.xtrain, select = stdMeanfieldIdCharVector)
df.xtest.subset <-  subset(df.xtest, select = stdMeanfieldIdCharVector)
                            
#apply field names to training and test subsets
names(df.xtrain.subset) <- stdMeanfieldNamesCharVector
names(df.xtest.subset) <- stdMeanfieldNamesCharVector

#add id column to each data frame to allow merge
df.xtrain.subset <- mutate(df.xtrain.subset, id = rownames(df.xtrain.subset))
df.ytrain <- mutate(df.ytrain, id = rownames(df.ytrain))
df.subjecttrain <- mutate(df.subjecttrain, id = rownames(df.subjecttrain))

df.xtest.subset <- mutate(df.xtest.subset, id = rownames(df.xtest.subset))
df.ytest <- mutate(df.ytest, id = rownames(df.ytest))
df.subjecttest <- mutate(df.subjecttest, id = rownames(df.subjecttest))

#merge each data frame by id
df.train.list <- list(df.xtrain.subset, df.ytrain, df.subjecttrain)
df.train <- join_all(df.train.list, "id")

df.test.list <- list(df.xtest.subset, df.ytest, df.subjecttest)
df.test <- join_all(df.test.list, "id")

#row bind (union) train and test data frames together
df <- rbind(df.train, df.test)

#add activity names based on labelid
df <- left_join(df, activityLabels)

#a second, independent tidy data set with the average of each variable for each activity and each subject
df.less <- select(df, -id, -activitylabels)
df.ave <- aggregate(df.less, by=list(subject=df.less$subjectid, activity=df.less$labelid), FUN=mean, na.rm=TRUE)

#add activity names back in to df.ave based on labelid
df.ave <- left_join(df.ave, activityLabels)

#save df.ave to file 
fullOutputFilePath <- file.path(workingDir, outputFileName)
write.table(df.ave, file=fullOutputFilePath, row.name=FALSE)

#set working dir back to original directory
setwd(workingDir)

