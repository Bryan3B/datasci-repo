## run_analysis.R  
## does the following.
## 1. Merges the training and the test sets to create one data set. 
## 2. Extracts only the measurements on the mean and standard deviation for 
##    each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set 
## 4. Appropriately labels the data set with descriptive activity names. 
## 5. Creates a second, independent tidy data set with the average of each 
##    variable for each activity and each subject. 
## 

# setwd("~/studyJH-DataSci/3-GetData/GetData-Proj")
rm(list=ls())

# file with column numbers of the means and stds with variable names to be 
# extracted from the X data files.
usedata <- read.table(file="./featuresmeanstd.txt", 
                      colClasses = c("integer", "character"))

# read in the test and training data set and extract the X means and stds
# then combine data into one dataframe "data_all".
s_tst <- read.table(file="./UCI HAR Dataset/test/subject_test.txt")
y_tst <- read.table(file="./UCI HAR Dataset/test/y_test.txt")
x_tst <- read.table(file="./UCI HAR Dataset/test/X_test.txt")
x_tst <- x_tst[,usedata$V1]
tst <- cbind(s_tst, y_tst, x_tst)

s_trn <- read.table(file="./UCI HAR Dataset/train/subject_train.txt")
y_trn <- read.table(file="./UCI HAR Dataset/train/y_train.txt")
x_trn <- read.table(file="./UCI HAR Dataset/train/X_train.txt")
x_trn <- x_trn[,usedata$V1]
trn <- cbind(s_trn, y_trn, x_trn)

data_all <- rbind(trn, tst)
rm(s_tst, y_tst, x_tst, tst, s_trn, y_trn, x_trn, trn)

# label the variable in the dataframe. 
names(data_all) <- c("subject", "Y", usedata$V2)

##  Creates a second, independent tidy data set with the average of each 
##  variable for each activity and each subject. 
df_avg <- data_all[1,]
cnt <- 1
for (ii in seq(1,30)) {
    for (jj in seq(1,6)){
      tiddy <- lapply(data_all[(data_all$subject == ii) & 
                               (data_all$Y == jj),seq(3,75)],mean)
      df_avg[cnt,] <- c(ii,jj,tiddy)
      cnt <- cnt + 1
    }
}
rm(cnt, ii, jj, tiddy)

write.csv(df_avg, file="./df_avg.txt")
