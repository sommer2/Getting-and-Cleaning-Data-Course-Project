library(data.table)
# Load all training and test data
X_train<-read.table("./UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

X_test<-read.table("./UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# Merge X, y, and subject training and test sets
X_merged<-rbind(X_train,X_test)
y_merged<-rbind(y_train,y_test)
subject_merged<-rbind(subject_train,subject_test)

# Extract the mean and standard deviation for each measurement
features<-read.table("./UCI HAR Dataset/UCI HAR Dataset/features.txt")
# Create the string for mean and std and find its indices in features
mean_std<-c(".*mean\\(\\).*",".*std\\(\\).*") 
indexMatch<-grep(paste(mean_std,collapse="|"), features$V2)
# Extract columns containing X's mean and std info
X_extract<-X_merged[,indexMatch]
# Rename the columns with descriptive measurements
colnames(X_extract)<-features$V2[indexMatch]

# Apply descriptive names to the activities in the data set
activity_label<-read.table("./UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
activity_label$V2 = factor(x=activity_label$V2, levels=activity_label$V2)
descriptive_label<-activity_label$V2[y_merged[,]]

# Create a tidy data set with the average of each variable for each activity and each subject
new_data<-cbind(subject_merged,descriptive_label,X_extract)
colnames(new_data)<-c("subject","descriptiveactivity",colnames(X_extract))

new_DT<-data.table(new_data)
tidy_data<-new_DT[,lapply(.SD,mean),by=list(subject,descriptiveactivity)]
write.table(tidy_data, file="tidy_data.txt", quote=FALSE, row.names=FALSE, sep="\t")

print("run_analysis.R complete")
print("Text file tidy_data.txt created succesfully")

