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


## REGULAR EXPRESSIONS

# metacharacters

        # ^ para los "comienza con"
        # $ para los "termina con"
        # [Bb] matchea todas las palabras con B o b.
        # [a-z] se puede usar tb para rangos de letras o numeros
        # usado entre [] el ^ opera como distinto, por ejemplo:
        # [^?.]$ busca todo lo que no termina en punto o con signo de interrogación
        # "." el punto representa cualquier caracter, por ejemplo:
        # 9.11 taería el 9-11, 9/11, 9.11, 9:11 etc
        # | funciona como operador OR
        # ? funciona como opcional, por ejemplo:
        # [Gg]eorge( [Ww]\.)? [Bb]ush trae cualquier registro que tenga o no el W. o w. en el medio
        # el backwards slash antes del . dice que no hay que tomar a ese punto como metacaracter sino como un punto común
        # * indica repetición, por ejemplo (.*) buscaría cualquier cosa entre parentesis
        # + indica que se debe incluir al menos uno de esos caracteres [0-9]+ trae todo lo que tenga al menos un nro.
        # {} permiten especificar el mín y máx de veces para "machear" una expresión. por ej:
        # [Bb]ush( +[^ ]+ +){1,5} debate devolvería:
        # Bush has historically lost all debates
        # in my view, Bush doesn't need these debates
        # etc (hasta cinco palabras con espacio entre Bush y debate)
        # {m,n} al menos m pero no mas de n
        # {m} exactamente m matches
        # {m,} al menos m matches
        # \n indica la cantidad de repeticiones del bloque anterior por ej:
        # +([a-zA-Z]+) +\1 + (busca todas las palabras repetidas en una oración, taería:)
        # blah blah bla, o , time for bed, night night, o, hi all all there
        # the * is "greedy" so it always matches the longest possible string that satifies the regular expression
        # the ? limits the "greediness" (.*?) por ejemplo

## WORKING WITH DATES

# staring simple
d1=date()
d1
class(d1)
d2=Sys.Date()
d2
class(d2)

# formatting dates
# %d = day as number (0-31)
# %a = abbreviated weekday 
# %A = unabbreviated weekday
# %m = month(00-12)
# %b = abbreviated month
# %B = unabbreviated month
# %y = 2 digit year
# %Y = 4 digit year

format(d2, "%a %b %d")

# creating dates
x = c("1ene1960", "2jan1960", "31mar1960"); z = as.Date(x, "%d%b%Y")
z
# apunte para mí, arriba se ve que tengo el r en español porque el "jan" 
# lo toma como NA, solo "ene" es enero.

z[3] - z[1] # calcula la diferencia entre 2 dechas

as.numeric(z[3] - z[1]) # paso esa diferencia a nros.

weekdays(d2)
months(d2)
julian(d2) # días transcurridos desde origen, en este caso 1 de enero del 70.


library(lubridate); ymd("20140108")

# o puede usarse mdy o dmy (month day year o day month year)

ymd_hms("2018-08.03 10:15:03")

ymd_hms("2018-08.03 10:15:03", tz="Pacific/Auckland") # para establecer la time zone

# some functions have slightly different syntax

x= dmy(c("1mar2013", "2mar2013",  "31mar2013"))
wday(x[2])
