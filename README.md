# Denver Health Paramedics Call Volumes
This is a collection of files and the final data set used for a collaborative project analyzing the 911 call volumes of the Denver Health Paramedic Division using R statistical software.  All code in this repository written by myself unless otherwise noted.

- Project write up as [PDF](4290_project_paper.pdf) or [google docs](https://docs.google.com/document/d/1LJyybxZWOSdklGorLDOCAo2dna9N-69BUY3RhuEw31k/edit#heading=h.o6pbv0p4cgu9) online.
- The slides for presentation can be viewed as [google slides](https://docs.google.com/presentation/d/1LP_FYMX9VJ-Oj_LOLcNiBZ4EOkV0bjGEULO3EL_9HI4/edit#slide=id.g59b92fdf11_1_0).

[![projectpdf](Buttons/button_pdf.png)](4290_project_paper.pdf)  [![slides](Buttons/google_slides.png)](https://docs.google.com/presentation/d/1LP_FYMX9VJ-Oj_LOLcNiBZ4EOkV0bjGEULO3EL_9HI4/edit#slide=id.g59b92fdf11_1_0)

**Website**: https://chriselarson.github.io/DenverEMS_rmd/ <br>
Expansion of data analysis not included in the original project.  Additional code examples and write up.  Project data is used, further development planned.

## Table of Contents
* [General info](#general-info)
* [Data Collection](#data-collection)
    - [Weather Data](#weather-data)
    - [Team Info](#team-info)
    - [Denver Health Paramedics Call Volumes](#denver-health-paramedics-call-volumes)
* [Data Preparation](#data-preparation)
    - [Merging and missing values](#merging-and-missing-values)
    - [Data Formatting](#data-formatting)
* [Downloadable Data Set](#final-data-set)
* [Modeling and Analysis](#modeling-and-analysis)
    - [Volume Analysis](#volume-analysis)
    - [Model selection](#model-selection)
* [R Packages](#r-packages)

## General Info
---
Analysis of 911 call volumes by hour for the Denver Health Paramedics.  The only data available from the Denver Health Paramedics was a list of number of calls per each hour of the day from the years 2002 - 2018.  We decided to use the years 2011-2018 for analysis. Partial data from 2019 is also available. For this project we want to analyize the volume of calls to help acurately set minimum staffing levels. The Denver Health Paramedic Division currently uses 10 hour shifts with staggered start times throughout the day, unfortunately without access to actual times (i.e. how long does a call take on average) a proper staffing recommendation will be difficult, however call volumes can still be evaluated.  Further, we want to see if local professional sports teams home games or weather variations; temperature and precipitation, have any predictive power in the number of 911 calls in a given hour.

## Data Collection
---
Data was gathered from various websites and the computer aided dispatch (CAD) system from the Denver Health Paramedics. No access to some of the original, pre-cleaned data; however the code used for gathering and cleaning the data is provided where available.

### Weather Data
Temperature data was taken from the [National Oceanic and Atmospheric Administration](https://www.ncei.noaa.gov/).  The weather recordings for temperature and precipitation at the Denver International Airport station were used.

[![weather](Buttons/button_r-code.png)](Weather_data.R) provided by Steve Hulac.

### Team Info
The data for Broncos(NFL) and Rockies(MLB) games was taken from www.pro-football-reference.com and www.baseball-reference.com respectively.  The actual start times were available for NFL games.  For MLB games they were simply broken into a day/night category.

The data for Nuggets(NBA) home games was gathered by Jephte Guerrier and received from Kroenke Sports. The methods used for the creation of the Nuggets data are unavailable.

No Avalanche(NHL) data is currently used.

For athletic events we used from one hour before until three hours after a home game as our timeline.  This was in an attempt to capture any pre and post game festivites that could potentially lead to an increase in 911 calls and to help account for any potential influx of population during the event.

[![teams](Buttons/button_r-code.png)](https://github.com/ChrisELarson/DenverEMS/blob/master/TeamData.R)

### Denver Health Paramedics call volumes
CAD data from the Denver Health Paramedic Division. The data was collected as a sum of 911 calls in the city of Denver within an hour period. Unfortunately access to locations (for any geospatial analysis) or response times were unable to be obtained.

[![cad](Buttons/button_r-code.png)](CAD_data_pull.R) provided by Steve Hulac

## Data Preparation
---
### Merging and missing values
All the data was combined into a single data set.  After merging the data there were 402 missing values, all within the temperature and precipitation columns.  To deal with missing precipitation values we found it reasonable to use the last value carried forward. I.E. if there was rain the previous hour, the missing hour will be coded with precipitation.  For temperature, linear interpolation([Wiki](https://en.wikipedia.org/wiki/Linear_interpolation)) was used.  

- Combining the data sets, provided by Steve Hulac.<br>[![merge](Buttons/button_r-code.png)](merging_data.R) 
- Imputing missing values.<br>[![impute](Buttons/button_r-code.png)](missing_values.R)

### Data Formatting
An .Rdata file was created from the combined CSV file for this data set.  Variables were changed to proper types for further analysis with more conventional naming of the factors.

-  Creating a formatted data set.<br>[![df](Buttons/button_r-code.png)](data_frame_creation.R)

#### Final Data Set
Downloadable in `CSV` or `.Rdata`<br>
[![csv](Buttons/csv_button.png)](all_variables.csv)  [![rdata](Buttons/button_rdata.png)](call_data.Rdata)

## Modeling and Analysis
---
This section includes links to files used for the development and selection of a predictive model.  Many of these files were shared between collaborators as `.html` files, mostly written using `Rmarkdown`. They are hopefully somewhat representative of our thought proccess and journey through this project. The original files are uploaded where available as `markdown` documents for viewing in github. Links to the original `.Rmd` file provided where available.  Where the original source files are unavailable they are converted here to `PDF` files for easier visualization in github. 

### Volume Analysis
- Volume and temperature analysis, authored by Steve Hulac.<br>
[![explore](Buttons/pdf_button.png)](Call_Volume_Data_Exploration.pdf)
- Further analysis being developed for [website](https://chriselarson.github.io/DenverEMS_rmd/) deployment.
### __Model Selection__
As we were using count data our focus was on discrete distributions, namely poisson and negative binomial. Maniuplating the available data in order to find a good fitting model proved to be a challenge.  Numerous models and distributions were explored before concluding a negative binomial model would fit our data best.  We achieved good fitting models with both poisson and negative binomial models, however the negative binomial allowed us to keep all of the outliers in the analysis.  As a group we decided that keeping as many data points in the model as possible was preferable.<br>

- Intial goodness of fit tests for negative binomial and poisson, explored graphically. Authored by Steve Hulac.<br>
[![fit](Buttons/pdf_button.png)](fitting_volume_frequency.pdf)
- More goodness of fit tests with outlier filtering, authored by Steve Hulac.<br>
[![fit1](Buttons/pdf_button.png)](Goodness_of_fit_tests.pdf)
- Initial modeling attempts, no goodness of fit found.  Poisson, Quasi-poisson, Negative Binomial on unfiltered data.<br>
[![gof](Buttons/button_md.png)](GOF.md)  [![gof2](Buttons/button_rmd.png)](GOF.Rmd)
- Goodness of fit acheived with a poisson model using truncated data.<br>
[![poisson](Buttons/button_md.png)](poisson.md)  [![poisson1](Buttons/button_rmd.png)](poisson.Rmd)
- Clues leading towards negative binomial model selection. Density graphs.  Outliers examined, created data set containing only outliers.<br>
[![try](Buttons/button_md.png)](trying.md)  [![try1](Buttons/button_rmd.png)](trying.Rmd)

#### Cross Validation and Final Model
- Initial cross validation and data filtering exploring possible models.<br>
[![cross](Buttons/button_md.png)](34minus.md) [![cross1](Buttons/button_rmd.png)](34minus.Rmd)
- Building the final model used.  Cross Validation, Stepwise selection,  Confidence Intervals and Incident Rate Ratios are included.  The majority of the output for this code is included in the [final write up](4290_project_paper.pdf) and/or the [slides](https://docs.google.com/presentation/d/1LP_FYMX9VJ-Oj_LOLcNiBZ4EOkV0bjGEULO3EL_9HI4/edit#slide=id.g59b92fdf11_1_0) for presentation.<br>
[![final](Buttons/button_r-code.png)](finalproject.R)

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
