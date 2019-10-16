#Complete data set, with missing values imputed and indexed hours
  #strings as factor = F needed to easily convert Date to a time format,
  #this imports Date as a character instead of a factor variable.

data <- read.csv("C:/Users/ADMIN/Desktop/GitRepos/all_variables.csv",
                 stringsAsFactors = F)

#variable types and structure
str(data)
head(data)


#libarires needed...for future reference, ggplot2 is inside tidyverse package
library(tidyverse)
library(lubridate)
library(MASS)
library(ggplot2)
library(dlookr)  #this has a nice bin function - looks robust, explore the documentation
library(PKPDmisc) #simplier than dlookr binning, based on user selected values not calculations

#set variables to proper type.
  #Date to date time format

data$Date <- ymd_hms(data$Date, tz = 'MST')


  #Factoring binary variables

cols <- c('broncos', 'rockies', 'nuggets', 'precip')
  data[,cols]<- data.frame(apply(data[cols], 2 , as.factor))
    levels(data$broncos) <- c('n', 'y')
    levels(data$nuggets) <- c('n', 'y')
    levels(data$rockies) <- c('n', 'y')
    levels(data$precip) <- c('F', 'T')

  #Weekday and Month as factors with appropriate labeling 

data$wday <- as.factor(data$wday)
  levels(data$wday)<- c('Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat')

data$Month <- as.factor(data$Month)
  levels(data$Month) <- c('Jan', 'Feb', 'Mar', 'Apr',
                          'May', 'Jun', 'Jul', 'Aug',
                          'Sep', 'Oct', 'Nov', 'Dec')
  
  #Hour as a factor (0 - 23), year as a factor

data$Hour <- as.factor(data$Hour)
data$Year <- as.factor(data$Year)

#convert Temp from celcius to farienheit

c_to_f <- function(temp) {
  farenheit <- ((temp * (9/5)) + 32)
  return(farenheit)
}

data$Temp <- c_to_f(data$Temp)

#check for missing values - this data set has imputed values already for precip etc.

colSums(is.na(data))


#Exploratory graphs of data
 #calls by hour

data %>% 
 group_by(Hour) %>%
 filter(Year != 2019) %>% 
  summarise(n = sum(n)) %>% 
 ggplot(aes(Hour, n , group = Hour)) +
  ggtitle('Calls by Hour', subtitle = 'Years 2011 - 2018') +
  xlab('Hour - 24hr scale') +
  ylab('Total Calls') +
  coord_cartesian(ylim = c(10000, 55000)) +
 geom_col()

 #calls by day

data %>% 
  group_by(wday) %>% 
  filter(Year != 2019) %>% 
  summarise(n = sum(n)) %>% 
  ggplot(aes(wday, n, group = wday)) +
   xlab('Day of the Week ') +
   ylab('Total Calls') +
   ggtitle('Calls by Day of Week', subtitle = 'Years 2011 - 2018') +
   coord_cartesian(ylim = c(105000, 120000)) +
  geom_col()

#Calls by hour on the busiest days

 # This sorts the days by call volume in decending order
busiest_days <- data %>% 
  group_by(wday) %>% 
  filter(Year != 2019) %>% 
  summarise(n = sum(n)) %>% 
  arrange(desc(n))
busiest_days

  #days call volume by percent
total_calls <- sum(busiest_days$n)
total_calls

busiest_days %>% 
  mutate(rel.freq = n / total_calls)

#percent bigger than function

perc_bigger <- function(x , y){
  perc_bigger <- (x - y) / y
  return(perc_bigger)
  }

#Percent bigger

  
#group days into fri-sat-sun? and mon-thurs?

#Mean calls per hour by day

 #Function for mean calls per day graph, must be entered in quotes to Return properly
Mean_calls_perDay <-
  function(day){
    data %>% 
      filter(wday == day) %>% 
      group_by(Hour) %>% 
      summarise(n = mean(n)) %>% 
      ggplot(aes(Hour, n , group = Hour)) +
      xlab('Hour') +
      ylab('Calls') +
      ggtitle(day, subtitle = 'mean calls per hour') +
      geom_col()
  }

Mean_calls_perDay('Sun')
#mean calls per hour...then overlay by day for insight into busiest/slowest times

d1 <- data %>% 
  group_by(Hour) %>% 
  summarise(n = mean(n))
d2<- data %>% 
  filter(wday == 'Sun') %>% 
  group_by(Hour) %>% 
  summarise(n = mean(n))

d1$group <- 1
d2$group <- 2
visual12 <- rbind(d1, d2)

ggplot(visual12, aes(Hour, n, group = group, fill = group)) +
  xlab('Hour') +
  ylab('Mean Calls') +
  ggtitle('Comparison of Mean Calls', subtitle = 'day vs. overall') +
  geom_col()

combo<- ggplot(NULL, aes(Hour, n))+
          geom_col(data = d1, aes(alpha = I(0.3))) +
                 
           geom_col(data = d2)
combo

#mean calls per hour

mean_calls_perHour <- data %>% 
  group_by(Hour) %>% 
  summarise(n = mean(n)) %>% 
  ggplot(aes(Hour, n, group = Hour)) +
  xlab('Hour') +
  ylab('Average Calls') +
  ggtitle('Mean Calls per Hour') +
  geom_col()

mean_calls_perHour

summary(data)
#build functions for calls per hour and by day.  Combine 2 data sets with rbind, use the new
#for ggplot.  Creates cleaner looking code and easier to fill, legend etc.
#ideally just want to put in the day of the week and have a function output an overlay
#of the mean calls per hour per day against general mean calls

#calls by Month
 data %>%
  group_by(Month) %>% 
  filter(Year != 2019) %>% 
  summarise(n = sum(n)) %>% 
  ggplot(aes(Month, n, group = Month)) +
  ggtitle('Calls by Month', subtitle = 'Years 2011 - 2018') +
   xlab('Month') +
   ylab('Total Calls') +
   coord_cartesian(ylim = c(55000, 72000)) +
  geom_col()

 #Calls by Year

data %>% 
  group_by(Year) %>% 
  filter(Year != 2019) %>% 
  summarise(n = sum(n)) %>% 
  ggplot(aes(Year, n , group = Year)) +
  ggtitle('Calls per Year') +
  xlab('Year') +
  ylab('Total Calls') +
  coord_cartesian(ylim = c(60000, 120000)) +
  geom_col()


 #scatterplot of variables - look for relationships
 #Temperature binning - dlookr package (extensive looking), automatically sets bins based on 
  #selected critera...PKDmisc lets you set your own bin values..useful here

data %>% 
  mutate(binned_Temp = set_bins(Temp, breaks = c(32, 40, 50, 60, 70, 80, 90), quiet = F)) %>% 
  head()


plot(data$Temp)


#Outliers

outliers <- ggplot(data = data, mapping = aes(x = '', y = n)) +
  geom_boxplot(outlier.color = 'red', outlier.shape = 1) +
  ggtitle(expression(atop('Number of Calls',
                          atop(italic('Outliers at 1.5 IQR'))))) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5))
outliers + coord_flip()

out_values <- boxplot(data$n, plot = F)$out
table(out_values)

#create data set containing solely the outliers

out_data <- data[which(data$n %in% out_values),]
nrow(out_data)

#distribution of calls by raw number...eg: 25 calls happened 80 different times
 #the filter shows between whatever range you want..>= 3 (there are no values less
 # and <= outlier # which is 27
 # set the x to be more defined, 1 number per bar

data %>% 
  count(n) %>% 
  filter((n >= 3) | (n <= 27)) %>% 
  ggplot(aes(n, nn)) +
  scale_x_discrete(name = 'Number of Calls', breaks = c(0:24)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +             
  ylab('Frequency') +
  geom_col()

data %>% 
  count(n)