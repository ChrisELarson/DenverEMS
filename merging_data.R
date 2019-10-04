library(tidyverse)
library(lubridate)

# Bring in the temperatures, vols is the csv of call volumes
temps <- read_csv('Project/Weather/houry_DEN_weather.csv')
vols  <- read_csv('volumes.csv')

# Rounding the temperature to the closest hourt
temps_rounded <- temps %>%
  group_by(Date = round_date(DATE, unit = 'hour')) %>% 
  summarise(Temp = mean(Temp, na.rm = T),
            precip = mean(mm, ma.rm = T) > 0)

# Merging call volume and temperature data
vols %>% 
  left_join(temps_rounded) -> vol_and_temp

#make variables for broncos, rockies, and nuggets
all_variables <- vol_and_temp %>% 
  mutate(broncos = 0,
         rockies = 0,
         nuggets = 0)

#broncos----
broncos <- read_csv('broncos2010_2018.csv') %>% 
  filter(!is.na(date)) %>% 
  select(date)

#If the hour is between 1hr before the game start and 3 hours after the game start then it's flagged as Broncos
for(i in 1:nrow(broncos)) {
  all_variables$broncos[all_variables$Date < broncos$date[i] + hours(3) & 
               all_variables$Date > broncos$date[i] - hours(1)] <- 1
}
  
#rockies----
rockies <- read_csv('rockies2010_2018.csv') %>% 
  mutate(game_time = ifelse(D.N == "D", "13:10", "18:40")) %>% 
  filter(!is.na(date)) %>%
  mutate(date = as.character(date)) %>% 
  unite("date", c(date, game_time), sep = ' ') %>% 
  mutate(date = ymd_hm(date))

for(i in 1:nrow(rockies)) {
  all_variables$rockies[all_variables$Date < rockies$date[i] + hours(3) & 
                          all_variables$Date > rockies$date[i] - hours(1)] <- 1
}


#nuggets----
nuggets <- read_csv('nuggets games.csv') %>% 
  mutate(m = 'm') %>% 
  unite(Date, c(Date, Time), sep = ' ') %>% 
  unite(Date, c(Date, m), sep = '') %>% 
  mutate(date = mdy_hm(Date))

for(i in 1:nrow(nuggets)) {
  all_variables$nuggets[all_variables$Date < nuggets$date[i] + hours(3) & 
                          all_variables$Date > nuggets$date[i] - hours(1)] <- 1
}

write_csv(all_variables, "all_vars.csv")
