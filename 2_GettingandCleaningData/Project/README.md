# Getting and Cleaning Data. Project 

## Content of the `run_analysis.R` script:
1. Download the data set from web 
2. Read the train and test data sets and merge them into "fullData"
3. Load the file "features.txt" to extract Only the measurements on the mean and standard deviation  
4. Load the files that contain the subject and activities to add them into "fullData"
5. Add descriptive names to the activities into the data set 
6. Add descriptive names to the variables (`t` to `time`, `f` to `frecuency`, and remove symbols like `-`, `(`, `)`
7. Generate the "Tidy data set" that consists of the average of each subject and each activity. The result is shown in the `tidy_dataset` file.