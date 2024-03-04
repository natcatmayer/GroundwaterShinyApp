
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
socioeco_data <- read.csv(here('data/socioeco.csv'))

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

# Socioeconmic data wrangling 
socio_by_county <- socioeco_data %>% 
dplyr::group_by(california_county) %>% 
  summarize(total_pop = sum(total_population, na.rm = TRUE),
            ces = mean(ces_4_0_percentile, na.rm = TRUE),
            low_birth_weight = mean(low_birth_weight_pctl, na.rm = TRUE),
            cardio_disease = mean(cardiovascular_disease_pctl, na.rm = TRUE),
            education = mean(education_pctl, na.rm = TRUE),
            poverty = mean(poverty_pctl, na.rm = TRUE),
            unemployment = mean(unemployment_pctl, na.rm = TRUE))

socio_by_county$county <- socio_by_county$california_county 

socio_county <- socio_by_county %>% 
  select(-california_county) %>% 
  select(county, everything()) %>% 
  mutate(county = str_squish(county))

### counties data
ca_counties_sf2 <- ca_counties_raw_sf %>% 
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2) %>% 
  mutate(county = str_squish(county)) 
  #ca_counties_sf2 %>% st_crs() ###3857

### join the two together
county_socio_join <- merge(x = ca_counties_sf2, y = socio_county, by = "county", all.x = TRUE) %>% 
  mutate(density = total_pop/land_km2) %>%
  select('county','density', everything(), -'total_pop', -'land_km2') %>%
  pivot_longer('density':'unemployment', names_to = 'parameter', values_to = 'percentile')

### ggplot
pop_plot <- ggplot(data = county_socio_join) +
  geom_sf(aes(fill = percentile, geometry = geometry), color = "white", size = 0.1) +
  scale_fill_gradientn(colors = c("lightgray", "orange","red")) +
  theme_void() +
  labs(fill = "Population Density")

### bar graph comparing counts by county
socio_pivot <- socio_county %>% 
  pivot_longer('ces':'unemployment', names_to = 'indicator', values_to = 'percentile') %>% 
  mutate(county = as.factor(county))

poverty_cardio_plot <- ggplot(data = socio_pivot, 
                              aes(x = reorder(county, percentile), y = percentile)) +
  geom_col(position = 'dodge')  +
  labs(x = 'County', y = 'Percentile') +
  theme_minimal()

poverty_cardio_plot


################## Create the user interface: ############################
ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  
  titlePanel('California Groundwater'),
  tabsetPanel(
    
    tabPanel( ######################## start tab 1 #############################
      title = 'Home',
      
      imageOutput("image1"),
      
      img(src = "devereux_slough.png", height = 140, width = 400),
      p('Beautful image of Deveraux Slough ;-)'),
      hr(),
      
      fluidRow( # start fluid row 1.1
        
        column(width = 9,
               h2(strong("Purpose")),
               hr(),
               p("This interactive tool presents data on how groundwater depth 
                  and quality intersects with socioeconomic factors in California counties."),
               br(),
               
               h2(strong("Background")),
               hr(),
               h4("What is groundwater?"),
                       p("Groundwater makes up 99% of Earth’s liquid freshwater. 
                       Groundwater is stored in aquifers below the Earth’s surface and 
                       is one of the most important natural resources. Groundwater is 
                       used for drinking water, crop irrigation, and agricultural production. 
                       Many ecosystems and wildlife depend on groundwater, such as salamanders 
                       in wetlands and fish in rivers."),
               
               h4("How do we measure and quantify groundwater?"),
                       p("Groundwater can be challenging to monitor, being that it is underground. 
                       Groundwater wells are drilled into the ground to measure water depth, 
                       water quality, and the presence of pollutants. Long-term groundwater 
                       monitoring is important to quantify groundwater levels in aquifer 
                       basins over time and to better understand how drought and groundwater 
                       extraction is impacting this finite natural resource. Groundwater can 
                       also be easily contaminated from human activities such as leakage from 
                       landfills, agricultural or urban runoff, and atmospheric pollution, to 
                       name a few. Measuring and monitoring for pollutants and groundwater levels 
                       is crucial."),
               
                       p("Groundwater can be measured in “depth to groundwater” or “elevation.” 
                       The depth to groundwater is how deep the water lies below the Earth’s surface. 
                       Whereas, the elevation is measured by subtracting the depth to groundwater 
                       from the surface elevation."),
               
               h4("Why is this analysis needed and important?"),
                       p("Groundwater is replenished or recharged by rain or snowmelt that seeps 
                       into the Earth’s surface. However, many people in the world face water 
                       shortages due to the over extraction of groundwater at a rate that is 
                       faster than the recharge. Many people also lack access to clean drinking 
                       water as groundwater is easily polluted by a multitude of chemicals, 
                       PFAS, and toxic metals. As an important source for drinking water, 
                       irrigation for food production, and supporting groundwater-dependent 
                       ecosystems, this analysis is crucial to better understand how groundwater 
                       depth and quality impact different socioeconomic groups."),
               br(),
               
               h2(strong("Website Content")),
               hr(),
                       p(" This website is comprised of three main tabs:"),
               h4(("Tab 1: Groundwater Levels")), 
                       p("This analysis explores the currents trends in groundwater depth 
                          and elevation in all California counties."),
               
               h4(("Tab 2: Groundwater Quality")),
                       p("This analysis explores chemical pollutants impacting groundwater. 
                            Pollutants explored in this analysis include:"),
               
                                  ##### How do I make these bullet points?? #####
                                  p(tags$b("Perfluorooctanoic acid (PFOA)"), "was phased out of production in the 
                                  United States in 2002, but continues to persist in soils and water 
                                  bodies. It was previously used in non-stick and stain resistant products, 
                                  food packaging, fire-fighting foam, and for industrial purposes. Exposure 
                                  to PFOA has been linked with lower birth weights and decreased antibodies 
                                  in infants, as well as increased cholesterol, increased liver enzymes and 
                                  higher risk of kidney cancer in adults."),
                                  p(tags$b("Perfluorooctane sulfonate (PFOS)"), "was used as a surface protectant in carpets, 
                                  clothing, paper and cardboard packaging, and firefighting foam until it was phased 
                                  out of production in 2002. PFOS can enter groundwater through sewage treatment plants, 
                                  industrial sites, landfills and through firefighting foam. The California State 
                                  government claims that most California residents have detectable PFOS levels in 
                                  their blood. High concentrations of PFOS have been linked with prostate, kidney 
                                  and testicular cancers, as well as birth defects."),
                                  p(tags$b("Calcium Carbonate (CaCO3)"), "is used as an indicator for a water sample’s alkalinity. 
                                  More alkaline waters have a higher buffering capacity, meaning they can take in 
                                  relatively more acid without significant change to pH. Alkaline water is also less 
                                  likely to corrode pipes or have adverse health effects."),
                                  p(tags$b("Bicarbonate (HCO3)"), "is another indicator of a body of water’s alkalinity and 
                                  buffering capacity. "),
                                  p(tags$b("Mercury"), "is introduced to the environment through a variety of human activities 
                                  including burning coal, the production of electrical appliances, and the use of 
                                  fungicides and preservatives. Its use in developed countries has declined, but it 
                                  is still commonly used in developing countries. Mercury can methylate and accumulate 
                                  in muscle tissue and bioconcentrates up the food chain. In humans, organic mercury 
                                  can deteriorate the nervous system by causing cellular damage, dull senses, cause 
                                  involuntary movements, corrode skin and mucous membranes, and cause difficulty chewing 
                                  and swallowing. Fortunately, adverse health effects may be reversible if exposure is stopped."),
                                  p(tags$b("Nitrate"), "is extremely water soluble and readily metabolizes into nitrite which 
                                  inactivates hemoglobin and increases the risk of several cancers. It is introduced 
                                  to the water supply by fertilizers, agricultural runoff, feedlot runoff, and sewage 
                                  treatment facilities."),
                                  p("Long term exposure to", tags$b("Arsenic"), "in drinking water can cause an array of health problems 
                                  in humans: diabetes, bladder cancer, lung cancer, liver cancer, cardiovascular and 
                                  respiratory disease, inhibited brain development in children and skin problems. Arsenic
                                  is locked up in sediments but is mobilized in the presence of oxygen and dissolves into water."),
                                  p(tags$b("Lead"), "is introduced to the environment through the combustion of gasoline and through 
                                  direct mining for use in alloys like bronze and brass, and to be used in batteries. High 
                                  exposure to lead can cause reduced birth weight, premature birth, permanent brain damage 
                                  in children, and trouble forming red blood cells. Inorganic lead is exchanged with Calcium 
                                  in bones and can accumulate in skeletons at  high concentrations."),
               
               h4(("Tab 3: Environmental Justice")),
                            p("This analysis shows socioeconomic variables mapped by percentile in each county. Socioeconomic variables 
                            explored in this analysis include:"),
               
                                   ##### How do I make these bullet points?? #####
                                   p(tags$b("Population Density,
                                   CES Score,
                                   Low Birth Weight,
                                   Cardiovascular Disease,
                                   Education,
                                   Poverty,
                                   Unemployment")),
               br(),
               
               h2(strong("Data Summary")),
               hr(),
                    p("In this analysis, groundwater levels and quality across all 58 California counties are analyzed. 
                    Our analysis includes measurements from 285,273 wells of groundwater depth from the surface (ft), 
                    PFOA in (ng/L), PFOS (ng/L), Calcium Carbonate (mg/L), bicarbonate (mg/L), mercury (ug/L), nitrate 
                    (mg/L), arsenic (ug/L), and lead (ug/L)."),
               br(),
               
               h2(strong("Data Sources")),
               hr(),
               p("Groundwater depth and water quality data:"),
                      p("The Groundwater Ambient Monitoring and Assessment (GAMA) Program is California's comprehensive 
                      groundwater quality monitoring program that was created by the State Water Resources Control Board 
                      (State Water Board) in 2000. It was later expanded by Assembly Bill 599 - the Groundwater Quality 
                      Monitoring Act of 2001. AB 599 required the State Water Board, in coordination with an Interagency 
                      Task Force (ITF) and Public Advisory Committee (PAC) to improve statewide comprehensive groundwater 
                      monitoring and increase the availability of groundwater quality information to the public."),
               
               #### How do I create a hyperlink?? ####
               p("Data can be accessed:  https://gamagroundwater.waterboards.ca.gov/gama/datadownload"),
               p("Socioeconomic Data:"),
                      p("CalEnviroScreen is a screening methodology that can be used to help identify California communities 
                      that are disproportionately burdened by multiple sources of pollution. It was produced in response to 
                      Senate Bill (SB) 535 (De León, Chapter 830, Statutes of 2012), which established initial requirements 
                      for minimum funding levels to “Disadvantaged Communities” (DACs). The legislation also gives CalEPA the 
                      responsibility for identifying those communities, stating that CalEPA’s designation of disadvantaged 
                      communities must be based on “geographic, socioeconomic, public health, and environmental hazard criteria”."),
               
               #### How do I create a hyperlink?? ####
               p("Data can be accessed:  https://oehha.ca.gov/calenviroscreen/report/calenviroscreen-40"),
               br(),
               
        ), ### end column 
        
        column(width = 3,
               h3(''),
               img(src = "cts.png", height = 140, width = 400),
               p('California tiger salamander (CTS) in GDE'),
               hr(),
               
               
               h3(''),
               img(src = "cts.png", height = 140, width = 400),
               p('California red-legged frog (CRLF) in GDE'),
               hr(),
               
               # tags$figure(
               #   class = "centerFigure",
               #   tags$img(
               #     src = "cts.jpg",
               #     width = 600,
               #     alt = "California tiger salamander (CTS)"
               #   ),
               #   tags$figcaption("California tiger salamander (CTS)"))
        ) ### end column 
      ), ### end fluidRow 1.1
      
      
      
      hr(), ### horizontal rule so the row breaks are easier to see
      p('Developed by Natalie Mayer, Chelsea Sanford, and Madi Calbert'),
      hr()
      
      
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
  
  ### START tab 4, row 1
  soc_select <- reactive({ ### start soc_select
    soc_df <- county_socio_join %>% 
      filter(parameter == input$factor_4_1)
    return(soc_df)
  }) ### end soc_select
  
  output$pop_plot <- renderPlot({ ### start ces_plot
    ggplot(data = soc_select()) +
      geom_sf(aes(fill = percentile, geometry = geometry), color = "white", size = 0.1) +
      labs(fill = "Percentile") +
      scale_fill_gradientn(colors = c("lightgray", "orange","red")) +
      theme_void() 
    
  }) ### end ces_plot
  ### END tab 4, row 1
  
  ### START tab 4, row 2
  soc_bar <- reactive({ ### start soc_bar
    soc_df_bar <- socio_pivot %>% 
      filter(indicator == input$factor_4_2)
    return(soc_df_bar)
  }) ### end soc_bar
  
  output$poverty_cardio_plot <- renderPlot({ ### start poverty_cardio_plot
    ggplot(data = soc_bar(), 
           aes(x = reorder(county, -percentile), y = percentile, fill = percentile)) +
      geom_col(color = "black") +
      scale_fill_gradientn(colors = c("lightgray", "orange","red")) + 
      labs(x = 'County', y = 'Percentile', fill = "Percentile") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
            legend.position = 'none')
    
  }) ### end poverty_cardio_plot
  
  ### END tab 4, row 2
  
  
  
}

### Combine them into an app:
shinyApp(ui = ui, server = server)

  
### Home Page 

### Groundwater depth levels 

### Chemicals 

### Socioeconomic 

### groundwater dependent ecosystems ? 