# load the data 
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)

ncol(outcome)
nrow(outcome)
names(outcome)
head(outcome[, 7], 15)

# make a histogram 
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11], main = "Rates from Heart Attack", 
     xlab = "Rates from Heart Attack")



