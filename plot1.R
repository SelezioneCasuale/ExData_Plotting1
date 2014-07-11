# Script for generating plot1.png;
# it is assumed that the household_power_consumption.txt file is in your current working directory

# first upload the data.table package
library(data.table)

fileName  <- "household_power_consumption.txt"

# only upload the names of the columns/variables
heads     <- names(fread(fileName,nrows=0,header=TRUE,sep=";"))

# upload the Date column
df        <- fread(fileName,select="Date",header=TRUE,sep=";")

# find Dates corresponding to 1/2/2007 and 2/2/2007 e calculate the number of measurements taken in these dates
indexing  <- length(which(df == "1/2/2007" | df == "2/2/2007"))

# now upload the data matching the required dates
df        <- fread(fileName,nrows=indexing,skip="1/2/2007",header="auto",sep=";",na.strings="?")

# clean the data from missing values
df        <- df[complete.cases(df),]

# reassign the column names (using "skip" two lines above we missed them)
setnames(df,1:length(heads),heads)


# generate a PNG file and save the histogram in the current directory
png('plot1.png')
par(oma=c(2,2,2,2))
data <- df$Global_active_power
hist(data,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")
axis(2,at=seq(0,1200,by=200))
dev.off()

