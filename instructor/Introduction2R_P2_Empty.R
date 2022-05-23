## Intro to R
## Date: 08/02/2021
## Author: Alex Mitchell

####~~~~~~~~~~~~~ Project Brief ~~~~~~~~~~~~~~####
## We have been tasked to compare the performance of and ESG indicator, "Agriculture, forestry, and fishing, value added (% of GDP)",
## between chosen countries, Thailand, Indonesia, and the United Kingdom. We also need to graphically present our results over time
## and for the most recent year.


####~~~~~~~~~~~~~ Loading data ~~~~~~~~~~~~~~####
## SessionInfo() can show us all of the packages that we have currently loaded into our environment
install.packages("ggplot2")
install.packages("readxl")
install.packages("writexl")

## Load packages into the environment so we can use the functions within them
library(magrittr)


####~~~~~~~~~~~~~~~~~~~~~~~~DATA CLEANING WITH %>% ~~~~~~~~~~~~~~~~~~~~~~####

## Lets experiment with the %>% operator
## %>% effectively means "then do this to that object"
## Try with loading data and clean_names()

ESG_data <- readxl::read_xlsx("ESG_data.xslx") %>% 
  janitor::clean_names()

## Tidy the ESG data - clean names > filter for Indonesia, United Kingdom and Thailand > filter for "Agriculture, forestry, and fishing, value added (% of GDP)"
##                      remove columns using select > pivot longer

ESG_tidy <- ESG_data %>% 
  dplyr::filter(country_name %in% c("Indonesia", "Thailand", "United Kingdom") & 
                                    indicator_name == "Agriculture, forestry, and fishing, value added (% of GDP)") %>% 
  dplyr::select(-c(x2050, x67)) %>% 
  tidyr::pivot_longer(cols = c(x1960:x2020), names_to = "year", values_to = "ag_for_fish_perc_gdp")


## Clean the data to remove x in year column and change data type
ESG_clean <- ESG_tidy %>% 
  dplyr::mutate(year = as.numeric(stringr::str_remove(year, "[[:alpha:]]")))


####~~~~~~~~~~~~~~~~~~~~~~~~COMBINING DATAFRAMES~~~~~~~~~~~~~~~~~~~~~~####

## We have some additional ESG data which gives us emissions for all countries. We want to include this in our dataset.

ESG_emmissions <- readxl::read_xlsx("ESG_C02_emissions.xlsx")

## We will have to join by all columns that match

ESG_and_emissions <- dplyr::left_join(ESG_clean, ESG_emmissions, by = c("country_code", "year", "country_name"))

####~~~~~~~~~~~~~~~~~~~~~~~~IF/IF ELSE~~~~~~~~~~~~~~~~~~~~~~####

## Very useful in R, a lot of real world examples, also a couple of different ways to do it...
x <- -5

if(selection == "ag"){
  make a graph of ag
} else {
  make a graph of lulucf
}

x <- c(-5, 5, 3,-2)

if(x < 0){
  print("negative")
} else {
  print("positive")
}


## However if we try to run an if statement on a list we will get an error.
## This is because the if function cannot assess lists, only single queries.

## to get around this we can use the function ifelse...
ifelse(x < 0, print("negative"), print("positive"))

## Real world example to assign countries their Region in our dataset
## Lets categorize our countries into continents by creating a new column, we can use a function ifelse

ESG_and_emissions$continent <- ifelse(ESG_and_emissions$country_name == "United Kingdom", "Europe", "Asia")

ESG <- ESG_and_emissions %>% 
  dplyr::mutate(
    continent = dplyr::case_when(
      country_name == "United Kingdom" ~ "Europe",
      country_name != "United Kingdom" ~ "Asia"
    )
  )



####~~~~~~~~~~~~~~~~~~~~~~~~ EXPORTING DATA ~~~~~~~~~~~~~~~~~~~~~~####

## We can write dataframe to many outputs, commonly we use R.Data files, or .csv/.xlsx
## To save as csv we need to identify the package (search google or look at installed packages)
## This will save the file to our working directory...


writexl::write_xlsx(ESG, "ESG_export.xlsx")



####~~~~~~~~~~~~~~~~~~~~~~~~ PLOTTING ~~~~~~~~~~~~~~~~~~~~~~####

## Lets create a simple plot using ggplot

?ggplot

## we can create a simple line graph using ggplot to look at change over time

esg_line_plot <- ggplot2::ggplot(
  data = ESG,
  ggplot2::aes(x = year, 
               y = ag_for_fish_perc_gdp, 
               group = country_name, 
               colour = country_name)) +
  ggplot2::geom_line()

esg_line_plot

## or we could quickly create a new dataset to compare current year proportion of GDP from agri+forestry+fishing

ESG_current_bar <- ESG %>% 
  dplyr::filter(year == 2019) %>% 
  ggplot2::ggplot(data = .,
                  ggplot2::aes(x = country_name, 
                               y = ag_for_fish_perc_gdp)) +
  ggplot2::geom_bar(stat = "identity")




## Editing plots
# Lets create our own colour blind palette
cbbPalette <- c("#009E73", "#E69F00", "#56B4E9", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

## Lets relabel some axis and change the colours
esg_bar_plot2 <- ESG_current_bar +
  ggplot2::labs(x = "",
                y = "% of GDP which is agri/forestry/fishing") + 
  ggplot2::expand_limits(y=c(0,0.5)) +
  ggplot2::scale_fill_manual(values=cbbPalette) +
  ggplot2::theme_minimal() +
  ggplot2::theme(legend.position = "none",
                 panel.grid.major = ggplot2::element_blank(),
                 panel.grid.minor = ggplot2::element_blank(),
                 axis.text.x = ggplot2::element_text(size = 12),
                 axis.text.y = ggplot2::element_text(size = 12),
                 axis.title.x = ggplot2::element_text(size = 13),
                 axis.title.y = ggplot2::element_text(size = 13))

esg_bar_plot2

ggplot2::ggsave(filename = "esg_final_plot.png", plot = esg_bar_plot2, width = 15, height = 12, unit = "cm")

