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
# get the scc values in relation with vehicles 
vehicleSCC <- NEI[grepl(".*[Vv]ehicle.*", NEI$SCC.Level.Two), 1]

# filter the data for the baltimore and Los Angeles cities related with vehicles 
dataPlot6 <- SCC %>% filter(fips == "24510" | fips =="06037", SCC %in% vehicleSCC) %>% 
  select(Emissions, year, fips)

dataPlot6$year <- as.character(dataPlot6$year)
dataPlot6$fips <- ifelse(dataPlot6$fips == "24510", "Baltimore City", "Los Angeles Country")

plot6 <- ggplot(data = dataPlot6, mapping = 
          aes(x=year, y=Emissions, fill = fips)) + geom_boxplot() + 
          ylim(0, 10) + 
          geom_hline(yintercept = median(dataPlot6$Emissions), 
                     colour = "red") + 
          ggtitle("Box plots of Total PM2.5 Emissions in Baltimore City and Los Angeles") +
          xlab("Year") + ylab("Total PM2.5 Emissions")

plot6 <- plot6 + theme(plot.title = element_text(size=11, hjust = 0.5, vjust = 0, 
                                        face = "bold"))  

ggsave(filename = "plot6.png", plot = plot6, units = c("cm"), 
       width = 30, height = 20, dpi = 200, limitsize = FALSE)
