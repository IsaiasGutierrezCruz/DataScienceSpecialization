# rank the hospital 
rankall <- function(outcome, num = "best") {
  # load the data 
  fileData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  #manage of errors 
  possiblesOutcome <- c("heart attack", "heart failure", "pneumonia")
  if (any(possiblesOutcome == outcome) == FALSE){
    stop("Invalid outcome")
  }
  
  
  # create a list for keep the variables
  variables <- list("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  # 2 = Hospital's name,  7 = State
  data <- fileData[, c(2, 7, as.numeric(variables[[outcome]]))]
  # remove the "Not Available" values 
  datacomplete <- data[data[3] != "Not Available", ]
  
  
  numEachState <- data.frame(hospital = character(), state = character())
  possiblesStates <- unique(fileData[, 7])
  possiblesStates <- sort(possiblesStates, decreasing = FALSE)
  for (state in possiblesStates){
    # get only the data of the state
    dataState <- datacomplete[datacomplete[2] == state, ]
    # convert the data type character to numeric
    dataState[, 3] <- as.numeric(dataState[, 3])
    
    # order the data and get the hospital's name by the position set 
    sortData <- dataState[with(dataState, order(dataState[3], dataState[1])), ]
    rowsNumbers <- nrow(dataState)
    if (num == "best"){
      keepData <- sortData[1, ]
    } else if (num == "worst"){
      keepData <- sortData[rowsNumbers, ]
    } else if (num > rowsNumbers){
      keepData <- NA
    } else {
      keepData <- sortData[num, ]
    }
    
    if (!is.na(keepData[1][1])){
      keepData <- keepData[, c(1 , 2)]
      numEachState <- rbind(numEachState, keepData)
    }
  }
  colnames(numEachState) <- c("hospital", "state")
  numEachState
}