# Madi Script 

### Attach necessary packages
library(shiny)
library(tidyverse)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  
  titlePanel('California Groundwater'),
  tabsetPanel(
    
    tabPanel( ### start tab 1
      title = 'Home',
      
      img(src = 'devereaux_slough.png', height = 140, width = 400),
      p('Photo caption'),
      hr(), 
      
      fluidRow( # start fluid row 1.1
        column(width = 9,
               
               textInput(" ", label = h3("Purpose"),
              
               )
        ), ### end column
        column(width = 3,
               h3('Map Here'),
               #plotOutput('insert_map')
        )
      ), ### end fluidRow 1.1
      
      hr(), ### horizontal rule so the row breaks are easier to see
      p('talk about how they should look at the map'),
      hr()
      
      
    ) ### end tab 1
  ) ### end tabsetPanel
  ) # end Fluidpage







### Create the server function:
server <- function(input, output) {}

### Combine them into an app:
shinyApp(ui = ui, server = server)
