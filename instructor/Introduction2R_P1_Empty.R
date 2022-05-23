## Intro to R
## Date: 02/02/2021
## Author: Alex Mitchell

##  ~~~~~~~~~~~~ Project Brief ~~~~~~~~~~~~ ##

## We have been tasked to compare the performance of ESG indicator, "Forest area (% of land area)", 
## between two chosen countries, the Netherlands and the United Kingdom.


####~~~~~~~~~~~~~ Loading data ~~~~~~~~~~~~~~####

### ~~~~~~ 1.1 - Load data and packages ~~~~~~ ####

## install packages

### which we can also do in a list

## Load packages into your environment

## Load in data using readxl::read_xlsx().
## Remember, if your data is in other formats such as .csv we can use other packages, for example readr::read_csv


####~~~~~~~~~~~~~~~~~~~~~ EXPLORE DATA ~~~~~~~~~~~~~~~~~~~~~~~~####
### ~~~~~~ 1.2 - View data ~~~~~~ ####
## Use some different ways to look at your data, investigate your data. 

## Just use the object name

## Look at the top 5 rows

## Look at the top 20 rows

## Open data in a new window (xl spreadsheet like)

## Shows a column wide view of data, notice the namespace loading the glimpse function from the pillar package

## Show column names in the order they appear in your data

## If we want to view or select a particular column of a dataset we can use the $ operator to view that column.

## Another useful function is unique() which shows us unique values from columns


####~~~~~~~~~~~~~~~~~~~~~ WRANGLING DATA ~~~~~~~~~~~~~~~~~~~~~~~~####
### Getting data into a "tidy" format

### ~~~~~~ 1.3 - Deleting Rows and Columns ~~~~~~ ####

## Firstly we are going to standardise our column names using a function from the `janitor` package called `clean_names`. 
## This converts all of our column names to lower case and any spaces to "_".




## delete rows

## delete cols

## remove cols and rows in one step

### These methods are useful to understand, but in the real world, and when using tidyverse we would normally filter to remove rows 
### use a function (select) to remove columns.
### For this example we are interested in comparing two countries, and two particular indicators, so lets get the data we need to filter our dataset.
### Countries = England and Switzerland
### Indicators = 	Forest area (% of land area).

## Filter country column first, call this variable ESG_filtered using the original data

## Filter indicator column overwriting our previous ESG_filtered

## Now if we look at our column names there are two columns that we aren't interested in, I know this from experience of the data...

## There is a "x67" column and a "x2050" which aren't useful to us in this dataset, so we will get rid of them. We will use -c here to denote we want to select everything BUT the columns listed.


### ~~~~~~ 1.4 - PIVOT DATA ~~~~~~ ####

## We can check how to use a function by viewing the help page

## User pivot_longer() - values_to = "land_area"

## Our data is now in what we call a "tidy" format, but we still need to clean it


####~~~~~~~~~~~~~ CLEANING DATA ~~~~~~~~~~~~~~####
### ~~~~~~ 1.5 - Removing / replacing values ~~~~~~ ####

### Now our data is in a tidy format we want to clean any columns (or variables) to ensure we have values ready to be presented.
### Our case with this data we could clean the Indicator name, filter out any NAs, and make sure we have all the correct variable types. 

## Filter out the NAs

## If we look at the year column we created earlier by pivoting, we can see it contains x's before the numerics.
## We want to get rid of these. There are two quick ways. 

## Clean the year column to remove x using str_remove

## Another likely better way to do this is to only keep the numeric characters in a string using a REGEX expression

### ~~~~~~ 1.6 - Data types ~~~~~~ ####

## Change the data types as we can see Year is a character type, rather than a numeric type


### End of sessions 1! ###

### A taster of next week....

####~~~~~~~~~~~~~ Plotting data ~~~~~~~~~~~~~~####

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


