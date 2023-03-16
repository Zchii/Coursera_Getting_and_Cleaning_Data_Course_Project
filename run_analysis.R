library(dplyr)

## merge the X_train dataset and the X_test dataset
Data = rbind(read.table("UCI HAR Dataset/train/X_train.txt"),read.table("UCI HAR Dataset/test/X_test.txt"))
## name the xData with feature.txt
names(Data) <- read.table("UCI HAR Dataset/features.txt")[,2]

##Extracts only the measurements on the mean and standard deviation for each measurement
Data = Data[,grep("mean\\(\\)|std\\(\\)", names(Data))]

##merge y_train and y_test data set
yData = rbind(read.table("UCI HAR Dataset/train/y_train.txt"), read.table("UCI HAR Dataset/test/y_test.txt"))
## read the index in the activity_labels.txt
act_name = read.table('UCI HAR Dataset/activity_labels.txt')[,2]
##name the activity in yData
activity = factor(act_name[yData[,1]])

## read the subject number from the subject_train.txt and subject_test.txt
subs = rbind(read.table('UCI HAR Dataset/train/subject_train.txt'),read.table('UCI HAR Dataset/test/subject_test.txt'))
names(subs) = 'subject'
## merge the subject and activity with Data
Data = cbind(subs, activity, Data)

## modify the variables name
name_mo = gsub('\\(\\)','',names(Data))
name_mo = gsub('-','',name_mo)
names(Data) = tolower(name_mo)

## calculate the mean of the average of each variable for each activity and each subject
Data_mean = Data %>%
    group_by(subject, activity)%>%
    summarise(across(1:66,mean))

## Save the tidy data as txt
write.table(Data_mean, file = 'tidy_Data.txt', row.names = FALSE)