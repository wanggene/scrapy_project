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
    

    
    

    
    # resource.trend <- reactive({
    #     df <- dataframes$trend %>%  # subset/filter df_base based on user selections
    #         filter(population == input$trend_population,
    #                year >= input$trend_years[1],
    #                year <= input$trend_years[2])
    #     return(df)
    # })
    # 
    # resource.occupation <- reactive({
    #     df <- dataframes$occupation %>%  # subset/filter df_base based on user selections
    #         filter(age_group %in% input$occupation_age_group,
    #                race %in% input$occupation_race,
    #                occupation %in% input$occupation_occupation)
    #     return(df)
    # })
    # 
    # resource.education <- reactive({
    #     if (input$education_category == "Gender") {
    #         df <- dataframes$education %>% 
    #             filter(category %in% c("Men", "Women"))
    #     }
    #     if (input$education_category == "Race") {
    #         df <- dataframes$education %>%
    #             filter(category %in% c("White", "Black", "Asian", "Hispanic"))
    #     }
    #     df <- df %>%  # subset/filter df_base based on user selections
    #         filter(metric == input$education_metric,
    #                education %in% input$education_education)
    #     return(df)
    # })
    # 
    # 
    
    # =========================================================================
    # Server outputs : Datatables
    # =========================================================================
    # output$trend_datatable <- renderDataTable({
    #     return(resource.trend())
    # }, options=list(pageLength=10, autoWidth=FALSE))
    
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    # output$trend_barchart <- renderPlot({
    #     # get data from dataframe
    #     df <- resource.trend()
    #     df_men <- df %>% filter(gender == "Men")
    #     df_women <- df %>% filter(gender == "Women")
    #     population <- input$trend_population
    #     
    #     # plotting
    #     plot <- ggplot(df, aes(x=year, y=value, group=gender, fill=gender)) +
    #         geom_bar(data=df_men, aes(y=value), stat="identity", color="black") + 
    #         geom_text(data=df_men, aes(y=value, label=value, color=gender), angle=90, size=3.5, fontface="italic", hjust=-0.25) + 
    #         geom_bar(data=df_women, aes(y=-value), stat="identity", color="black") + 
    #         geom_text(data=df_women, aes(y=-value, label=value, color=gender), angle=90, size=3.5, fontface="italic", hjust=1.25) + 
    #         geom_text(aes(y=0, label=year), angle=90, size=4, hjust=0.5, color="white") + 
    #         scale_x_continuous(breaks=seq(min(df$year), max(df$year), by=1)) + 
    #         scale_y_continuous(labels=abs, expand=c(0.4, 0.4)) + 
    #         scale_fill_manual(values=CATEGORYCOLORS) + 
    #         scale_color_manual(values=CATEGORYCOLORS) +
    #         labs(title=sprintf("%s (%s - %s)", input$trend_population, input$trend_years[1], input$trend_years[2]),
    #              x="",
    #              y=population) + 
    #         theme(panel.background=element_blank(),
    #               axis.text.x=element_blank(),
    #               axis.ticks=element_blank())
    #     return(plot)
    # })
    # 
    # 
    # output$occupation_facetplot <- renderPlot({
    #     # get data from dataframe
    #     df <- resource.occupation()
    #     df_men <- df %>% filter(gender == "Men")
    #     df_women <- df %>% filter(gender == "Women")
    #     percentage_flag <- input$occupation_percentage
    #     
    #     # plotting
    #     plot <- ggplot(df, aes(x=occupation, y=value, group=gender, color=gender, fill=gender)) +
    #         facet_grid(age_group ~ race) + 
    #         scale_y_continuous(labels=abs, expand=c(0.4, 0.4)) + 
    #         scale_fill_manual(values=CATEGORYCOLORS) + 
    #         scale_color_manual(values=CATEGORYCOLORS) +
    #         labs(title="Employment by Occupations (2013)",
    #              x="Occupation",
    #              y="Employment") + 
    #         theme(panel.background=element_blank(),
    #               axis.text.x=element_blank(),
    #               axis.ticks=element_blank())
    #     if (percentage_flag) {  # conditional geom_text label
    #         plot <- plot + 
    #             geom_text(data=df_men, aes(y=percentage, label=sprintf("%1.1f%%", percentage)), size=3, fontface="italic", hjust=-0.25) + 
    #             geom_text(data=df_women, aes(y=-percentage, label=sprintf("%1.1f%%", percentage)), size=3, fontface="italic", hjust=1.25) + 
    #             geom_bar(data=df_men, aes(y=percentage), stat="identity", color="black") + 
    #             geom_bar(data=df_women, aes(y=-percentage), stat="identity", color="black")
    #     } else {
    #         plot <- plot + 
    #             geom_text(data=df_men, aes(y=value, label=value), size=3, fontface="italic", hjust=-0.25) + 
    #             geom_text(data=df_women, aes(y=-value, label=value), size=3, fontface="italic", hjust=1.25) +
    #             geom_bar(data=df_men, aes(y=value), stat="identity", color="black") + 
    #             geom_bar(data=df_women, aes(y=-value), stat="identity", color="black")
    #     }
    #     plot <- plot + coord_flip()  # flip coordinates
    #     return(plot)
    # })
    # 
    # 
    # output$education_barchart <- renderPlot({
    #     # get data from dataframe
    #     df <- resource.education()
    #     category <- input$education_category
    #     metric <- input$education_metric
    #     
    #     # plotting
    #     plot <- ggplot(df, aes(x=education, y=value, group=category, color=category, fill=category, ymax=max(value)*1.1)) +
    #         geom_bar(stat="identity", color="black", position=position_dodge(width=0.6), width=0.5) + 
    #         geom_text(aes(label=value), size=3.5, fontface="italic", hjust=-0.5, position=position_dodge(width=0.6)) + 
    #         scale_y_continuous(labels=comma, expand=c(0.4, 0.4)) + 
    #         scale_color_manual(values=CATEGORYCOLORS) +
    #         scale_fill_manual(values=CATEGORYCOLORS) +
    #         labs(title=sprintf("%s (by %s)", metric, category),
    #              x="Education Level",
    #              y="") + 
    #         theme(panel.background=element_blank(),
    #               axis.ticks.y = element_blank())
    #     plot <- plot + coord_flip()  # flip coordinates
    #     return(plot)
    # })
    
    
    
    
    # =========================================================================
    # Server outputs : Downloads
    # =========================================================================
    # output$trend_download <- downloadHandler(
    #     filename <- function() {
    #         return("employment_trend.csv")
    #     },
    #     content <- function(filename) {
    #         df <- dataframes$trend
    #         write.csv(df, file=filename, row.names=FALSE)
    #     }
    # )
    # 
    # output$occupation_download <- downloadHandler(
    #     filename <- function() {
    #         return("employment_occupation.csv")
    #     },
    #     content <- function(filename) {
    #         df <- dataframes$occupation
    #         write.csv(df, file=filename, row.names=FALSE)
    #     }
    # )
    # 
    # output$education_download <- downloadHandler(
    #     filename <- function() {
    #         return("employment_education.csv")
    #     },
    #     content <- function(filename) {
    #         df <- dataframes$education
    #         write.csv(df, file=filename, row.names=FALSE)
    #     }
    # )
    
})