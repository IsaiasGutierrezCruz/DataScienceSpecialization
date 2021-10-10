library(dplyr)
# ---- get the data ----
setwd("./3_ExploratoryDataAnalysis/CourseProject2")

if (!dir.exists("Data")){
  dir.create("Data")
}

setwd("./3_ExploratoryDataAnalysis/CourseProject2/Data")

fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists('./Data/dataProject2.csv')){
  invisible(download.file(fileUrl,"./Data/dataCourseProject2.zip"))
  unzip("Data/dataCourseProject2.zip", exdir = getwd())
}
unlink('./Data/dataCourseProject2.zip')

NEI <- readRDS("Data/Source_Classification_Code.rds")
SCC <- readRDS("Data/summarySCC_PM25.rds")

# ---- do the plot ---- 
png(file = "plot2.png")

dataPlot2 <- SCC %>% filter(fips == "24510") %>% group_by(year) %>% 
       summarize(mean = mean(Emissions))
plot(dataPlot2, xlab = "Year", ylab = "Mean Total PM2.5 Emissions", main = "Mean Total PM2.5 Emissions per year in Baltimore City", pch = 19)
lines(dataPlot2$year, dataPlot2$mean)

dev.off()
