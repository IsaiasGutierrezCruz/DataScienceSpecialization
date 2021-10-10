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

coalSCC <- NEI[grepl(".*[Cc]oal.*", NEI$EI.Sector), 1]

dataPlot4 <- SCC %>% filter(SCC %in% coalSCC) %>% select(Emissions, year) %>% 
  group_by(year) %>% summarize(mean = mean(Emissions))

plot4 <- ggplot(data = dataPlot4, mapping = 
          aes(x=year, y=mean)) + geom_point() + geom_line() + 
          ggtitle("Mean Total PM2.5 Emissions in us related with Coal combustion") +
          xlab("Year") + ylab("Mean Total PM2.5 Emissions") 

plot4 <- plot4 + theme(plot.title = element_text(size=11, hjust = 0.5, vjust = 0, 
                                        face = "bold")) 
ggsave(filename = "plot4.png", plot = plot4, units = c("cm"), 
       width = 30, height = 20, dpi = 200, limitsize = FALSE)
