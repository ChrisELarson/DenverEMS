# Libraries needed
library(tidyverse)
library(lubridate)

# Loading complete CSV
call_data <- read.csv("C:/Users/ADMIN/Desktop/GitRepos/all_variables.csv",
                 stringsAsFactors = F)

# current data structure
str(call_data)

# rename n to calls for more descriptive variable name. n is the number of call in an hour period
call_data <- call_data %>% 
  rename(calls = n)

# Convert binary variables to factors, name levels y/n for a athletic event, T/F for precipitation
cols <- c('broncos', 'rockies', 'nuggets', 'precip') #select the columns to change
call_data[,cols]<- data.frame(apply(call_data[cols], 2 , as.factor)) #change to factors with 2 levels
levels(call_data$broncos) <- c('n', 'y') #relabel the levels
levels(call_data$nuggets) <- c('n', 'y')
levels(call_data$rockies) <- c('n', 'y')
levels(call_data$precip) <- c('F', 'T')

# Weekday, Month, Hour and Year as factors with labeling
call_data$wday <- as.factor(call_data$wday)
levels(call_data$wday)<- c('Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat')

call_data$Month <- as.factor(call_data$Month)
levels(call_data$Month) <- c('Jan', 'Feb', 'Mar', 'Apr',
                        'May', 'Jun', 'Jul', 'Aug',
                        'Sep', 'Oct', 'Nov', 'Dec')

call_data$Hour <- as.factor(call_data$Hour) #factor 0 - 23
call_data$Year <- as.factor(call_data$Year)

# Converting Celcius to Farienheit
c_to_f <- function(temp) {
  farienheit <- ((temp * (9/5)) + 32)
  return(farienheit)
}

call_data$Temp <- c_to_f(call_data$Temp)

# Convert Date from character to date variable
call_data$Date <- ymd_hms(call_data$Date, tz = 'MST')

# Save the variable changes as a data frame
save(call_data, file = "c:/Users/ADMIN/Desktop/GitRepos/DenverEMS/call_data.Rdata")





