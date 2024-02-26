# Madi Script 

### Attach necessary packages
library(shiny)
library(tidyverse)
library(bslib)
library(here)


ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  
  titlePanel('California Groundwater'),
  
  tabsetPanel(
    
    tabPanel( ### start tab 1
      title = 'Home',
    
      img(src = "rstudio.png", height = 140, width = 400),
      p('Photo caption'),
      hr(), 
      
      fluidRow( # start fluid row 1.1
        
        column(width = 9,
               h2(strong("Purpose")),
               helpText("Groundwater in California is rapidly dwindling. We aim to explore ....."),
               
               h2(strong("Background")),
               helpText("Groundwater is important because....."),
               
               h2(strong("Website Content")),
               helpText(" Tab 1: Groundwater Levels
                        Tab 2: Gwater Quality 
                        Tab 3: EJ
                        Tab 4 Ecosystems"),
               
               h2(strong("Data Summary")),
               helpText("In this analysis, ......"),
               
               h2(strong("Data Source")),
               helpText("Data Sourced from blah blah blah...."),
               
        ), ### end column 
        
        column(width = 3,
               h3(''),
               tags$figure(
                 class = "centerFigure",
                 tags$img(
                   src = "cts.jpg",
                   width = 600,
                   alt = "California tiger salamander (CTS)"
                 ),
                 tags$figcaption("California tiger salamander (CTS)"))
        ) ### end column 
      ), ### end fluidRow 1.1
      
      
      
      hr(), ### horizontal rule so the row breaks are easier to see
      p('Developed by Natalie Mayer, Chelsea Sanford, and Madi Calbert'),
      hr()
      
      
    ) ### end tab 1
  ) ### end tabsetPanel
  ) # end Fluidpage



### Create the server function:
server <- function(input, output) {
  thematic::thematic_shiny() #### ensures that the ggplot2 automatically matches the app theme

}

### Combine them into an app:
shinyApp(ui = ui, server = server)
