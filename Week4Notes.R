## EDITING TEXT VARIABLES

cameraData <- read.csv("./data/camera.csv")
names(cameraData)

# Fixing character vectors tolower() to upper()

tolower(names(cameraData)) # pasa todas las vbles a minúsculas

# strsplit() separa los nombres por caracter elegido (punto por ej)

splitNames = strsplit(names(cameraData), "\\.")
splitNames[[5]]
splitNames[[6]]
# [1] "Location" "1"  
splitNames[[6]][1]
# [1] "Location"
firstElement <- function(x){x[1]}
sapply(splitNames, firstElement)

# Fixing character vectors sub()

# sirve para sacar caracteres molestos como _

sub("_","",nombredf) # limpia el primer _
gsub("_","",nombredf) # limpia todos los _

# grep() grepl()

# busca donde aparece cierta string

grep("Alameda", cameraData$intersection)

table(grepl("Alameda", cameraData$intersection))
# tira donde es cierta esa condicion

grep("Alameda", cameraData$intersection, value=TRUE)
# muestra donde aparece esa palabra en los registros

grep("Santi",cameraData$intersection)
# si la respuesta da integer(0) es que ese valor no está

# more useful string functions

library(stringr)

nchar("Santi Fernandez")
substr("Santi Fernandez",1,5)
paste("Santi", "Fernandez")
paste0("Santi", "Fernandez") # pega sin espacio en medio
str_trim("Jeff         ") # Saca los caracteres en blanco

# Buenas practicas al nombrar variables

# siempre que se pueda todo minúscula
# descriptivas (diagnosis en lugar de dx)
# no duplicadas
# sin puntos o guiones o espacio en blanco
# si son binarias masculino/femenino, verdadero/falso en lugar de 1/0.
