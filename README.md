README.md for "getting_cleaning_data_project" - Jim Wolfe 6/19/2014

BACKGROUND: The UCI project "Human Activity Recognition Using Smartphones Data
Set" collected accelerometer and gyroscope data from Samsung Galaxy S smartphones
worn by a group of 30 volunteers while exercising.

See the project webpage at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+ Smartphones

The data from that project can be downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


THIS SCRIPT: "run_analysis.R", uses the above source data and performs
several general steps:

  + Merges the test and training data sets into one data set
  + Extracts only the measuremements related to mean or standard deviation
  + Renames the activities from numbers to descripting text
  + Labels the variables with more readible names
  + Writes a "tiny data set" containing averaged values


PREREQUISITES: "run_analysis.R" script uses libraries:
   reshape2
   sqldf
that should be installed before execution.

This script expects the source data to be in subdirectories below the
script's current directory in this arrangement:

 <current_directory>
    <UCI HAR Data>
       <test>
          subject_test.txt
	  X_test.txt
	  y_test.txt
       <train>
          subject_test.txt
          X_test.txt
          y_test.txt


DESIGN PHILOSOPHY: In addition to performing the functions outlined in the
"THIS SCRIPT" section above, this script is a learning tool.  It is very
verbose and contains many internal comments, and commented out
commands, that can be used when manually running the script.  Intermediate
data frames are left intact for checking that the code is working as
intended and for exploring R command functionality.

There are surely "more elegant" approaches, but one of MY goals was to
make a script that followed a logical progression without too much "magic".


SCRIPT DETAILED STEPS:

+ Step 1  - Get the column names (from "features.txt" file)

Handle the "test" data...

+ Step 2a - Get Test Data (from "X_test.txt" file
+ Step 3a - Apply column names to Test Data
+ Step 4a - Get the Test Data Subject column (from "subject_test.txt")
+ Step 5a - Apply column name to Test Subject column
+ Step 6a - Get the Test Activity column (from "y_test.txt")
+ Step 7a - Apply column name to Test Activity column
+ Step 8a - Glue columns together in this order: Activity | Subject | Data

Handle the "training" data...

+ Step 2b - Get Training Data (from "X_train.txt" file)
+ Step 3b - Apply column names to Train Data
+ Step 4b - Get the Train Data Subject column (from "subject_test.txt")
+ Step 5b - Apply column name to Train Subject column
+ Step 6b - Get the Train Activity column (from "y_train.txt")
+ Step 7b - Apply column name to Train Activity column
+ Step 8b - Glue them all together in this order: Activity | Subject | Data
+ Step 9  - Combine Test and Train into one data frame

Now using combined "test" and "training" data...

+ Step 10 - In the Activity column, replace
+ Step 11 - Left pad the Subject values with zero to make later sorting nicer
+ Step 12 - Get only columns "Activity", "Subject" and others dealing with means ("mean") or standard deviations ("std")
+ Step 13 - "Melt" the data so that the measured Variables are stored as rows
+ Step 14 - Find the averages for each "Activity" and "Subject" combination
+ Step 15 - Write the Tidy Data to a text file, "tidydata.txt"

(see the script "run_analysis.R" for even more details surrounding each step)

TIDY DATA:  In Hadley Wickham's "Journal of Statistical Software", volume VV,
issue II, page 4 (available at: http://vita.had.co.nz/papers/tidy-data.pdf), he
says that in "tidy data", "each variable forms a column" and "each observation
forms a row".

In the source dataset from the Human Activity Recognition project, the
"features" (like tBodyAcc-mean()-X,tBodyAcc-mean()-Y, tBodyAcc-mean()-Z)
were represented in columns with the measured values recorded in rows.

Since the "run_analysis.R" script averages for each Activity, Subject and
subset of "features", it seems "tidier" and more conducive for subsequent
use to arrange the output in a "tall skinny" arrangement like this:

Activity    Subject    Variable                       Average
LAYING      01         FreqBodyAccJerkMag_mean       -0.9333003608
LAYING      01         FreqBodyAccJerkMag_meanFreq    0.26639115416
:

By the definition of "tidy data", the original "features" can be considered
just another "variable" factoring into the averages.

The output table so arranged would be very easy to query using SQL with a
statement like:

SELECT average
FROM tidydata
WHERE activity='laying' AND subject='01' AND variable='FreqBodyAccJerkMag_mean'


Variable names from the original "features.txt" file have been slightly tweaked
for this script's output file.  The leading "t" has been replaced with "Time",
and the leading "f" replaced by "Freq".

The original column names contained chars that R won't like, such as "()" and
"-" and ",".

"-" is replaced with "_" to preserve term separations within names between
the thing being measured, like "fBodyAccMag", and the measurement, like
"mean()".

"()" are squeezed out, essentially replacing them with "" so that names
that looked like "_mean()" become "_mean", still very readible.

And the apparent typo "BodyBody" is replaced by "Body".


OUTPUT FILE: The tidy data output file, is named "tidydata.txt" and
is space delimited, with character strings enclosed in " ".

The First row contains column names, each enclosed with " ".

Exported columns are:

+ Activity   = character field, containing one of the 6 activities
+ Subject    = character field, ranging from 1 to 30
+ Variable   = character field, what parameter was measureed
+ Average    = numeric field, the average of the variable measurements for the indicated Activity and Subject

Ordering is by Activity, Subject and Variable name

Emjoy!
Jim




