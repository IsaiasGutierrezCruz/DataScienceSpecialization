# load the data 
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)


outcome[3897, ]
variables <- list("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
variables[["heart attack"]]
data <- outcome[good, ][, c(2, 7, variables[["heart attack"]])]
print(head(data))

ncol(outcome)
nrow(outcome)
names(outcome)
head(outcome[, 7], 15)

# make a histogram 
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11], main = "Rates from Heart Attack", 
     xlab = "Rates from Heart Attack")



