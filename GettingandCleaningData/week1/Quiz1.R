# --- Question 1 - 2 ----
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./SurveyHousing.cvs")
data <- read.csv("SurveyHousing.cvs")

length(which(data$VAL == 24))

# --- Question 3 ----
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
# se tiene que establecer el mode = "wb"
download.file(fileUrl2, destfile = "./NaturalGasAquisition.xlsx", mode = "wb")
library(xlsx)
dat <- read.xlsx("NaturalGasAquisition.xlsx", sheetIndex = 1, 
                            header = TRUE, rowIndex = c(18, 19, 20, 21, 22, 23), 
                            colIndex = c(7, 8, 9, 10 ,11, 12, 13, 14, 15))
# funcion que se esta evaluando en el quiz 
sum(dat$Zip*dat$Ext,na.rm=T)

# ---- Question 4 ----
library(XML)
library(httr)
fileUrl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
# para que lo identifique como un elemento xml 
r = GET(fileUrl3)
dataRestaurants <- xmlTreeParse(r, useInternalNodes = TRUE)
rootNode <- xmlRoot(dataRestaurants)
xmlName(rootNode)
zipcode <- xpathSApply(rootNode, "//zipcode", xmlValue)
which(zipcode == 21231)
length(which(zipcode == 21231))

# ---- Question 5 ----
