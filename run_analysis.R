#Read the fitbit data from textfiles into R
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Read the feature labels into R
feat <- read.table("./UCI HAR Dataset/features.txt")
#Read the activity labels into R
active <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Add names to feature columns
names(feat) <- c("Feature_id", "Feature_name")
names(active) <- c("Id", "Activity")

#Combine data into data sets 
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
sub_data <- rbind(subject_train, subject_test)

#Search x_data for matched to std or mean
index_features <- grep("-mean\\(\\)|-std\\(\\)", feat$Feature_name) 
x_data <- x_data[, index_features] 

# Replaces all matches of a string features 
names(x_data) <- gsub("\\(|\\)", "", (feat[index_features, 2]))

#Add column names for y_data and sub_data
y_data[, 1] = active[y_data[, 1], 2]
names(y_data) <- "Activity"
names(sub_data) <- "Subject"

#Merge all data into one tidy dataset
TDset <- cbind(x_data, y_data, sub_data)

#Create dataset with mean and std values
p <- TDset[, 3:dim(TDset)[2]]
TDMeanSD <- aggregate(p,list(TDset$Subject, TDset$Activity), mean)

#Add correct column names
names(TDMeanSD)[1] <- "Subject"
names(TDMeanSD)[2] <- "Activity"

#Write tabels from data
write.table(TDset, "./UCI HAR Dataset/TidyDataSet.txt")
write.table(TDMeanSD, "./UCI HAR Dataset/TidyMeanStd.txt", row.names = FALSE)
