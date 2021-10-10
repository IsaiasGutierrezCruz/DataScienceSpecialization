library(ggplot2)
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

dataPlot3 <- SCC %>% filter(fips == "24510") %>% group_by(type, year) %>% summarize(mean = mean(Emissions))

plot3 <- ggplot(data = dataPlot3, mapping = 
          aes(x=year, y=mean, color = type, shape = type)) + geom_point() + 
          geom_smooth(method=lm, se = FALSE, fullrange = TRUE) + 
          ggtitle("Mean Total PM2.5 Emissions from 1999 to 2008 in Baltimore City per type of source") + 
          xlab("Year") + ylab("Mean Total PM2.5 Emissions") 

plot3 <- plot3 + theme(plot.title = element_text(size=11, hjust = 0.5, vjust = 0, 
                                        face = "bold")) 
ggsave(filename = "plot3.png", plot = plot3, units = c("cm"), 
       width = 30, height = 20, dpi = 200, limitsize = FALSE)
