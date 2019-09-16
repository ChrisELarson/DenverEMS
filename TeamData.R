#Libraries used

library(tidyverse)
library(lubridate)
library(dplyr)

#Broncos Games
  #Read data as csv and add year variable
bronx<-read.csv("C:\\Users\\Clars\\Desktop\\ProjectRawData\\bronx2010.txt",
                stringsAsFactors = F)
bronx$year = "2010"

#merging date and year and changing char to date value
bronx<-
  bronx %>% 
  unite(date, X.1, year, sep = " ", remove = F)
bronx$date<-mdy(bronx$date)                  

# Filtering away games and shrinking data to date and time only
broncos2010<- bronx %>% 
  filter(X.3 != '@') %>%       
  select(date, X.2)                      

#Create a path to save created as a CSV file
BroncosPath<- "C:/Users/Clars/Desktop/Broncos"
write.csv(broncos2010, file = BroncosPath)



#Run this for each set of data, changing bronxm to appropriate year, then merge them togehter

#Rockies Data
 #Read the downloaded data as CSV and add year variable
rox<- read.csv("C:/Users/Clars/Desktop/ProjectRawData/rox2010.txt")
rox$year = "2010"

# Merge date and year and change to date variable
rox<-
  rox %>% 
  unite(date, Date, year, sep = " ", remove = F)
rox$date<- mdy(rox$date)

# Filter out away games, saving only date and D.N (which is a Day/Night classifier for games), actual times not availabile from website
rockies2010<-
  rox %>% 
  filter(X != "@") %>% 
  select(date, D.N)