# Script for generating plot1.png;
# it is assumed that the household_power_consumption.txt file is in your current working directory

# first upload the data.table package
library(data.table)

fileName  <- "household_power_consumption.txt"

#only upload the names of the columns/variables
heads     <- names(fread(fileName,nrows=0,header=TRUE,sep=";"))

# upload the Date column
dt        <- fread(fileName,select="Date",header=TRUE,sep=";")

# find Dates corresponding to 1/2/2007 and 2/2/2007 e calculate the number of measurements taken in these dates
indexing  <- length(which(dt == "1/2/2007" | dt == "2/2/2007"))

# now upload the data matching the required dates
dt        <- fread(fileName,nrows=indexing,skip="1/2/2007",header="auto",sep=";",na.strings="?")

# clean the data from missing values
dt        <- dt[complete.cases(dt),]

# reassign the column names (using "skip" two lines above we missed them)
setnames(dt,1:length(heads),heads)

# set language to english
Sys.setlocale("LC_TIME", "en_US")

# find weekdays for selected dates
days  <-  weekdays(as.Date(dt$Date,"%d/%m/%Y"),abbreviate=TRUE)

# add a day to match xlabels of the plot
further_day <- weekdays(as.Date("3/2/2007","%d/%m/%Y"),abbreviate=TRUE)

# array with weekdays without repetitions
uniq_days <- c(unique(days),further_day)

# add a column to dt with weekdays
dt[,Days:=days]

# find first occurrence of second day
first_occur <- which(dt$Days == uniq_days[2])[1]


# define x and ys for plotting
x <- 1:dim(dt)[1]
y  <- dt$Global_active_power
y1 <- dt$Sub_metering_1
y2 <- dt$Sub_metering_2
y3 <- dt$Sub_metering_3
y4 <- dt$Global_reactive_power
y5 <- dt$Voltage


# generate a PNG file and save the plot in the current directory
png('plot4.png')
par(mfrow= c(2,2), oma=c(2,2,2,2))
# first plot
plot(x,y,type="n",xaxt="n",xlab="",ylab="Global Active Power (kilowatts)")
lines(x,y,type="l")
axis(1, at = c(1,first_occur,dim(dt)[1]), labels=uniq_days)
# second plot
plot(x,y5,type="n",xaxt="n",xlab="datetime",ylab="Voltage")
lines(x,y5,type="l")
axis(1, at = c(1,first_occur,dim(dt)[1]), labels=uniq_days)
# third plot
plot(x,y1,type="n",xaxt="n",xlab="",ylab="Energy sub metering")
lines(x,y1,type="l",col="black")
lines(x,y2,type="l",col="red")
lines(x,y3,type="l",col="blue")
axis(1, at = c(1,first_occur,dim(dt)[1]), labels=uniq_days)
legend('topright',cex=0.8,lty=1, bty="n",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","blue","red"))
# fourth plot
plot(x,y4,type="n",xaxt="n",xlab="datetime",ylab="Global_reactive_power")
lines(x,y4,type="l")
axis(1, at = c(1,first_occur,dim(dt)[1]), labels=uniq_days)

dev.off()

