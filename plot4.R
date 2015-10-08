## -----------------------------------------------------------------------------
## Downloads the Household Power Consumption data, creates a subset of
## that data with only February 1st and 2nd, 2007.  Will then generate
## a line plot on the Energy sub meters for those two days
##
## To Use:
## source("plot4.R")
## plot4()
## -----------------------------------------------------------------------------
plot4 <- function()
{
	# SCBToolBox.R is a library of R code I've been writting as I started
	# taking the Coursera Data Science classes.  If you haven't started
	# creating your own library file, I highly recommend that you do.  It will
	# save you time for future projects and you can add new functions you find
	# are useful for your R script development.
	source("SCBToolBox.R")
	
	dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
	targetDir <- "downloadeData"
	rawDataFile <- paste(".", targetDir, "household_power_consumption.txt", sep = "/")
	subDataFile <- paste(".", targetDir, "sub_household_power_consumption.txt", sep = "/")
	
	# Test to see if the data has been downloaded and unzipped if the target directory exists
	if (!file.exists(targetDir) | !file.exists(rawDataFile))
		downloadAndUnzip(dataUrl, targetDir) # otherwise download And Unzip
		
	# Test to see if the sub data file exists, otherwise generate it if it doesn't
	if(!file.exists(subDataFile))
		readBigDataSubsetRegEx(rawDataFile, subDataFile, "^1/2/2007|^2/2/2007", TRUE);

	# We can now read in the subset of the data file
	dataIn <- read.table(subDataFile, sep = ";", header = TRUE)
	
	# Format the data so that the x axis has the day of the week
	dataIn$DateTime = paste(dataIn$Date, dataIn$Time)
	dataIn$DateTime <- strptime(dataIn$DateTime, "%d/%m/%Y %H:%M:%S")

	# Open the Graph output device
	png(filename="plot4.png",width = 480, height = 480, units="px")
	
	# Generate the Graph - You can find different colors here:  http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
	par(mfrow=c(2,2))
	# first plot - just like plot 2, minus the kilowatts
	plot(dataIn$DateTime, as.numeric(as.character(dataIn$Global_active_power)), 
		type = "l", xlab = "", ylab="Global Active Power")
	
	# second plot
	plot(dataIn$DateTime, as.numeric(as.character(dataIn$Voltage)),
		type = "l", xlab = "datetime", ylab="Voltage")
	
	# third plot - just like plot3
	plot(dataIn$DateTime, as.numeric(as.character(dataIn$Sub_metering_1)),
		type = "l", xlab = "", ylab="Energy sub metering", col="black")
	lines(dataIn$DateTime, as.numeric(as.character(dataIn$Sub_metering_2)), col="red")
	lines(dataIn$DateTime, as.numeric(as.character(dataIn$Sub_metering_3)), col="blue")
	legend("topright", lty=1, bty="n",
		col = c("black", "red", "blue"), 
		legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ))
	
	# forth plot
	plot(dataIn$DateTime, as.numeric(as.character(dataIn$Global_reactive_power)),
		type="l", xlab="datetime", ylab="Global_reactive_power")
	
	# Close the Graph output device
	dev.off()
}
