# R file for realtor web scrapy project

library(ggplot2)
library(dplyr)
library(mgcv)
library(dygraphs)

#----------------------------------------- Preprocessing ----------------------------------

# import csv file and correct the data type
dataset = read.csv('file_all_single_corrected.csv', stringsAsFactors = F)
dataset = dataset[ , -1]

# data type conversion
dataset$propertyType = as.factor(dataset$propertyType)
dataset$county = as.factor(dataset$county)
dataset$propertyid = as.character(dataset$propertyid)
dataset$zipcode = as.character(dataset$zipcode)
dataset$soldDate = as.Date(dataset$soldDate)

head(dataset)
# feature engineering


# save and load dataset
save(dataset, file='realtor_df.Rda')


#------------------------------------- Visualization ------------------------

# Data visualization -01 

# Data visualization -02 

# Data visualization -03 

# Data visualization -04 

# Data visualization -05 


# --------------------------------------------- Analysis ----------------------------

# Data analysis -01 

# Data analysis -02 

# Data analysis -03


# -------------------------------------------- Anotation -----------------------------