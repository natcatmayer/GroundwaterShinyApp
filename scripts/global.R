### code here will be executed before the UI and server
### include libraries and loading data 

### Attach necessary packages
library(shiny)
library(tidyverse)
library(here)
library(sf)
library(bslib)
library(shinydashboard)

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

### bar graph comparing counts by county
poverty_cardio_plot <- ggplot(data = socio_pivot, 
       aes(x = reorder(county, -percentile), y = percentile, fill = percentile)) +
  geom_col(color = "black") +
  scale_fill_gradientn(colors = c("lightgray", "orange","red")) + 
  labs(x = 'County', y = 'Percentile', fill = "Percentile") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = 'none')