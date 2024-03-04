
################## Create the user interface: ############################
ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  
  titlePanel('California Groundwater'),
  tabsetPanel(
    
    tabPanel( ######################## start tab 1 #############################
              title = 'Home',
              
              includeMarkdown('home.md'),
              
              imageOutput("image1"),
       
    ), ########################### end tab 1 ##############################
    
    
    
    
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
    
    
    tabPanel( ###################### start tab 3 ###########################
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
    
    tabPanel( ############################ start tab 4 ######################
              title = 'Environmental Justice',
              
              includeMarkdown('tab4.md'),

              fluidRow( # start fluid row 4.1
                column(width = 5,
                       h4('Socioeconomic Indicator'),
                       radioButtons(
                         inputId = 'factor_4_1',
                         label = ' ',
                         choices = c('Low Birth Weight' = 'low_birth_weight', 
                                     'Cardiovascular Disease' = 'cardio_disease', 
                                     'Education' = 'education', 
                                     'Poverty' = 'poverty', 
                                     'Unemplpoyment' = 'unemployment',
                                     'CES Score' = 'ces')
                       )
                ), ### end column
                column(width = 7,
                       h4('Map of California Counties'),
                       plotOutput(outputId = 'pop_plot')
                ) ### end column
              ), ### end fluidRow 4.1
              
              hr(), ### horizontal rule so the row breaks are easier to see
              p('talk about how they should look at the map'),
              hr(),
              
              fluidRow( # start fluid row 4.2
                column(
                  width = 3,
                  h4('Indicator'),
                  radioButtons(
                    inputId = 'factor_4_2',
                    label = ' ',
                    choices = c('Low Birth Weight' = 'low_birth_weight', 
                                'Cardiovascular Disease' = 'cardio_disease', 
                                'Education' = 'education', 
                                'Poverty' = 'poverty', 
                                'Unemplpoyment' = 'unemployment',
                                'CES Score' = 'ces')
                  ) ### end radioButtons
                ), ### end column
                column(
                  width = 9,
                  h4('Indicators Across Counties'),
                  plotOutput(outputId = 'poverty_cardio_plot')
                ) ### end column
              ) ### end fluidRow 4.2
              
    ), ### end tab 4 
    
    tabPanel( ### start tab 5
      title = 'Groundwater Dependent Ecosystems',
      
      p(' If we have time :-) ')
      
    ) ### end tab 5  
  ) ### end tabsetPanel
  
) # end Fluidpage