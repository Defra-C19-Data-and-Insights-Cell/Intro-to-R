## Let's load the data
arable_csv <- read_csv("june_survey_data_clean.csv")

## Now use our new package to load in some more data
arable_xls <- read_excel("june_survey_data_clean.xls")

## And again...
arable <- read_excel("june_survey_data_clean.xlsx", sheet = "june_survey_data_clean")

## taking it further, lets run arable to examine the dataset
arable # we can see that there is a column called ...1 which is simply row numbers, lets get rid of this using %>% 

arable_wheat_clean <- arable %>% 
  filter(Arable_crop == "wheat") %>% 
  select(-...1)

arable_wheat_clean # and by running our output, we can see a cleaner, filtered dataset


####~~~~~~~~~~~~~~~~~~~~~~~~Combining Dataframes~~~~~~~~~~~~~~~~~~~~~~####

## create a dataframe (df)

prices <- data.frame("Arable_crop" = c("wheat", "barley"), "Price" = c(3,5))
prices # well done on creating your first dataframe!

## Now we want to join the two data sets, first, lets have a look at them
## our aim here is to join all of the relevant data from prices, with the arable dataset
## we will create a new dataset, with a new column for prices using the left_join() function from dplyr
arable
prices

?left_join() # joins add columns from y to x, matching rows based on keys

arable_inc_prices <- left_join(arable, prices, by = "Arable_crop")


####~~~~~~~~~~~~~~~~~~~~~~~~Checking data types ~~~~~~~~~~~~~~~~~~~~~~####
## One method of checking datatypes
str(arable_inc_prices)

## Let's check the column AreaM
arable_inc_prices$AreaM

## And how it looks when we convert to a character
arable_inc_prices$AreaM <- as.character(arable_inc_prices$AreaM) # chr, or strings, shown within quotes

## Change back to numeric (as that is what it is)
arable_inc_prices$AreaM <- as.numeric(arable_inc_prices$AreaM)

####~~~~~~~~~~~~~~~~~~~~~~~~ IF Statements ~~~~~~~~~~~~~~~~~~~~~~####

## Very useful in R - IF a statement is true, do this

x <- 5

if (x > 0) {
  print("Positive Number")
}


## If Else - IF a statement is true, do this, ELSE, do that
x <- -5

if(x > 0){
  print("Positive Number")
} else {
  print("Negative Number")
}

## Lets see how we can apply if statements on our arable_inc_prices dataset

if(arable_inc_prices$Price[1] == 3){
  print("Match")
} else {
  print("No match")
}


if(arable_inc_prices$Price[13] == 5){
  print("Match")
} else {
  print("No match")
}


if (arable_inc_prices$Price[32] > 1) {
  print(arable_inc_prices$Price[32])
} else {
  print("Less than 1")
}


####~~~bonus FOR LOOPS~~~####

## lets create a list
l <- c(2,3,45,9,6,7,5,2,4,32)

for(i in l){ # for an element i in list l (i - although this could literally be any character or word...)
  if(i > 10){
    print("is greater than 10")
  } else
    print("i is less than 10")
}


####~~~~~~~~~~~~~~~~~~~~~~~~ Saving Dataframes ~~~~~~~~~~~~~~~~~~~~~~####

## We can write dataframe to many outputs, commonly we use R.Data files, or .csv/.xlsx
## To save as csv we need to identify the package (search google or look at installed packages)
## This will save the file to our working directory...

write.csv(arable_inc_prices, file = "arable_inc_prices.csv") # need to include file extension

## Save as excel file, but lets try stating the filepath to save it somewhere else outside our WD

write_xlsx(arable_inc_prices, path = "/cloud/project/arable_inc_prices.xslx")



####~~~~~~~~~~~~~~~~~~~~~~~~ Saving Dataframes ~~~~~~~~~~~~~~~~~~~~~~####

## Lets create a simple plot using ggplot
?ggplot

arable_p <- ggplot(arable, aes(x = Year, y = AreaM, group = Arable_crop, colour = Arable_crop)) + 
  geom_line() 

arable_p # take a look


## Editing plots
## we can create a colour blind palette for the plot
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

## now we can apply this to a custome colour palette and then apply it to the graph (in 2 ways)
arable_p2 <- arable_p +
  scale_colour_manual(values = cbPalette, name = "Crop type") + 
  xlab("Year") + ylab("Area (million ha)") + # many different ways to change axis labels
  expand_limits(y=c(0,2.3)) # change axis range from default, 0 - 2.3 million ha
arable_p2 # take a look


## we could also input the palette values directly into the plot code chunk
arable_p2 <- arable_p +
  scale_colour_manual(values = c("#999999", 
                                 "#E69F00", 
                                 "#56B4E9", 
                                 "#009E73", 
                                 "#F0E442", 
                                 "#0072B2", 
                                 "#D55E00", 
                                 "#CC79A7"), name = "Crop type") + 
  xlab("Year") + ylab("Area (million ha)") + # many different ways to change axis labels
  expand_limits(y=c(0,2.3)) # change axis range from default, 0 - 2.3 million ha
arable_p2 # take a look


## Themes
## Here we’re going to apply the theme_minimal which will remove the ugly grey background and also remove the gridlines.
arable_p3 <- arable_p2 + 
  theme_minimal() +
  theme(text = element_text(colour = "black"), # make text black
        panel.grid.major.x = element_blank(), # remove major gridlines on the x axis 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) # remove minor gridlines on the x axis
arable_p3


## Axes
## We will also want to make our x axis whole numbers.
## The below is a compound of the steps above into one plotting script

arable$Year <- ?as.factor(arable$Year) 

arable_final <- ggplot(arable, aes(x = Year, y = AreaM, group = Arable_crop, colour = Arable_crop)) + 
  geom_line() +
  scale_colour_manual(values = cbPalette, name = "Crop type") +
  labs(title="Crop areas in the UK 2008-2019",
       subtitle = "Area (million ha)") +
  xlab("") + ylab("")+ # make axis labels blank 
  expand_limits(y=c(0,2.3))+ scale_x_discrete(breaks = seq(2008, 2019, by = 2))+
  theme_minimal() +
  theme(text = element_text(colour = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank())

arable_final

## Then we can save
ggsave(filename = "arable_final_plot.png", plot = arable_final, width = 15, height = 12, unit = "cm")


