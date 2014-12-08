# You should create one R script called run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
testDataFrame <- data.frame(read.table("UCI HAR Dataset/test/X_test.txt"))
testDataFrameLabels <- data.frame(read.table("UCI HAR Dataset/test/y_test.txt"))
testDataFrameSubject <- data.frame(read.table("UCI HAR Dataset/test/subject_test.txt"))

trainDataFrame <- data.frame(read.table("UCI HAR Dataset/train/X_train.txt")) 
trainDataFrameLabels <- data.frame(read.table("UCI HAR Dataset/train/y_train.txt"))
trainDataFrameSubject <- data.frame(read.table("UCI HAR Dataset/train//subject_train.txt"))

names(trainDataFrameLabels) <- c("Label")
names(trainDataFrameSubject) <- c("Subject")

names(testDataFrameLabels) <- c("Label")
names(testDataFrameSubject) <- c("Subject")

testData <- cbind(testDataFrame, testDataFrameLabels, testDataFrameSubject)
trainData <- cbind(trainDataFrame, trainDataFrameLabels, trainDataFrameSubject)


data <- rbind(testData, trainData)
# Extracts only the measurements on the mean and standard deviation for each measurement. 
dataMean <- apply(data, 1, mean)
dataSD <- apply(data, 1, sd)
finalData <- data.frame(cbind(data$Subject, data$Label, dataMean, dataSD))
names(finalData)[1:2] <- c("Subject", "Label")
# Uses descriptive activity names to name the activities in the data set
finalData$Activity <- lapply(finalData$Label, activityNumber)
# Appropriately labels the data set with descriptive variable names. 
names(finalData)[3:4] <- c("Mean", "StandardDeviation")
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data2 <- data.frame()
for (subject in unique(finalData$Subject)){
    for (label in unique(finalData$Label)){
        meanMean <- mean(finalData[finalData$Label == label & finalData$Subject == subject,]$Mean)
        sdMean <- mean(finalData[finalData$Label == label & finalData$Subject == subject,]$StandardDeviation)
        print(m)
        data2 <- rbind(data2, list(subject, label, meanMean, sdMean))
    }
}
names(data2) <- c("Subject", "Label", "Mean average", "SD average")

#Aux functionsdata2[order(data2$Subject, data2$Label),]
data2[order(data2$Subject, data2$Label),]
activityNumber <- function(raw){
    number <- as.character(raw)
    switch(number, "1" = "WALKING",
           "2" = "WALKING_UPSTAIRS",
           "3" = "WALKING_DOWNSTAIRS",
           "4" = "SITTING",
           "5" = "STANDING",
           "6" = "LAYING")    
}
