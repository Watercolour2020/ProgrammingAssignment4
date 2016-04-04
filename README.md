# ProgrammingAssignment4
--
title: "Codebook run_analysis.R"
author: "Howard Stiff"
date: "April 3 2016"
output:
---

## Project Description
This program reads & analyzes data from the Human Activity Recognition experiment (Reyes-Ortiz et al; avail. online at http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names).

##Study design and data processing - See http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names for all details
#The experiments have been carried out with a group of 30 volunteer subjects within an age bracket of 19-48 years. 
#Each person performed six Activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone 
#(Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity we captured at a constant rate of 50Hz. 
#The dataset has been randomly partitioned into two sets, where 21 (70%) of the volunteers was selected for generating the training data and 9 (30%) the test data.

###Collection of the raw data
See http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names for all details

###Notes on the original (raw) data 
See http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names for all details

##Creating the tidy datafile
###Guide to create the tidy data file
#Program reads the training and test datasets pre-analyzed from the raw experimental data.
#Meta-datasets are also read including the features variable list (Features.txt) which are used to label the data columns; 
#and the activity list (six activities described above).  
#These are used to identify the TEST and TRAINing data columns and the activity type for each record. 
#Columns based on mean() or std() are extracted into a separate table for each Source type (TEST or TRAIN).
#The TEST and TRAIN data are then concatenated into one dataset (--> TrainAndTestData), grouped on SubjectCode and ActivityCode 
#for summarization (averaging) of all columns by Subject and Activity.  
#The summary is output to another datset --> TrainAndTestSummary.

###Cleaning of the data
Data were pre-processed by Reyes-Ortiz et al, and were very clean.  No NAs.  

##Sources
===================================================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
===================================================================================================
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Universit?  degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Polit?cnica de Catalunya (BarcelonaTech). Vilanova i la Geltr? (08800), Spain
activityrecognition '@' smartlab.ws 
===================================================================================================
