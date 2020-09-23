### LOADING THE REQUIRED FILES FOR CLEANING  #################################

features <- read.table("features.txt") # A vector (total 561 rows) contains feature index (1,2,3...) and
# features i.e mean,std-deviation,mean absolute deviation (mad),frequency etc. along 3 axis

X_test <- read.table("test/X_test.txt",col.names = features[,2])# contains 561 columns in the order
# of the feature vector; str(X_test) returns "'data.frame':	2947 obs. of  561 variables"

X_train <- read.table("train/X_train.txt",col.names = features[,2])#contains 561 columns in the order
# of the feature vector; str(X_train) returns "'data.frame':	7352 obs. of  561 variables"

activity <- read.table("activity_labels.txt",col.names = c("activity_code","activity_name")) 
#contains activity codes (1-6) and activities ("WALKING","SITTING","STANDING"..)

y_train <- read.table("train/y_train.txt",col.names = "activity_code") # contains activity
# codes; the corresponding activity name can be extracted from the activity table.

y_test <- read.table("test/y_test.txt",col.names = "activity_code")# contains activity
# codes; the corresponding activity name can be extracted from the activity table.

subject_test <- read.table("test/subject_test.txt",col.names = "subject") # contains the 
# subject id. i.e. the ID of the different people participating in this experiment.

subject_train <- read.table("train/subject_train.txt",col.names = "subject")# contains the 
# subject id. i.e. the ID of the different people participating in this experiment.



### MERGING TRAINING AND TEST DATA  ###############################

# simple..
X <- rbind(X_train,X_test)
Y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

### EXTRACTING DATA ONLY ON MEAN AND STANDARD DEVIATION

#in this we will just select the columns from X table that contain 'mean' or 'std' in their names

X <- X[grep("mean|std",names(X))]    #for columns 552-561 the 'mean' is spelled as 'Mean' (10 instances)
# and hence are not recorded in the above regex ; they are to be ignored anyways


### DESCRIPTIVE ACTIVITY NAMES #####################

# Y data contains activity code and we have to replace them with corresponding activity names

Y <- activity$activity_name[Y[["activity_code"]]]    # this first extracts value from Y (activity codes)
# as activity codes are same as their index so I directly subset activity$activity_name with these index



### LABELLING DATASET WITH DESCRIPTIVE VARIABLE NAMES. ###############

# this has to be done on X; as Y and subject are already been descriptively labeled by us.
# the data for the following changes have been extracted from features_info.txt

temp <- names(X)
temp <- gsub("^t","time",temp)
temp <- gsub("Acc","Acceleration",temp)
temp <- gsub("std","standard.dev",temp)
temp <- gsub("mad","mean.abs.dev",temp)
temp <- gsub("Gyro","Gyroscope",temp)
temp <- gsub("[(][)]","",temp)     # or regex "\\(\\)" is also valid
temp <- gsub("Mag","Magnitude",temp)
temp <- gsub("^f","frequency",temp)
temp <- gsub("Freq","Frequency",temp)
temp <- gsub("sma","signal.magnitude.area",temp)
temp <- gsub("iqr","interquartile.range",temp)
temp <- gsub("arCoeff","auto.regression.coeff",temp)
temp <- gsub("Inds","Indexs",temp)

### CREATING A NEW DATASET WITH MEAN OF EACH VARIABLE (in X) for  each activity and each person (subject)

# before that let's make a single dataset
dataOld <- cbind(subject,Y,X)

# using aggregate function to apply fn mean() on groups "subject" and "Y" (activity)

dataNew <- aggregate(dataOld[c(-1,-2)], list(dataOld$subject,dataOld$Y),mean)
# okay.. in the above statement we apply mean function on every column except the first 2 (subject and Y) hence c(-1,-2)
# next to the 'by' argument of aggregate we pass subject and Y (activity). Internally aggregate function
# splits the data given into subsets based on the factor variables given in 'by' argument.
# as in our case there are 6 activities and 30 subjects so total 6x30 = 180 splits happen.
# mean function is then applied on every column except the first 2 c(-1,-2) and then all the 
# 180 splits containing just 1 row of data about mean of the individual columns are joined together 
# to give the final output containing 180 rows.
# however this does messes up names of the first 2 columns. Let's fix it.

names(dataNew)[c(1,2)] <- c("subject","activity")

#and done
head(dataNew,10)  #preview