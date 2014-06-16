## Download and unzip the file##
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile="getdata_projectfiles_UCI_HAR_Dataset.zip")

unzip("getdata_projectfiles_UCI_HAR_Dataset.zip")

close(con)

setwd("C:/Users/Sameer/Desktop/UCI HAR Dataset")

## Read features.txt which has column names
ColNames<-read.table("features.txt",col.names=c("id","ColumnName"))

## Identify columns with "mean" and "std" in columns names and save these columns in a new datafeame : RelevantCols
RelevantCols<-ColNames[grep("mean|std",ColNames[,2]),]
## Remove '-' and '()' from column names so that they are meaningful
RelevantCols[,2]<-gsub("-","_",RelevantCols[,2])
RelevantCols[,2]<-gsub("\\(|\\)", "", RelevantCols[,2])


## Read subject_test.txt, X_test.txt and Y_test.txt and assign them relevant column names
## Note: Only the columns with "mean" and "std" in column names are read from X_test.txt

Subject_Test<-read.table("test/subject_test.txt",col.names="Subject_id")

X_Test<-read.table("test/X_test.txt")[,RelevantCols$id]
colnames(X_Test) <- RelevantCols$ColumnName

Y_Test<-read.table("test/Y_test.txt",col.names="Activity_id")

## Columns from subject_test, X_test and Y_test combined to form complete Test dataset: Test_DS
Test_DS<-cbind(Subject_Test,X_Test,Y_Test)


## Read subject_train.txt, X_train.txt and Y_train.txt and assign them relevant column names
## Note: Only the columns with "mean" and "std" in column names are read from X_train.txt

Subject_Train<-read.table("train/subject_train.txt",col.names="Subject_id")

X_Train<-read.table("train/X_train.txt")[,RelevantCols$id]
colnames(X_Train) <- RelevantCols$ColumnName

Y_Train<-read.table("train/Y_train.txt",col.names="Activity_id")

## Columns from subject_train, X_train and Y_train combined to form complete Train dataset: Train_DS
Train_DS<-cbind(Subject_Train,X_Train,Y_Train)

## Test dataset and Train dataset combined to form the complete dataset: Compete_DS
Complete_DS<-rbind(Train_DS, Test_DS)

## Mean of all the variables calculated for each unique combination of Subject_id and Activity_id
tidy_data<-aggregate(Complete_DS[,2:80], list(Subject_id = Complete_DS$Subject_id, Activity_id = Complete_DS$Activity_id), mean)

## Dataset thus formed ordered by Subject_id in increasing order to form tidy dataset: tidy_data with 180 rows and 81 columns
tidy_data<-tidy_data[order(tidy_data$Subject_id, decreasing=F), ]

## Tidy dataset exported to "tidy_data.csv"
write.csv(tidy_data,"tidy_data.csv")
## Tidy dataset exported to "tidy_data.txt"
write.table(tidy_data, "tidy_data.txt", sep="\t")

