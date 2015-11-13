library(dplyr)

smartphone_zip_dest <- "C:\\Temp\\smartphone_dataset.zip"
smartphone_zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
smartphone_unzip_dest <- "C:\\Temp"
download.file(smartphone_zip_url,destfile=smartphone_zip_dest)
unzip(smartphone_zip_dest, exdir=smartphone_unzip_dest)

#read data from files into dataframes
activity_labels <- read.table("C:\\Temp\\UCI HAR Dataset\\activity_labels.txt")
features <- read.table("C:\\Temp\\UCI HAR Dataset\\features.txt")


subject_train <- read.table("C:\\Temp\\UCI HAR Dataset\\train\\subject_train.txt")
x_train <- read.table("C:\\Temp\\UCI HAR Dataset\\train\\x_train.txt")
y_train <- read.table("C:\\Temp\\UCI HAR Dataset\\train\\y_train.txt")

subject_test <- read.table("C:\\Temp\\UCI HAR Dataset\\test\\subject_test.txt")
x_test <- read.table("C:\\Temp\\UCI HAR Dataset\\test\\x_test.txt")
y_test <- read.table("C:\\Temp\\UCI HAR Dataset\\test\\y_test.txt")


#assign column names
colnames(activity_labels) <- c("activity_id","activity")
colnames(y_test) <- c("activity_id")
colnames(y_train) <- c("activity_id")
colnames(subject_test) <- c("subject")
colnames(subject_train) <- c("subject")

names(x_test) <- features[,2]
names(x_train) <- features[,2]

#reduced test/train datasets to include only mean() and std() columns
x_test <- x_test[,grepl("mean\\(\\)|std\\(\\)",names(x_test))] 
x_train <- x_train[,grepl("mean\\(\\)|std\\(\\)",names(x_train))]


#combine test subject, data, and activity dataframes into one
test_data <- cbind(subject_test, x_test,y_test)

#combine training subject, data, and activity dataframes into one
train_data <- cbind(subject_train, x_train, y_train)

#combine rows from train and test sets
all_data <- rbind(test_data, train_data)

#merge activity names into data set
all_data <- merge(all_data, activity_labels, by="activity_id")

#use dplyr to group by subject/activity apply mean to all data columns
tidy_data <- all_data %>% group_by(subject, activity) %>% summarize_each(funs(mean))

#write tidy data to file
write.table(tidy_data, file="C:\\Temp\\tidy_data.txt")



