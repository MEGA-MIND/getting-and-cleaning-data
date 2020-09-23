# getting-and-cleaning-data
peer graded assignment

### How to run the code

* Download the dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* unzip it. using GUI tools, unzip terminal command or unzip function in R.
* keep the run_analysis.R in the same directory as the folders test , train and files activity_labels.txt and features.txt
* run the run_analysis.R function.

### what's in it ?

run_analysis.R outputs 2 dataframes dataOld and dataNew.
dataOld suffices the following requirement asked in the assignment.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 

dataNew extracts data from dataOld and suffices the following requirement
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
