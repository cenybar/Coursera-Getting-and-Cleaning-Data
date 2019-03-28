## 1 The American Community Survey distributes downloadable data about United States communities. 
 # Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
 # from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
 # and load the data into R. The code book, describing the variable names is here:
 # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
 # How many properties are worth $1,000,000 or more?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/housingData.csv")
list.files("./data")
housingData <- read.csv("./data/housingData.csv")
head(housingData)

 # Following the code book, VAL is the property value, with a value of 24 for properties
 # over a million usd.

sum(housingData$VAL == 24, na.rm = TRUE)

# So the answer is 53

## 2 Use the data you loaded from Question 1. Consider the variable FES in the code 
 # book. Which of the "tidy data" principles does this variable violate?

 # Each tidy data table contains information about only one type of observation.
 # Tidy data has one variable per column.
 # Each variable in a tidy data set has been transformed to be interpretable.
 # Numeric values in tidy data can not represent categories.

# FES represents the family type and employment status. This means that two variables
# are reperesented in one column, which violates the one column per variable rule.
# Option two is the correct one.

## 3 Download the Excel spreadsheet on Natural Gas Aquisition Program here:
 # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
 # Read rows 18-23 and columns 7-15 into R and assign the result to a variable 
 # called: dat. What is the value of: sum(dat$Zip*dat$Ext,na.rm=T) ?

library(xlsx)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, "./data/NaturalGasAP.xlsx")
list.files("./data")
rowIndex <- (18:23)
colIndex <- (7:15)
dat <- read.xlsx("./data/NaturalGasAP.xlsx", sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)

sum(dat$Zip*dat$Ext,na.rm=T)

## Answer is: 36534720

## 4 Read the XML data on Baltimore restaurants from here:
 # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
 # How many restaurants have zipcode 21231?
library(XML)
library(RCurl)
temp <- getURL("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml",ssl.verifyPeer = FALSE)
doc <- xmlTreeParse(temp, useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]][[1]]

zipcode <- xpathSApply(rootNode,"//zipcode",xmlValue)
length(zipcode[zipcode==21231])

 # Answer is 127

## 5 The American Community Survey distributes downloadable data about United States communities. 
 # Download the 2006 microdata survey about housing for the state of Idaho using download.file() from 
 # here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
 # using the fread() command load the data into an R object : DT.
 # The following are ways to calculate the average value of the variable pwgtp15
 # broken down by sex. Using the data.table package, which will deliver the fastest user time?

 # DT[,mean(pwgtp15),by=SEX]
 # mean(DT$pwgtp15,by=DT$SEX)
 # mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
 # rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
 # tapply(DT$pwgtp15,DT$SEX,mean)
 # sapply(split(DT$pwgtp15,DT$SEX),mean)

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(url=fileUrl1, destfile="./data/fsspid.csv", mode="w", method="curl")

library(data.table)
DT <- fread(input = "./data/fsspid.csv", sep = ",")
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(mean(DT[DT$SEX==1,]$pwgtp15))
system.time(mean(DT[DT$SEX==2,]$pwgtp15))
system.time(rowMeans(DT)[DT$SEX==1]) #error
system.time(rowMeans(DT)[DT$SEX==2]) # error
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

## Got some errors in some options but my answer would be: system.time(mean(DT$pwgtp15,by=DT$SEX))
