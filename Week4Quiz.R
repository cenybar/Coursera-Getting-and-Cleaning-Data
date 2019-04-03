1 ## The American Community Survey distributes downloadable data about United States communities. Download the 2006 
   # microdata survey about housing for the state of Idaho using download.file() from here: 
   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
   # and load the data into R. The code book, describing the variable names is here:
   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
   # Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
   # What is the value of the 123 element of the resulting list?

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, destfile = "./data/survey.csv")
survey <- read.csv("./data/survey.csv")

splitNames = strsplit(names(survey),"wgtp")
splitNames[123]

## Answer [1] ""   "15"

2 ## Load the Gross Domestic Product data for the 190 ranked countries in this data set:

   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
   # Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
   # Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table

gdpdata <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip = 5, nrows = 190, header = FALSE)
head(gdpdata)        
gdpdata <- gdpdata[,c(1,2,4,5)]
header <- c("countryCodes","Ranking","countryNames","GDP")
colnames(gdpdata) <- header

mean(gdpdata[,"GDP"]) # Antes de quitar la coma, da error el cálculo ya que R no reconoce ese caracter para computar la media

gsub(",","",gdpdata) 
library(dplyr)
gdpdatanew <- mutate(gdpdata, gdpnocommas = as.numeric(gsub(",","",gdpdata$GDP)))

mean(gdpdatanew[,"gdpnocommas"])

# answer is [1] 377652.4

3 ## In the data set from Question 2 what is a regular expression that would allow you to count the number of countries
   # whose name begins with "United"? Assume that the variable with the country names in it is named countryNames. 
   # How many countries begin with United?
        
        
# grep("*United",countryNames), 5
# grep("United$",countryNames), 3
# grep("^United",countryNames), 3
# grep("*United",countryNames), 2

## Answer grep("^United",countryNames), 3

4 ## Load the Gross Domestic Product data for the 190 ranked countries in this data set:
   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
   # Load the educational data from this data set:
   # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
   # Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, 
   # how many end in June?

gdpdata <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip = 5, nrows = 190, header = FALSE)
gdpdata <- gdpdata[,c(1,2,4,5)]
header <- c("countryCodes","Ranking","countryNames","GDP")
colnames(gdpdata) <- header

edudata <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")

merged_data <- merge(gdpdata,edudata, by.x = "countryCodes", by.y = "CountryCode", all = FALSE)

# fiscal year info, when available, in special notes

c <- grep("Fiscal year end: June", merged_data$Special.Notes)
length(c)

# answer is 13

5 ## You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded 
   # companies on the NASDAQ and NYSE. Use the following code to download data on Amazon's stock price and get the times
   # the data was sampled.

install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

 # How many values were collected in 2012? How many values were collected on Mondays in 2012?
length(grep("^2012",sampleTimes))

amzn2012 <- sampleTimes[grep("^2012",sampleTimes)]
NROW(amzn2012)
library(lubridate)
NROW(amzn2012[weekdays(amzn2012) == "lunes"])

# Answer is 250, 47

# Otra forma que vi en: https://github.com/benjamin-chan (clap clap clap, hermoso código)
sampleTimes <- index(amzn)
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))
