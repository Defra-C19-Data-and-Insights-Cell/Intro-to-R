## Intro to R
## Date: 08/02/2021
## Author: Alex Mitchell

####~~~~~~~~~~~~~ Project Brief ~~~~~~~~~~~~~~####
## We have been tasked to compare the performance of and ESG indicator, "Agriculture, forestry, and fishing, value added (% of GDP)",
## between chosen countries, Thailand, Indonesia, and the United Kingdom. We also need to graphically present our results over time
## and for the most recent year.


####~~~~~~~~~~~~~ Loading data ~~~~~~~~~~~~~~####

## We're going to need a couple extra packages
install.packages("ggplot2")
install.packages("readxl")
install.packages("writexl")

## Load packages into the environment so we can use the functions within them
library(readr)
library(readxl)
library(ggplot2)
library(writexl)
library(magrittr)

####  ~~~~~~~~~~~~~~~~~~~~ 2.1 DATA CLEANING WITH %>% ~~~~~~~~~~~~~~~~~~~~~ ####

## Lets experiment with the %>% operator
## %>% effectively means "then do this to that object"
## Try with loading data and clean_names()


## Tidy the ESG data - clean names > filter for Indonesia, Thailand, United Kingdom > filter for "Agriculture, forestry, and fishing, value added (% of GDP)"
##                     remove columns using select > pivot longer


## Clean the data to remove x in year column and change data type




#### ~~~~~~~~~~~~~~~~~~~~~~ 2.2 COMBINING DATAFRAMES ~~~~~~~~~~~~~~~~~~~~ ####

## We have some additional ESG data which gives us emissions for all countries. We want to include this in our dataset.




## Now we want to join the two data sets
## we will create a new dataset, with a new column for prices using the left_join() function from dplyr


## We will have to join by all columns that match




#### ~~~~~~~~~~~~~~~~~~~~~~ 2.3 IF/IF ELSE ~~~~~~~~~~~~~~~~~~~~ ####

## Very useful in R, a lot of real world examples, also a couple of different ways to do it...

## Example of how an if statement works




## However if we try to run an if statement on a list we will get an error.
## This is because the if function cannot assess lists, only single queries.

## to get around this we can use the function ifelse...

## Real world example to assign countries their Region in our dataset
## Lets categorize our countries into continents by creating a new column, we can use a function ifelse


## We can do this in the tidyverse as well using case_when and mutate



#### ~~~~~~~~~~~~~~~~~~~~~~ 2.4 EXPORTING DATA ~~~~~~~~~~~~~~~~~~~~~ ####

## We can write dataframe to many outputs, commonly we use R.Data files, or .csv/.xlsx
## To save as csv we need to identify the package (search google or look at installed packages)
## This will save the file to our working directory...





#### ~~~~~~~~~~~~~~~~~~~~~~~ 2.5 PLOTTING ~~~~~~~~~~~~~~~~~~~~~ ####

## Lets create a simple plot using ggplot
?ggplot

## we can create a simple line graph using ggplot to look at change over time


## or we could quickly create a new dataset to compare current year proportion of GDP from agri+forestry+fishing





## Editing plots
# Lets create our own colour blind palette

## Lets relabel some axis and change the colours


## Then we can save



