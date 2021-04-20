# Finding the best hospital in a state 
best <- function(state, outcome) {
  # load the data 
  fileData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  # create a list for keep the variables
  variables <- list("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  # 2 = Hospital's name,  7 = State
  data <- fileData[, c(2, 7, as.numeric(variables[[outcome]]))]
  # remove the "Not Available" values 
  datacomplete <- data[data[3] != "Not Available", ]
  # get only the data of the state
  dataState <- datacomplete[datacomplete[2] == state, ]
  # convert the data type character to numeric
  dataState[, 3] <- as.numeric(dataState[, 3])
  # get the minor mortality
  minMortality <- dataState[dataState[, 3] == min(as.numeric(dataState[, 3])), ]
  #get the name of the hospital
  name <- minMortality[, 1]
  name
}