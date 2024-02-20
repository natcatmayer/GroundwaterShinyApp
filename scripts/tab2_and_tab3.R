
######### data wrangling ##########################
# convert depth to sf 

depth_df <- depth %>%
  janitor::clean_names() %>%
  select(measurement_date, depth_to_water, longitude, latitude)

depth_sf <- st_as_sf(x = depth_df, 
                     coords = c('longitude', 'latitude'), 
                     crs = 4326)

depth_sf <- depth_sf %>%
  mutate(date = lubridate::mdy(measurement_date)) %>%
  separate(date, c("year", "month", "day"))


# convert water quality to sf 

water_quality_sf <- st_as_sf(x = water_quality, 
                             coords = c('longitude', 'latitude'), 
                             crs = 4326)

water_quality_sf <- st_transform(water_quality_sf, 3857)

# combine water quality and county data 

county_water <- st_join(ca_counties, water_quality_sf)
water_county <- st_join(water_quality_sf, ca_counties)


########### shiny app ##############################
library(shiny)
library(tidyverse)

ui <- fluidPage(
  
  tabsetPanel(
  
tabPanel( ### start tab 2
  title = 'Groundwater Levels',
  
  fluidRow( # start fluid row 2.1
    column(width = 3,
           selectInput("select", label = h3("Select year"),
                       choices = list("2000" = 1, "2001" = 2, "2002" = 3),
                       selected = 1),
           hr(),
           fluidRow(column(3, verbatimTextOutput("value"))
                    
                    
           )
    ), ### end column
    column(width = 9,
           h3('Map Here'),
           #plotOutput('insert_map')
    )
  ), ### end fluidRow 2.1
  
  hr(), ### horizontal rule so the row breaks are easier to see
  p('talk about how they should look at the map'),
  hr(),
  
  fluidRow( # start fluid row 2.2
    column(
      width = 3,
      
      
      selectInput("county", label = h3("select county"),
                  choices = list("ventura" = 1, "santa barbara" = 2, "los angeles" = 3),
                  selected = 1),
      
      selectInput("year", label = h3("select year"),
                  choices = list("2000" = 1, "2001" = 2, "2002" = 3),
                  selected = 1)
      
      
    ), # end column
    
    column(
      width = 9,
      h3('Graph here'),
      plotOutput('insert_graph'))
    
  ) ### end fluidRow 2.2
  
  
), ### end tab 2


tabPanel( ### start tab 3
  title = 'Groundwater Quality',
  
  
  fluidRow( # start fluid row 3.1
    column(width = 3,
           h3('select chemical'),
           
           radioButtons(
             inputId = 'chemical',
             label = 'chemical',
             choices = c('lead', 'etc.')),
           
           
    ), ### end column
    
    column(width = 9,
           h3('Map Here'),
           plotOutput('insert_map')
    ) ### end column
    
  ), ### end fluidRow 3.1
  
  hr(), ### horizontal rule so the row breaks are easier to see
  p('talk about how they should look at the map'),
  hr(),
  
  fluidRow( # start fluid row 3.2
    column(
      width = 3,
      
      selectInput("county", label = h3("Select year"),
                  choices = list("ventura" = 1, "santa barbara" = 2, "los angeles" = 3),
                  selected = 1),
      
      
      radioButtons(
        inputId = 'chemical',
        label = 'chemical',
        choices = c(4, 6, 8))
      
    ), # end column
    
    column(
      width = 9,
      h3('Graph here'),
      plotOutput('insert_graph'))
  ) ### end fluidRow 3.2
  
  
  
  
), ### end tab 3  



) # end tabset panel 

) # end fluidPage


### Create the server function:
server <- function(input, output) {}

### Combine them into an app:
shinyApp(ui = ui, server = server)
















# # give each chemical its sf 
# 
# pfoa_sf <- county_water %>%
#   filter(chemical == "Perfluorooctanoic acid (PFOA)")
# 
# pfos_sf <- county_water %>%
#   filter(chemical == "Perfluorooctane sulfonate (PFOS)")
# 
# caco3_sf <- county_water %>%
#   filter(chemical == "Alkalinity as CaCO3")
# 
# mercury_sf <- county_water %>%
#   filter(chemical == "Mercury")
# 
# nitrate_sf <- county_water %>%
#   filter(chemical == "Nitrate as N")
# 
# arsenic_sf <- county_water %>%
#   filter(chemical == "Arsenic")
# 
# hco3_sf <- county_water %>%
#   filter(chemical == "bicarbonate HCO3")
# 
# lead_sf <- county_water %>%
#   filter(chemical == "Lead")
# 














