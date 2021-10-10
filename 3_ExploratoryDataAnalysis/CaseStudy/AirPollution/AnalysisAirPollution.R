library(dplyr)

# data and more information https://www.epa.gov/outdoor-air-quality-data
# documentation https://aqs.epa.gov/aqsweb/airdata/FileFormats.html

fileUrl2012 = "https://aqs.epa.gov/aqsweb/airdata/annual_conc_by_monitor_2012.zip"
fileUrl1999 = "https://aqs.epa.gov/aqsweb/airdata/annual_conc_by_monitor_1999.zip"
if(!file.exists('./data_1999.csv')&&!file.exists('./data_2012.csv')){
  invisible(download.file(fileUrl1999,"./data_1999.zip"))
  invisible(download.file(fileUrl2012,"./data_2012.zip"))
  unzip("data_2012.zip", exdir = getwd())
  unzip("data_1999.zip", exdir = getwd())
}
unlink('./data_1999.zip')
unlink('./data_2012.zip')

tryCatch(
  invisible(
    file.rename(
      "annual_conc_by_monitor_1999.csv","data_1999.csv"
    )
  ),warning = function(w){
    if(file.exists('./data_1999.csv')){
      print("The file \"data_1999.csv\" already exists!")
    }else{
      print("Some error occured while trying to rename the file 
              \"annual_conc_by_monitor_1999.csv\" to \"data_1999.csv\"!")
    }
  }
)
tryCatch(
  invisible(
    file.rename(
      "annual_conc_by_monitor_2012.csv","data_2012.csv"
    )
  ),warning = function(w){
    if(file.exists('./data_1999.csv')){
      print("The file \"data_2012.csv\" already exists!")
    }else{
      print("Some error occured while trying to rename the file 
              \"annual_conc_by_monitor_2012.csv\" to \"data_2012.csv\"!")
    }
  }
)
data_1999 = read.csv("data_1999.csv")
data_2012 = read.csv("data_2012.csv")




pm0 <- read.csv("Data/daily_88101_1999.csv", comment.char = "#", header = TRUE)

pm1 <- read.csv("Data/daily_88101_2012.csv", comment.char = "#", header = TRUE)

pm2 <- read.csv("Data/daily_88101_2021.csv", comment.char = "#", header = TRUE)

x0 <- pm0$X1st.Max.Value
x1 <- pm1$X1st.Max.Value
x2 <- pm2$X1st.Max.Value


summary(x0)
summary(x1)
summary(x2)


boxplot(log10(x0), log10(x1), log10(x2))



# we can see negative values in the data of the years 2012 and 2021, 
# something that is a bit strange because this value 
# measures the mass of a filter after being exposed to the air pollution 

negative <- x1 < 0
mean(negative, na.rm = TRUE)

# there are a bit of negative values, so it is a good idea analyze the dates 
# to understand better the nature of those values
dates <- pm1$Date.Local
dates <- as.Date(as.character(dates), "%Y-%m-%d")

hist(dates, "month")

hist(dates[negative], "month")

# ONe issue with PM2.5 is that many areas of the country It tend to very low in 
# the winter. And high in the summer. And so typically when, pollution values 
# are high, they're easier to measure. And when they're low, they're harder to 
# measure. So it could be a error in the measure when the values tend to be very low

# ---- Analysis in a specific monitor ----
# Okay, well the median for the entire country has gone down between 1999 and 
# 2012, why don't we pick out one monitor. See whether or not we can see a 
# change or a decrease in the level just at that one location, and so and that 
# way we can kind of control for the fact that you know there's different 
# monitors at different times

# We can control for possible changes in the monitoring locations between 1999 
# and 2012.

# get the data from new york
site0 <- unique(subset(pm0, State.Code == 36, c(County.Code, Site.Num)))
site1 <- unique(subset(pm1, State.Code == 36, c(County.Code, Site.Num)))
site2 <- unique(subset(pm2, State.Code == 36, c(County.Code, Site.Num)))

# prepare the new name with those two columns 
site0 <- paste(site0[, 1], site0[, 2], sep = ".")
site1 <- paste(site1[, 1], site1[, 2], sep = ".")
site2 <- paste(site2[, 1], site2[, 2], sep = ".")

# there are a different number of the possible combinations, so we only want to 
# get the intersection

both <- intersect(site0, site1)
three <- intersect(both, site2)

# so there are eight monitors that are in the three data sets 
# something interesting to do is check how many observations are in the data set 
# for each monitor 
pm0$County.Site <- with(pm0, paste(County.Code, Site.Num, sep = "."))
pm1$County.Site <- with(pm1, paste(County.Code, Site.Num, sep = "."))
pm2$County.Site <- with(pm2, paste(County.Code, Site.Num, sep = "."))

cnt0 <- subset(pm0, State.Code == 36 & County.Site %in% three)
cnt1 <- subset(pm1, State.Code == 36 & County.Site %in% three)
cnt2 <- subset(pm2, State.Code == 36 & County.Site %in% three)

# then we will split the data set to count how many observations have each monitor 
sapply(split(cnt0, cnt0$County.Site), nrow)
sapply(split(cnt1, cnt1$County.Site), nrow)
sapply(split(cnt2, cnt2$County.Site), nrow)

# after that, we will analyze the monitor 67.1015
pm0sub <- subset(pm0, State.Code == 36 & County.Code == 67 & Site.Num == 1015)
pm1sub <- subset(pm1, State.Code == 36 & County.Code == 67 & Site.Num == 1015)
pm2sub <- subset(pm2, State.Code == 36 & County.Code == 67 & Site.Num == 1015)

# get the dates and then plot the data 
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1))
rng <- range(x0sub, x1sub, x2sub, na.rm = T)
dates0 <-  as.Date(as.character(pm0sub$Date.Local), "%Y-%m-%d")
x0sub <- pm0sub$X1st.Max.Value
plot(dates0, x0sub, pch = 20, ylim = rng)
abline(h = median(x0sub, na.rm = TRUE))

dates1 <-  as.Date(as.character(pm1sub$Date.Local), "%Y-%m-%d")
x1sub <- pm1sub$X1st.Max.Value
plot(dates1, x1sub, pch = 20, ylim = rng)
abline(h = median(x1sub, na.rm = TRUE))

dates2 <-  as.Date(as.character(pm2sub$Date.Local), "%Y-%m-%d")
x2sub <- pm2sub$X1st.Max.Value
plot(dates2, x2sub, pch = 20, ylim = rng)
abline(h = median(x2sub, na.rm = TRUE))

# do a resume to each states 
mn0 <- with(pm0, tapply(X1st.Max.Value, State.Code, mean, na.rm = TRUE))
mn1 <- with(pm1, tapply(X1st.Max.Value, State.Code, mean, na.rm = TRUE))
mn2 <- with(pm2, tapply(X1st.Max.Value, State.Code, mean, na.rm = TRUE))

d0 <- data.frame(state = names(mn0), mean = mn0)
d1 <- data.frame(state = names(mn1), mean = mn1)
d2 <- data.frame(state = names(mn2), mean = mn2)

mrg <- merge(d0, d1, by ="state")
mrg <- merge(mrg, d2, by = "state")

par(mfrow = c(1, 1))
with(mrg, plot(rep(1999, 35), mrg[, 2], xlim = c(1998, 2022), ylim = range(mrg[, 2:4])))
with(mrg, points(rep(2012, 35), mrg[, 3]))
segments(rep(1999, 35), mrg[, 2], rep(2012, 35), mrg[, 3])

with(mrg, points(rep(2021, 35), mrg[, 4]))
segments(rep(2012, 35), mrg[, 3], rep(2021, 35), mrg[, 4])

# Deleting the data 
unlink("data_1999.csv")
unlink("data_2012.csv")