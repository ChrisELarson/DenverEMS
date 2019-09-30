#+ Setup, include = FALSE, message = FALSE
library(tidyverse)
library(odbc)
library(lubridate)
library(knitr)
library(janitor)

opts_chunk$set(message = F, echo =F, warning = F)

#Base CAD Query----
con <- dbConnect(odbc::odbc(),
                 "CAD_DW_NEW",
                 UID = "sopadw", 
                 PWD = rstudioapi::askForPassword('Database Password'))

cancel_reasons <- c ("TS - Test/Training Call Only",
                     "DU - Duplicate Call",
                     "OC - Out of City")

delay_reasons <- c('Bad Address',
                   'Priority Change',
                   'Arrival Time Entry Delayed',
                   'Weather')

englewood_units <- c('A837','A838','B837','B838')
TRV_units <- c('M101','M102')

RMI <- tbl(con, 'Response_Master_Incident')
RVA <- tbl(con, 'Response_Vehicles_Assigned')
RT  <- tbl(con, 'Response_Transports')
AVL <- tbl(con, 'AVL')
comm <- tbl(con, 'Response_Comments')

base <- RMI %>% 
filter(Agency_Type == 'EMS') %>%
filter(!(Cancel_Reason %in% cancel_reasons) | is.na(Cancel_Reason)) %>% 
filter(!is.na(Priority_Description)) %>% 
filter(Priority_Description != '') %>% 
filter(!str_detect(string = Problem, 'test')) %>%
left_join(RVA, by = c('ID' = 'Master_Incident_ID'),
suffix = c('_RMI', '_RVA')) %>%
left_join(RT, by = c('ID_RVA' = 'Vehicle_Assigned_ID')) %>% 
mutate(
priority_type = case_when (
Priority_Description %in% c("Emergency", "Non Emergency") ~ 'ALS',
Priority_Description %in% c("BLS Non-Emergency") ~ "BLS",
Priority_Description %in% c("Call On Hold",
"Call On Hold - DP") ~ "Call On Hold",
Priority_Description %in% c("DIA Monitor Only") ~ "DIA Monitor Only",
Priority_Description %in% c("Monitor Only") ~ "Monitor Only",
Priority_Description %in% c("Stand By") ~ "Stand By",
Priority_Description %in% c("Transfer") ~ "Transfer"
),
Zone = ifelse(City.x == 'Englewood', 'Englewood', 'DSG')
) %>% 
mutate(
unit_type = case_when(
str_detect(Radio_Name, "B83") ~ "DH_ENG",
str_detect(Radio_Name, "A83") ~ "DH_ENG",
Radio_Name %in% c('M101', 'M102') ~ 'DH_TRV',
str_detect(Radio_Name, 'VST') ~ 'DH_VST',
str_detect(Radio_Name, "EMS") ~ "DH_CMD",
str_detect(Radio_Name, "OP") ~ "DH_CMD",
str_detect(Radio_Name, "EMA") ~ "MA",
str_detect(Radio_Name, "AC") ~ "MA",
str_detect(Radio_Name, "AMR") ~ "MA",
str_detect(Radio_Name, "PM") ~ "MA",
str_detect(Radio_Name, "RM") ~ "MA",
str_detect(Radio_Name, "WM") ~ "MA",
str_detect(Radio_Name, "SM") ~ "MA",
str_detect(Radio_Name, "WA") ~ "MA",
str_detect(Radio_Name, "CF") ~ "MA",
str_detect(Radio_Name, "NG") ~ "MA",
str_detect(Radio_Name, "CO") ~ "MA",
str_detect(Radio_Name, "X") ~ "DH_BLS",
str_detect(Radio_Name, "B") ~ "DH_SE",
str_detect(Radio_Name, "M") ~ "DH_SE",
str_detect(Radio_Name, "BM") ~ "DH_SE",
str_detect(Radio_Name, "GR") ~ "DH_SE",
str_detect(Radio_Name, "BT") ~ "DH_SE",
str_detect(Radio_Name, "CC") ~ "DH_CCT",
str_detect(Radio_Name, "S") ~ "DH_ALS",
Radio_Name %in% c( "1", "2", "3", "4", "5", "6", "7", "8", "9","10",
"11","12","13","14","15","16","17","18","19","20",
"21","22","23","24","25","26","27","28","29","30",
"31","32","33","34","35","36","37","38","39","40",
"41","42","43","44","45","46","47","48","49","50",
"51","52","53","54","55","56","57","58","59","60",
"61","62","63","64","65","66","67","68","69","70",
"71","72","73","74","75","76","77","78","79","80",
"81","82","83","84","85","86","87","88","89","90",
"91","92","93","94","95","96","97","98","99") ~ 'DH_ALS'
)
)
#----

base %>%
  filter(!is.na(Time_First_Unit_Assigned)) %>% 
  filter(!(City.x %in% 'Englewood')) %>% 
  filter(!(Priority_Description %in% 'Transfer')) %>% 
  select(Response_Date, ID_RMI) %>% 

  collect() -> raw

raw %>%
  group_by(Date = floor_date(Response_Date, 'hour')) %>% 
  summarise(n = n_distinct(ID_RMI)) %>% 
  write_csv('hourly_incidents_assigned_volume.csv')