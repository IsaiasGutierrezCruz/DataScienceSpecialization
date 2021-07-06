corr <- function(directory = "specdata", threshold = 0){
  id = 1:332
  correlation <- vector(mode = "numeric", length = 0)
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
    
    # get which values are NA
    temporalDataNitrate <- file["nitrate"]
    good1 <- complete.cases(temporalDataNitrate[, 1])
    temporalDataSulfate <- file["sulfate"]
    good2 <- complete.cases(temporalDataSulfate[, 1])
    
    # get the coincidences 
    count_nobs <- 0
    coincidendces_index <- vector(mode = "numeric", length = 0)
    for (j in seq_along(good1)){
      for (k in seq_along(good2)){
        if (j == k && good1[j] == TRUE && good2[k] == TRUE){
          count_nobs <- count_nobs + 1
          coincidendces_index <- c(coincidendces_index, j)
        }
      }
    }
    
    # evaluate if the count_nobs is greater than the threshold
    if (count_nobs > threshold){
      # calculate the correlation
      vectorCalculateSulfate <- temporalDataSulfate[, 1][coincidendces_index]
      vectorCalculateNitrate <- temporalDataNitrate[, 1][coincidendces_index]
      correlation <- c(correlation, cor(vectorCalculateSulfate, 
                                        vectorCalculateNitrate))
    }
  }
  correlation
}