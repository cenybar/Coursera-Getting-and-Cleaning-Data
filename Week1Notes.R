# Checking for and creating directories

file.exists("directoryName") # will check if the directory exists.
dir.create("directoryName") # will create a directory that doesn't exist.

# Example of checking for "data" directory and creating it if it doesn't exist:

if (!file.exists("data")) {
        dir.create("data")
}

## Getting data from the internet

download.file()

# Example:

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/camera.csv", method = "curl") # curl used in MAC (Linux not sure)
list.files("./data")

dateDownloaded <- date() # To keep a record of when the data was downloaded (best practices)
dateDownloaded

## Reading local flat files

read.table() # Reads data into RAM, not recommended for big data sets.

read.csv() # Special case of read.table, sets sep="," and header=TRUE

# One issue while reading local flat files might be the quotation marks ( ' or " ) placed in data
# values, setting the parameter quote="" often resolves these.

## Reading Excel files

# useful packages: xlsx package, read.xlsx() 

install.packages("xlsx")
library(xlsx)

# following same example as before:

cameraData <- read.xlsx("./data/cameras.xlsx", sheetIndex = 1, header = TRUE)

# other useful tip: reading specific columns and rows from an excel file

colIndex <- 2:3 # the desired columns
rowIndex <- 1:4 # the desired rows
camaraDataSubset <- read.xlsx(".data/cameras.xlsx", sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)
camaraDataSubset

# the write.xlsx will write out an Excel file with similar arguments (to share work with Excel users)

## Reading XML

install.packages("XML")
library(XML)

fileURL <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal = TRUE) #da un error este script del instructor
rootNode <- xmlRoot(doc)
xmlRoot(rootNode)

# Esto de debajo es una prueba mía a partir de cosas que leí para 
# solucionar el error de arriba, funciona!! Al ser una https daba un
# problema que se soluciona con RCurl
install.packages("RCurl")
library(RCurl)
temp <- getURL("https://www.w3schools.com/xml/simple.xml", ssl.verifyPeer = FALSE )
doc <- xmlTreeParse(temp, useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

rootNode[[1]]
rootNode[[1]][[1]]
xmlSApply(rootNode, xmlValue)
xpathSApply(rootNode, "//name",xmlValue)
xpathSApply(rootNode, "//price",xmlValue)

# Extract content by atrributes (la web cambió y ya no da mismo resultado)

fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal = TRUE)
scores <- xpathSApply(doc, "//li[@class='score']",xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']",xmlValue)
scores
teams

## Reading JSON

install.packages("jsonlite")
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
jsonData$owners$login                     

# Writing data frames to JSON

myjson <- toJSON(iris, pretty=TRUE) #pretty presenta los datos más amigables
cat(myjson)

iris2 <- fromJSON(myjson)
head(iris2)

## The data.table Package

library(data.table)
DF = data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3),z=rnorm(9))
head(DF,3)
DT = data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3),z=rnorm(9))
head(DT,3)
tables()
