# Load the files
features <- read.table("./features.txt", stringsAsFactors=FALSE, header=FALSE, sep="")
activity_labels <- read.table("./activity_labels.txt", stringsAsFactors=FALSE, header=FALSE, sep="")

test_x = read.table("./test/X_test.txt", stringsAsFactors=FALSE, header=FALSE)
test_y = read.table("./test/y_test.txt", stringsAsFactors=FALSE, header=FALSE)
test_subjects = read.table("./test/subject_test.txt", stringsAsFactors=FALSE, header=FALSE)

train_x = read.table("./train/X_train.txt", stringsAsFactors=FALSE, header=FALSE)
train_y = read.table("./train/y_train.txt", stringsAsFactors=FALSE, header=FALSE)
train_subjects = read.table("./train/subject_train.txt", stringsAsFactors=FALSE, header=FALSE)

A <- cbind(test_y, test_subjects)
names(A)[1:2] <- c("Activity", "Subject")  # rename the first 2 column headings

B <- cbind(train_y, train_subjects)
names(B)[1:2] <- c("Activity", "Subject")

C <- rbind(A, B)
D <- rbind(train_x, test_x)

names(D)[1:561] <- features[,2]  # rename column headings

# extract columns that contain "mean()" and "std()"
D_Mean_Col <- D[,grep("mean\\(\\)", colnames(D))]
D_Std_Col <- D[,grep("std\\(\\)", colnames(D))]

E <- cbind(D_Mean_Col, D_Std_Col)
F <- cbind(C, E)

# get the mean of observations of activity per subject
g <- split(F[,1:68], list(F$Activity, F$Subject))
splitData <- sapply(g, colMeans)

# replace the [1,6] values in the first row, with strings representing the activity (e.g. "WALKING", "SITTING")
splitData[1,] <- replace(splitData[1,], c(1:180), activity_labels[,2])

write.csv(splitData, file = "FinalTable.csv")