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
