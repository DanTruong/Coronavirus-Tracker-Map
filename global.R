# Load requisite libraries
library(dplyr)
library(plyr)
library(tidyr)
library(tidyverse)
library(httr)
library(jsonlite)

# Uncomment lines 11-53 to update the COVID-19 dataset
#
# ## API Endpoint URL
# path <- "https://data.cdc.gov/resource/9mfq-cb36.json"
# 
# ## List of US States with abbreviations and central coordinates
# states <- read.csv("~/GitHub/Coronavirus-Tracker-Map/data/states.csv")
# 
# ## Data frame that will hold the daily cases (per state)
# covidCases <- data.frame(submission_date = character(),
#                          state = character(),
#                          cases = character()
# )
# 
# ## Iterate through the list of US States
# for(i in 1:length(states$state)) {
# 
#   ## Perform GET request on API Endpoint w/ State at index "i"
#   request <- GET(url = path, query = list(state = states$state[[i]]))
# 
#   ## Convert API request into UTF-8 encoded text
#   response <- content(request, as = "text", encoding = "UTF-8")
# 
#   ## Convert reponse from JSON format to data frame
#   df <- fromJSON(response, flatten = TRUE) %>% data.frame()
# 
#   ## Select only date, state and cases
#   df <- select(df, submission_date, state, cases = tot_cases)
# 
#   ## Add State cases to working data frame
#   covidCases <- rbind(covidCases, df)
# }
# 
# ## Convert date variable
# covidCases$date <- as.Date(covidCases$submission_date)
# covidCases <- subset(covidCases, select = -c(submission_date))
# 
# ## Add full State names and coordinates to data
# covidCases <- merge(covidCases, states, by="state")
# 
# ## Split coordinates into Latitude/Longitude
# covidCases <- covidCases %>% separate(coord, c("lat", "long"), ", ")
# 
# ## Save into CSV file
# write.csv(covidCases, "data/covidCases.csv")

## Read in dataset
covidCases <- read.csv("data/covidCases.csv")

## Convert coordinate variables into double
covidCases$lat <- as.double(covidCases$lat)
covidCases$long <- as.double(covidCases$long)

## Convert case variable into integer
covidCases$cases <- as.integer(covidCases$cases)

## Remove variable "X"
covidCases <- subset(covidCases, select = -c(X))

# Separate date into Month, Day and Year (Integer)
covidCases <- covidCases %>% separate(date, 
                                      sep = "-", 
                                      into = c("year", "month", "day"))
covidCases$month <- as.integer(covidCases$month)
covidCases$day <- as.integer(covidCases$day)
covidCases$year <- as.integer(covidCases$year)

## Aggregate coronavirus cases by sum of cases
covidCasesCons <- covidCases[-c(5)]
covidCasesCons <- aggregate(cases ~ ., covidCasesCons, sum)
