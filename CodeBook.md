---
title: "CODEBOOK.md"
output: html_document
date: "Friday, June 05, 2015"
---

# CODEBOOK.md

Instructions for the project: 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

#### Step 1. Downloading and Setting up the data. Loading the plyr package.

```{r warning=FALSE, comment=FALSE}

setwd("C:/Users/abo586/Desktop/Coursera/Course Project/")

#download file and save it in the data folder, in the working directory specified above.
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip", method="curl")

#unzip
unzip(zipfile="./data/Dataset.zip",exdir="./data")

```

#### Step 2. Loading packages

```{r warning=FALSE, comment=FALSE, message=FALSE}
library(dplyr)
library(data.table)
library(tidyr)
```


### Task 1: Merge the training and the test sets to create one data set.

```{r warning=FALSE, comment=FALSE, message=FALSE, results='hide'}
#read the training data
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainLabel <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#read the test data
testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testLabel <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# create a joined train/test data set
dataJoined <- rbind(trainData, testData)
dim(dataJoined)

# create a joined 'label' data set
labelJoined <- rbind(trainLabel, testLabel)
dim(labelJoined)

# create a joined 'subject' data set
subjectJoined <- rbind(trainSubject, testSubject)
dim(subjectJoined)
```


### Task 2: Extract only the measurements on the mean and standard deviation for each measurement.

```{r warning=FALSE, comment=FALSE, message=FALSE, results='hide'}

features <- read.table("./data/UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
length(mean_and_std_features)

# subset the desired columns
dataJoined <- dataJoined[, mean_and_std_features]

# correct the column names
names(dataJoined) <- features[mean_and_std_features, 2]

#remove "()"; capitalize M and S; remove "-" in column names.
names(dataJoined) <- gsub("\\(\\)", "", features[mean_and_std_features, 2])
names(dataJoined) <- gsub("mean", "Mean", names(dataJoined))
names(dataJoined) <- gsub("std", "Std", names(dataJoined))
names(dataJoined) <- gsub("-", "", names(dataJoined))
```


### Task 3: Use descriptive activity names to name the activities in the data set.

```{r warning=FALSE, comment=FALSE, message=FALSE, results='hide'}

activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
labelJoined[, 1] <- activities[labelJoined[, 1], 2]

# correct column name
names(labelJoined) <- "activity"
```

### Task 4: Appropriately label the data set with descriptive variable names.

```{r warning=FALSE, comment=FALSE, message=FALSE, results='hide'}

#correct column name
names(subjectJoined) <- "subject"

#create a single clean dataset
cleanData <- cbind(subjectJoined, labelJoined, dataJoined)
dim(cleanData)
head(cleanData)

#write out a merged and cleaned dataset
write.table(cleanData, "merged_cleaned_data.txt")
```

### Task 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

```{r warning=FALSE, comment=FALSE, message=FALSE, results='hide'}
cleanData2 <- aggregate(. ~subject + activity, cleanData, mean)

cleanData2 <- cleanData2[order(cleanData2$subject, cleanData2$activity),]
write.table(cleanData2, file = "merged_cleaned_data2.txt", row.name=FALSE)
```



