#========================================================================
#    File: run_analysis.R
#    Date: 03/19/2014
#  Author: Jim Wolfe
#     URL: https://github.com/jewlf/getting_cleaning_data_project/blob/master/run_analysis.R
#   Email: <no spam>
#
# Purpose: This script reads source data previously downloaded from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# and performs several general steps:
#
#  + Merges the test and training data sets into one data set
#  + Extracts only the measuremements related to mean or standard deviation
#  + Renames the activities from numbers to descripting text
#  + Labels the variables with more readible names
#  + Writes a "tiny data set" containing averaged values
#
# For more details see the accompanying README.md and CODEBOOK.TXT found
# in this repo.
#
#========================================================================

getwd()  # Check what directory we're in
setwd("./UCI HAR Dataset") #Step down to the project main directory
getwd()  # Confirm we are where we intended


#========================================================================
# Step 1 - Get the column names
#========================================================================

# Read in the "features.txt" file to a dataframe as characters
features <- read.table("features.txt", colClasses = "character")
# str(features) # Now have 2 columns x 561 rows
                # Column is 1,2,3... sequential
                # Column is the field names

# Column names appear contain chars that R won't like
# Such as () and - and ,
# head(features)
# str(features)
# dim(features)

# Using only the second column containing the field names,
# replace "-" with "_" to preserve term separations within names
# between the thing being measured, like "fBodyAccMag"
# and the measurement, like "mean()"
column_namesx <- gsub("-","_",features[,2], fixed = TRUE)

# Squeeze out the "()" character pairs, which will go from
# names looking like "_mean()" to "_mean"
column_namesy <- gsub("()","",column_namesx, fixed = TRUE)


# Make R "syntactically valid names" of them, enforcing uniqueness
# This replaces invalid characters with a "."
# and it won't be unusual to have more than one placed together.
# Although record 556 apparently has an extraneous ")" typo,
# it will get fixed in this step, too.
column_namesz <- make.names(column_namesy, unique = TRUE)
# ?make.names()
# column_names   # Take a look

# For readability, lets replace any repeating periods with single periods
column_names2 <- gsub("\\.+",".",column_namesz, perl = TRUE)
# ?gsub
# ?regex
# Take a look at what we've got so far

# And get rid of all those trailing periods
column_names3 <- gsub("\\.+$","",column_names2, perl = TRUE)
# column_names3  # Take a look at the result
# Now we have concise, nice looking column names that R won't complain about
# str(column_names3)

# And lastly, replace leading "t" with "Time"
column_names4 <- gsub("^t","Time",column_names3, perl = TRUE)

# And lastly, replace leading "f" with "Freq"
column_names5 <- gsub("^f","Freq",column_names4, perl = TRUE)

# Some have the typo "BodyBody" so replace with "Body"
column_names6 <- gsub("BodyBody","Body",column_names5, fixed = TRUE)


#========================================================================
# Step 2a - Get Test Data
#========================================================================
getwd()  # Check what director we're in
setwd("./test") #Step down to the "test" directory
getwd()  # Confirm we are where we intended

test_data <- read.table("X_test.txt", colClasses = "character")


#========================================================================
# Step 3a - Apply column names to Test Data
#========================================================================
names(test_data) <- column_names6
# head(test_data)  # Take a look

#========================================================================
# Step 4a - Get the Test Data Subject column
#========================================================================
test_subjects <- read.table("subject_test.txt", colClasses = "character")

#========================================================================
# Step 5a - Apply column name to Test Subject column
#========================================================================
names(test_subjects) <- c("Subject")
# head(test_subjects)  # Take a look

#========================================================================
# Step 6a - Get the Test Activity column
#========================================================================
test_activity <- read.table("y_test.txt", colClasses = "character")

#========================================================================
# Step 7a - Apply column name to Test Activity column
#========================================================================
names(test_activity) <- c("Activity")
# head(test_activity)  # Take a look

#========================================================================
# Step 8a - Glue them all together in this order:
#    Activity | Subject | Data
#========================================================================

test_data2 <- cbind(test_activity, test_subjects)
test_data2 <- cbind(test_data2, test_data)
# head(test_data2)  # Take a look


#########################################################################
#   Perform similar steps for training data
#########################################################################


#========================================================================
# Step 2b - Get Training Data
#========================================================================
getwd()  # Check what directory we're in
setwd("../train") #Step up and back down to the "train" directory
getwd()  # Confirm we are where we intended

train_data <- read.table("X_train.txt", colClasses = "character")


#========================================================================
# Step 3b - Apply column names to Train Data
#========================================================================
names(train_data) <- column_names6
# head(train_data)  # Take a look

#========================================================================
# Step 4b - Get the Train Data Subject column
#========================================================================
train_subjects <- read.table("subject_train.txt", colClasses = "character")

#========================================================================
# Step 5b - Apply column name to Train Subject column
#========================================================================
names(train_subjects) <- c("Subject")
# head(train_subjects)  # Take a look

#========================================================================
# Step 6b - Get the Train Activity column
#========================================================================
train_activity <- read.table("y_train.txt", colClasses = "character")

#========================================================================
# Step 7b - Apply column name to Train Activity column
#========================================================================
names(train_activity) <- c("Activity")
# head(train_activity)  # Take a look

#========================================================================
# Step 8b - Glue them all together in this order:
#    Activity | Subject | Data
#========================================================================

train_data2 <- cbind(train_activity, train_subjects)
train_data2 <- cbind(train_data2, train_data)
# head(train_data2)  # Take a look

#========================================================================
# Step 9 - Combine Test and Train into one DF
#========================================================================
# nrow(test_data2)  # Shows 2947 rows
# nrow(train_data2) # Shows 7532 rows
expected_rows <- nrow(test_data2) + nrow(train_data2)
# expected_rows     # Shows 10299

data2 <- rbind(test_data2, train_data2)
# head(data2)
# nrow(data2)       # 10299, as expected

#========================================================================
# Step 10 - In the Activity column, replace
# numbers with words, like this:
#    1 = WALKING
#    2 = WALKING_UPSTAIRS
#    3 = WALKING_DOWNSTAIRS
#    4 = SITTING
#    5 = STANDING
#    6 = LAYING
#========================================================================

data2$Activity[data2$Activity == "1"] <- "WALKING"
data2$Activity[data2$Activity == "2"] <- "WALKING_UPSTAIRS"
data2$Activity[data2$Activity == "3"] <- "WALKING_DOWNSTAIRS"
data2$Activity[data2$Activity == "4"] <- "SITTING"
data2$Activity[data2$Activity == "5"] <- "STANDING"
data2$Activity[data2$Activity == "6"] <- "LAYING"

# data2$Activity   # Take a look
# head(data2)

#========================================================================
# Step 11 - Left pad the Subject values with zero to make
# later sorting look nicer
#========================================================================
data2$Subject <- gsub(" ", "0", formatC(data2$Subject, width=2))

# data2$Subject    # Take a look, much better
# head(data2)      # Take a look

#########################################################################
# At this point, the data frame "data2" contains everything in a
# clean format and is available should we want to do anything
# requiring columns in addition to the mean and std var columns.
#
# However, for this project, we're only asked for the mean and std dev
# columns, so now we'll isolate them.
#########################################################################

#========================================================================
# Step 12 - Get only columns "Activity", "Subject" and any others
# dealing with means ("mean") or standard deviations ("std")
#========================================================================
data3 <- data2[,grep("Activity|Subject|*mean*|*std*", colnames(data2))]
# nrow(data3)      # Still have the 10299 rows
# ncol(data3)      # But now only have 81 columns
# head(data3,n=10) # Take a look
# tail(data3,n=10) # Take a look
# summary(data3)   # Take a look
# str(data3)       # Take a look
# all(colSums(is.na(data3))==0) # Check for N/As, none

#########################################################################
# At this point, "data3" is a "more trim" data frame containing
# columns "Activity", "Subject" and all other columns dealing with
# means ("mean") or standard deviations ("std").
#
# "data3" is the "main" Data Set output to satisfy project directives
# 1 through 4.
#########################################################################

#========================================================================
# Step 13 - "Melt" the data so that the measured Variables are stored as
# rows instead of columns, to result in an arrangement like:
#
#    Activity | Subject | Variable           | Value
#    STANDING |      02 | TimeBodyAcc_mean_X | 2.5717778e-001
#

library(reshape2)  # Load the Reshape 2 library to make "melt" available

data4 <- melt(data3,id=c("Activity","Subject"))
                   # Keeping "Activity" and "Subject" as columns
                   # means that the 81 - 2 = 79 columns will become
                   # 30 volunteers, 6 activities, 79 variables
# nrow(data4)      # Result has 10299 * 79 = 813621 rows
# ncol(data4)      # But now only have 4 columns
# head(data4,n=10) # Take a look
# tail(data4,n=10) # Take a look
# summary(data4)   # Take a look
# str(data4)       # Take a look

# Melt changed the variables to factors, so change them back to characters
data4$variable <- as.character(data4$variable)
# str(data4)       # Take a look, that's better
# head(data4,n=10) # Take a look

#========================================================================
# Step 14 - Having a long history in SQL, I prefer to use a SQL statement
# to find the means
#========================================================================
library(sqldf)     # Load the sqldf library to make "sqldf" available

# Get the grouped averages and "pretty up" the field names
data5 <- sqldf('SELECT Activity, Subject, variable AS Variable, AVG(value) AS Average
    FROM data4
    GROUP BY Activity, Subject, variable
    ORDER BY Activity, Subject, Variable')

# head(data5)  # Take a look, note first Subject is "01"
# tail(data5)  # Take a look, note last Subject is "30"
# str(data5)   # Take a look

# Take a look at all the means for Subject "01"
# data5[data5$Subject == "01",]
# See how many rows were for Subject "01"
# Expecting 6 activities * 79 variables = 474
# nrow(data5[data5$Subject == "01",])  # And it is

# Expecting overall Tidy Data row count to be
# 79 variables * 30 subjects * 6 activities = 14220
# nrow(data5)  # And it is

#========================================================================
# Step 15 - Write the Tidy Data to a text
#========================================================================
getwd()     # Check what directory we're in
setwd("..") # Step up to target directory
getwd()     # Confirm we are where we intended

write.table(data5, ".\\tidydata.txt", row.names = FALSE)

# Tidy data file "tidydata.txt" has been created
# It's space delimited, with character strings enclosed in " "
# First row contains column names, each enclosed with " "
#
# Exported columns are:
#
# Activity   = character field, containing one of the 6 activities
# Subject    = character field, ranging from 1 to 30
# Variable   = character field, what parameter was measureed
# Average    = numeric field, the average of the variable measurements
#              for the indicated Activity and Subject
#
# Ordering is by Activity, Subject and Variable name
#
