
### Attach necessary packages
library(shiny)
library(tidyverse)

### Create the user interface:
ui <- fluidPage(
  titlePanel('California Groundwater'),
  tabsetPanel(
    
    tabPanel( ### start tab 1
      title = 'Home',
      p('Photo, TOC, purpose, baclground, etc. ')
         ), ### end tab 1
    
    tabPanel( ### start tab 2
      title = 'Groundwater Levels',
      sidebarLayout(
        sidebarPanel("Groundwater Levels",
        
                # Copy the line below to make a select box 
                 selectInput("select", label = h3("Select year"), 
                        choices = list("2000" = 1, "2001" = 2, "2002" = 3), 
                        selected = 1),
        
              hr(),
              fluidRow(column(3, verbatimTextOutput("value"))) 
                 
                ), #end sidebar panel
    
        mainPanel("map goes here")
      ) # end sidebar layout
      
      
      
    ), ### end tab 2
    
    tabPanel( ### start tab 3
      title = 'Groundwater Quality',
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
    ), ### end tab 3  
    
    tabPanel( ### start tab 4
      title = 'Environmental Justice'
    ), ### end tab 4  
    
    tabPanel( ### start tab 5
      title = 'Groundwater Dependent Ecosystems'
    ) ### end tab 5  
  ) ### end tabsetPanel
  
)

### Create the server function:
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

### Combine them into an app:
shinyApp(ui = ui, server = server)

  
### Home Page 

### Groundwater depth levels 

### Chemicals 

### Socioeconomic 

### groundwater dependent ecosystems ? 