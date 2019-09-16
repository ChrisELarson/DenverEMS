library(tidyverse)
library(lubridate)
library(data.table)

#Download the hourly weather data for DIA and save it

#A nice FTP location for this data
url1 <- "https://www.ncei.noaa.gov/data/global-hourly/access/"

#The years in question
years <- 2002:2019 

#This is the weather station code for DIA
url3 <- "/72565003017.csv" 

#Create and save the data table
files <- paste0(url1,years,url3)

tables <- map(files, read_csv)
save(tables, file = 'tables.rData')

#Cleaning the Weather Data and saving as CSV file
load('Project/Weather/tables.rData')

a <- function(table) {
  table %>% 
    as_data_frame() %>% 
    select(DATE, TMP) %>%
    # head(1) %>% 
    return()
}#; a(tables[[1]])

all <- map(.x = tables, a) %>% 
  bind_rows()

temps <- all %>% 
  separate(TMP, into = c('Temp', 'Code'), sep = ",") %>%
  filter(Code %in% c('1','5')) %>% 
  mutate(Temp = as.numeric(Temp) / 10)

data.table::fwrite(temps, file = 'Project/Weather/houry_DEN_weather.csv')