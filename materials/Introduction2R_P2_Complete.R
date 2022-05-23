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
ESG_data <- readxl::read_xlsx("./data/ESG_data.xslx") %>% # take the arable data set, then do...
  janitor::clean_names() 

## Tidy the ESG data - clean names > filter for Indonesia, Thailand, United Kingdom > filter for "Agriculture, forestry, and fishing, value added (% of GDP)"
##                     remove columns using select > pivot longer
ESG_tidy <- ESG_data %>% 
  dplyr::filter(country_name == "Indonesia" | country_name == "Thailand" | country_name == "United Kingdom") %>% 
  dplyr::filter(indicator_name == "Agriculture, forestry, and fishing, value added (% of GDP)") %>% 
  dplyr::select(-c(x2050, x67)) %>% 
  tidyr::pivot_longer(cols = c(x1960:x2020), names_to = "year", values_to = "agri_forest_fishing_percent_GDP")

## Clean the data to remove x in year column and change data type
ESG_clean <- ESG_tidy %>% 
  dplyr::mutate(year = as.numeric(stringr::str_remove(year, "x"))) %>% 
  dplyr::select(-c(indicator_name, indicator_code))



#### ~~~~~~~~~~~~~~~~~~~~~~ 2.2 COMBINING DATAFRAMES ~~~~~~~~~~~~~~~~~~~~ ####

## We have some additional ESG data which gives us emissions for all countries. We want to include this in our dataset.

ESG_emissions <- readxl::read_xlsx("./data/ESG_C02_emissions.xlsx")


## Now we want to join the two data sets
## we will create a new dataset, with a new column for prices using the left_join() function from dplyr
ESG_clean
ESG_emissions

?left_join() # joins add columns from y to x, matching rows based on keys

## We will have to join by all columns that match
ESG_and_emissions <- dplyr::left_join(ESG_clean, ESG_emissions, by = c("country_code", "year", "country_name"))



#### ~~~~~~~~~~~~~~~~~~~~~~ 2.3 IF/IF ELSE ~~~~~~~~~~~~~~~~~~~~ ####

## Very useful in R, a lot of real world examples, also a couple of different ways to do it...

## Example of how an if statement works

x <- -4

if(x > 0){
  print("Positive Number")
} else {
  print("Negative Number")
}


## However if we try to run an if statement on a list we will get an error.
## This is because the if function cannot assess lists, only single queries.
x <- c(5,4,-3,-2)

if(x > 0){
  print("Positive Number")
} else {
  print("Negative Number")
}

## to get around this we can use the function ifelse...
ifelse(x > 0, "Positive Number", "Negative Nunber") 

## Real world example to assign countries their Region in our dataset
## Lets categorize our countries into continents by creating a new column, we can use a function ifelse

ESG_and_emissions$continent <- ifelse(ESG_and_emissions$country_name == "United Kingdom", "Europe", "Asia")
ESG_and_emissions

## We can do this in the tidyverse as well using case_when and mutate

ESG <- ESG_and_emissions %>% 
  dplyr::mutate(
    continent = dplyr::case_when(
      country_name == "United Kingdom" ~ "Europe",
      country_name != "United Kingdom" ~ "Asia"
    )
  )


#### ~~~~~~~~~~~~~~~~~~~~~~ 2.4 EXPORTING DATA ~~~~~~~~~~~~~~~~~~~~~ ####

## We can write dataframe to many outputs, commonly we use R.Data files, or .csv/.xlsx
## To save as csv we need to identify the package (search google or look at installed packages)
## This will save the file to our working directory...

write.csv(ESG, file = "ESG_clean.csv") # need to include file extension




#### ~~~~~~~~~~~~~~~~~~~~~~~ 2.5 PLOTTING ~~~~~~~~~~~~~~~~~~~~~ ####

## Lets create a simple plot using ggplot
?ggplot

## we can create a simple line graph using ggplot to look at change over time

esg_line_plot <- ggplot2::ggplot(
  data = ESG,
  ggplot2::aes(x = year, y = agri_forest_fishing_percent_GDP, group = country_name, colour = country_name)) + 
  ggplot2::geom_line()

esg_line_plot

## or we could quickly create a new dataset to compare current year proportion of GDP from agri+forestry+fishing

ESG_current <- ESG %>% 
  dplyr::filter(year == 2019)

esg_bar_plot <- ggplot2::ggplot(data = ESG_current, 
                                ggplot2::aes(x = country_name, y = agri_forest_fishing_percent_GDP/100, fill = country_name)) + 
  ggplot2::geom_bar(stat="identity") 
  

esg_bar_plot




## Editing plots
# Lets create our own colour blind palette
cbbPalette <- c("#009E73", "#E69F00", "#56B4E9", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

## Lets relabel some axis and change the colours
esg_bar_plot2 <- esg_bar_plot +
  ggplot2::labs(x = "Country",
                y = "GDP which is agri/forestry/fishing") + 
  ggplot2::expand_limits(y=c(0,0.5)) +
  ggplot2::scale_fill_manual(values=cbbPalette) +
  ggplot2::theme_minimal() +
  ggplot2::theme(legend.position = "none",
                 panel.grid.major = ggplot2::element_blank(),
                 panel.grid.minor = ggplot2::element_blank(),
                 axis.text.x = ggplot2::element_text(size = 12),
                 axis.text.y = ggplot2::element_text(size = 12),
                 axis.title.x = ggplot2::element_text(size = 13),
                 axis.title.y = ggplot2::element_text(size = 13)) +
  ggplot2::scale_y_continuous(labels = scales::percent)

esg_bar_plot2


## Then we can save
ggplot2::ggsave(filename = "esg_final_plot.png", plot = esg_bar_plot2, width = 15, height = 12, unit = "cm")



