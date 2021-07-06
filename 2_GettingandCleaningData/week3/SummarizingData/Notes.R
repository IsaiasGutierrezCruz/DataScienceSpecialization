restData <- read.csv("restaurants.csv")
summary(restData)
str(restData)

restData$nearMe <- restData$nghbrhd %in% c("Roland Park", "Homeland")
table(restData$nearMe)

restData$zipWrong <- ifelse(restData$zipcode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipcode < 0) 

# Creating caategorical variables
restData$zipcode <- as.numeric(restData$zipcode)
restData$zipGroups <- cut(restData$zipcode, breaks=quantile(restData$zipcode, na.rm = TRUE))
table(restData$zipGroups)

table(restData$zipGroups, restData$zipcode)

# ---- Reshaping ----
library(reshape2)
data("mtcars")
head(mtcars)
row.names(mtcars)

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp")) 
