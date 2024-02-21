library(tmap)

county_gw_avg <- county_gw %>%
  drop_na() %>%
  group_by(county) %>%
  summarise(average_depth = mean(depth_to_water))


gw_county_map <- ggplot(data = county_gw) + 
  geom_sf(aes(fill = depth_to_water), color = "white", size = 0.1) + 
  scale_fill_gradientn(colors = c("lightgray", "yellow", "orange", "red")) + 
  theme_minimal() + 
  labs(fill = 'Groundwater Depth')