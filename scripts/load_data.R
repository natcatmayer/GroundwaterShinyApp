
library(tidyverse)
library(here)
library(sf)
library(terra)
library(tidyterra)
library(tmap)

# upload data 

nitrate <- read_tsv(here::here('data', 'ucdavis_nitrate_data.txt'))
pfos <- read_tsv(here('data', 'statewide_pfos_data.txt'))
dwr <- read_tsv(here('data', 'dwr_water_quality_data.txt'))
depth <- read_tsv(here('data', 'depth_to_water_and_groundwater_elevation_data.txt'))

enviro <- read_csv(here('data', 'SB353_tract.csv'))
enviro_all <- read_csv(here('data', 'SB353_tract_all.csv'))
tribal <- read_csv(here('data', 'SB353_tribal_area.csv'))


#### California Counties Data
ca_counties <- read_sf(here("data/ca_counties"), layer = "CA_Counties_TIGER2016") %>% 
  janitor::clean_names() %>% 
  select(name)

view(ca_counties)
#st_crs(ca_counties) 3857

#### Groundwater Depth
depth_mod <- depth %>% 
  janitor::clean_names() %>% 
  st_as_sf(coords = c("latitude", "longitude"))

st_crs(depth_mod) <- 3857

#### Groundwater Depth and Counties Map
tmap_mode(mode = "view")

map <- tm_shape(ca_counties) +
  tm_fill() +
  tm_shape(depth_mod) +
  tm_dots()

view(map)

#### California Map
counties_depth <- st_join(ca_counties, depth_mod)

ggplot(data = counties_depth) +
  geom_sf(aes(fill = depth_to_water), color = "white", size = 0.1) +
  scale_fill_gradientn(colors = c("lightgray","orange","red")) +
  labs(x = 'Latitude', y = 'Longitude')
theme_minimal()

################################CHELSEA ZONE ENDS
