### code here will be executed before the UI and server
### include libraries and loading data 

### Attach necessary packages
library(shiny)
library(tidyverse)
library(here)
library(sf)
library(bslib)
library(shinydashboard)
library(tsibble)
library(feasts)
library(fable)
library(markdown)
library(fabletools)

### Data

ca_counties_raw_sf <- read_sf(here("data/ca_counties/CA_Counties_TIGER2016.shp"))
socioeco_data <- read.csv(here('data/socioeco.csv'))

ca_counties_sf <- ca_counties_raw_sf %>% 
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2)

### Socioeconmic data wrangling 
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
  mutate(county = str_squish(county)) %>% 
  filter(county %in% c('Imperial', 'Kern', 'Los Angeles', 
                       'Orange', 'Riverside', 'San Bernardino',
                       'San Diego', 'San Luis Obispo', 'Santa Barbara', 'Ventura'))

### counties data
ca_counties_sf <- ca_counties_raw_sf %>% 
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2) %>% 
  mutate(county = str_squish(county)) %>% 
  filter(county %in% c('Imperial', 'Kern', 'Los Angeles', 
                       'Orange', 'Riverside', 'San Bernardino',
                       'San Diego', 'San Luis Obispo', 'Santa Barbara', 'Ventura'))
# ca_counties_sf %>% st_crs() ###3857

### join the two together
county_socio_join <- merge(x = ca_counties_sf, 
                           y = socio_county, by = "county", all.x = TRUE) %>% 
  select('county', everything(), -'land_km2') %>%
  pivot_longer('ces':'unemployment', names_to = 'parameter', values_to = 'percentile') %>% 
  mutate(county = as.factor(county))

## tab 2 data load 


quality_avg_csv <- read_csv(here('data', 'quality_avg.csv'))
depth_avg <- read_sf(dsn = here('data', 'depth_average.gpkg'))
county_shapes <- read_sf(dsn = here('data', 'so_cal_county_shape.gpkg'))
epa_levels <- read_csv(here('data', 'epa_levels.csv')) %>% janitor::clean_names()


quality_avg <- ca_counties_sf %>%
  left_join(quality_avg_csv, by = c('county' = 'name')) %>%
  select(-land_km2) %>%
  rename(name = county)

## predictions load data

depth_ts <- depth_avg %>%
  mutate(year = as.numeric(year)) %>%
  as_tsibble(key = name, index = year)