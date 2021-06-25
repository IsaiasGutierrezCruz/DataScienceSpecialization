#----- 1. Use the github's API  -----

library(httr)
oauth_endpoints("github")

my_app <- oauth_app("github", 
                    key = "4e584a1565d168866978",
                    secret = "ed35838b270534edf3178d1ec8c1ef72c10edebd")

github_token <- oauth2.0_token(oauth_endpoints("github"), my_app)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

req$content

# ----- 2. Use of the sqldf packege ----
library(sqldf)
acs <- read.csv("getdata_data_ss06pid.csv")

# Which of the following commands will select only the data 
# for the probability weights pwgtp1 with ages less than 50?
sqldf("select pwgtp1 from acs where AGEP < 50")

# Using the same data frame you created in the previous problem, 
# what is the equivalent function to unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

# -----4. HTML ----- 
#How many characters are in the 10th, 20th, 30th and 100th lines of 
# HTML from this page
# http://biostat.jhsph.edu/~jleek/contact.html
library(XML)
library(httr)
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
r <- GET(url)
html <- htmlTreeParse(r, useInternalNodes = T)
rootNode <- xmlRoot(html)

lines <- readLines(url)
nchar(lines[10])
nchar(lines[20])
nchar(lines[30])
nchar(lines[100])

# ----- 5. -----
df <- read.fwf("getdata_wksst8110.for", widths = c(13, 6, 7, 6, 7, 6, 7, 6, 4), 
               header = FALSE, skip = 3)
colnames(df) <- df[1, ]
df <- df[-1, ]
df[, 4] <- as.numeric(df[, 4])
sum(df[, 4])
