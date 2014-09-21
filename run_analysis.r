## COURSERA 
## Getting and Cleaning Data - Johns Hopkins University
## Course Project 
## @author: Erik Redelinghuys

## --------------
# Purpose: 
# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.


## ---------------

# Load packages to be used in script and clear up workspace
library(plyr)
rm(list=ls())
cat("\014")

#set Working directory
#setwd("C:/Users/erik/COURSERA/3. Getting and Cleaning Data/Assignments/GETTING_AND_CLEANING_DATA-Course_Project")

## ---------------

##  Read data into R    ##

# training set
xTrain = read.table("./data/train/X_train.txt")
yTrain = read.table("./data/train/y_train.txt")
subjectTrain = read.table("./data/train/subject_train.txt")

# test set
xTest = read.table("./data/test/X_test.txt")
yTest = read.table("./data/test/y_test.txt")
subjectTest = read.table("./data/test/subject_test.txt")


## ---------------

## Format x datasets (xTrain and xTest)     ##

# format variable names
# load headings from file
features = read.table("./data/features.txt")
headings = features$V2

# transfer headings to data set
colnames(xTrain) = headings
colnames(xTest) = headings


## ---------------

## Format y datasets (yTrain and yTest)      ##

# format 6 activity types (convert from numbers to text from "activity_labels" file)
activity_labels = read.table("./data/activity_labels.txt")
activity_labels = levels(activity_labels$V2)

# change V1 variable of y datasets to something descriptive, such as "activity"
yTest <- rename(yTest, c(V1="activity"))
yTrain <- rename(yTrain, c(V1="activity"))

# convert "activity" column to factor and add descriptive labels from "activity_labels" file
yTrain$activity = factor(yTrain$activity, labels = activity_labels)
yTest$activity = factor(yTest$activity, labels = activity_labels)

# rename subjectID heading
subjectTest <- rename(subjectTest, c(V1="subjectID"))
subjectTrain <- rename(subjectTrain, c(V1="subjectID"))


## ---------------

## Combine all data   ##

# Create test and train datasets, to be able to merge
Test_set <- data.frame(yTest,subjectTest,xTest)
Train_set <- data.frame(yTrain,subjectTrain,xTrain)

# Combine test and train datasets
finalData <- rbind(Test_set,Train_set)


## ---------------

## Select only mean and sd from dataset  ##

# Create vector containing all column names, to be used to select only mean and sd
colNames  = colnames(finalData)

# Create a dataset from pattern (containing only mean & sd)
pattern = "mean|std|subjectID|activity"
tidyData = finalData[,grep(pattern , names(finalData), value=TRUE)]


## ---------------

## Tidy up variable names

# Don't use underscores ( "_" ) or hyphens ( "-" )
# remove parentheses, dash, commas
cleanNames = gsub("\\(|\\)|-|,", "", names(tidyData))
names(tidyData) <- cleanNames


## ---------------

## Summarize data and write as output

# Summarize
result = ddply(tidyData, .(activity, subjectID), numcolwise(mean))

# write file to output
write.table(result, file="final_tidy_data.txt", sep = "\t", append=F)

