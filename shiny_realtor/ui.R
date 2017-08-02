shinyUI(fluidPage(
    tags$head(tags$link(rel="stylesheet", type="text/css", href="app.css")),
    
    titlePanel("Long Island Realtor Estate Market Explorer 2017"),
    
    sidebarLayout(
        sidebarPanel(
            p(class="text-small",
              a(href="http://wanggene.github.io/", target="_blank", " Gene "), " | ",
              a(href="https://github.com/wanggene", target="_blank", icon("github")), " | ",
              a(href="https://www.linkedin.com/in/wanggene", target="_blank", icon("linkedin"))," | ",
              a(href="https://www.facebook.com/in/wanggene", target="_blank", icon("facebook"))),
            hr(),

           
            conditionalPanel(
                condition="input.tabset == 'Sold Proporty Count' | input.tabset == 'Median Sale Price Distribution' | 
                           input.tabset == 'Median Sale Price Volatility' ",
                
                selectInput(inputId = 'county', label = 'County', choices=choices$county, selected=choices$county[[3]]),
                hr(),
                selectInput(inputId = 'type', label = 'Property Type', choices=choices$property_type, selected=choices$property_type[[2]]),
                hr(),
                sliderInput('soldpriceRange', 'Price Range', min=200000, max=2000000,value=c(300000, 1000000), step=100000, round=0),
                hr(),
                sliderInput('bedroom', 'Bedroom', min=0, max=7, value=c(1, 7), step =1),
                hr(),
                sliderInput('bathroom', 'Bathroom', min=0, max=5, value=c(1,5), step=0.5),
                hr(),
                sliderInput('floorsize', 'Floor Size', min=100, max=5000, value=c(500,5000) , step=200),
                hr(),
                sliderInput('lotsize', 'Lot Size', min=0, max=10000, value=c(1000, 6000), step=1000)
                
            ),
      
            
            # conditionalPanel(
            #     condition="input.tabset == 'Median Sale Price Volatility'",
            #     selectInput(inputId = 'type', label = 'Property Type', choices=choices$property_type, selected=choices$property_type[[2]]),
            #     hr(),
            #     selectInput(inputId = 'county', label = 'County', choices=choices$county, selected=choices$county[[3]]),
            #     hr(),
            # 
            #     selectInput(inputId = 'city', label = 'City', choices=choices$city, selected=choices$city[[1]]),
            #     hr()
            #     
            # ),
            
            
            conditionalPanel(
                condition="input.tabset == 'Linear Regression'",
                selectInput(inputId="education_category", label="Select Category", choices=choices$category, selected=choices$category[[1]]),
                hr(),
                selectInput(inputId="education_metric", label="Select Metric", choices=choices$education_metric, selected=choices$education_metric[[1]]),
                hr(),
                checkboxGroupInput(inputId="education_education", label="Choose Education:", choices=choices$education_education, selected=choices$education_education)
            ),
            
            
            conditionalPanel(
                condition="input.tabset == 'Links'",
                selectInput(inputId="education_category", label="Select Category", choices=choices$category, selected=choices$category[[1]]),
                hr(),
                selectInput(inputId="education_metric", label="Select Metric", choices=choices$education_metric, selected=choices$education_metric[[1]]),
                hr(),
                checkboxGroupInput(inputId="education_education", label="Choose Education:", choices=choices$education_education, selected=choices$education_education)
            ),
            
            
            
            
            width=3
        ),
        
        mainPanel(
            tabsetPanel(id="tabset",
                        tabPanel("Sold Proporty Count",
                                 h2("Labor Force Trends"),
                                 p(class="text-small", "This section visualizes ...."),
                                 hr(),
                                 
                                 h3("Bar Chart"),
                                 p(class="text-small", "Visualization of ....."),
                                 
                                 hr(),
                                 
                                 h3("Data", downloadButton("trend_download", label="")),
                                 p(class="text-small", "Tabular searchable data display similar to that found in the original source ",
                                   a(href="#", target="_blank", "#")),
                                 p(class="text-small", "You can download the data with the download button above."),
                                 dataTableOutput("trend_datatable"),
                                 hr()
                        ),
                        
                        tabPanel("Median Sale Price Distribution",
                                 h2("Median Sale Price Time Line "),
                                 p(class="text-small", "This section visualizes median sale price change from beginning of 2017."),
                                 plotOutput("Price_county", height=200, width="auto"),
                                 hr(),
                                 
                                 h2("Median Sale Price Density Plot"),
                                 p(class="text-small", "This section visualizes median sale price ditribution by county."),
                                 plotOutput("Price_distribution", height=200, width="auto"),
                                 hr(),
                                 
                                 #plotOutput("Time_trend", height=200, width="auto"),
                                 #hr(),
                                 
                                 
                                 h3("Data", downloadButton("occupation_download", label="")),
                                 p(class="text-small", "Tabular searchable data display similar to that found in the original source ",
                                 a(href="#", target="_blank", "#")),
                                 
                                 p(class="text-small", "You can download the data with the download button above."),
                                 #plotOutput("Time_trend2"),
                                 #dataTableOutput("occupation_datatable"),
                                 hr()

                        ),
                        
                        
                        tabPanel("Median Sale Price Volatility",

                                 h2("Median Sale Price Volatility"),
                                 p(class="text-small", "Narrow down the selection to check the median sale price trend"),
                                 plotOutput("Time_trend", height=300, width="auto"),
                                 hr(),
                                 
                                 p(class="text-small", "Facet plot of employment by race, age group, and gender and occupation.  
                                   Toggle the 'Display Percentage' checkbox to show percentages or actual counts."),
                                 checkboxInput(inputId="occupation_percentage", label="Display Percentage", value=TRUE),
                                 hr()
                                 

                                 
                        ),
                        
                        
                        tabPanel("Linear Regression",
                                 h2("Labor Force by Education Level"),
                                 p(class="text-small", "This section displays visualizations of labor force statistics by education level attainment.  
                                   Please select a category to view the detailed breakdown by gender or race.  Units are in thousands."),
                                 hr(),
                                 
                                 h3("Bar Chart"),
                                 p(class="text-small", "Visualization of various labor metrics and statistics by education level."),
                                 #plotOutput("education_barchart", height=400, width="auto"),
                                 hr(),
                                 
                                 h3("Data", downloadButton("education_download", label="")),
                                 p(class="text-small", "Tabular searchable data display similar to that found in the original source ",
                                   a(href="#", target="_blank", "#")),
                                 p(class="text-small", "You can download the data with the download button above."),
                                 #dataTableOutput("education_datatable"),
                                 hr()
                        ),
                        

                        tabPanel("Links",
                                 h2("Labor Force by Education Level"),
                                 p(class="text-small", "This section displays visualizations of labor force statistics by education level attainment.  
                                   Please select a category to view the detailed breakdown by gender or race.  Units are in thousands."),
                                 
                                 hr()
                        )
   
                        
            ),
            width=9
        )
    )
))
