library(data.table)
library(plyr)

analysis <- function(){
    
    # Downloads the file 
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if(!file.exists("./data")){
        dir.create("./data")
        download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
        unzip(zipfile="./data/Dataset.zip",exdir="./data")
    }
    
    # Sets the path
    path_rf <- file.path("./data" , "UCI HAR Dataset")
    files<-list.files(path_rf, recursive=TRUE)

    # Reads the test data
    test.subject_test <- fread(file.path(path_rf, "test" , "subject_test.txt"))
    test.X_test <- fread(file.path(path_rf, "test" , "X_test.txt" ))
    test.Y_test <- fread(file.path(path_rf, "test" , "y_test.txt" ))
    
    # Reads the train data
    train.subject_train <- fread(file.path(path_rf, "train" , "subject_train.txt"))
    train.X_train <- fread(file.path(path_rf, "train" , "X_train.txt" ))
    train.Y_train <- fread(file.path(path_rf, "train" , "y_train.txt" ))
    
    # Row bind x train and test data and attribute 
    # features names
    x_data <- rbind(train.X_train, test.X_test)
    features <- fread(file.path(path_rf, "features.txt"))
    names(x_data) <- features$V2

    test <- cbind(test.subject_test, test.Y_test)
    train <- cbind(train.subject_train, train.Y_train)
    
    data <- rbind(test, train)
    
    # Put it all together
    data <- cbind(data, x_data)
    
    colnames(data)[1:2] <- c("Subject", "Activity")
    
    # Get the std and mean
    mean_std <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
    full_names <- c("Subject", "Activity", mean_std)
    
    # Subset only the required columns
    data <- subset(data, select=full_names)
    
    activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
    
    # Give descriptive names to activities
    data$Activity <- factor(data$Activity, labels=activityLabels$V2)
    
    # Give descriptive names to variables
    names(data) <- gsub('Acc',"Acceleration", names(data))
    names(data) <- gsub('Gyro',"Gyroscope", names(data))
    names(data) <- gsub('Mag',"Magnitude", names(data))
    names(data) <- gsub('GyroJerk',"AngularAcceleration", names(data))
    names(data) <- gsub('^t',"Time", names(data))
    names(data) <- gsub('^f',"Frequency", names(data))
    names(data) <- gsub('\\-std',"StandardDeviation", names(data))
    
    # New tidy dataset
    tidy_data <-aggregate(. ~Subject + Activity, data, mean)
    tidy_data <- arrange(tidy_data, Subject, Activity)
    write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)
}

analysis()