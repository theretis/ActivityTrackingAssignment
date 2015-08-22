## Getting and Cleaning Data Project README


One of the most exciting areas in all of data science right now is wearable computing as evidenced in this article: <http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/>

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

### Assignment
This repo uses an Activity Tracking dataset provided by UCI (described in the CodeBook in this repo). The goal is to prepare a tidy dataset, from the source data, that can be used for later analysis.

### Repo Contents
* Data/UCI HAR Dataset - source data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
* run_analysis.R - the R script which processes the UCI HAR Dataset and outputs a tidy dataset named _tidyUCIHARDataset.txt_ (as described in the CodeBook)
* tidyUCIHARDataset.txt - the tidy dataset produced by _run_analysis.R_
* CodeBook.md - describes the variables, the data, and any transformations or work performed to clean up the _Human Activity Recognition Using Smartphones Data Set_

### Assumptions
run_analysis.R assumes the following packages have been installed in R:

* plyr
* dplyr

```
library(plyr)
library(dplyr)
```

### Script
The run_analysis.R script will determine whether the UCI HAR dataset is in your working directory and if not download and unzip it ready for processing