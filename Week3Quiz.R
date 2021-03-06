1 ## The American Community Survey distributes downloadable data about United States communities. Download the 2006 
# microdata survey about housing for the state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of 
# agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like 
# this to identify the rows of the data frame where the logical vector is TRUE.
which(agricultureLogical)
# What are the first 3 values that result?

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, "./data/q1.csv")
q1 <- read.csv("./data/q1.csv")

agricultureLogical <- q1$ACR == 3 & q1$AGS == 6

# answer 125, 238, 262

2 ## Using the jpeg package read in the following picture of your instructor into R

# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

install.packages("jpeg")
library(jpeg)
?jpeg

url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url, "./data/q2.jpeg")
img <- readJPEG("./data/q2.jpeg", native = TRUE)

quantile(img, probs = c(.3,.8))
#      30%       80% 
#     -15258512 -10575416

# (some Linux systems may produce an answer 638 different for the 30th quantile)
# answer -15259150 -10575416

3 ## Question Load the Gross Domestic Product data for the 190 ranked countries in this data set:
   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
   # Load the educational data from this data set:
   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
   # Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order 
   # by GDP rank (so United States is last). What is the 13th country in the resulting data frame?

url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url1, "./gdp.csv")
download.file(url2, "./country.csv")
gdp <- read.csv("./gdp.csv", skip = 5, nrows = 190, header = FALSE)
head(gdp)
gdp <- gdp[,c(1,2,4,5)]
header <- c("CountryCode", "Ranking", "Country", "GDP")
colnames(gdp) <- header
gdp
country <- read.csv("./country.csv")

names(country)

merged_data <- merge(country, gdp, by = "CountryCode", all = FALSE)
nrow(merged_data)

sorted_data <- arrange(merged_data, desc(Ranking))
sorted_data[13,"Country"]

## Answer 189 matches, 13th country is St. Kitts and Nevis

4 ## What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

tapply(merged_data$Ranking, merged_data$Income.Group, mean)

## Answer 32.96667, 91.91304

5 ## Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
   # are Lower middle income but among the 38 nations with highest GDP?

library(Hmisc)
cutGDP <- cut2(sorted_data$Ranking, g=5 )
table(cutGDP, sorted_data$Income.Group )

# Answer 5
