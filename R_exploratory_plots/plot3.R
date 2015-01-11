## Jason Stedl plot3  project 1 Jan 2014

#removes database objects from working memory if they exist 
if (exists("powerConsumption"))
	{rm(powerConsumption)}

if (exists("con")) 
	{rm(con)}

## loads R sqlite library into working memory 
library(RSQLite)

## creates a database
con <- dbConnect(SQLite(), dbname = "powerconsumption")

## writes file household power consumption to database
dbWriteTable(con, name="powerconsumption", value="household_power_consumption.txt",  row.names=FALSE, header=TRUE, sep = ";", overwrite = TRUE)

## query of database for certian dates
powerConsumption <- dbGetQuery(con, "SELECT * FROM powerconsumption WHERE Date='1/2/2007' OR Date='2/2/2007'")
dbDisconnect(con)

## pastes time and date text together on 1st column 
powerConsumption[[1]]  <- paste(powerConsumption[[1]], powerConsumption[[2]])

## converts 1st column to a date object
powerConsumption[[1]]  <-  strptime(powerConsumption[[1]], "%d/%m/%Y %H:%M:%S")

## open a connection to a .png file
png(filename = "plot3.png")

## gets range of y  data used in all three calls to plot
y_range  =  range(c(powerConsumption$Sub_metering_1,powerConsumption$Sub_metering_2, powerConsumption$Sub_meterin_3))
##plots first line to graph 
plot(powerConsumption$Date ,powerConsumption$Sub_metering_1, , type = "l",xlab = "" , ylab ="Energy sub metering" , ylim = y_range)
## lets plot keep writing to existing graph
par(new = T)
## plots second line to graph
plot(powerConsumption$Date ,powerConsumption$Sub_metering_2, , type = "l", col = "red2",ylim = y_range , xlab = "", ylab = "")
## lets plot keep writing to existing graph
par(new = T)
## plots thirs line to graph 
plot(powerConsumption$Date ,powerConsumption$Sub_metering_3, , type = "l", col = "blue",ylim = y_range , xlab = "", ylab = "Energy sub metering")

## attaches legend to graph 
legend("topright", lty = c(1,1,1), col = c("black","red2","blue")  , legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"  ))

#closes connection to .png file
dev.off()
