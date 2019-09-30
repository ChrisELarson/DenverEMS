# Denver Paramedics call volumes

## _Table of Contents_
* [General info](#general-info)
* [R Packages](#r-packages)
* [Data Gathering](#data-gathering)
* [Data Cleaning](#data-cleaning)
* [Exploratory Analysis](#exploratory-analysis)
    - [Summary Statistics](#summary-statistics)
* [Modeling](#modeling)
    - [GOF](#gof)
    - [Model selection](#model-selection)

## _General Info_
Analysis of 911 call volumes by hour for Denver Health Paramedics.  The only data available from the Denver Health Paramedics was a list of number of calls per each hour of the day from the years 2002 - 2018.  We decided to use the years 2008 -2018 for the analysis and training data.  Partial data for the beginning months of 2019 are used for testing.(not sure I like this bit) For this project we want to analyize the volume of calls to help acurately set minimum staffing levels. The Denver Health Paramedic Division currently uses 10 hour shifts with staggered start times throughout the day, unfortunately without access to actual times (i.e. how long does a call take on average) a proper staffing recommendation will be difficult.  Further, we want to see if local professional sports teams home games or weather variations; temperature and precipitation, have any predictive power in the number of 911 calls in a given hour.

## _R Packages_
Project created in R with the following packages:
* tidyverse: dplyr, ggplot2, tidyr, readr, tibble
* lubridate  
* MASS
* data.table
* odbc
* Janitor


## _Data Gathering_

### Weather Data
Temperature data was taken from the [National Oceanic and Atmospheric Administration](https://www.ncei.noaa.gov/).  The weather recordings for temperature and precipitation at the Denver International Airport station were used. [Code](Weather_data.R) provided by Steve Hulac.  

### Team Info
The data for Broncos(NFL) and Rockies(MLB) games was taken from www.pro-football-refernce.com and www.baseball-reference.com respectively.  The code used to gather the data can be found [here](https://github.com/ChrisELarson/DenverEMS/blob/master/TeamData.R).  The actual start times were available for NFL games.  For MLB games they were simply broken into a day/night category.  Per (whatever source I can use here) day games routinely start at X:XX and night games start at X:XX.  These times were used in our analysis.

The data for Nuggets(NBA) home games was gathered by Jephte Guerrier and received from Kroenke Sports. The methods used for the creation of the Nuggets data are unavailable.

No Avalanche(NHL) data is currently used.

### Denver Health Paramedics call volumes
[Code](CAD_data_pull.R) for obtaining call volumes provided by Steve Hulac via the Denver Health Paramedic Division. Unfortunately access to locations (for any geospatial analysis) and response times were unable to be obtained.

## _Data Cleaning_

## _Exploratory Analysis_
Our main focus is on the volume of 911 calls in the city of Denver.

### Summary Statistics

## _Modeling_

### GOF

### Model Selection
