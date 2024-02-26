
### Attach necessary packages
library(shiny)
library(tidyverse)
library(bslib)

### Create the user interface:
ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  
  titlePanel('California Groundwater'),
  tabsetPanel(
    
    tabPanel( ### start tab 1
      title = 'Home',
      p('Photo, TOC, purpose, baclground, etc. ')
         ), ### end tab 1
    
    tabPanel( ### start tab 2
      title = 'Groundwater Levels',
      
      fluidRow( # start fluid row 2.1
        column(width = 3,
               
               
               sliderInput("year_2_1", label = h3("Select Year"), min = 2022, 
                           max = 2024, value = 2024, sep = "")
               
               
        ), ### end column
        column(width = 9,
               h3('Map Here'),
               plotOutput(outputId = 'gw_plot')
        )
      ), ### end fluidRow 2.1
      
      hr(), ### horizontal rule so the row breaks are easier to see
      p('talk about how they should look at the map'),
      hr(),
      
      fluidRow( # start fluid row 2.2
        column(
          width = 3,
          
          
          selectInput("county_2_2", label = h3("Select County"),
                      choices = unique(county_gw_avg$county),
                      selected = 1)
          
          
        ), # end column
        
        column(
          width = 9,
          h3('Graph here'),
          plotOutput(outputId = 'gw_plot_2'))
        
      ) ### end fluidRow 2.2
      
      
    ), ### end tab 2
    
    
    tabPanel( ### start tab 3
      title = 'Groundwater Quality',
      
      
      fluidRow( # start fluid row 3.1
        column(width = 3,
               h3('Select Water Quality Indicator'),
               
               radioButtons(
                 inputId = 'chemical_3_1',
                 label = 'chemical',
                 choices = unique(water_quality_sf$chemical)),
               
               sliderInput("year_3_1", label = h3("Select Year"), 
                           min = 1990, max = 2024, value = 2024, sep = "")
               
        ), ### end column
        
        column(width = 9,
               plotOutput('chemical_map')
        ) ### end column
        
      ), ### end fluidRow 3.1
      
      hr(), ### horizontal rule so the row breaks are easier to see
      p('talk about how they should look at the map'),
      hr(),
      
      fluidRow( # start fluid row 3.2
        column(
          width = 3,
          
          selectInput("county_3_2", label = h3("Select County"),
                      choices = unique(water_county$county),
                      selected = 1),
          
          
          radioButtons(
            inputId = 'chemical_3_2',
            label = 'chemical',
            choices = unique(water_county$chemical))
          
        ), # end column
        
        column(
          width = 9,
          h3('Graph here'),
          plotOutput('chemical_plot'))
      ) ### end fluidRow 3.2
      
      
      
      
    ), ### end tab 3  
    
    tabPanel( ### start tab 4
      title = 'Environmental Justice',
  
      fluidRow( # start fluid row 4.1
      column(width = 3,
                    h3('select demographic'),
                    radioButtons(
                      inputId = 'demographic',
                      label = 'demographic category',
                      choices = c(4, 6, 8)
                    )
        ), ### end column
        column(width = 9,
                    h3('Map Here'),
                    #plotOutput('insert_map')
        )
      ), ### end fluidRow 4.1
      
      hr(), ### horizontal rule so the row breaks are easier to see
      p('talk about how they should look at the map'),
      hr(),
      
      fluidRow( # start fluid row 4.2
        column(
          width = 3,
          h3('Select other variable'),
          radioButtons(
            inputId = 'demographic',
            label = 'demographic category',
            choices = c(4, 6, 8)
          )
        ),
        column(
          width = 9,
          h3('Graph here'),
          #plotOutput('insert_graph'))
        )
      ) ### end fluidRow 4.2
      
    ), ### end tab 4 
    
    tabPanel( ### start tab 5
      title = 'Groundwater Dependent Ecosystems',
      
      p(' If we have time :-) ')
      
    ) ### end tab 5  
  ) ### end tabsetPanel
  
) # end Fluidpage

### Create the server function:
server <- function(input, output) {
  
  thematic::thematic_shiny() #### ensures that the ggplot2 automatically matches the app theme
  
  ### START tab 2, row 1  
  gw_select <- reactive({ ### start gw_select
    gw_county_df <- county_gw_avg %>%
      filter(year %in% input$year_2_1)
    
    return(gw_county_df)
  }) ### end gw_select
  
  output$gw_plot <- renderPlot({ ### start gw_plot
    ggplot(data = gw_select()) + 
      geom_sf(aes(fill = average_depth), color = "white", size = 0.1) + 
      scale_fill_gradientn(colors = c("lightgray", "yellow", "orange", "red")) + 
      theme_minimal() + 
      labs(fill = 'Groundwater Depth')
  }) ### end gw_plot
  ### END tab 2, row 1 
  
  ### START tab 2, row 2
  
  gw_select_1 <- reactive({
    gw_county_df_1 <- county_gw_avg %>%
      filter(county %in% input$county_2_2)
    
    return(gw_county_df_1)
  })  ### end gw_select_1
  
  output$gw_plot_2 <- renderPlot({
    ggplot(data = gw_select_1()) + 
      geom_col(aes(x = year, y = average_depth)) + 
      labs(x = "Year", 
           y = "Average Groundwater Depth")
    theme_minimal()
  })
  
  ### END tab 2, row 2
  
  ### START tab 3, row 1
  
  county_chemical_select_1 <- reactive({
    county_chemical_df_1 <- water_county_avg %>%
      filter(chemical == input$chemical_3_1) %>%
      filter(year %in% input$year_3_1)
    
    return(county_chemical_df_1)
  }) ### end county_chemical_select_1
  
  output$chemical_map <- renderPlot({
    ggplot(data = county_chemical_select_1()) + 
      geom_sf(aes(fill = avg_measure), color = "white", size = 0.1) + 
      scale_fill_continuous(low = "lightblue", high = "navy", guide = "colorbar", na.value = "lightgray") + 
      theme_minimal() + 
      labs(fill = 'Chemical Concentration in Groundwater')
  })
  
  ### END tab 3, row 1
  
  ### START tab 3, row 2
  
  county_chemical_select <- reactive({
    county_chemical_df <- water_county_avg %>%
      filter(chemical == input$chemical_3_2) %>%
      filter(county == input$county_3_2)
    
    return(county_chemical_df)
  }) ### end county chemical select 
  
  output$chemical_plot <- renderPlot({
    ggplot(data = county_chemical_select()) + 
      geom_col(aes(x = year, y = avg_measure), color = "navy") + 
      theme_minimal()
  })
  
  ### END tab 3, row 2
  
  
  
}

### Combine them into an app:
shinyApp(ui = ui, server = server)

  
### Home Page 

### Groundwater depth levels 

### Chemicals 

### Socioeconomic 

### groundwater dependent ecosystems ? 