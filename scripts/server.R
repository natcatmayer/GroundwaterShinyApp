server <- function(input, output, session) {
  
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
    gw_county_df <- depth_avg %>%
      filter(year %in% input$year_2_1)
    
    return(gw_county_df)
  }) ### end gw_select
  
  output$gw_plot <- renderPlot({ ### start gw_plot
    ggplot(data = gw_select()) + 
      geom_sf(data = county_shapes, color = "black", size = 0.5, fill = "white") +
      geom_sf(aes(fill = average_depth), color = "black", size = 0.5) + 
      scale_fill_continuous(low = "lightblue", high = "navy", guide = "colorbar", na.value = "white") + 
      geom_sf_label(aes(label = name)) +
      theme_void() + 
      labs(fill = 'Groundwater Depth (ft)') +
      theme(axis.text.x = element_blank(), 
            axis.text.y = element_blank())
  }) ### end gw_plot
  ### END tab 2, row 1 
  
  ### START tab 2, row 2
  
  gw_select_1 <- reactive({
    gw_county_df_1 <- depth_avg %>%
      filter(name %in% input$county_2_2)
    
  })  ### end gw_select_1
  
  theme_groundwater <- function(base_size = 11, base_family = "") {
    theme_bw() %+replace%
      theme(
        panel.background = element_rect(fill = "lightblue")
      )
  }
  
  
  output$gw_plot_2 <- renderPlot({
    ggplot(data = gw_select_1(), aes(x = year, y = average_depth)) + 
      geom_col(fill = "tan3") + 
      scale_y_continuous(trans = "reverse", expand = c(0,0), limits = c(200,0)) +
      labs(x = " ", 
           y = "Average Depth to Groundwater") +
      theme_groundwater() +
      theme(axis.text.x = element_text(angle = 45, size = 12, vjust = -0.1), 
            axis.text.y = element_text(size = 12), 
            axis.title=element_text(size=18,face="bold", hjust = -0.2, vjust = 1)) +
      scale_x_discrete(breaks=seq(1985, 2023, 2))
  })
  
  ### END tab 2, row 2
  
  ### START tab 3, row 1
  
  observeEvent(input$chemical_3_1, {
    relevant_years <- quality_avg %>% 
      filter(chemical == input$chemical_3_1) 
    
    year_vec <- relevant_years$year %>% sort() %>% unique()
    
    updateRadioButtons(
      inputId = 'year_3_1',
      choices = year_vec
    )
  })
  
  county_chemical_select_1 <- reactive({
    county_chemical_df_1 <- quality_avg %>%
      filter(chemical == input$chemical_3_1) %>%
      filter(year %in% input$year_3_1)
    
    return(county_chemical_df_1)
  }) ### end county_chemical_select_1
  
  output$chemical_map <- renderPlot({
    ggplot(data = county_chemical_select_1()) + 
      geom_sf(data = county_shapes, color = "black", size = 0.5, fill = "white") +
      geom_sf(aes(fill = avg_measure), color = "black", size = 0.5) + 
      geom_sf_label(aes(label = name)) +
      scale_fill_continuous(low = "lightblue", high = "tan4", guide = "colorbar", na.value = "white") + 
      labs(fill = 'Groundwater Concentration') + 
      theme_void() + 
      theme(axis.text.x = element_blank(), 
            axis.text.y = element_blank())
  })
  
  ### END tab 3, row 1
  
  ### START tab 3, row 2
  
  county_chemical_select <- reactive({
    county_chemical_df <- quality_avg %>%
      filter(chemical %in% input$chemical_3_2) %>%
      filter(name == input$county_3_2)
    
    return(county_chemical_df)
  }) ### end county chemical select 
  
  color_vec <- c("Perfluorooctane sulfonate (PFOS)" = "green4", 
                 "Perfluorooctanoic acid (PFOA)" = "pink2", 
                 "Alkalinity as CaCO3" = "lightblue", 
                 "Boron" = "steelblue3", "Chloride" = "lightgreen" )
  
  epa_level_select <- reactive({
    epa_level_df <- epa_levels %>%
      filter(chemical %in% input$chemical_3_2)
    
    print(epa_level_df)
    return(epa_level_df)
  })
  
  output$chemical_plot <- renderPlot({
    ggplot(data = county_chemical_select()) + 
      geom_col(aes(x = year, y = avg_measure, fill = chemical), position = "dodge") +
      geom_hline(data = epa_level_select(), aes(yintercept = level, linetype = chemical, color = chemical), size = 1) +
      scale_color_manual(values = color_vec) +
      scale_fill_manual(values = color_vec) +
      #scale_fill_brewer(palette = 'Paired') +
      theme_minimal() + 
      labs(x = "", y = "Average Concentration", fill = "Chemical") +
      theme(axis.text.x = element_text(size = 12), 
            axis.text.y = element_text(size = 12), 
            axis.title = element_text(size = 14, face = "bold"))
  })
  
  ### END tab 3, row 2
  
  ### START tab 4, row 1
  soc_select <- reactive({ ### start soc_select
    soc_df <- county_socio_join %>% 
      filter(parameter == input$factor_4_1)
    return(soc_df)
  }) ### end soc_select
  
  output$socio_plot <- renderPlot({ ### start ces_plot
    ggplot(data = soc_select()) +
      geom_sf(aes(fill = percentile, geometry = geometry), color = "white", size = 0.1) +
      labs(fill = "Percentile") +
      scale_fill_gradientn(colors = c("lightgray", "darkorange","red4")) +
      theme_void() +
      theme(legend.position = 'none')
  }) ### end socio_plot
  
  output$ces_barplot <- renderPlot({ ### start ces_barplot
    ggplot(data = soc_select(), 
           aes(x = reorder(county, -percentile), 
               y = percentile, fill = percentile)) +
      geom_col(color = "black") +
      scale_fill_gradientn(colors = c("lightgray", "darkorange","red4")) + 
      labs(x = 'County', y = 'Percentile', fill = "Percentile") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
            legend.position = 'none') +
      theme(text = element_text(size = 15))
  }) ### end ces_barplot
  
  ### END tab 4, row 1
  
  
  
}
