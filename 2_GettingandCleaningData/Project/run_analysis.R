library(dplyr)
library(plyr)
library(reshape2)


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir.create("Data")
download.file(url, destfile = "Data/AccelerometersData.zip", mode = "wb")
setwd("Data")
unzip("AccelerometersData.zip")
setwd("../")

# ---- Merges the training and the test sets to create one data set ----- 
dataTest <- read.table(file = "Data/UCI HAR Dataset/test/X_test.txt")

dataTrain <- read.table(file = "Data/UCI HAR Dataset/train/X_train.txt")

fullData <- rbind(dataTest, dataTrain)

# ---- Extracts only the measurements on the mean and standard deviation for each ----
# measurement
features <- read.table(file = "Data/UCI HAR Dataset/features.txt")

fullData <- fullData[, grep("mean|std", features$V2)]
names(fullData) <- grep("mean|std", features$V2, value = TRUE)


subjectsDataTest <- read.table(file = "Data/UCI HAR Dataset/test/subject_test.txt")
subjectsDataTrain <- read.table(file = "Data/UCI HAR Dataset/train/subject_train.txt")
 
fullData$subjects <- c(subjectsDataTest$V1, subjectsDataTrain$V1)

activitiesDataTest <- read.table(file = "Data/UCI HAR Dataset/test/y_test.txt")
activitiesDataTrain <- read.table(file = "Data/UCI HAR Dataset/train/y_train.txt")

fullData$activities <- c(activitiesDataTest$V1, activitiesDataTrain$V1)

# ---- Uses descriptive activity names to name the activities in the data set ---- 
activitiesNames <- read.table(file = "Data/UCI HAR Dataset/activity_labels.txt")
activitiesNames$V2 <- tolower(activitiesNames$V2)
activitiesNames$V2 <- sub("_", "", activitiesNames$V2)

for (i in seq_along(activitiesNames$V1)){
  fullData$activities <- sub(as.character(activitiesNames$V1[i]), 
                             activitiesNames$V2[i], as.character(fullData$activities))
}

# --- Appropriately labels the data set with descriptive variable names ----
descriptiveLabels <- names(fullData)
descriptiveLabels <- gsub("\\(\\)", "", descriptiveLabels)
descriptiveLabels <- gsub("^t", "time", descriptiveLabels)
descriptiveLabels <- gsub("^f", "frecuency", descriptiveLabels)
descriptiveLabels <- gsub("-", "", descriptiveLabels)

names(fullData) <- descriptiveLabels

# ---- From the data set in step 4, creates a second, independent ----
# tidy data set with the average of each variable for each activity and each subject.

meltedData <- melt(fullData, id = c("activities", "subjects"))
tidyData <- dcast(meltedData, subjects + activities ~ variable, mean)

write.table(tidyData, "tidy_dataset.txt", row.names = FALSE, quote = FALSE)
