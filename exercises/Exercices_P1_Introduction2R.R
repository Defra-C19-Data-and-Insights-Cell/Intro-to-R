## 1.1 ~~~~~~~~~~~~ Load and Explore data ~~~~~~~~~~~~ ##

## Install packages "readr" and "tidyverse"
install.packages(c("readr", "tidyverse"))

## Load packages into your environment
library(readr)
library(tidyverse)


## Load the "june_survey_data.csv" data into the environment using the readr::read_csv package.
## call this variable "crops_data".
crops_data <- readr::read_csv("./exercises/june_survey_data.csv")

## View the data by running the variable, then with the "View" function, then with the "dplyr::glimpse" function.
crops_data
View(crops_data)
dplyr::glimpse(crops_data)

## show the help for the "head" function.
help(head)
?head

## use the head function to display only the top 5 rows of the data.
head(crops_data, 5)


## 1.2 ~~~~~~~~~~~~ Wrangle data ~~~~~~~~~~~~ ##

readr::read_csv("./exercises/june_survey_data_clean.csv")

## 1. Filter out year 2009 using dplyr::filter and the "not equal to" operator: !=
crops_filtered <- dplyr::filter(crops, Year != 2009)

## 2. Using the function tidyr::pivot_longer to pivot all columns other than "Crop"
##    names_to should be "Year", values_to should be "Area". Call this "Crops".

crops <- tidyr::pivot_longer(crops_data, -Crop, names_to = "Year", values_to = "Area")

## 3. There is a value within the "Year" column called "revised" which we want to replace with "2009"
##    Fill in the STRING, PATTERN, and REPLACEMENT in the below code which uses stringr::str_replace. 
##    Remember to use ?stringr::str_replace to check what you need to tell the function.

?stringr::str_replace()
crops_filtered$Year <- stringr::str_replace(crops_filtered$Year, "revised", "2009")

## 4. Run the below code, it shows we have strange values in the year column
unique(crops_filtered$Year)

##    We will get rid of these by only keeping numeric characters using the following code
crops_filtered$Year <- stringr::str_remove_all(crops_filtered$Year, "[[:punct:][:alpha:]]")

##    run the below code, it shows we have kept only numbers in our year column
unique(crops_filtered$Year)

##    Now using the as.numeric function change the "Year" column and "Area" column to numeric data types
crops_filtered$Year <- as.numeric(arable$Year) # Make year numeric
crops_filtered$Area <- as.numeric(arable$Area) # Make area numeric

## 5. Remove NAs using the na.omit function.
arable <- na.omit(arable)


## subsetting data
# similarly can use these: >, <, <=, ==, !=
arable_sub <- subset(arable, Year >= 2008) 

## filter for multiple values/catagories
crop_list <- c("wheat", "barley", "oilseed rape")
arable_sub <- filter(arable_sub, Crop %in% crop_list)
