
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
server <- function(input, output) {}

### Combine them into an app:
shinyApp(ui = ui, server = server)

  
### Home Page 

### Groundwater depth levels 

### Chemicals 

### Socioeconomic 

### groundwater dependent ecosystems ? 