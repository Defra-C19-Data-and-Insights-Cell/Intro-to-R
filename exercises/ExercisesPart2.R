# Intro to R
# Homework following session 2


# Set up ------------------------------------------------------------------

# Load the necessary packages
library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(writexl)


# Exercises ---------------------------------------------------------------

# Exercise 1: 
# Load the data into r ("USITC beef 2017-2021 imports.xlsx")



# Solution:
USBeefTradeData <- read_xlsx("./data/USITC beef 2017-2021 imports.xlsx")



# Exercise 2:
# Can you do the following steps in one chunk of code, using pipes?
# 2a: remove the columns Special Import Program and Rate Provision Code
# 2b: filter to only observations from the countries Brazil, Canada, and Uruguay
# 2c: pivot the data longer
# 2d: remove "Year" from the values in the the year column created after pivoting the data 



# Solution:
USBeefTradeDataTidied <- USBeefTradeData %>%
  select(-c(`Special Import Program`, `Rate Provision Code`)) %>%
  filter(Country == "Brazil" | Country == "Canada" | Country == "Uruguay")  %>% # alternative: filter(Country %in% c("Brazil", "Canada", "Uruguay"))
  pivot_longer(cols = c(`Year 2017`, `Year 2018`, `Year 2019`, `Year 2020`, `Year 2021`), names_to = "Year", values_to = "ImportQuantity") %>%
  mutate("Year" = str_remove(Year, "Year "))
  

  
# Exercise 3:  
# Using a combination of mutate and ifelse (or mutate and case_when)
  # create a new column called SouthAmerica with a value of TRUE if the country is in South America and FALSE if not



# Solution using ifelse:
USBeefTradeDataTidied <- USBeefTradeDataTidied %>%
  mutate("SouthAmerica" = ifelse(Country %in% c("Brazil", "Uruguay"), TRUE, FALSE))

# Solution using case_when:
USBeefTradeDataTidied <- USBeefTradeDataTidied %>%
  mutate("SouthAmerica" = case_when (
    Country %in% c("Brazil", "Uruguay") ~ TRUE, 
    Country == "Canada" ~ FALSE))



# Exercise 4:
# Load the population data into R ("Populations.xlsx")



# Solution: 
Populations <- read_xlsx("./data/Populations.xlsx")



# Exercise 5:
# Add the population data to the trade dataframe through a join



# Solution: 
USBeefTradeDataTidied <- USBeefTradeDataTidied %>%
  left_join(Populations, by = "Country")



# Exercise 6:
# Create a line graph to look at the quantity of imports per country over time
# Hint: you will need to include the line 'stat_summary(fun=sum, geom="line")' to ensure that the total sum of import quantity per country is used
# Remember to include axis labels



# Solution:
ImportTimeSeriesPlot <- ggplot(data = USBeefTradeDataTidied, aes(x = Year, y = ImportQuantity, group = Country, colour = Country)) +
  stat_summary(fun=sum, geom="line") +
  theme_minimal() +
  labs(x="Year", y="US beef imports (kg)") 

ImportTimeSeriesPlot



# Exercise 7:
# 7a: export the plot
# 7b: export the tidied trade dataframe



# Solutions:
ggsave(filename = "ImportTimeSeries.png", plot = ImportTimeSeriesPlot, width = 15, height = 12, unit = "cm", bg="white")

write_xlsx(USBeefTradeDataTidied, "USBeefImportsByCountry20172021.xlsx")


  