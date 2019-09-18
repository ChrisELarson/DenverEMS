# Denver Paramedics call volumes

## _Table of Contents_
* [General info](#general-info)
* [Packages](#packages)
* [Data Gathering](#data-gathering)
* [Exploratory Analysis](#exploratory-analysis)
    -[Summary Statistics](#summary-statistics)
* [Modeling](#modeling)
    - [GOF](#gof)
    - [Model selection](#model-selection)

## _General Info_
Analysis of 911 call volumes by hour for Denver Health Paramedics.  The only data available from the Denver Health Paramedics was a list of number of calls per each hour of the day from the years 2002 - 2018.  For this project we want to analyize the volume of calls to help acurately set minium staffing levels.  Further, we want to see if local professional sports teams home games or weather variations have any predictive power in the number of 911 calls in a given hour.

## _Packages_
Project created in R with the following packages:
* tidyverse: dplyr, ggplot2, tidyr, readr, tibble
* lubridate  
* MASS


## _Data Gathering_

### Weather Data
Temperature data was taken from the [National Oceanic and Atmospheric Administration](https://www.ncei.noaa.gov/).  The weather recordings for temperature and precipitation at the Denver International Airport station were used. Code provided by Steve Hulac.  

### Team Info
The data for Broncos(NFL) and Rockies(MLB) games was taken from www.pro-football-refernce.com and www.baseball-reference.com respectively.  The code used to gather and clean the data can be found [here](https://github.com/ChrisELarson/DenverEMS/blob/master/TeamData.R).

The data for Nuggets(NBA) home games was gathered by Jephte Guirree and received from Kroenke Sports. The methods used for the creation of the Nuggets data are unavailable.

No Avalanche(NHL) data is currently used.

### Denver Health Paramedics call volumes
Provided by Steve Hulac. **Put link to code here** Unfortunately access to locations (for any geospatial analysis) and response times was unable to be obtained.

## _Exploratory Analysis_

### Summary Statistics

## _Modeling_

### GOF

### Model Selection
