### READING FROM MYSQL

# Connecting and listing databases

library(RMySQL)
ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb);
# The "show databases" is actually a MySql command, not an R command,
# that we are sending through the dbGetQuery function
# It's IMPORTANT to disconnect from the server after making the query
# Always run the dbDisconnect when finished
result

hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

dbListFields(hg19,"affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
## El comando de arriba incluye una query the mysql, la select X from Y,
## esta es una forma de ver el total de registros de la BBDD desde R

# Read from the table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# Select a specific subset
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)
# Con el fetch(query) puedo traerme la consulta a R. La hice arriba, la traigo
# a affyMis. Lo del quantile es para verificar que lo hice bien.

# Otra posibilidad es hacer una consulta breve, para asegurarme que estoy
# trayendo los datos que quiero de la consulta. En ese caso, luego de verificar
# que esté todo bien, IMPORTANTE borro la query con dbCleanResult(query)

affyMisSmall <- fetch(query, n=10); dbClearResult(query);
dim(affyMisSmall)

## ALWAYS END THE CONNECTION - IMPORTANT - 

dbDisconnect(hg19)

### READING FROM HDF5

source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

library(rhdf5)
created = h5createFile("example.h5")
created

# This lecture is modeled very closely on the rhd tutorial found here:
# http://www.bioconductor.org/packages/release/bioc/vigneetes/rhdf5/inst/doc/rhdf5.pdf

# Create groups
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

# Write to groups

A = matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1,2.0,by=0.1), dim = c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5","foo/foobaa/B")
h5ls("example.h5")

# Write a data set

df = data.frame(1L:5L, seq(0,1, length.out = 5),
                c("ab","cde","fghi","a","s"), stringsAsFactors = FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")

# Reading data

readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf= h5read("example.h5", "df")
readA

# Writing and reading chunks

h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")

### READING FROM THE WEB

# Webscraping: Progamatically extracting data from the HTML code of websites.

# Gettin data off webpages - readLines()

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

# The previous code doesn't work, seems to be an error while reading the url. TBA.

# Parsing with XML

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = T)

# Lo de arriba se colgaba (de nuevo por el https), abajo lo modifiqué y funciona:
library(RCurl)
temp <- getURL("https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en", ssl.verifyPeer = FALSE )
html <- htmlTreeParse(temp, useInternalNodes = TRUE)

xpathApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue) #Este no funciona, a investigar

# GET from the httr package

library(httr); html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2,asText = TRUE)
xpathApply(parsedHtml, "//title", xmlValue)

# Accessing websites with passwords

pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1
# If we run the previous code, we get a 401 error because we need to authenticate ourselves
# A way to solve this:
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2

names(pg2)

# Using handles (to avoid having to authenticate every time you access a website)

google= handle("http://google.com")
pg1 = GET(handle = google, path="/")
pg2 = GET(handle = google, path="search")

# Notes and further resources
# R bloggers has a number of examples on web scarping, search there web+scraping

### READING DATA FROM APIs

# Accessing Twitter from R

myapp = oauth_app("twitter", key = "1eP2X0SyE9QF3Xby0CzaPKU5L", secret = "4JTRzgs8iJ8ApA96RrxkGnrJNbl97WPYT1dQy23byHd9SwhzmI")
sig = sign_oauth1.0(myapp, token = "900611552-2V7j0cKZDdjoOyQAqvYvA2L2fXl5OoJsGveCoOkh", token_secret = "u99Opbmx1JMcT37kjr5gWgKJc8uOm7I4cslwwmHEq6ncK")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 = content(homeTL)
json2 = jsonlite::fromJSON(jsonlite::toJSON(json1))
json2[1,1:4]


### READING FROM OTHER SOURCES

# Refer to the pdf downloaded and always remember google is your
# best friend (e.g. search= "what_you_need R package" "MySQL R package")
