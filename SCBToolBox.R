## -----------------------------------------------------------------------------
## Peforms a few useful things
## To use:
## source("SCBToolBox.R")
##
## Writen By Steven Barberena - Austin, TX 2015
##
## This is a library of R code I've been writting as I started
## taking the Coursera Data Science classes.  If you haven't started
## creating your own library file, I highly recommend that you do.  It will
## save you time for future projects and you can add new functions you find
## are useful for your general R development.
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Creates a subset file of data from a large file that match the given
## regular expression
## -----------------------------------------------------------------------------
readBigDataSubsetRegEx <- function(inputFile, outputFile, regExValue, header = TRUE)
{
	inputCon <- file(inputFile, 'r')
	outputCon <- file(outputFile, 'w')
	methodIndex <- 1

	# reading data in 10,000 line chunks, this makes things faster
	while (length(input<- readLines(inputCon, n=10000)) >  0)
	{
		consoleWriteLine(paste("Processing Lines", methodIndex, "to", methodIndex + 10000, sep=" "))
		for (ix in 1:length(input))
		{
			if(methodIndex == 1 & ix == 1 & header == TRUE)
			{
				# keep header data
				writeLines(input[ix], con=outputCon)
			}
			else if(grepl(regExValue, input[ix], perl=TRUE))
			{
				writeLines(input[ix], con=outputCon)
			}
		}
		flush(outputCon)
		methodIndex <- methodIndex + 10000
	}

	close(outputCon)
	close(inputCon)
}

## -----------------------------------------------------------------------------
## Creates a subset file of data from a large file for the given
## index start and stop
## -----------------------------------------------------------------------------
readBigDataSubset <- function(inputFile, outputFile, startIndex, stopIndex, header = TRUE)
{
	inputCon <- file(inputFile, 'r')
	outputCon<- file(outputFile, 'w')
	methodIndex <- 1
	
	# reading data in 10,000 line chunks, this makes things faster
	while (length(input<- readLines(inputCon, n=10000)) >  0)
	{
		consoleWriteLine(paste("Processing Lines", methodIndex, "to", methodIndex + 10000, sep=" "))
		if(methodIndex == 1 & header == TRUE & length(input) > 0)
		{
			# keep header data
			writeLines(input[ix], con=outputCon)
		}

		if(startIndex >= methodIndex & stopIndex <= methodIndex + 10000)
		{
			for (ix in 1:length(input))
			{
				locationIx <- methodIndex + ix;
				if(locationIx >= startIndex & locationIx <= stopIndex)
				{
					writeLines(input[ix], con=outputCon)
				}
			}
		}
		flush(outputCon)
		methodIndex <- methodIndex + 10000
	}
	
	close(outputCon)
	close(inputCon)
}

## -----------------------------------------------------------------------------
## Called to write information to a log file as well as to the console
## Logs will include a time stamp as to when the message was written
## -----------------------------------------------------------------------------
logWrite <- function(messageIn)
{
	if(!exists("logFile"))
	{
		dateStamp <- getDateStamp()
		logFile <<- paste("LogFile_", dateStamp, ".log", sep = "") ## logFile is now a global
	}
	now <- format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z | ")
	newMessage <- paste(now, messageIn, sep = "")
	consoleMessage <- paste(newMessage, "\n", sep = "")
	cat(consoleMessage)
	write(newMessage, file = logFile, append = TRUE)
}

## -----------------------------------------------------------------------------
## Called to write information to the console 
## -----------------------------------------------------------------------------
consoleWriteLine <- function(messageIn)
{
	consoleMessage <- paste(messageIn, "\n", sep = "")
	cat(consoleMessage)
}


## --------------------------------------------------------------------------
## This function downloads the data from the website and unzips the file
## --------------------------------------------------------------------------
downloadAndUnzip <- function(fileUrl, targetFolder) 
{
	dateTimeStamp <- getDateTimeStamp()
	if (!file.exists(targetFolder))
		dir.create(targetFolder)
	
	# The source and target names for downloading the file
	destFile <- paste("./", targetFolder, "/Downloded_", dateTimeStamp, ".zip", sep = "")

	logWrite("Download File")
	# Mac Download Command - comment out the windows version and use this if running on Mac
	#download.file(fileUrl, destfile = destFile, method = "curl")

	# Windows Download Command 
	download.file(fileUrl, destfile = destFile)

	# log the date we downloaded the file
	dateDownload <- date()
	logWrite(paste("Downloaded File on ", dateDownload, sep = ""))

	# unzip the downloaded file
	logWrite(paste("Unzip File: ", destFile, sep = ""))
	unzipInfo <- unzip(destFile, overwrite = TRUE, exdir = paste(".", targetFolder, sep = "/"), setTimes = TRUE)
	logWrite(unzipInfo)
}

getDateTimeStamp <- function()
{
	format(Sys.time(), "%Y_%m_%d_%H_%M")
}

getDateStamp <- function()
{
	format(Sys.time(), "%Y_%m_%d")
}

getTimeStamp <- function()
{
	format(Sys.time(), "%H_%M")
}

