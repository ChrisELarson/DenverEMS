# Denver Paramedics Call Volumes
This is a collection of files and data sets used for a collaborative project analyzing the 911 call volumes of the Denver Health Paramedic Division using R statistical software. All code in this repository written by myself unless otherwise noted.

- Write up for the project as [PDF](4290_project_paper.pdf) or [google docs](https://docs.google.com/document/d/1LJyybxZWOSdklGorLDOCAo2dna9N-69BUY3RhuEw31k/edit#heading=h.o6pbv0p4cgu9) online.
- The slides for presentation can be viewed [HERE](https://docs.google.com/presentation/d/1LP_FYMX9VJ-Oj_LOLcNiBZ4EOkV0bjGEULO3EL_9HI4/edit#slide=id.g59b92fdf11_1_0) as google slides.

[![slides](Buttons/button_google-slides (1).png)](https://docs.google.com/presentation/d/1LP_FYMX9VJ-Oj_LOLcNiBZ4EOkV0bjGEULO3EL_9HI4/edit#slide=id.g59b92fdf11_1_0)

### Website
https://chriselarson.github.io/DenverEMS_rmd/ <br>
**_Under Construction_** More analysis of the data from this project with further coding examples.

## Table of Contents
* [General info](#general-info)
* [Data Collection](#data-collection)
    - [Weather Data](#weather-data)
    - [Team Info](#team-info)
    - [Denver Health Paramedics Call Volumes](#denver-health-paramedics-call-volumes)
* [Data Preparation](#data-preparation)
    - [Merging and missing values](#merging-and-missing-values)
    - [Data Formatting](#formatting-the-data)
* [Downloadable Data Set](#formatting-the-data)
* [Modeling and Analysis](#modeling-and-analysis)
    - [Volume Analysis](#volume-analysis)
    - [Model selection](#model-selection)
* [R Packages](#r-packages)
## General Info
---
Analysis of 911 call volumes by hour for Denver Health Paramedics.  The only data available from the Denver Health Paramedics was a list of number of calls per each hour of the day from the years 2002 - 2018.  We decided to use the years 2011-2018 for analysis. Partial data from 2019 is also available. For this project we want to analyize the volume of calls to help acurately set minimum staffing levels. The Denver Health Paramedic Division currently uses 10 hour shifts with staggered start times throughout the day, unfortunately without access to actual times (i.e. how long does a call take on average) a proper staffing recommendation will be difficult, however  call volumes can still be evaluated.  Further, we want to see if local professional sports teams home games or weather variations; temperature and precipitation, have any predictive power in the number of 911 calls in a given hour.

## Data Collection
---
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

## Data Preparation
---
### Merging and missing values
[Here](merging_data.R) is the code for compiling the various sources into one file, saved as a CSV.  After merging the data there were 402 missing values, all within the temperature and precipitation columns.  To deal with missing precipitation values we found it reasonable to use the last value carried forward. I.E. if there was rain the previous hour, the missing hour will be coded with precipitation.  For temperature, linear interpolation([Wiki](https://en.wikipedia.org/wiki/Linear_interpolation)) was used.  Code for imputing the missing values can be found [here](missing_values.R).

### Data Formatting
An .Rdata file was created from the combined CSV for this data set.  It can be downloaded [here](call_data.Rdata).  Variables were changed to proper types for further analysis with more conventional naming of the factors.  This [link](data_frame_creation.R) is for the code written to create the data frame.

#### Final Data Set: Downloadable in *[CSV](all_variables.csv)* or *[.RData](call_data.Rdata)* format

## Modeling and Analysis
---
This section will include links to files used for the development and selection of a predictive model.  Many of these files were shared between collaborators as html files, mostly written using Rmarkdown. They are hopefully somewhat representative of our thought proccess and journey through this project. The original files are uploaded where available as markdown documents with links to the original `.Rmd`.  Where the original source files are unavailable they are converted here to PDF files for easier visualization in github. 

### Volume Analysis
- [File](Call_Volume_Data_Exploration.pdf) for volume and temperature analysis, authored by Steve Hulac
- Further analysis being developed for [website](https://chriselarson.github.io/DenverEMS_rmd/) deployment.
### Model Selection
As we were using count data our focus was on discrete distributions, namely poisson and negative binomial. Maniuplating the available data in order to find a good fitting model proved to be a challenge.  Numerous models and distributions were explored before concluding a negative binomial model would fit our data best.  We achieved good fitting models with both poisson and negative binomial models, however the negative binomial allowed us to keep all of the outliers in the analysis.  As a group we decided that keeping as many data points in the model as possible was preferable.<br>


- **_[File](fitting_volume_frequency.pdf)_**: some intial goodness of fit tests for negative binomial and poisson, explored graphically. Authored by Steve Hulac.
- __[File](Goodness_of_fit_tests.pdf)__: more goodness of fit tests with outlier filtering, authored by Steve Hulac.
- __[File](GOF.md)__: some initial modeling attempts, no goodness of fit found.  Poisson, Quasi-poisson, Negative Binomial on unfiltered data.  [.Rmd file](GOF.rmd)
- __[File](poisson.md)__: goodness of fit acheived with a poisson model using truncated data. [.Rmd file](poisson.rmd)
- __[File](trying.md)__: clues leading towards negative binomial model selection. Density graphs.  Outliers examined, created data set containing only outliers.  [.Rmd file](trying.rmd)

#### Cross Validation and Final Model
- __[File](34minus.md)__: some initial cross validation and data filtering exploring possible models
- __[File](finalproject.R)__: containing code for the final model.  Cross Validation, Stepwise selection,  Confidence Intervals and Incident Rate Ratios are included.  The majority of the output for this code is included in the [final write up](4290_project_paper.pdf) and/or the [slides](https://docs.google.com/presentation/d/1LP_FYMX9VJ-Oj_LOLcNiBZ4EOkV0bjGEULO3EL_9HI4/edit#slide=id.g59b92fdf11_1_0) for presentation.

### Further Development
Potential ideas include outlier analysis for patterns in high volume hours.  For example are there routinely increased call volumes on certain holidays?  Time series analysis.

## _R Packages_
Project created in R with the following packages:
* tidyverse: ggplot2, dplyr, tidyr, readr, purrr, tibble
* lubridate  
* MASS
* data.table
* odbc
* Janitor
* fitdistplus
* caret
