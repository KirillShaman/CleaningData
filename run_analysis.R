library(dplyr)
library(tidyr)
library(lubridate)
library(data.table)

# This data was obtained and stored from:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip #
# Data was stored locally and unzipped in the workding directory
# From the website: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Check if file exists, if not, download it and unzip it ##
setwd("./DataScience/CleaningData/Project")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("./UCI HAR Dataset.zip")){
  download.file(fileurl, "./UCI HAR Dataset.zip", mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

## features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

## Combine data into one data set
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)

# remove any unused data
rm(YTest,YTrain,XTest,XTrain,SubjectTest,SubjectTrain)

# create a listing of all the columns that contain std or mean in their titles
stdmean<-grep("mean\\(\\)|std\\(\\)", features[,2]) #

# selects only the features that contain mean or std in the features data set
X<-X[,stdmean]

# replaces the numbering of activities with the activity name
Y[,1]<-activity[Y[,1],2]

# creates a list of the feature header names
headernames<-features[stdmean,2]

# applies the header names for each data set
names(X)<-headernames
names(Subject)<-"Subject"
names(Y)<-"Activity"


# Create the final data set and removed unused data
FinalData <- cbind(Subject, Y, X)

rm(Subject, Y, X)


FinalData<-data.table(FinalData)
TidyData <- FinalData[, lapply(.SD, mean), by = 'Subject,Activity'] ## features average by Subject and by activity

write.table(TidyData, file = "Tidy.txt", row.names = FALSE)


