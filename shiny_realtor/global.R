# =========================================================================
# Load libraries and scripts
# =========================================================================
library(shiny)
library(ggplot2, ggthemes)
library(scales)
library(dplyr)
library(plotly)

library(corrplot)

library(googleVis)
library(leaflet)

library(maps)

#source("data/parser.R")

# =========================================================================
# Load data from 'realtor_df.Rda'
# =========================================================================
load('data/realtor_df.Rda')
data = dataset %>% filter(soldPrice >= 200000 & soldPrice <=2000000)


# =========================================================================
# Load data from 'zipcode'
# ========================================================================= 
df_zipcode = read.csv('data/zip_codes_states.csv', colClasses = "character")
df_property = data %>% select(city, state, county, zipcode, soldPrice, propertyid)
# joinn two tables
df3 = merge(df_property, df_zipcode, by.x=c("city", "zipcode"), by.y=c("city", "zip_code"))
df3$latitude = as.numeric(df3$latitude)
df3$longitude = as.numeric(df3$longitude)


# =========================================================================
# ui.R variables
# =========================================================================

choices <- list(
    county = unique(data$county),
    property_type = unique(data$propertyType),
    city = sort(unique(data$city)),
    zipcode = sort(unique(data$zipcode))
    
)


# =========================================================================
# server.R variables and functions
# =========================================================================
CATEGORYCOLORS <- c("Men" = "#4393C3")