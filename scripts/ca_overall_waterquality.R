
# convert depth to sf 

depth_df <- depth %>%
  janitor::clean_names() %>%
  select(measurement_date, depth_to_water, gw_elevation, longitude, latitude)

depth_sf <- st_as_sf(x = depth_df, 
                     coords = c('longitude', 'latitude'), 
                     crs = 4326)

# convert water quality to sf 

water_quality_sf <- st_as_sf(x = water_quality, 
                             coords = c('longitude', 'latitude'), 
                             crs = 4326)

water_quality_sf <- st_transform(water_quality_sf, 3857)

# combine water quality and county data 


county_water <- st_join(ca_counties, water_quality_sf)
water_county <- st_join(water_quality_sf, ca_counties)

# give each chemical its sf 

pfoa_sf <- county_water %>%
  filter(chemical == "Perfluorooctanoic acid (PFOA)")

pfos_sf <- county_water %>%
  filter(chemical == "Perfluorooctane sulfonate (PFOS)")

caco3_sf <- county_water %>%
  filter(chemical == "Alkalinity as CaCO3")

mercury_sf <- county_water %>%
  filter(chemical == "Mercury")

nitrate_sf <- county_water %>%
  filter(chemical == "Nitrate as N")

arsenic_sf <- county_water %>%
  filter(chemical == "Arsenic")

hco3_sf <- county_water %>%
  filter(chemical == "bicarbonate HCO3")

lead_sf <- county_water %>%
  filter(chemical == "Lead")

#### make it shiny ####################################

library(shiny)
library(tidyverse)


### create the user interface 

ui <- fluidPage(
  titlePanel("Groundwater Quality in California"), 
  sidebarLayout(
    sidebarPanel("Select Water Quality Indicator",
          
          radioButtons(
            inputId = "chemical", 
            label = "Chemicals", 
            choices = c("Perfluorooctanoic acid (PFOA)", "Perfluorooctane sulfonate (PFOS)", "Alkalinity as CaCO3", "Mercury", "Nitrate as N", "Arsenic", "bicarbonate HCO3")
          )   # end radioButtons
    ), # end sidebarPanel
    mainPanel(plotOutput(outputId = "chemical_plot"))
  ) # end of sidebarLayout
) # end of my fluidPage


### create the server function 

server <- function(input, output) {
  
  chemical_select <- reactive({
    chemical_select_df <- county_water %>%
      filter(chemical == input$chemical)
  }) # end chemical reactive 
  
  output$chemical_plot <- renderPlot({
    ggplot(data = chemical_select()) + 
      geom_point(aes(x = date, y = measurement))
  })
}


### combine them into an app

shinyApp(ui = ui, server = server)















