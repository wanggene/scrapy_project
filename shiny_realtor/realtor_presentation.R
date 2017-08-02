# R file for realtor web scrapy project
library(corrplot)
library(ggplot2)
library(dplyr)
library(mgcv)
library(dygraphs)
library(plotly)

# ================================================================================================
# Preprocessing 
# ================================================================================================

# import csv file and correct the data type
dataset = read.csv('file_all_single_corrected.csv', stringsAsFactors = F) # for sold file
dataset = read.csv('file_all_single_newrearch_corrected.csv', stringsAsFactors = F) 


# data type conversion
#dataset$propertyType[dataset$propertyType=='Condo/Townhome/Row Home/Co-Op'] ='Condo_Co-Op'
dataset$propertyType = as.factor(dataset$propertyType)

#dataset$county = as.factor(dataset$county)
dataset$propertyid = as.character(dataset$propertyid)
dataset$zipcode = as.character(dataset$zipcode)

dataset$soldDate = as.Date(dataset$soldDate, '%Y-%m-%d')
dataset$month = strftime(dataset$soldDate, "%m")

#filter wrong date row
dataset = dataset %>% filter(soldDate > '2017-01-01' & soldDate < '2017-08-01')
                                

#head(dataset)

# ================================================================================================
# Save and load data
# ================================================================================================

# save and load dataset
# save(dataset, file='realtor_new_list_df.Rda')

# !diagnostics off
# load dataset for sold property
load('realtor_df.Rda')
data = dataset %>% filter(soldPrice >= 200000 & soldPrice <=2000000)

# load dataset for new listing property
#load('realtor_new_list_df.Rda')
#data = dataset

# ================================================================================================
# Visualization
# ================================================================================================

### 1 Explore the total sold property number by time, county, type, city, zipcode
### 1.1 Number of sold properties by Month

    # Data
    g1 = ggplot(data, aes(x = month))

    # Plotting
    g1 + geom_bar(aes(x = month, fill = month)) +
    theme(legend.position="none") +
    ggtitle('Total Sold Property Number')

    
    
### 1.2 Number of sold properties by Type
    
    # data
    df = data %>% group_by(propertyType) %>% summarise(total_sold = n())
    df$propertyType = factor(df$propertyType, levels = df$propertyType[order(df$total_sold,decreasing = TRUE)])
    
    # plotting
    g2 = ggplot(df, aes(x = propertyType, y = total_sold))
    g2 + geom_bar(aes(fill = propertyType), stat = 'identity') +
        theme(legend.position="none") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab('') +
        ggtitle('Total Sold Property Number')

 
       
### 1.3 Number of sold properties by County
    
    # data
    df = data %>% group_by(county) %>% summarise(total_sold = n())
    df$county = factor(df$county, levels = df$county[order(df$total_sold,decreasing = TRUE)])
    
    # plotting
    g3 = ggplot(df, aes(x = county, y = total_sold))
    g3 + geom_bar(aes(fill = county), stat = 'identity') +
        theme(legend.position="none") +
        ggtitle('Total Property Sold in Counties') +
        xlab('')
    
    
### 1.4 Number of sold properties by County ~ Type    
    
    # data
    df = data %>% group_by(county, propertyType) %>% summarise(total_sold = n())
    #df$propertyType = factor(df$propertyType, levels = df$propertyType[order(df$total_sold,decreasing = TRUE)])
    
    # plotting
    g4 = ggplot(df, aes(x = propertyType, y = total_sold))
    g4 + geom_bar(aes(fill = propertyType), stat = 'identity') +
        facet_wrap( ~ county , nrow=2, scales = 'free_y')   +
        theme(legend.position="none") +
        ggtitle('Total Property Sold in Counties')

### 1.5 Number of sold properties by city in long island
    
    # data
    df = data %>% filter(county == 'Nassau') %>% 
        filter(propertyType=='Single Family Home') %>% 
        group_by(city) %>% summarise(total_sold = n()) %>% 
        arrange(desc(total_sold))%>% head(50)
    
    df$city = factor(df$city, levels = df$city[order(df$total_sold,decreasing = TRUE)])
    
    # plotting
    g3 = ggplot(df, aes(x = city, y = total_sold))
    g3 + geom_bar(aes(fill = city), stat = 'identity') +
        theme(legend.position="none") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab('') +
        ylab('Nassau County - Single Family Home')
        #coord_flip() 
       
    
### 1.6 Number of sold properties by zipcode in long island
    
    # data
    df1 = data %>% filter(county == 'Nassau') %>% 
        group_by(zipcode) %>% summarise(total_sold = n()) %>% 
        arrange(desc(total_sold))%>% head(30)
    
    df1$zipcode = factor(df1$zipcode, levels = df1$zipcode[order(df1$total_sold,decreasing = FALSE)])
    
    # plotting
    g3 = ggplot(df1, aes(x = zipcode, y = total_sold))
    g3 + geom_bar(aes(fill = zipcode), stat = 'identity') +
        coord_flip() + 
        theme(legend.position="none")   
    
### 1.7 Median price ranking in Nassau City in 2017    
    # data
    df = data %>% filter(county == 'Nassau') %>% 
        filter(propertyType=='Single Family Home') %>% 
        group_by(city) %>% 
        summarise(median_sales_price = median(soldPrice, rm.na=TRUE)) %>% 
        arrange(desc(median_sales_price))%>% head(50)
    
    df$city = factor(df$city, levels = df$city[order(df$median_sales_price,decreasing = TRUE)])
    
    # plotting
    g3 = ggplot(df, aes(x = city, y = median_sales_price))
    g3 + geom_bar(aes(fill = city), stat = 'identity') +
        theme(legend.position="none") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab('') +
        ylab('Nassau County - Single Family Home')
        #coord_flip()     
    

### 2 Explore the Median sale price change by time 
    
### 2.1 Median price change by month in 2017    
    # data
    df1 = data %>% filter(soldPrice <=1000000) %>%
        filter(county == 'Nassau') %>% 
        filter((propertyType == 'Single Family Home')) %>% 
        #filter(bedroom >= 1 & bedroom <= 5) %>%
        group_by(month, county ) %>% 
        summarise(median_sales_price = median(soldPrice, rm.na=TRUE))
    
    # plotting
    g = ggplot(df1, aes(x = month , y = median_price))
    g + geom_bar(aes(x=month, y= median_sales_price, fill = county), stat='identity') +
        facet_wrap( ~ county , nrow=2) +
        theme(legend.position="none") 

        
### 2.2 Median price change by day in 2017
    # Data
    df2 = data %>% filter(soldPrice <=2000000) %>% 
        #filter(county == 'Nassau') %>% 
        filter((propertyType == 'Single Family Home')) %>% 
        filter(bedroom >= 1 & bedroom <= 5) %>%
        group_by(soldDate, county) %>% 
        summarise(median_sales_price = median(soldPrice, rm.na=TRUE))

    # Plotting
    g = ggplot(df2, aes(x = soldDate , y = median_price))
    g + geom_line(aes(x=soldDate, y= median_sales_price, group=county, color=county), stat='identity') +
        facet_wrap( ~ county , nrow = 2)  +
        theme(legend.position="none") +
        xlab('')

    
### 2.3 Median price change by type in 2017
    
    # data
    data2 = data %>% 
        #filter((propertyType == 'Single Family Home')) %>% 
        filter(bedroom >= 0 & bedroom <= 4) %>%
        group_by(month, propertyType , bedroom) %>% 
        summarise(median_sales_price = median(soldPrice, rm.na=TRUE))
    
    # plotting
    g = ggplot(data2, aes(x = month , y = median_price))
    g + geom_bar(aes(x=month, y= median_sales_price, fill = propertyType), stat='identity') +
        facet_wrap( ~ propertyType, nrow=2)  +
        theme(legend.position="bottom")

    

    

### 3 Explore the correlation between sale price ~ :  floorsize, lotsize 
    
### 3.1 sfh_floorsize ~ sale price
    # Data
    df = data %>% filter (propertyType == 'Single Family Home') %>% 
        filter (county == 'Nassau') %>% 
        filter (floorsize >= 1000 & floorsize <= 4000) %>%
        filter (lotsize >= 1000 & lotsize <= 7000) %>%
        filter (bedroom >= 2 & bedroom <=5) %>% 
        filter (bathroom >= 1.5 & bathroom <=3 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom)
    
    # Plotting    
    g = ggplot(df, aes(x = floorsize , y = soldPrice))
    g + geom_point (aes(x=floorsize, y= soldPrice), size=0.1, alpha =0.5) +
        facet_grid( bathroom ~ bedroom) + 
        geom_smooth(method=lm,se=FALSE)  # Add linear regression line
    

### 3.2 sfh_floorlot ~ sale price nassau
    # Data
    df = data %>% filter (propertyType == 'Single Family Home') %>% 
        filter (soldPrice <= 1000000) %>% 
        filter (county == 'Nassau') %>% 
        filter (floorsize >= 1000 & floorsize <= 4000) %>%
        filter (lotsize >= 1000 & lotsize <= 10000) %>%
        filter (bedroom >= 3 & bedroom <=5) %>% 
        filter (bathroom >= 2 & bathroom <=3 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom)
    
    # Plotting    
    g = ggplot(df, aes(x = floorsize , y = soldPrice))
    g + geom_point (aes(x=floorsize, y= soldPrice), size=0.1, alpha =0.5) +
        facet_grid( bathroom ~ bedroom ) + 
        geom_smooth(method=lm,se=FALSE) +  # Add linear regression line
        theme(legend.position="bottom")

    
### 3.3 sfh_floorlot/lotsize ~ sale price 
    # Data
    df = data %>% filter (propertyType == 'Single Family Home') %>% 
        filter (floorsize >= 1000 & floorsize <= 5000) %>%
        filter (lotsize >= 1000 & lotsize <= 7000) %>%
        filter (bedroom >= 1 & bedroom <=5) %>% 
        filter (bathroom >= 1 & bathroom <=3 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom) %>% 
        mutate (floor_lot_ratio = floorsize/lotsize)
    
    # Plotting    
    g = ggplot(df, aes(x = floor_lot_ratio , y = soldPrice))
    g + geom_point (aes(x=floor_lot_ratio, y= soldPrice), size=0.1, alpha =0.5) +
        facet_grid( bathroom ~ bedroom ) + 
        geom_smooth(method=lm,se=FALSE) +  # Add linear regression line
        theme(legend.position="bottom")
    
    
### 3.4 county/floorsize ~ sale price-------------------------------------------------------- NEW
    # Data
    df = data %>% #filter (propertyType == 'Single Family Home') %>% 
        filter (soldPrice < 1500000) %>% 
        filter (floorsize >= 100 & floorsize <= 4000) %>%
        filter (lotsize >= 500 & lotsize <= 7000) %>%
        filter (bedroom >= 1 & bedroom <=5) %>% 
        filter (bathroom >= 1 & bathroom <=3 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom, county, propertyType)
    
    # Plotting    
    g = ggplot(df, aes(x = floorsize , y = soldPrice))
    g + geom_point (aes(x=floorsize, y= soldPrice), size=0.2, alpha =0.5) +
        facet_wrap( ~ county,  nrow=2) + 
        geom_smooth(method=lm,se=FALSE) +  # Add linear regression line
        theme(legend.position="bottom")    
    
    
### 3.5 type/floorsize ~ sale price-------------------------------------------------------- NEW
    # Data
    df3.4 = data %>% #filter (propertyType == 'Single Family Home') %>% 
        filter (floorsize >= 500 & floorsize <= 5000) %>%
        filter (lotsize >= 1000 & lotsize <= 7000) %>%
        filter (bedroom >= 1 & bedroom <=5) %>% 
        filter (bathroom >= 1 & bathroom <=3 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom, county, propertyType)
    
    # Plotting    
    g = ggplot(df3.4, aes(x = floorsize , y = soldPrice))
    g + geom_point (aes(x=floorsize, y= soldPrice), size=0.1, alpha =0.5) +
        facet_wrap( ~ propertyType,  nrow=2) + 
        geom_smooth(method=lm,se=FALSE) +  # Add linear regression line
        theme(legend.position="bottom")       

### 3.6 type/bathroom ~ sale price-------------------------------------------------------- NEW
    # Data
    df3.4 = data %>% #filter (propertyType == 'Single Family Home') %>% 
        filter (floorsize >= 500 & floorsize <= 5000) %>%
        filter (lotsize >= 1000 & lotsize <= 7000) %>%
        filter (bedroom >= 1 & bedroom <=5) %>% 
        filter (bathroom >= 1 & bathroom <=3 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom, county, propertyType)
    
    # Plotting    
    g = ggplot(df3.4, aes(x = bathroom , y = soldPrice))
    g + geom_point (aes(x=bathroom, y= soldPrice), size=0.1, alpha =0.5) +
        facet_wrap( ~ propertyType,  nrow=2) + 
        geom_smooth(method=lm,se=FALSE) +  # Add linear regression line
        theme(legend.position="bottom")      
      

### 4 Explore the correlation between sale price ~ :  city, zipcode

### 4.1 top_median_sale_price by city
    # Data
    df4.1 = data %>% filter (propertyType == 'Single Family Home') %>%
        filter(county == 'Nassau') %>% 
        group_by(city) %>% 
        summarise(median_sales_price = median(soldPrice, rm.na=TRUE)) %>% 
        arrange(desc(median_sales_price))%>% head(30)
    
    df1$city = factor(df4.1$city, levels = df1$city[order(df1$median_sales_price,decreasing = FALSE)])
    
    # Plotting    
    g = ggplot(df4.1, aes(x = city , y = median_sales_price))
    g + geom_bar(aes(x=city, y= median_sales_price, fill=city), stat = 'identity') +
        coord_flip() + 
        theme(legend.position="none")  

### 4.2 Number of sold properties by zipcode in long island
    
    # data
    df2 = data %>% filter (propertyType == 'Single Family Home') %>%
        filter(county == 'Nassau') %>% 
        group_by(zipcode) %>% 
        summarise(median_sales_price = median(soldPrice, rm.na=TRUE)) %>% 
        arrange(desc(median_sales_price))%>% head(30)
    
    df2$zipcode = factor(df2$zipcode, levels = df2$zipcode[order(df2$median_sales_price,decreasing = FALSE)])
    
    # plotting
    g = ggplot(df2, aes(x = zipcode, y = median_sales_price))
    g + geom_bar(aes(x=zipcode, y= median_sales_price, fill=zipcode), stat = 'identity') +
   
        coord_flip() + 
        theme(legend.position="none")  
    
    
    
# ================================================================================================
# Analysis
# ================================================================================================ 
### load package   
library(corrplot)

### 5.1 find the correlation between variables
    # data
    df5.1 = data %>% filter(propertyType == 'Single Family Home') %>% 
        select(bathroom, bedroom, floorsize, lotsize, soldPrice) %>%
        filter( bedroom >1 & bathroom > 1 & floorsize >1000 & floorsize <6000 
                & lotsize >2000 & lotsize < 10000 )

    # plotting
    corrplot(cor(df5.1), na.label = "NA")
    

### 5.2 scatter plot to find the correlation

    # plotting   
    car::scatterplotMatrix(df5.1, diagonal='histogram')
    
    pairs(df5.1)      

### 5.3 distribution of sold price based on county
    zoom <- coord_cartesian(xlim = c(200000, 000000))
    
    df1 = data %>% filter(soldPrice <=2000000) %>% 
        #filter(county == 'Nassau') %>% 
        filter((propertyType == 'Single Family Home')) %>% 
        filter(bedroom >= 1 & bedroom <= 5)

    
    
    g1 = ggplot(df1, aes(x = soldPrice)) 
    
    g1 + geom_histogram(aes(fill = county), bins = 100)
    
    g1 + geom_freqpoly(aes(color = county), bins =100)
    
    g1 + geom_density(aes(color = county)) +
        facet_wrap( ~ county , nrow = 2)  +
        theme(legend.position="none") 
    
### 5.4 
    df1 = data %>% filter(propertyType == 'Single Family Home') %>% 
        select(bathroom, bedroom, floorsize, lotsize, soldPrice, county) %>%
        filter( bedroom >1 & bathroom > 1 & floorsize >500 & floorsize <6000 )
               # & lotsize >2000 & lotsize < 10000 )
    
    g = ggplot(df1, aes(x = floorsize, y = soldPrice)) 
    
    g + geom_smooth(aes(color=county)) +
        facet_wrap(~ county, nrow =2)
    
    g + geom_smooth(aes(color=county), method = "loess", se = FALSE) +
        facet_wrap( ~ county , nrow = 2)  +
        theme(legend.position="none")

    
    
    
# ================================================================================================
# Mapping
# ================================================================================================      
### 6.1 combine zipcode info, mapping total sold/listing number based on zip code
    # data
    library(ggplot2)
    library(dplyr)
    library(googleVis)
    library(leaflet)
    library(shiny)
    library(maps)
    
    df_property = data %>% select(city, state, county, zipcode, soldPrice, propertyid)
    

    df_zipcode = read.csv('data/zip_codes_states.csv', colClasses = "character")

    # joinn two tables
    df3 = merge(df_property, df_zipcode, by.x=c("city", "zipcode"), by.y=c("city", "zip_code"))
    df3$latitude = as.numeric(df3$latitude)
    df3$longitude = as.numeric(df3$longitude)
    
    
    # aggregate sold numbers based on zipcode
    df4 = df3 %>% group_by(latitude, longitude, zipcode, city) %>% 
        summarise(total_sold = n(), median_price=median(soldPrice))
    

    
    # mapping
    
    g <- ggplot(data = df3, aes(x = longitude, y = latitude))
    
    g + geom_point()
    g + geom_polygon(aes(group=zipcode))
        

    # leaflet

gvisGeoMap(df3, locationvar='zipcode', colorvar='soldPrice',
                      options=list(region='US', height=350, 
                                   displayMode='markers')
                      ) 

    
    
# ================================================================================================
# Modeling
# ================================================================================================    

    # Data
    df = data %>% #filter (propertyType == 'Single Family Home') %>% 
        #filter (soldPrice < 1500000) %>% 
        filter (floorsize >= 500 & floorsize <=5000) %>%
        filter (lotsize >= 1000 & lotsize <= 10000) %>%
        filter (bedroom >= 1 & bedroom <=5) %>% 
        filter (bathroom >= 1 & bathroom <=4 ) %>% 
        select (soldPrice, floorsize, lotsize, bedroom, bathroom, county, propertyType)

    df2 = df  %>% filter(county =='Richmond') %>% select(floorsize, soldPrice) 

    # Plotting    
    g = ggplot(df, aes(x = floorsize , y = soldPrice))
    g + geom_point (aes(x=floorsize, y= soldPrice), size=0.2, alpha =0.5) +
        facet_wrap( ~ county,  nrow=2) + 
        geom_smooth(method=lm,se=FALSE) +  # Add linear regression line
        theme(legend.position="bottom")
    
    
    #Basic graphical EDA for realtor dataset.
    hist(df2$floorsize, xlab = "floorsize", main = "Histogram of floorsize")
    hist(df2$soldPrice, xlab = "sold price", main = "Histogram of sold price")
    
    plot(df2, xlab = "floor size", ylab = "sold price", #    , pch=19, cex= 0.5 ,
         main = "Scatterplot of Realtor dataset, Richmond County")
    
    #Basic graphical EDA for realtor dataset, with log transformation
    x1 = df2$floorsize
    y1 = df2$soldPrice
    y2 = y1^-0.5
    
    plot(x1,y1, xlab = "floor size", ylab = "sold price", #    , pch=19, cex= 0.5 ,
         main = "Scatterplot of Realtor dataset transformed")
    
    

    
    #Manual calculation of simple linear regression coefficients.
    beta1 = sum((df2$floorsize - mean(df2$floorsize)) * (df2$soldPrice - mean(df2$soldPrice))) /
        sum((df2$floorsize - mean(df2$floorsize))^2)
    
    beta0 = mean(df2$soldPrice) - beta1*mean(df2$floorsize)
    
    print(beta1)
    print(beta0)
    
    
    #Adding the least squares regression line to the plot.
    abline(beta0, beta1, lty = 2)
    
    #Calculating the residual values.
    residuals = df2$soldPrice - (beta0 + beta1*df2$floorsize)
    
    #Note the sum of the residuals is 0.
    sum(residuals)
    
    #Visualizing the residuals.
    segments(df2$soldPrice, df2$soldPrice,
             df2$soldPrice, (beta0 + beta1*df2$soldPrice),
             col = "red")
    text(df2$soldPrice - .5, df2$soldPrice, round(residuals, 2), cex = 0.5)

    
    # modeling
    model = lm(soldPrice ~ floorsize, data = df2)
    
    
    plot(df2, xlab = "floorsize", ylab = "sold price",
         main = "Scatterplot of Realtor Dataset")
    
    abline(model, lty = 2)
    summary(model)
    
    # model residuals
    plot(model$fitted, model$residuals,
         xlab = "Fitted Values", ylab = "Residual Values",
         main = "Residual Plot for Cars Dataset")
    abline(h = 0, lty = 2)

    #Normality
    qqnorm(model$residuals)
    qqline(model$residuals)

    library(car) #Companion to applied regression.
    influencePlot(model)
    

    
    #####The Box-Cox Transformation#####
    
    bc = boxCox(model) #Automatically plots a 95% confidence interval for the lambda
    #value that maximizes the likelihhood of transforming to
    #normality.
    
    lambda = bc$x[which(bc$y == max(bc$y))] #Extracting the best lambda value.
    
    price.bc = (df2$soldPrice^lambda - 1)/lambda #Applying the Box-Cox transformation.
    # transform y value
    
    model.bc = lm(price.bc ~ df2$floorsize) #Creating a new regression based on the
    #transformed variable.
    
    summary(model.bc) #Assessing the output of the new model.
    
    plot(model.bc) #Assessing the assumptions of the new model.
    
    
    #What happens if we want to apply the Box-Cox transformation
    bc2 = boxCox(model.bc) 
    #a second time?
    lambda2 = bc$x[which(bc2$y == max(bc2$y))]
    lambda2
    
    
    # make some prediction
    
    model$fitted.values #Returns the fitted values.
    
    newdata = data.frame(floorsize = c(1980, 1500, 2683))
    
    
    predict(model, newdata )   #, interval = "confidence")
    
    predict(model, newdata, interval = "confidence") #Construct confidence intervals
    
    predict(model, newdata, interval = "prediction")
    
    
# ================================================================================================
# Predict
# ================================================================================================    
  
    # New Date  
    new_dataset = read.csv('data/file_all_single_pred_corrected.csv', stringsAsFactors = F) # for sold file
    new_dataset$soldDate = as.Date(new_dataset$soldDate, '%Y-%m-%d')
    
    
    new_data_pred = new_dataset %>% filter(soldDate > '2017-07-27') %>% 
        filter (floorsize >= 500 & floorsize <=10000) %>%
        filter (lotsize >= 1000 & lotsize <= 10000) %>% 
        filter (bedroom >= 1 & bedroom <=5) %>% 
        filter (bathroom >= 1 & bathroom <=4 )
    
    
    # predict using the model
    predict(model, new_data_pred )   #, interval = "confidence")
    #predict(model, new_data_pred, interval = "confidence") #Construct confidence intervals
    #predict(model, new_data_pred, interval = "prediction")
    
    new_data_pred$predPrice = predict(model, new_data_pred ) 
    new_data_pred = new_data_pred %>% mutate(error = (predPrice - soldPrice)/soldPrice)
    
    # plotting the error
    histogram(new_data_pred$error, breaks = 30)
    
    g = ggplot(new_data_pred, aes(x = soldPrice, y = predPrice))
    g + geom_point() +
        geom_smooth(method = "lm")
    
    g1  = ggplot(new_data_pred, aes(x = error)) 
    g1 + geom_histogram(color='white', binwidth = 0.25)
    
    #plot(new_data_pred$predPrice, new_data_pred$soldPrice )
    
    
