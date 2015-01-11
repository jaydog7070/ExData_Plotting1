## Jason Stedl plot4  project 1 Jan 2014

## removes database objects from r working memory if they exist 
if (exists("powerConsumption"))
	{rm(powerConsumption)}

if (exists("con")) 
	{rm(con)}

## loads  R sqlite library 	
library(RSQLite)

## creates a connection to a new database 
con <- dbConnect(SQLite(), dbname = "powerconsumption")

## write household power consumption to the new database
dbWriteTable(con, name="powerconsumption", value="household_power_consumption.txt",  row.names=FALSE, header=TRUE, sep = ";", overwrite = TRUE)

## query of new database sent to variable powerConsumption 
powerConsumption <- dbGetQuery(con, "SELECT * FROM powerconsumption WHERE Date='1/2/2007' OR Date='2/2/2007'")
## closes connection to database 
dbDisconnect(con)

## pastes date and time text info to 1st column of powerConsumption 
powerConsumption[[1]]  <- paste(powerConsumption[[1]], powerConsumption[[2]])

## converts 1st column of data frame to a date object  
powerConsumption[[1]]  <-  strptime(powerConsumption[[1]], "%d/%m/%Y %H:%M:%S")

## opens connection toa .png file in working directory 
png(filename = "plot4.png")

## 2 rows of plots by 2 columns 
par(mfrow=c(2,2))

## sets margins for individual plots and the total corporate plot
par(mar = c(4.0,4.0, 2.0,2.0), oma =  c(1,1,.5,1))

## First plot 
plot(powerConsumption$Date, powerConsumption$Global_active_power, type = "l",xlab = "" , ylab ="Global Active Power")



## Second plot 

plot(powerConsumption$Date, powerConsumption$Voltage,type = "l",xlab = "datetime" , ylab ="Voltage" )

## Third plot 
y_range  =  range(c(powerConsumption$Sub_metering_1,powerConsumption$Sub_metering_2, powerConsumption$Sub_meterin_3))
plot(powerConsumption$Date ,powerConsumption$Sub_metering_1, , type = "l",xlab = "" , ylab ="Energy sub metering" , ylim = y_range)
par(new = T)
plot(powerConsumption$Date ,powerConsumption$Sub_metering_2, , type = "l", col = "red2",ylim = y_range , xlab = "", ylab = "")
par(new = T)
plot(powerConsumption$Date ,powerConsumption$Sub_metering_3, , type = "l", col = "blue",ylim = y_range , xlab = "", ylab = "Energy sub metering")

legend("topright", lty = c(1,1,1), col = c("black","red2","blue") , bty = "n"  ,legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"  ))


##Fourth plot 

plot(powerConsumption$Date, powerConsumption$Global_reactive_power ,type = "l",ylim = c(0.0, 0.5) ,xlab = "datetime" , ylab ="Global_reactive_power")


##closes connection to .png file
dev.off()


