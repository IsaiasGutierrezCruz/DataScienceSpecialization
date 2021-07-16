# ---- Question 1 ----
# The American Community Survey distributes downloadable data about United States 
# communities. Download the 2006 microdata survey about housing for the state 
# of Idaho using download.file() from here: 
  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names is here:
  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 

# Apply strsplit() to split all the names of the data frame on the characters 
# "wgtp". What is the value of the 123 element of the resulting list?
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "Data/HousingIdaho.csv")

data1 <- read.csv("Data/HousingIdaho.csv")

names_split <- strsplit(names(data1), "wgtp")
names_split[[123]][2]

# ---- Question 2 ----
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
  
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Remove the commas from the GDP numbers in millions of dollars and average them. 
# What is the average?
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl2, "Data/GrossDomesticProduct.csv")

domesticProductData <- read.csv("Data/GrossDomesticProduct.csv", skip = 5, header = FALSE)
domesticProductData <- domesticProductData[1:190, ]


GDPnumbers <- gsub(",", "", domesticProductData$V5)
mean(as.numeric(GDPnumbers))

# ---- Question 3 ----
# In the data set from Question 2 what is a regular expression that would allow 
# you to count the number of countries whose name begins with "United"? Assume 
# that the variable with the country names in it is named countryNames. 
# How many countries begin with United? 

countryNames <- domesticProductData$V4
  
length(grep("^United", countryNames))


# ---- Question 4 ----
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

# Load the educational data from this data set:
  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. Of the countries for which the 
# end of the fiscal year is available, how many end in June?

domesticProductData

url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url3, "Data/EducationalData.csv")
educationalData <- read.csv("Data/EducationalData.csv")

# merge: 
datasetsTogether <- merge(domesticProductData, educationalData, by.x = "V1", 
                          by.y = "CountryCode")

# ---- Question 5 ----
# You can use the quantmod (http://www.quantmod.com/) package to get historical 
# stock prices for publicly traded companies on the NASDAQ and NYSE. Use the 
# following code to download data on Amazon's stock price and get the times the 
# data was sampled.
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

dates <- as.Date(sampleTimes, "%d%b%Y")

# years
years <- as.numeric(format(dates,'%Y'))
length(which(years == 2012))
