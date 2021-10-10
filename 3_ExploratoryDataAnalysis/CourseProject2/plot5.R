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

vehicleSCC <- NEI[grepl(".*[Vv]ehicle.*", NEI$SCC.Level.Two), 1]

dataPlot5 <- SCC %>% filter(fips == "24510", SCC %in% vehicleSCC) %>% 
  group_by(year) %>% summarize(mean = mean(Emissions))

plot5 <- ggplot(data = dataPlot5, mapping = 
          aes(x=year, y=mean, fill = year)) + geom_bar(stat = "identity") + 
          ggtitle("Mean Total PM2.5 Emissions in Baltimore City related with motor vehicle") +
          xlab("Year") + ylab("Mean Total PM2.5 Emissions") 

plot5 <- plot5 + theme(plot.title = element_text(size=11, hjust = 0.5, vjust = 0, 
                                        face = "bold")) 
ggsave(filename = "plot5.png", plot = plot5, units = c("cm"), 
       width = 30, height = 20, dpi = 200, limitsize = FALSE)
