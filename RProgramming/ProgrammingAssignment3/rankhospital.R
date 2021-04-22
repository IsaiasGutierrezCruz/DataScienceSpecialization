# rank the hospital 
rankhospital <- function(state, outcome, num = "best") {
  # load the data 
  fileData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  #manage of errors 
  possiblesOutcome <- c("heart attack", "heart failure", "pneumonia")
  if (any(possiblesOutcome == outcome) == FALSE){
    stop("Invalid outcome")
  }
  possiblesStates <- unique(fileData[, 7])
  if (any(possiblesStates == state) == FALSE){
    stop("Invalid state")
  }
  
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
  
  # order the data and get the hospital's name by the position set 
  sortData <- dataState[with(dataState, order(dataState[3], dataState[1])), ]
  rowsNumbers <- nrow(dataState)
  if (num == "best"){
    result <- sortData[1, ]
  } else if (num == "worst"){
    result <- sortData[rowsNumbers, ]
  } else if (num > rowsNumbers){
    result <- NA
  } else {
    result <- sortData[num, ]
  }
  
  if (!is.na(result[1][1])){
    result <- result[, 1]
  }
  result
}