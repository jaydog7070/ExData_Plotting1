## Jason Stedl plot2  project 1 Jan 2014

## removes database objects from working memory if they exist
if (exists("powerConsumption"))
	{rm(powerConsumption)}

if (exists("con")) 
	{rm(con)}

## loads R sqlite libray into working memory  
library(RSQLite)


## creates a database
con <- dbConnect(SQLite(), dbname = "powerconsumption")

## writes to database file household_power_consumption.txt
dbWriteTable(con, name="powerconsumption", value="household_power_consumption.txt",  row.names=FALSE, header=TRUE, sep = ";", overwrite = TRUE)

## query of data base using sql command
powerConsumption <- dbGetQuery(con, "SELECT * FROM powerconsumption WHERE Date='1/2/2007' OR Date='2/2/2007'")

## disconects from database
dbDisconnect(con)

## pastes together date and time element 
powerConsumption[[1]]  <- paste(powerConsumption[[1]], powerConsumption[[2]])

## converts 1st column to a date objects
powerConsumption[[1]]  <-  strptime(powerConsumption[[1]], "%d/%m/%Y %H:%M:%S")

## opens a connection to a file in working dir
png(filename = "plot2.png")
## plots lines of dates vs Global active power per specifications
plot(powerConsumption$Date, powerConsumption$Global_active_power, type = "l",xlab = "" , ylab ="Global Active Power(Kilowats")

## closes conection to .png file  
dev.off()