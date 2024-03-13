
################## Create the user interface: ############################
ui <- fluidPage(
  theme = bs_theme(bootswatch = 'cerulean'),
  
  titlePanel('California Groundwater'),
  tabsetPanel(
    
    tabPanel( ######################## start tab 1 #############################
              icon("home"),
              
              tags$img(src="clara.jpg", width="100%",height="360px", align = "justify"),
              p(em("The Santa Clara River, Ventura County. Photo Credit: The Nature Conservancy.", style = "font-size:12px")),
              hr(),
              
              fluidRow( ### start fluidRow 1
                    column(width=8,
                            h4(strong("Purpose"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
                            p("This interactive tool presents data on how groundwater depth and groundwater quality
                              intersects with socioeconomic factors in California counties."), # End paragraph 1 
                            br(), # Line break
                       
                            h4(strong("Background"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
                            includeMarkdown('background.md')
                       
                          ), ### end column 
                  
                
                    column(style="text-align:justify;color:#003366;background-color:#6699CC;padding:15px;border-radius:10px",
                             br(),
                            tags$img(src="pump.jpeg", width="455px",height="320px", align = "justify"), 
                            br(),
                            p(em("Credit: California Department of Water Resources.", style="text-align:justify;font-size:12px")),
                            br(),
                  
                            tags$img(src="monitor.jpeg", width="455px",height="320px", align = "justify"), 
                            br(),
                            p(em("Credit: California Department of Water Resources.", style="text-align:justify;font-size:12px")),
                            width=4,
                           ) ### end column 
                      ), ### end fluidRow 1
              hr(),
              
              
              
              fluidRow( ### start fluidRow 2
                
                column(width=4, 
                         tags$img(src="simple_fig.jpeg", width="350px",height="300px", align = "justify"), 
                         p(em("Figure 1: Groundwater and Water Table diagram", style="text-align:justify;font-size:12px")),
                         p(em("Photo Credit: Cornell University Northeast Regional Climate Center", style="text-align:justify;font-size:12px")),
                  ), ### end column
                  
                  column(width=4, 
                         tags$img(src="hydro_cycle.jpeg", width="500px",height="300px", align = "justify"),  
                         p(em("Figure 2: The Hydrologic Cycle", style="text-align:justify;font-size:12px")), 
                         p(em("Photo Credit: Lumen Learning - Hydrology Module", style="text-align:justify;font-size:12px"))
                  ) ### end column
              ), ### end fluidRow 2
              hr(),
              
              
              
              fluidRow( ### start fluidRow 3
                column(width=8,
                       h4(strong("Website Content"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
                            p(" This website is comprised of three main tabs:"),
                                p(tags$b("Tab 1 - Groundwater Levels")), 
                                p("This analysis explores the currents trends in groundwater depth 
                                and elevation in all California counties."),
                                p(tags$b("Tab 2 - Groundwater Quality")),
                                p("This analysis explores chemical pollutants impacting groundwater."),
                                p(tags$b("Tab 3 - Environmental Justice")),
                                p("This analysis shows socioeconomic variables mapped by percentile in each county. Socioeconomic variables 
                                explore in this analysis include:"),
                            br(), # Line break
                       
                       h4(strong("Data Source"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
                            p("In this analysis, groundwater levels and quality across all 58 California counties are analyzed. 
                            Our analysis includes measurements from 285,273 wells of groundwater depth from the surface (ft), 
                            PFOA in (ng/L), PFOS (ng/L), Calcium Carbonate (mg/L), bicarbonate (mg/L), mercury (ug/L), nitrate 
                            (mg/L), arsenic (ug/L), and lead (ug/L)."),     
                       
                            p(strong("Groundwater depth and water quality data:")),
                            p("The Groundwater Ambient Monitoring and Assessment (GAMA) Program is California's comprehensive 
                            groundwater quality monitoring program that was created by the State Water Resources Control Board 
                            (State Water Board) in 2000. It was later expanded by Assembly Bill 599 - the Groundwater Quality 
                            Monitoring Act of 2001. AB 599 required the State Water Board, in coordination with an Interagency 
                            Task Force (ITF) and Public Advisory Committee (PAC) to improve statewide comprehensive groundwater 
                            monitoring and increase the availability of groundwater quality information to the public."),
                       
                       
                            p(strong("Socioeconomic Data:")),
                            p("CalEnviroScreen is a screening methodology that can be used to help identify California communities 
                              that are disproportionately burdened by multiple sources of pollution. It was produced in response to 
                              Senate Bill (SB) 535 (De León, Chapter 830, Statutes of 2012), which established initial requirements 
                              for minimum funding levels to “Disadvantaged Communities” (DACs). The legislation also gives CalEPA the 
                              responsibility for identifying those communities, stating that CalEPA’s designation of disadvantaged 
                              communities must be based on “geographic, socioeconomic, public health, and environmental hazard criteria”.")
                ), ### end column 
                
                column(style="text-align:justify;color:#003366;background-color:#6699CC;padding:15px;border-radius:10px",
                       br(), 
                       tags$img(src="GWBasins.JPG", width="455px",height="470px", align = "justify"), 
                       br(),
                       p(em("Map of California Groundwater Basins. Credit: California Department of Water Resources.", style="text-align:justify;font-size:12px")),
                       br(), 
                       
                       tags$img(src="swrcb_logo.png", width="300px",height="100px", align = "justify"), 
                       br(),
                       br(),
                       br(),
                       tags$img(src="calenviroscreenlogo.png", width="400px",height="150px", align = "justify"), 
                       br(),
                       width=4,
                ) ### end column
              ), ### end fluidRow 3
            
              br(),
              p(em("Developed by Natalie Mayer, Chelsea Sanford, and Madi Calbert"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
              
              tags$img(src="water.jpeg", width="100%",height="150px", align = "justify"),
              br(),
              br()
             
       
            ), ########################### end tab 1 ##############################
    
    
    
    
    tabPanel( ########################## start tab 2 ################################
      title = 'Groundwater Levels',
      
      # tags$img(src="casitas.png", width="100%",height="300px", align = "justify"),
      # p(em("Lake Casitas in Ventura County. Photo Credit: Casitas Municipal Water District", style="text-align:justify;font-size:12px")),
      # hr(),
      
      br(),
      h4(strong('Southern California Groundwater Depth by County'), 
         style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
      fluidRow( # start fluid row 2.1
        
        
        column(width = 8,
               br(),
               br(),
               br(),
               plotOutput(outputId = 'gw_plot'),
              
               sliderInput("year_2_1", label = h3("Select Year"), min = 1985, 
                           max = 2023, value = 2023, sep = "")
        ),
        
        column(style="text-align:justify;color:#FFFFFF;background-color:#6699CC;padding:15px;border-radius:10px",
               includeMarkdown('tab_2.md'),
               tags$img(src="aqueduct.jpeg", width="455px",height="250px", align = "justify"),
               p(em("California Aqueduct. Photo Credit: Public Policy Institute of California.", style="text-align:justify;font-size:12px")),
               width=4,
               
        ) ### end column 
      ), ### end fluidRow 2.1
    
      
      hr(), ### horizontal rule so the row breaks are easier to see
        p('In a typical year, groundwater makes up about 40% of California’s total water supply. 
        In a drought year, that number can exceed 60%. Groundwater is an essential resource in shielding 
        Californians from the impacts of severe drought and human-caused climate change. Unfortunately, over-extracting groundwater has its consequences. According to the California Sustainable 
        Groundwater Management Act, which passed in 2014, the undesirable results of lowering groundwater levels 
        include reduction of storage, seawater intrusion, degraded water quality, land subsidence, and surface water 
        depletion.', style="text-align:justify;color:#FFFFFF;background-color:#6699CC;padding:15px;border-radius:10px"),
      hr(),
      
      fluidRow( # start fluid row 2.2
        
        column(
          width = 9,
          plotOutput(outputId = 'gw_plot_2')),
        
        column(
          width = 3,
          
          
          selectInput("county_2_2", label = h3("Select County"),
                      choices = unique(depth_avg$name),
                      selected = 1)
        ), # end column
        
      ), ### end fluidRow 2.2
      
      br(),
      p(em("Developed by Natalie Mayer, Chelsea Sanford, and Madi Calbert"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
      tags$img(src="water.jpeg", width="100%",height="150px", align = "justify"),
      br(),
      br(),
      
    ), ############################## end tab 2 #############################
    
    
    
    tabPanel( ######################### start tab 3 #############################
      title = 'Groundwater Quality',
      
      br(),
      h4(strong('Southern California Groundwater Quality by County'), 
         style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
      fluidRow(
        column(width = 8, 
          p("One of the solutions for groundwater depletion in California is Flood Managed Aquifer Recharge (MAR). 
      In Flood-MAR, landowners voluntarily flooding their land during high precipitation events, allowing the 
      water to infiltrate the soil, percolate downward, and recharge California’s aquifers. A limiting factor 
      that could disqualify otherwise optimal locations for participating in flood-MAR is what elements are 
      present in the soil. Soluble compounds present in high concentrations in the soil are likely to dissolve 
      into the water and contaminate the groundwater as it recharges the aquifer. Due to human activities such 
      as pesticide and fertilizer use in agriculture, wastewater treatment, and other chemical industrial processes, 
      soils and surface waters can contain many harmful compounds. Elements of concern include Lead, Copper, Mercury,
      and Arsenic. Unfortunately, the California State Water Resources Control Board lacks consistent historical data 
      for these chemicals across the state.", 
            style="text-align:justify;color:#FFFFFF;background-color:#6699CC;padding:15px;border-radius:10px"),
        ), ### end column
        
        column(width = 4,
          tags$img(src="flood_mar.jpeg", width="400px",height="250px", align = "justify"),
          p(em("Flooded Vineyards in California. Photo Credit: Sustainable Conservation", 
               style="text-align:justify;font-size:12px")),
        )
      ), ### end fluidRow
      
      hr(),
      
      
      fluidRow( # start fluid row 3.1
        
        column(width = 8,
               
               plotOutput('chemical_map')
        ), ### end column
        
        column(width = 2,
               
               radioButtons(
                 inputId = 'year_3_1', 
                 label = h4("Select Year"), 
                 choices = unique(quality_avg$year) %>% sort(),
                 selected = 1)
               
        ), ### end column
        
        column(width = 2,
               
               radioButtons(
                 inputId = 'chemical_3_1',
                 label = h4('Select Indicator'),
                 choices = c("PFOS (ng/L)" = "Perfluorooctane sulfonate (PFOS)", 
                             "PFOA (ng/L)" = "Perfluorooctanoic acid (PFOA)", 
                             "Alkalinity (mg/L)" = "Alkalinity as CaCO3", 
                             "Boron (mg/L)" = "Boron", 
                             "Chloride (mg/L)" = "Chloride")),
               
        ), ### end column
        
      ), ### end fluidRow 3.1
      hr(), ### horizontal rule so the row breaks are easier to see
      
      fluidRow(
        column(width = 8, 
          includeMarkdown('chem_descriptions.md')
        ),
        
        column(width = 4, style="text-align:justify;color:#FFFFFF;background-color:#6699CC;padding:15px;border-radius:10px",
               br(),
               tags$img(src="table.png", width="455",height="200px", align = "justify"),
               p(em("Table 1: EPA Safe Concentrations of Chemicals", style="text-align:justify;font-size:12px")),
               br(),
               tags$img(src="contaminants_fig.jpeg", width="455px",height="300px", align = "justify"),
               p(em("Groundwater Contamination. Photo Credit: FilterWater.com.", 
                    style="text-align:justify;font-size:12px")),
               ),
      ), ### end fluidRow
      
      
      hr(),
      
      fluidRow( # start fluid row 3.2
        column(
          width = 3,
          
          selectInput("county_3_2", label = h3("Select County"),
                      choices = unique(quality_avg$name),
                      selected = "Los Angeles"),
          
          checkboxGroupInput(
            inputId = 'chemical_3_2',
            label = h3('Select Chemical'),
            choices = c("PFOS (ng/L)" = "Perfluorooctane sulfonate (PFOS)", 
                        "PFOA (ng/L)" = "Perfluorooctanoic acid (PFOA)", 
                        "Alkalinity as CaCO3 (mg/L)" = "Alkalinity as CaCO3", 
                        "Boron (mg/L)" = "Boron", "Chloride (mg/L)" = "Chloride"),
            selected = "Perfluorooctane sulfonate (PFOS)"),
          
          
          hr(),
          fluidRow(column(3, verbatimTextOutput("value")))
          
        ), # end column
        
        column(
          width = 9,
          h3(''),
          plotOutput('chemical_plot'))
      ), ### end fluidRow 3.2
      
      br(),
      p(em("Developed by Natalie Mayer, Chelsea Sanford, and Madi Calbert"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
      tags$img(src="water.jpeg", width="100%",height="150px", align = "justify"),
      br(),
      br()
      
    ), ############################ end tab 3  ###########################
    
    
    
    
    
    tabPanel( ################# start tab 4 ###########################
      title = 'Environmental Justice',
      
      br(),
      h4(strong("Socioeconomic & Health Indicators"), 
         style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
      
      hr(),
      
      fluidRow( # start fluid row 4.1
        column(width = 3,
               h5('Socioeconomic Indicator'),
               radioButtons(
                 inputId = 'factor_4_1',
                 label = ' ',
                 choices = c('Low Birth Weight' = 'low_birth_weight', 
                             'Cardiovascular Disease' = 'cardio_disease', 
                             'Education' = 'education', 
                             'Poverty' = 'poverty', 
                             'Unemplpoyment' = 'unemployment',
                             'CES Score' = 'ces')
               ) ### end radioButtons
        ), ### end column
        
        column(width = 5,
               h5('Map of California Counties'),
               plotOutput(outputId = 'socio_plot')
        ), ### end column
        
        column(width = 4,
               h5('Indicators Across Counties'),
               plotOutput(outputId = 'ces_barplot')
        ) ### end column
      ), ### end fluidRow 4.1
      
      hr(),
      
      
      fluidRow( ### start fluidRow 4.2
        column(width=8,
               
               includeMarkdown('tab4.md')
        ), ### end column 
        
        
        column(style="text-align:justify;color:#003366;background-color:#6699CC;padding:15px;border-radius:10px",
               br(),
               tags$img(src="clean_water.jpeg", width="455px",height="320px", align = "justify"), 
               br(),
               p(em("Credit: Centers for Disease Control and Prevention.", style="text-align:justify;font-size:12px")),
               br(),
               
               br(),
               tags$img(src="dirty_groundwater.jpeg", width="455px",height="320px", align = "justify"), 
               br(),
               p(em("Credit: All American Environmental.", style="text-align:justify;font-size:12px")),
               br(),
               width=4,
        ) ### end column 
      ), ### end fluidRow 4.2
     
      
     
      fluidRow( # start fluid row 4.2
        column(
          width = 4,
          # h4('Indicator'),
          # radioButtons(
          #   inputId = 'factor_4_2',
          #   label = ' ',
          #   choices = c('Low Birth Weight' = 'low_birth_weight',
          #                         'Cardiovascular Disease' = 'cardio_disease',
          #                         'Education' = 'education',
          #                         'Poverty' = 'poverty',
          #                         'Unemplpoyment' = 'unemployment',
          #                         'CES Score' = 'ces')
          # ) ### end radioButtons
        ), ### end column
        
        column(
          width = 7,
          #h4('Indicators Across Counties'),
          #plotOutput(outputId = 'poverty_cardio_plot')
        ) ### end column
      
        ), ### end fluidRow 4.2
      
      br(),
      p(em("Developed by Natalie Mayer, Chelsea Sanford, and Madi Calbert"), style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
      tags$img(src="water.jpeg", width="100%",height="150px", align = "justify"),
      br(),
      br()
      
    ), ############################# end tab 4 ##########################
    
    
    tabPanel( ####################### start tab 5 ####################
      title = "Sustainable Groundwater Management Act",
      
      br(),
      h4(strong("Socioeconomic & Health Indicators"), 
         style="text-align:justify;color:#FFFFFF;background-color:#003366;padding:15px;border-radius:10px"),
      
              fluidRow(
                
                column(width = 3, 
                       
                       selectInput("county_ts", label = h3("Select County"), 
                                   choices = unique(depth_ts$name), 
                                   selected = "Santa Barbara"),
                       
                ),  ### end column 1
                
                column(width = 9, 
                       
                       plotOutput(outputId = 'time_series')
                       
                ) ### end column 2
              ) ### end fluidRow
              
    ) ####################### end tab 5 ####################
    
  ) ### end tabsetPanel
  
) # end Fluidpage