
### Attach necessary packages
library(shiny)
library(tidyverse)
library(here)
library(sf)
library(bslib)



### Data
water_quality <- read_csv(here('data', 'water_quality.csv'))
depth_df <- read_csv(here('data', 'groundwater_depth.csv'))
ca_counties_raw_sf <- read_sf(here("data/ca_counties/CA_Counties_TIGER2016.shp"))

ca_counties_sf <- ca_counties_raw_sf %>% 
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2)


# convert water quality to sf 

water_quality_sf <- st_as_sf(x = water_quality, 
                             coords = c('longitude', 'latitude'), 
                             crs = 4326)

water_quality_sf <- st_transform(water_quality_sf, 3857)

# combine water quality and county data 

county_water <- st_join(ca_counties_sf, water_quality_sf)
water_county <- st_join(water_quality_sf, ca_counties_sf)

water_county <- water_county %>%
  separate(date, c("year", "month", "day"))

county_water <- county_water %>%
  separate(date, c("year", "month", "day"))

# convert depth to sf 


depth_sf <- st_as_sf(x = depth_df, 
                     coords = c('longitude', 'latitude'), 
                     crs = 4326)

depth_sf <- st_transform(depth_sf, 3857)

# combine groundwater depth and ca counties 

gw_county <- st_join(depth_sf, ca_counties_sf)
county_gw <- st_join(ca_counties_sf, depth_sf)

county_gw_avg <- county_gw %>%
  drop_na() %>%
  group_by(county, year) %>%
  summarise(average_depth = mean(depth_to_water))

water_county_avg <- county_water %>%
  group_by(county, chemical, year) %>%
  summarise(avg_measure = mean(measurement))



### Create the user interface:
ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  
  titlePanel('California Groundwater'),
  tabsetPanel(
    tabPanel( ####################### start tab 2 ###############################
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
      
      
      
      
    ) ### end tab 3  
    

  ) ### end tabsetPanel
  
) # end Fluidpage


### Create the server function:
server <- function(input, output) {
  
  thematic::thematic_shiny() #### ensures that the ggplot2 automatically matches the app theme
  
  #### START tab 1 ####
  
  output$image1 <- renderImage({
    
    list(src = "www/cts.png",
         width = "100%",
         height = 330)
    
  }, deleteFile = F)
  
  #### END tab 1 #####
  
  
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
      theme_void() + 
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
      geom_col(aes(x = year, y = average_depth), fill = "red3") + 
      labs(x = "Year", 
           y = "Average Groundwater Depth") +
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
      geom_sf(aes(fill = avg_measure), color = "lightgray", size = 0.1) + 
      scale_fill_continuous(low = "lightblue", high = "navy", guide = "colorbar", na.value = "lightgray") + 
      theme_void() + 
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
      geom_col(aes(x = year, y = avg_measure), fill = "navy") + 
      theme_minimal()
  })
  
  ### END tab 3, row 2
  
  
  
}

### Combine them into an app:
shinyApp(ui = ui, server = server)














