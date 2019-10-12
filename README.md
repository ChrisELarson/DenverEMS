# Denver Paramedics Call Volumes
This is a collection of files and data sets used for a collaborative project analyzing the 911 call volumes of the Denver Health Paramedic Division using R statistical software.  All code in this repository written by myself unless otherwise noted.

### Website
https://chriselarson.github.io/DenverEMS_rmd/ <br>
**_Under Construction_** with more visually appealing analysis and code examples using rmarkdown files

## _Table of Contents_
* [General info](#general-info)
* [R Packages](#r-packages)
* [Data Collection](#data-collection)
    - [Weather Data](#weather-data)
    - [Team Info](#team-info)
    - [Denver Health Paramedics Call Volumes](#denver-health-paramedics-call-volumes)
* [Data Preparation](#data-preparation)
    - [Merging and missing values](#merging-and-missing-values)
    - [Data Formatting](#formatting-the-data)
* [Downloadable Data Set](#formatting-the-data)
* [Modeling](#modeling)
    - [GOF](#gof)
    - [Model selection](#model-selection)

## _General Info_
Analysis of 911 call volumes by hour for Denver Health Paramedics.  The only data available from the Denver Health Paramedics was a list of number of calls per each hour of the day from the years 2002 - 2018.  We decided to use the years 2011-2018 for analysis.  Partial data for the beginning months of 2019 are used for testing.(not sure I like this bit) For this project we want to analyize the volume of calls to help acurately set minimum staffing levels. The Denver Health Paramedic Division currently uses 10 hour shifts with staggered start times throughout the day, unfortunately without access to actual times (i.e. how long does a call take on average) a proper staffing recommendation will be difficult.  Further, we want to see if local professional sports teams home games or weather variations; temperature and precipitation, have any predictive power in the number of 911 calls in a given hour.

## _R Packages_
Project created in R with the following packages:
* tidyverse
* ggplot2
* plotly
* lubridate  
* MASS
* data.table
* odbc
* Janitor


## _Data Collection_
[Here](all_variables.csv) is the final data set used for this project in CSV format.  No access to some of the original, pre-cleaned data; however the code used for gathering and cleaning provided where available.  Some variables in the data set were exploratory in nature and not used in any analysis.

### Weather Data
Temperature data was taken from the [National Oceanic and Atmospheric Administration](https://www.ncei.noaa.gov/).  The weather recordings for temperature and precipitation at the Denver International Airport station were used. [Code](Weather_data.R) provided by Steve Hulac.  

### Team Info
The data for Broncos(NFL) and Rockies(MLB) games was taken from www.pro-football-reference.com and www.baseball-reference.com respectively.  The code used to gather the data can be found [here](https://github.com/ChrisELarson/DenverEMS/blob/master/TeamData.R).  The actual start times were available for NFL games.  For MLB games they were simply broken into a day/night category.

The data for Nuggets(NBA) home games was gathered by Jephte Guerrier and received from Kroenke Sports. The methods used for the creation of the Nuggets data are unavailable.

No Avalanche(NHL) data is currently used.

For athletic events we used from one hour before until three hours after a home game as our timeline.  This was in an attempt to capture any pre and post game festivites that could potentially lead to an increase in 911 calls and to help account for any potential influx of population during the event.

### Denver Health Paramedics call volumes
[Code](CAD_data_pull.R) for obtaining call volumes provided by Steve Hulac via the Denver Health Paramedic Division. Unfortunately access to locations (for any geospatial analysis) and response times were unable to be obtained.

## _Data Preparation_
### Merging and missing values
[Here](merging_data.R) is the code for compiling the various sources into one file, saved as a CSV.  After merging the data there were 402 missing values, all within the temperature and precipitation columns.  To deal with missing precipitation values we found it reasonable to use the last value carried forward. I.E. if there was rain the previous hour, the missing hour will be coded with precipitation.  For temperature, linear interpolation([Wiki](https://en.wikipedia.org/wiki/Linear_interpolation)) was used.  Code for imputing the missing values can be found [here](missing_values.R).

### Formatting the data
An .Rdata file was created from the combined CSV for this data set.  It can be downloaded [here](call_data.Rdata).  Variables were changed to proper types for further analysis with more conventional naming of the factors.  This [link](data_frame_creation.R) is for the code written to create the data frame.

#### Final Data Set: Downloadable in *[CSV](all_variables.csv)* or *[.RData](call_data.Rdata)* format

## _Modeling_
This section will include links to files used for the development and selection of a predictive model

### GOF

### Model Selection
