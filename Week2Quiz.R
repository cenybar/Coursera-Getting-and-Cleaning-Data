## 1 Register an application with the Github API here 
# https://github.com/settings/applications. Access the API to get information 
# on your instructors repositories (hint: this is the url you want 
# "https://api.github.com/users/jtleek/repos"). Use this data to find the 
# time that the datasharing repo was created. What time was it created?

# This tutorial may be useful 
#(https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
#You may also need to run the code in the base R package and not R studio.

#2013-11-07T13:25:07Z
#2012-06-20T18:39:06Z
#2014-03-05T16:11:46Z
#2014-02-06T16:13:11Z

library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github", 
                   key = "737b24aa33d845417ed6", 
                   secret = "49affcc40b6dd9ba78430801794787d222228f40")
# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
output <- content(req)
# Find "datasharing"
datashare <- which(sapply(output, FUN=function(X) "datasharing" %in% X))
datashare
list(output[[16]]$name, output[[16]]$created_at)

#[[1]]
#[1] "datasharing"
#[[2]]
#[1] "2013-11-07T13:25:07Z" CORRECT ANSWER


## 2 The sqldf package allows for execution of SQL commands on R data frames. 
# We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.
# Download the American Community Survey data and load it into an R object called acs
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# Which of the following commands will select only the data for the probability weights pwgtp1 with ages less 
# than 50?

# sqldf("select * from acs where AGEP < 50")
# sqldf("select pwgtp1 from acs")
# sqldf("select * from acs")
# sqldf("select pwgtp1 from acs where AGEP < 50")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/acs.csv")
acs <- read.csv("./data/acs.csv")

install.packages("sqldf")
library(sqldf)
sqldf("select pwgtp1 from acs where AGEP < 50")


## 3 Using the same data frame you created in the previous problem, what is the equivalent function to 
#  unique(acs$AGEP)

A <- sqldf("select unique * from acs") #Runs an error
B <- sqldf("select distinct pwgtp1 from acs")
C <- sqldf("select distinct AGEP from acs")
D <- sqldf("select AGEP where unique from acs") #Runs an error
        
U <- unique(acs$AGEP)

identical(U, B$AGEP)
# False
identical(U, C$AGEP)
# True
# Answer is C

## 4 How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
# http://biostat.jhsph.edu/~jleek/contact.html (Hint: the nchar() function in R may be helpful)

#43 99 7 25
#45 31 7 25
#45 31 2 25
#45 31 7 31
#43 99 8 6
#45 92 7 2
#45 0 2 2

htmlURL <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(htmlURL)
close(htmlURL)

head(htmlCode)

c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))
# 45 31  7 25 Answer is B

## 5 Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# (Hint this is a fixed width file format)

## The following answer is not mine, had to search it as this question was out of my scope.
## credits: Rpubs

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
SST <- read.fwf(fileUrl, skip=4, widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))
sum(SST[,4])


        