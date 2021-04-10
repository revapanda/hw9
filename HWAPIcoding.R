# Homework APIcoding 
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidycensus)

#1) Show and use a census API key that gives you access to the ACS data. Do not use my API key, use and show
#your own key.
census_api_key("597670248f949034ea581cf127bf73a80371656a")
install = TRUE
#2) Using ACS census data from 2015, show and use R code to do the following:
  #a) Produce a tibble that shows the median income estimates and the margin of errors for white males in the
#counties of California. The required variable code starts with the characters BO1OO1. Use the table to find the
#other characters.
v15 <- load_variables(2015, "acs5", cache = TRUE)

View(v15)

CA <- get_acs(geography = "county", 
              variables = c(medincome = "B01001A_011"), 
              state = "CA", 
              year = 2015)

CA
#b ) Use a dplyr functions to change your table of part a so that it 
#reflects estimates that are greater than $30,00 dollars and list the estimates in descending order.
CA%>%
  filter(estimate>30000)%>%
  arrange(desc(estimate))
#c Using the tibble that you produced in part b, use and show R code that will show the county that has a median income estimate of 
#51644 and a margin of error of 667.
CA%>%
  filter(estimate>30000)%>%
  arrange(desc(estimate)) -> CA1
CA1 
CA1 %>%
  filter( estimate==51644)%>%
  filter(moe == 667)
#d Use and show ggplot coding that will produce the following boxplot for the data 
#that you generated for part b.
ggplot(data = CA1) + 
  geom_boxplot(mapping = aes(x = estimate), fill="red")

# e 
CA1 %>%
  mutate(NAME = gsub(" County, California", "", NAME)) %>%
  ggplot(aes(x = estimate, y = reorder(NAME, estimate))) +
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe)) +
  geom_point(color = "blue", size = 3) +
  labs(title = "Median Income for White Males by County",
       subtitle = "2014-2018 American Community Survey",
       y = "",
       x = "ACS estimate (bars represent margin of error)")





