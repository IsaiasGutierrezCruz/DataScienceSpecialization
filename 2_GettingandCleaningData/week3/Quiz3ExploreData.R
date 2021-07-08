# ---- Question 1 -----
# The American Community Survey distributes downloadable data about United 
# States communities. Download the 2006 microdata survey about housing for 
# the state of Idaho using download.file() from here: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
# Create a logical vector that identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products. Assign that 
# logical vector to the variable agricultureLogical. Apply the which() function 
# like this to identify the rows of the data frame where the logical vector is TRUE. 

# which(agricultureLogical) 

# What are the first 3 values that result?
library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "Data/Communities.csv")
data <- read.csv("Data/Communities.csv")
which(data$ACR == 3 & data$AGS == 6)

# ---- Question 2 ----
# Using the jpeg package read in the following picture of your instructor into R
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
# resulting data? (some Linux systems may produce an answer 638 different for 
# the 30th quantile)
library(jpeg)
data2 <- readJPEG("Data/getdata_jeff.jpg", native = TRUE)
data2
quantile(data2, c(0.3, 0.8))

# ---- Question 3 ---- 
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is 
# last). What is the 13th country in the resulting data frame?
# Original data sources: 
# --- 
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats

fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl2, destfile = "Data/GrossDomesticProductData.csv")
domesticProductData <- read.csv("Data/GrossDomesticProductData.csv", skip = 5, header = FALSE)
fileUrl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl3, destfile = "Data/EducationalData.csv")
educationalData <- read.csv("Data/EducationalData.csv")


domesticProductData <- read.csv("Data/GrossDomesticProductData.csv", skip = 5, header = FALSE)
domesticProductData <- domesticProductData[1:190, ]
datasetsTogether <- merge(domesticProductData, educationalData, by.x = "V1", 
                          by.y = "CountryCode")
datasetsTogether$V2 <- as.integer(datasetsTogether$V2)
datasetsTogether <- arrange(datasetsTogether, desc(V2))

# ---- Question 4 ----
# What is the average GDP ranking for the "High income: OECD" and 
# "High income: nonOECD" group? 
OECD <- datasetsTogether %>% filter(Income.Group == "High income: OECD") %>%
  select("V2")
mean(OECD[[1]])  

nonOECD <- datasetsTogether %>% filter(Income.Group == "High income: nonOECD") %>%
  select("V2")
mean(nonOECD[[1]])  

# ---- Question 5 ----
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus 
# Income.Group. How many countries are Lower middle income but among the 38 
# nations with highest GDP?
datasetsTogether$V2 <- as.numeric(datasetsTogether$V2)
datasetsTogether$quantileGroups <- cut(datasetsTogether$V2, 
                                       breaks = quantile(datasetsTogether$V2, 
                                                        c(), na.rm = TRUE))
table(datasetsTogether$quantileGroups, datasetsTogether$Income.Group)
