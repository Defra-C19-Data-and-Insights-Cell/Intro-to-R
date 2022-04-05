## Intro to R
## Date: 02/02/2021
## Author: Alex Mitchell

##  ~~~~~~~~~~~~ Project Brief ~~~~~~~~~~~~ ##

## We have been tasked to compare the performance of ESG indicators, "People using safely managed drinking water services (% of population)"                                    
## and "People using safely managed sanitation services (% of population)" between chosen countries, Zimbabwe and Malawi.


####~~~~~~~~~~~~~ Loading data ~~~~~~~~~~~~~~####

### ~~~~~~ 1.1 - Load data and packages ~~~~~~ ####

## install packages
install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("janitor")

### which we can also do in a list
install.packages(c("readr", "dplyr", "tidyr"))

## Load packages into your environment
library(readr)
library(tidyverse)

## Load in data using readxl::read_xlsx().
## Remember, if your data is in other formats such as .csv we can use other packages, for example readr::read_csv
ESG_data <- readxl::read_xlsx("./ESG_data.xslx")


## Use janitor::clean_names to clean up our column names in our dataset, this should be a standard process
ESG_data <- janitor::clean_names(ESG_data)


### ~~~~~~ 1.2 - Explore data ~~~~~~ ####
## Use some different ways to look at your data, investigate your data. 

## Just use the object name
ESG_data

## Look at the top 5 rows
head(ESG_data, 5)

## Look at the top 20 rows
head(ESG_data, 20)

## Open data in a new window (xl spreadsheet like)
View(ESG_data)

## Shows a column wide view of data, notice the namespace loading the glimpse function from the pillar package
pillar::glimpse(ESG_data)

## Show column names in the order they appear in your data
colnames(ESG_data)

## If we want to view or select a particular column of a dataset we can use the $ operator to view that column.
ESG_data$country_name

## Another useful function is unique() which shows us unique values from columns
unique(ESG_data$country_name)


####~~~~~~~~~~~~~~~~~~~~~ WRANGLING DATA ~~~~~~~~~~~~~~~~~~~~~~~~####
### Getting data into a "tidy" format

### ~~~~~~ 1.3 - Deleting Rows and Columns ~~~~~~ ####

## Firstly we are going to standardise our column names using a function from the `janitor` package called `clean_names`. This converts all of our column names to lower case and any spaces to "_".

colnames(ESG_data) ## before

ESG_data <- janitor::clean_names(ESG_data) 

colnames(ESG_data) ## after

## delete rows
ESG_data_cleaning <- ESG_data[-1,] #square bracket = [row, column]
ESG_data_cleaning # view the data and we can see the first total row is gone
ESG_data_cleaning <- ESG_data[-c(1:67),] #square bracket = [row, column]

## delete cols
ESG_data_cleaning <- ESG_data[,-4]
ESG_data_cleaning # column 4 is deleted

## remove cols and rows in one step
ESG_data_cleaning <- ESG_data[-c(1:67), -4]

### These methods are useful to understand, but in the real world, and when using tidyverse we would normally filter to remove rows 
### use a function (select) to remove columns.
### For this example we are interested in comparing two countries, and two particular indicators, so lets get the data we need to filter our dataset.
### Countries = England and Switzerland
### Indicators = 	Forest area (% of land area).

## Filter country column first, call this variable ESG_filtered using the original data
ESG_filtered <- dplyr::filter(ESG_data, country_name == "United Kingdom" | country_name == "Netherlands") ## like in excel we can use the OR operator.
unique(ESG_filtered$country_name)

## Filter indicator column overwriting our previous ESG_filtered
ESG_filtered <- dplyr::filter(ESG_filtered, indicator_name == "Forest area (% of land area)") ## to write equals we use ==
unique(ESG_filtered$indicator_name)

## Now if we look at our column names there are two columns that we aren't interested in, I know this from experience of the data...
colnames(ESG_filtered)

## There is a "x67" column and a "x2050" which aren't useful to us in this dataset, so we will get rid of them. We will use -c here to denote we want to select everything BUT the columns listed.

ESG_filtered <- dplyr::select(ESG_filtered, -c(x2050, x67))

colnames(ESG_filtered)

### ~~~~~~ 1.4 - PIVOT DATA ~~~~~~ ####

## We can check how to use a function by viewing the help page
help(pivot_longer)
?pivot_longer

## User pivot_longer() - values_to = "land_area"
ESG_tidy <- tidyr::pivot_longer(ESG_filtered, cols = c(x1960:ncol(ESG_filtered)), names_to = "year", values_to = "land_area")


####~~~~~~~~~~~~~ 1.5 - CLEANING DATA ~~~~~~~~~~~~~~####
### Now our data is in a tidy format we want to clean any columns (or variables) to ensure we have values ready to be presented.
### Our case with this data we could clean the Indicator name, filter out any NAs, and make sure we ahve all the correct variable types. 

## Filter out the NAs
ESG_clean <- dplyr::filter(ESG_tidy, is.na(ESG_tidy$land_area) == F)

## Clean the year column to remove x
ESG_clean_year_example <- stringr::str_remove_all(ESG_clean$year, "x")

## Another likely better way to do this is to only keep the numeric characters in a string using a REGEX expression
ESG_clean$year <- stringr::str_extract(ESG_clean$year, "[[:digit:]]*$")

## Change the data types as we can see Year is a character type, rather than a numeric type
ESG_clean$year <- as.numeric(ESG_clean$year)


### End of sessions 1! ###

### A taster of next week....

####~~~~~~~~~~~~~ Plotting data ~~~~~~~~~~~~~~####

## Install ggplot2
install.packages(ggplot2)


## Create a line graph of land_area vs year colored by country
ggplot2::ggplot(ESG_clean, ggplot2::aes(x = year, y = land_area, color = country_name)) +
  ggplot2::geom_point() +
  ggplot2::geom_line()

####~~~~~~~~~~~~~ Alternative Script... ~~~~~~~~~~~~~~####
## Combine all of the above into a succinct cleaning script and create the plot

library(magrittr)

ESG_data <- readxl::read_xlsx("./ESGData.xslx") %>%
  janitor::clean_names() %>%
  dplyr::select(-c(x2050, x67)) %>%
  dplyr::filter(country_name == "United Kingdom" | country_name == "Netherlands",
                indicator_name == "Forest area (% of land area)") %>%
  tidyr::pivot_longer(cols = c(x1960:ncol(.)), names_to = "year", values_to = "land_area")

ESG_clean <- ESG_data %>%
  dplyr::filter(is.na(land_area) == F) %>% 
  dplyr::mutate(year = as.numeric(stringr::str_remove_all(year, "x")))
  
ggplot2::ggplot(ESG_clean, ggplot2::aes(x = year, y = land_area, color = country_name)) +
  ggplot2::geom_point() +
  ggplot2::geom_line()


