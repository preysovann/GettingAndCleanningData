# run_analysis.R
# The following codes will perform the following tasks.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Obtain necessary library for data manipulation
library(reshape2)


# Obtain data from the sources, and prepare data for further processing
dataSourcesDir <- "./DataSources"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datafile <- "fuci_har_dataset.zip"
dataFilenameFull <- paste(dataSourcesDir, "/", "fuci_har_dataset.zip", sep = "")
dataProcessingDir <- "./DataProcessing"

if (!file.exists(dataSourcesDir)) {
  dir.create(dataSourcesDir)
  download.file(url = url, destfile = dataFilenameFull)
}

if (!file.exists(dataProcessingDir)) {
  dir.create(dataProcessingDir)
  unzip(zipfile = dataFilenameFull, exdir = dataProcessingDir)
}


# Prepare and Merge both train and test datasets
# read train data
x_train <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/train/Y_train.txt"))
sub_train <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/train/subject_train.txt"))

# read test data
x_test <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/test/Y_test.txt"))
sub_test <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/test/subject_test.txt"))

# merge train and test data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
sub_data <- rbind(sub_train, sub_test)


# Load feature & activity info
# feature info
feature <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/features.txt"))

# activity labels
a_label <- read.table(paste(sep = "", dataProcessingDir, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

# extract feature columns named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


# Extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(sub_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


# Generate tidy data set
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)