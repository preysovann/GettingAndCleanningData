The codes in run_analysis.R will perform the following steps:

1. Download the dataset from the sources web site if it does not already exist in the working directory.
2. Read both the train and test datasets and merge them into x(measurements), y(activity) and subject, respectively.
3. Load the data(x's) feature, activity info and extract columns named 'mean' and 'standard'. Then give descriptive name to the columns.
4. Extract data by selected columns(from step 3), and merge x, y(activity) and subject data. Also, replace y(activity) column to it's name by refering activity label (in step 3).
5. Generate 'Tidy Dataset' consisting of the average (mean) of each variable for each subject and each activity. The result is shown in the file tidy_dataset.txt.