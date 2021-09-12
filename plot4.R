##load required library
library(data.table)
library(lubridate)
library(dplyr)

##download the file and read the raw data into table
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile = "powerdata.zip")
unzip("powerdata.zip")

read.table("household_power_consumption.txt", sep = ";", header = TRUE) -> powerdata

##add DateTime column and clean the rest of the table to correct data type
powerdata$DateTime <- strptime(paste(powerdata$Date,powerdata$Time),format = "%d/%m/%Y %H:%M:%OS")
powerdata$Date <- as.Date(powerdata$Date,"%d/%m/%Y")
powerdata$Time <- hms(powerdata$Time)
powerdata$Global_active_power <- as.numeric(powerdata$Global_active_power)
powerdata$Global_reactive_power <- as.numeric(powerdata$Global_reactive_power)
powerdata$Voltage <- as.numeric(powerdata$Voltage)
powerdata$Sub_metering_1 <- as.numeric(powerdata$Sub_metering_1)
powerdata$Sub_metering_2 <- as.numeric(powerdata$Sub_metering_2)
powerdata$Sub_metering_3 <- as.numeric(powerdata$Sub_metering_3)

##filter the data to required set
projectdata <- filter(powerdata,Date == "2007-02-01" | Date == "2007-02-02")

##generate the required graphs and save into a png file
png(file="plot4.png", width=480, height=480)

par(mfcol = c(2,2))

##1st graph - top left
plot(projectdata$DateTime,projectdata$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

##2nd graph - bottom left
plot(projectdata$DateTime,projectdata$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(projectdata$DateTime,projectdata$Sub_metering_2,  col = "red")
lines(projectdata$DateTime,projectdata$Sub_metering_3,  col = "blue")
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1, lwd = 2)

##3rd graph - top right
plot(projectdata$DateTime,projectdata$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

##4th graph - bottom right
plot(projectdata$DateTime,projectdata$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
