# Denver Paramedics call volumes

## Table of Contents
* [General info](#general-info)
* [Packages](#packages)
* [Data Gathering](#data-gathering)

## General Info
Analysis of 911 call volumes by hour for Denver Health Paramedics.  The only data available from the Denver Health Paramedics was a list of number of calls per each hour of the day from the years 2002 - 2018.  For this project we want to analyize the volume of calls to help acurately set minium staffing levels.  Further, we want to see if local professional sports teams home games or weather variations have any predictive power in the number of 911 calls in a given hour.

## Packages
Project created in R with the following packages:
* tidyverse
* ggplot2

## Data Gathering

### Weather Data
Temperature data was taken from the [National Oceanic and Atmospheric Administration](https://www.ncei.noaa.gov/).  The weather recordings for temperature and precipitation at the Denver International Airport station were used.   

### Team Info
The data for Broncos(NFL) and Rockies(MLB) games was taken from www.pro-football-refernce.com and www.baseball-reference.com respectively.  The code used to gather and clean the data can be found [here](https://github.com/ChrisELarson/DenverEMS/blob/master/TeamData.R).

The data for Nuggets(NBA) home games was gathered by a teammate and received from Kroenke Sports. The methods used for the creation of the Nuggets data are unavailable, however the source is trusted.

No Avalanche(NHL) data is currently used.