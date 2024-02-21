
library(tidyverse)
library(here)
library(sf)

# load water data 

water_quality <- read_csv(here('data', 'water_quality.csv'))
depth_df <- read_csv(here('data', 'groundwater_depth.csv'))
ca_counties_raw_sf <- read_sf(here("data/ca_counties/CA_Counties_TIGER2016.shp"))

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
  group_by(county) %>%
  summarise(average_depth = mean(depth_to_water))

