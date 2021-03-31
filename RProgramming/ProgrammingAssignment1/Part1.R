pollutantmean <- function(directory = "specdata", pollutant, id = 1){
  total_amount <- 0
  total_elements <- 0
  for (i in seq_along(id)){
    # set a format of the id 
    if (nchar(id[i]) == 1){
      ajust_id <- paste("00", id[i], sep = "")
    } else if(nchar(id[i]) == 2){
      ajust_id <- paste("0", id[i], sep = "")
    } else {
      ajust_id <- id[i]
    }
    
    # get the directory of each file 
    directory_file <- paste(directory[1], "/", ajust_id, ".csv", sep = "")
    # read each file 
    file <- read.csv(file = directory_file)
    
    # put off NA
    temporalData <- file[pollutant]
    good <- complete.cases(temporalData[, 1])
    calculationData <- temporalData[, 1][good]
    
    # get the data of each file 
    total_elements <- total_elements + length(calculationData)
    total_amount <- total_amount + sum(calculationData)
    rm(temporalData, good, calculationData)
  }
  
  # calculate the mean 
  meanTotal <- total_amount/total_elements
  #print(meanTotal)
}

