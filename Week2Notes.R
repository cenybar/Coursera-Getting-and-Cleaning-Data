## Reading from MySQL

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





