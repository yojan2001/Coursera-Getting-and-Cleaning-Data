
library(plyr)
setwd("C:/Users/abo586/Desktop/Coursera/Course Project/")

#download file and save it in the data folder, in the working directory specified above.
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#unzip
unzip(zipfile="./data/Dataset.zip",exdir="./data")

##########################################################################
#Question 1: Merge the training and the test sets to create one data set.#
##########################################################################

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



#####################################################################################################
#Question 2: Extract only the measurements on the mean and standard deviation for each measurement.#
#####################################################################################################

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



#####################################################################################
#Question 3: Uses descriptive activity names to name the activities in the data set.#
#####################################################################################

activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
labelJoined[, 1] <- activities[labelJoined[, 1], 2]

# correct column name
names(labelJoined) <- "activity"


################################################################################
#Question 4: Appropriately labels the data set with descriptive variable names.# 
################################################################################

#correct column name
names(subjectJoined) <- "subject"

#create a single clean dataset
cleanData <- cbind(subjectJoined, labelJoined, dataJoined)
dim(cleanData)
head(cleanData)

#write out a merged and cleaned dataset
write.table(cleanData, "merged_cleaned_data.txt")


#####################################################################################
# Question 5:  Create a second, independent tidy data set with the average of each  #
# variable for each activity and each subject.                                      #
#####################################################################################

cleanData2 <- aggregate(. ~subject + activity, cleanData, mean)

cleanData2 <- cleanData2[order(cleanData2$subject, cleanData2$activity),]
write.table(cleanData2, file = "merged_cleaned_data2.txt", row.name=FALSE)


###########################
# Create Codebook in knitr#
###########################

library(knitr)
knit2html("C:\\Users\\abo586\\Desktop\\Coursera\\Course Project\\run_analysis.R", "codebook.Rmd")

library(markdown)
markdownToHTML("C:\\Users\\abo586\\Desktop\\Coursera\\Course Project\\codebook.html", "final.html")
