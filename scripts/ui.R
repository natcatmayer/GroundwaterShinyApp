
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
              
              h4('Description:'), 
              p('This tab shows socioeconomic and health indicators mapped by percentile in each county from the CalEnviroScreen data and has been gathered between 2013-2019. An indicator measures environmental conditions as well as health and vulnerability factors. The CalEnviroScreen indicators fall into four categories: exposure, environmental, sensitive population, and socioeconomic. Here, we have selected relevant sensitive population and socioeconomic indicators, which may be correlated with groundwater quality.'),
              HTML("<ul>
              <li><b>Low Birth Weight: </b>Low birth weight is characterized by infants who weigh less than about five and a half pounds (2500 grams) at birth. Many factors, including poor nutrition, lack of prenatal care, stress, and smoking by the mother, can increase the risk of having a low birth-weight baby. Many factors can increase the risk of having a low birth-weight baby, including mothers who experience poverty, mothers who live in neighborhoods with high rates of violence or experience other stress, who do not have access to healthy foods, regular medical care, and prenatal care, and mothers who smoke. Exposure to pollution from traffic, industry, or agriculture also increases incidences of low-weight births. </li>
              <li><b>Cardiovascular Disease: </b>Cardiovascular disease is a condition in which blood vessels are blocked or narrowed and this can cause heart attacks. There are many risk factors for developing cardiovascular disease including diet, lack of exercise, smoking, and exposure to air pollution. People with heart disease may react differently to pollution than those without.</li>
              <li><b>Education:</b>Education refers to the highest level of education that an individual has attained. This is an important indicator because higher education correlates with higher income and therefore higher health standards. People with higher education tend to live longer, live in less polluted areas, and therefore experience fewer pollution-related health issues.  In California, 19% of adults over 25 do not have a high school degree, compared to 14% in the United States.</li>
              <li><b>Poverty:</b>The poverty income level is set by the US Census Bureau every year. When household income falls below that level based on the size of a household and the ages of the individuals, those individuals are considered in poverty. This indicator is included because people who experience poverty have higher exposure to pollution and therefore have higher incidences of environmental-related health issues. These individuals also lack access to regular health care, nutrient-rich foods, and often do not have healthy living and working environments. Stress caused by poverty can also lower the immune system and increase health issues from exposure to pollution.</li>
              <li><b>Unemployment:</b>Unemployment is considered anyone who is 16 years or older who is not working, but is able to work. This does not include students, active duty military, retired people, or people who have stopped looking for work. This is an important indicator because people who are not employed may not have health insurance or medical care, and that can lead to health issues, which inturn makes it more difficult to find work. Stress from long-term unemployment can lead to chronic illnesses, such as heart disease, and can shorten a person’s life.</li>
              <li><b>CES Score: </b>The CES Score is an overall score that includes all 21 indicators. To read more about how the score is calculated, please see the CalEnviroScreen website.</li>
              <li> <b>Population Density:</b> Population density is the number of residents in a location divided by the total land area.</li>
            </ul>"),
              hr(),
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
                )
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
                  )
                  
                ),
                column(
                  width = 9,
                  h4('Indicators Across Counties'),
                  plotOutput(outputId = 'poverty_cardio_plot')
                )
              ) ### end fluidRow 4.2
              
    ), ### end tab 4 
    
    tabPanel( ### start tab 5
      title = 'Groundwater Dependent Ecosystems',
      
      p(' If we have time :-) ')
      
    ) ### end tab 5  
  ) ### end tabsetPanel
  
) # end Fluidpage