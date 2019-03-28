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

# Los comandos arriba se cuelgan, creo que debe ser porque es una https y eso da problemas
