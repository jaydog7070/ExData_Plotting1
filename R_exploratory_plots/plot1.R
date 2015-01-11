## Jason Stedl plot1  project 1 Jan 2014

## Code to remove objects from memory if they are already in working memory 
if (exists("powerConsumption"))
  { rm(powerConsumption)}

if (exists("con")) 
  {rm(con)}

## Libray for R sqlite  
library(RSQLite)

## creates a database
con <- dbConnect(SQLite(), dbname = "powerconsumption")

## writes to that database
dbWriteTable(con, name="powerconsumption", value="household_power_consumption.txt",  row.names=FALSE, header=TRUE, sep = ";", overwrite = TRUE)


## Query the data base using sql command
powerConsumption <- dbGetQuery(con, "SELECT * FROM powerconsumption WHERE Date='1/2/2007' OR Date='2/2/2007'")
dbDisconnect(con)

## combine time with date info
powerConsumption[[1]]  <- paste(powerConsumption[[1]], powerConsumption[[2]])

## create a  date object 
powerConsumption[[1]]  <-  strptime(powerConsumption[[1]], "%d/%m/%Y %H:%M:%S")

## open a .png file in the working directory
png(filename = "plot1.png")

## draw a histogram per specification 
hist(powerConsumption$Global_active_power, freq = TRUE, main = ("Global Active Power"), xlab = "Global Active Power(Kilowats)" , col = "red2")

##close writing of .png file 
dev.off()
