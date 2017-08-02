shinyServer(function(input, output) {
    
    # =========================================================================
    # Reactive resources
    # =========================================================================
    
    data2 <- reactive({
        df <- data %>% filter(propertyType == input$type) %>%
            filter(soldPrice >= input$soldpriceRange[1] & soldPrice <= input$soldpriceRange[2]) %>%
            filter(bedroom >= input$bedroom[1] & bedroom <= input$bedroom[2]) %>%
            filter(bathroom >= input$bathroom[1] & bathroom <= input$bathroom[2]) %>% 
            filter(floorsize >= input$floorsize[1] & floorsize <= input$floorsize[2]) %>%
            filter(lotsize >= input$lotsize[1] & lotsize <= input$lotsize[2]) %>% 
            group_by(county , month, bedroom) %>% 
            summarise(median_price = median(soldPrice, rm.na=TRUE))
        return(df)
    })
    
    
    
    data3 <- reactive({
        df <- data %>% filter(county == input$county) %>% 
            filter(propertyType == input$type) %>% 
            filter(soldPrice >= input$soldpriceRange[1] & soldPrice <= input$soldpriceRange[2]) %>%
            filter(bedroom >= input$bedroom[1] & bedroom <= input$bedroom[2]) %>%
            filter(bathroom >= input$bathroom[1] & bathroom <= input$bathroom[2]) %>% 
            filter(floorsize >= input$floorsize[1] & floorsize <= input$floorsize[2]) %>%
            filter(lotsize >= input$lotsize[1] & lotsize <= input$lotsize[2]) %>% 
            
            group_by(soldDate, county) %>% 
            summarise(median_price = median(soldPrice, rm.na=TRUE))
        
        return(df)
    })
    
    
    data4 <- reactive({
        df <- data %>%# filter(county==input$county) %>% 
            filter(propertyType == input$type) %>% 
            filter(soldPrice >= input$soldpriceRange[1] & soldPrice <= input$soldpriceRange[2]) %>%
            filter(bedroom >= input$bedroom[1] & bedroom <= input$bedroom[2]) %>%
            filter(bathroom >= input$bathroom[1] & bathroom <= input$bathroom[2]) %>% 
            filter(floorsize >= input$floorsize[1] & floorsize <= input$floorsize[2]) %>%
            filter(lotsize >= input$lotsize[1] & lotsize <= input$lotsize[2])
        return(df)
    })
    
    
    data5 <- reactive({
        df = data %>% filter(propertyType == input$type) %>% 
            filter(soldPrice >= input$soldpriceRange[1] & soldPrice <= input$soldpriceRange[2]) %>%
            filter(bedroom >= input$bedroom[1] & bedroom <= input$bedroom[2]) %>%
            filter(bathroom >= input$bathroom[1] & bathroom <= input$bathroom[2]) %>% 
            filter(floorsize >= input$floorsize[1] & floorsize <= input$floorsize[2]) %>%
            filter(lotsize >= input$lotsize[1] & lotsize <= input$lotsize[2])
        
        return(df)
    })
    
    data6 <- reactive({
        df = data %>% filter(propertyType == 'Single Family Home') %>% 
            select(bathroom, bedroom, floorsize, lotsize, soldPrice) %>%
            filter( bedroom >1 & bathroom > 1 & floorsize >1000 & floorsize <6000 
                    & lotsize >2000 & lotsize < 10000 )
        
        return(df)
        
        
    })
    


    
    # =========================================================================
    # Server outputs : Datatables
    # =========================================================================

    
    
    
    
    # =========================================================================
    # Server outputs : Plots
    # =========================================================================
    
    output$Price_county <- renderPlot({
            # get data from dataframe
            df = data2()

            # plotting
            plot <- ggplot(df, aes(x=month , y=median_price)) +
                    geom_bar(aes(x=month, y=median_price, fill=county), stat='identity') +
                    facet_grid(. ~ county) +
                    scale_colour_hue("clarity", l = 70, c = 150) + ggthemes::theme_few() +
                    theme(legend.position="none")
            return(plot)
    })
    
    
    output$Time_trend <- renderPlot({
            # get data from dataframe
            df = data3()
            
            price_mean = mean(df$median_price)
            
            # plotting
            plot <- ggplot(df, aes(x=soldDate , y=median_price)) +
                    geom_line(aes(x=soldDate, y=median_price , group=county,color=county), stat='identity') +
                    scale_colour_hue("clarity", l = 70, c = 150) + ggthemes::theme_few() +
                    geom_hline(aes(yintercept = price_mean), color = "blue") +
                    xlab(paste(input$county, input$type)) +
                    ylab('Median Sale Price') + 
                    theme(legend.position="none")
            
            
            return(plot)
    })
    
    
    
    output$Price_distribution <- renderPlot({
            # get data
            df = data5()
        
            # plotting
            plot <- ggplot(df, aes(x = soldPrice)) +
                    geom_density(aes(color = county)) +
                    facet_grid(. ~ county) +
                    scale_colour_hue("clarity", l = 70, c = 150) + ggthemes::theme_few() +
                    theme(legend.position="none")
            
            return(plot)

    })
    
    
    # output$Time_trend2 <- renderPlot({
    #     # get data from dataframe
    #     df = data4()
    #     
    #     # plotting
    #     plot <- ggplot(df, aes(x=soldDate , y=soldPrice)) +
    #                 geom_point(aes(x=soldDate, y=soldPrice, color = input$county)) 
    #                 #scale_colour_hue("clarity", l = 70, c = 150) + ggthemes::theme_few()
    #         return(plot)
    # })
    
    
    # output$Plotly_test <- renderPlot({
    #         # Get data from dataframe
    #         df = data2()
    #         
    #         # plotting
    #         plot <- plot_ly(df, x = ~ month, y = ~median_price, color = ~county, text = ~paste("month: ", month))
    #         return(plot)
    # })
    # 
    # 
    # output$plot <- renderPlotly({
    #     plot_ly(mtcars, x = ~mpg, y = ~wt)
    # })
    # 
    # 
    # 
    # output$event <- renderPrint({
    #     d <- event_data("plotly_hover")
    #     if (is.null(d)) "Hover on a point!" else d
    # })
    
    
    
    
    

    # =========================================================================
    # Server outputs : Downloads
    # =========================================================================

    
})