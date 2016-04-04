#PROGRAM:  run_analysis.R (H Stiff March 2016)
#
#This program reads data from the Human Activity Recognition experiment (Reyes-Ortiz et al; avail. online at http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names [downloaded March 2016] )
#The experiments have been carried out with a group of 30 volunteer subjects within an age bracket of 19-48 years. 
#Each person performed six Activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone 
#(Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity we captured at a constant rate of 50Hz. 
#The dataset has been randomly partitioned into two sets, where 21 (70%) of the volunteers was selected for generating the training data and 9 (30%) the test data.
#
#This program reads the training and test datasets pre-analyzed from the raw experimental data.
#Meta-datasets are also read including the features variable list (Features.txt) which are used to label the data columns; 
#and the activity list (six activities described above).  
#These are used to identify the TEST and TRAINing data columns and the activity type for each record. 
#Columns based on mean() or std() are extracted into a separate table for each Source type (TEST or TRAIN).
#The TEST and TRAIN data are then concatenated into one dataset (TrainAndTestData), grouped on SubjectCode and ActivityCode 
#for summarization (averaging) of all columns by Subject and Activity.  
#The summary is output to another datset - TrainAndTestSummary.

library(dplyr)

#Read Features and Activities MetaData into R
setwd("~/GitHub/ProgrammingAssignment4/UCI HAR Dataset") #start in meta-data directory
FeatureListImport <-
        tbl_df(
                read.table(
                        "features.txt",
                        header = FALSE,
                        sep = "",
                        stringsAsFactors = FALSE,
                        col.names = c("FeatureCode", "FeatureName")
                )
        )
View(FeatureListImport)
FeatureNames <-
        FeatureListImport$FeatureName #head(FeatureNames) #extract the list of names for column headings?

ActivityListImport <-
        tbl_df(
                read.table(
                        "activity_labels.txt",
                        header = FALSE,
                        sep = "",
                        stringsAsFactors = FALSE,
                        col.names = c("ActivityCode", "ActivityName")
                )
        ) #View(ActivityListImport)
ActivityNames <-
        ActivityListImport$ActivityName #ActivityNames #extract the list of names for column headings


#Read TEST dataset into R
setwd("~/GitHub/ProgrammingAssignment4/UCI HAR Dataset/test") #set WD to TEST-data directory
SubjectTestImport <-
        tbl_df(
                read.table(
                        "subject_test.txt",
                        header = FALSE,
                        sep = "",
                        stringsAsFactors = FALSE,
                        col.names = c("SubjectCode")
                )
        ) #View(SubjectTestImport) #these are the SubjectCodes associated with the actual data (xTestImport)

yTestImport <-
        tbl_df(
                read.table(
                        "y_test.txt",
                        header = FALSE,
                        sep = "",
                        stringsAsFactors = FALSE,
                        col.names = c("ActivityCode")
                )
        ) #View(yTestImport) #these are the ActivityCodes associated with the actual data (xTestImport)

xTestImport <-
        tbl_df(read.table(
                "x_test.txt",
                header = FALSE,
                sep = "",
                stringsAsFactors = FALSE
        ))  #View(xTestImport); dim(xTestImport) #check dimensions of measurements dataset

#Tidy TEST dataset
names(xTestImport) <-
        FeatureNames #assign variable names (features) to columns of data
TestDataMerge <-
        cbind(SubjectTestImport, yTestImport, xTestImport)   #merge subject and activity codes with data by row
#table(TestDataMerge$ActivityCode,TestDataMerge$SubjectCode) #tabulate by subject & activity type
TestDataMerge <-
        merge(
                ActivityListImport,
                TestDataMerge,
                by.x = "ActivityCode",
                by.y = "ActivityCode",
                all = TRUE
        )  #View(TestDataMerge)  #merge Activity list with data by code

TestMeans <-
        select(TestDataMerge,
               SubjectCode,
               ActivityCode,
               ActivityName,
               contains("mean()"))
#dim(TestMeans)  # was TestDataMerge2 -- extract columns with mean() in col name

TestStds <-
        select(TestDataMerge, contains("std()"))
dim(TestStds)     # was TestDataMerge2 - extract columns with std() in col name

TestData <-
        tbl_df(cbind(TestMeans, TestStds))
dim(TestData)  #combine means and stds

TestData$Source <- "TEST"
dim(TestData) #tag as TEST data
TestData$Source <- as.factor(TestData$Source) #set the following four variables as.factor
TestData$SubjectCode <- as.factor(TestData$SubjectCode)
TestData$ActivityCode <- as.factor(TestData$ActivityCode)
TestData$ActivityName <- as.factor(TestData$ActivityName)

TestData <-
        arrange(TestData, ActivityCode, SubjectCode, Source)  #sort by SubjectCode and ActivityCode and groupby factor vars
TestGroup <-
        group_by(TestData, SubjectCode, ActivityCode, ActivityName, Source) #dim(TestGroup)

#Summarize TEST dataset           #this intermediate section NOT used
#TestSummary<-(summarize_each(TestGroup,funs(mean))); #dim(TestSummary); #View(TestSummary) #head(TestSummary,12);  tail(TestSummary,12) #get mean of all measurement means & stds
#table(TestSummary$SubjectCode,TestSummary$ActivityCode)


#Read TRAIN dataset into R
setwd("~/GitHub/ProgrammingAssignment4/UCI HAR Dataset/train") #set WD to TRAIN-data directory
SubjectTrainImport <-
        tbl_df(
                read.table(
                        "subject_train.txt",
                        header = FALSE,
                        sep = "",
                        stringsAsFactors = FALSE,
                        col.names = c("SubjectCode")
                )
        ) #View(SubjectTrainImport) #these are the SubjectCodes associated with the actual data (xTrainImport)

yTrainImport <-
        tbl_df(
                read.table(
                        "y_train.txt",
                        header = FALSE,
                        sep = "",
                        stringsAsFactors = FALSE,
                        col.names = c("ActivityCode")
                )
        ) #View(yTrainImport) #these are the ActivityCodes associated with the actual data (xTrainImport)

xTrainImport <-
        tbl_df(read.table(
                "x_train.txt",
                header = FALSE,
                sep = "",
                stringsAsFactors = FALSE
        ))  #View(xTrainImport); #these are the measurement data (xTrainImport)


#Tidy TRAIN dataset
names(xTrainImport) <-
        FeatureNames #assign variable names (features) to columns of data
TrainDataMerge <-
        cbind(SubjectTrainImport, yTrainImport, xTrainImport) #merge subject and activity codes with data by row
#table(TrainDataMerge$ActivityCode,TrainDataMerge$SubjectCode) #tabulate by subject & activity type
TrainDataMerge <-
        merge(
                ActivityListImport,
                TrainDataMerge,
                by.x = "ActivityCode",
                by.y = "ActivityCode",
                all = TRUE
        ) #View(TrainDataMerge)

TrainMeans <-
        select(TrainDataMerge,
               SubjectCode,
               ActivityCode,
               ActivityName,
               contains("mean()"))
#dim(TrainMeans)  #extract columns with mean() in col name
TrainStds <-
        select(TrainDataMerge, contains("std()"))
dim(TrainStds)     #extract columns with std() in col name
TrainData <-
        tbl_df(cbind(TrainMeans, TrainStds))
dim(TrainData)  #combine means and stds

TrainData$Source <- "TRAIN"
dim(TrainData) #tag as TRAIN data
TrainData$Source <- as.factor(TrainData$Source)  #identify factor vars
TrainData$SubjectCode <- as.factor(TrainData$SubjectCode)
TrainData$ActivityCode <- as.factor(TrainData$ActivityCode)
TrainData$ActivityName <- as.factor(TrainData$ActivityName)

#Combine TRAIN and TEST datasets into one
TrainAndTestData <-
        tbl_df(rbind(TrainData, TestData))
dim(TrainAndTestData) #append source datasets
TrainAndTestData <-
        arrange(TrainAndTestData, ActivityCode, SubjectCode, Source) #dim(TrainData) #sort by SubjectCode and ActivityCode
TrainAndTestGroup <-
        group_by(TrainAndTestData,
                 SubjectCode,
                 ActivityCode,
                 ActivityName,
                 Source) #dim(TrainGroup) #group-by for summary analysis

#Summarize combined TRAIN & TEST dataset
TrainAndTestSummary <-
        (summarize_each(TrainAndTestGroup, funs(mean)))  #tidy summary of mean values for each subject, activity, and column
#dim(TrainAndTestSummary)
View(TrainAndTestSummary) #head(TrainAndTestSummary,12);  tail(TrainAndTestSummary,12) #get mean of all measurement means & stds
table(TrainAndTestSummary$SubjectCode,
      TrainAndTestSummary$ActivityCode) #frequency analysis of combinations of Subject and Activity

#output tidy summary to text file
setwd("~/GitHub/ProgrammingAssignment4")
z<-file("TrainAndTestSummary_tidy.txt","w")
write.table(TrainAndTestSummary, file="TrainAndTestSummary_tidy.txt", row.name=FALSE)
close(z)
