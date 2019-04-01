## SUMMARIZING DATA     

# We'll work with real data from Baltimore restaurants
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv")
restData <- read.csv("./data/restaurants.csv")

# Look at a bit of the data

head(restData, n=3)
tail(restData, n=3)

summary(restData)

str(restData)

# quantiles of quantitative variables

quantile(restData$councilDistrict, na.rm = TRUE)

quantile(restData$councilDistrict, probs = c(0.5,0.75,0.9))

# make table

table(restData$zipCode, useNA = "ifany") #useNA sums up the missing values (if any)

table(restData$councilDistrict, restData$zipCode)

# check for missing values

sum(is.na(restData$councilDistrict)) # if the sum=0, no missing values

any(is.na(restData$councilDistrict)) # alternative way

all(restData$zipCode > 0) # check for potential sample errors, zipcodes must be positive

# row and column sums

colSums(is.na(restData)) # check to see missing values

all(colSums(is.na(restData))==0) # alternative way 

# values with specific characteristics

table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212","21213"))    

 # and you can also subset values like this

restData[restData$zipCode %in% c("21212","21213"),]

# cross tabs
 # load data set
data("UCBAdmissions") 
DF = as.data.frame(UCBAdmissions)
summary(DF)
 # cross tabs to analyse
xt <- xtabs(Freq ~ Gender + Admit,data=DF)
xt

# flat tables
 # creating multiple two dimension tables to see variables
 # replicate wool tension

warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data = warpbreaks)
xt

 # the previous analysis might be difficult to see, that's
 # where flat tables come in handy

ftable(xt)

# size of a data set

fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units="Mb")

## CREATING NEW VARIABLES

# creating sequences (useful when you need an index for your data set)

s1 <- seq(1,10,by=2) ; s1
s2 <- seq(1,10,length=3) ; s2
x <- c(1,3,8,25,100); seq(along=x)

#subsetting variables
restData$nearMe = restData$neighborhood %in% c("Roland Park","Homeland")
table(restData$nearMe)
# arriba filtró los restaurantes cerca de su casa y luego hizo
# una tabla, un subset, para poder llamarla comodamente y no tener
# que escribir siempre el %in%

# creating binary variables

restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)

# creating categorical variables

restData$zipGroups = cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)

table(restData$zipGroups, restData$zipCode)                         

# easier cutting

install.packages("Hmisc")
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode, g=4)
table(restData$zipGroups)

# creating factor variables

restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]

# a veces puede ser más útil transformar una variable numérica
# en factor. por ejemplo, el código postal no altera mucho al 
# incrementarse en una unidad, por eso se pueden agrupar. para
# eso se crea la variable zcf (zip code factor).

class(restData$zcf)

# level of factor variables

# we create a dummy vector with "yes" and "no" values to work with
yesno <- sample(c("yes","no"),size=10,replace=TRUE)
yesnofac = factor(yesno,levels = c("yes","no"))
relevel(yesnofac, ref = "yes")
# también puedo ver los datos en formato numérico
as.numeric(yesnofac)

# cutting produces factor variables

library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)

# using the mutate function

library(Hmisc); library(plyr)
restData2 = mutate(restData, zipGroups=cut2(zipCode,g=4)) # agrego una nueva variable al data frame
table(restData2$zipGroups)

# common transforms

abs
sqrt
ceiling
floor
round(x, digits=n)

## RESHAPING DATA

library(reshape2)
head(mtcars)

# Melting data frames

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)                

# Casting data frames

cylData <- dcast(carMelt, cyl ~ variable)
cylData

cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData

# Averaging values

head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum)

# Another way-split

spIns = split(InsectSprays$count, InsectSprays$spray)
spIns

sprCount = lapply(spIns,sum)
sprCount
unlist(sprCount)

sapply(spIns,sum) # This does the same of above in only one step (the list and unlist)

# Another way - plyr package

library(plyr)
ddply(InsectSprays,.(spray), summarize, sum=sum(count))

# Creating a new variable

spraySums <- ddply(InsectSprays,.(spray), summarize, sum=ave(count, FUN = sum))
dim(spraySums)
head(spraySums)

# other useful functions
acast # for casting as multi-dimensional arrays
arrange # for faster reordering without using order() commands
mutate # adding new variables

## MANAGING DATA FRAMES WITH DPLYR

# dplyr Verbs

select # return a subset of the columns of a df
filter # extract a subset of rows from a df based on logical conditions
arrange # reorder rows of a df
rename # rename variables in a data frame
mutate # add new variables/columns or transform existing vbles
summarise / summarize # generate summary statistics of different variables in th df

 # there is also a handy "print" method that prevents you from printing a lot of data to the console

# getting the data to work with 
library(dplyr)
url <- "https://github.com/DataScienceSpecialization/courses/blob/master/03_GettingData/dplyr/chicago.rds?raw=true"
download.file(url, destfile = "./data/chicago.rds", mode = "wb")
chicago <- readRDS("./data/chicago.rds")

dim(chicago)
str(chicago)
names(chicago)
head(select(chicago, city:dptp)) # A way to select columns (first 3) by their names
head(select(chicago, -(city:dptp))) # similar a arriba pero seleccionando lo inverso
# para ver todo lo que soluciona dplyr abajo se repite programando en R lo mismo:
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)]) # bastante más código para lo mismo

# Se pueden hacer subsets de la data aplicando filtros a distintas columnas
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, 10)
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f)

# ordenando el df según los valores de cierta columna

chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)

chicago <- arrange(chicago, desc(date)) #ordeno en orden descendente
head(chicago)

# renombrando variables

chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)

# transformar o crear nuevas variables

chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend))

chicago <- mutate(chicago, tempcat = factor(1*(tmpd > 80), labels = c("cold", "hot")))
hotcold <- group_by(chicago, tempcat)
hotcold
summarise(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2))
summarise(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2))

# agrupación por años

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
summarize(years, pm25=mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# pipeline operator %>%

chicago %>% mutate(month =as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarise(pm25=mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

        # prevents to having to assing temporary variables, can do the same in one sequence

## MERGING DATA

# Can be done with the merge command

# Also with the join feature on plyr
library(plyr)
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id)

# Very handy when joining several data sets
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList)



