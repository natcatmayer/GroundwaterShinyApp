
library(tidyverse)
library(here)
library(sf)
library(terra)
library(tidyterra)
library(tmap)

# load water data 

pfos <- read_tsv(here('data', 'water_quality', 'statewide_pfos_data.txt'))
dwr <- read_tsv(here('data', 'water_quality', 'dwr_water_quality_data.txt'))
groundwater_depth <- read_csv(here('data', 'groundwater_depth.csv'))

# clean groundwater data 
depth_df <- groundwater_depth %>%
  filter(year >= 2022) %>%
  distinct(.keep_all = TRUE) %>%
  drop_na()


depth_df %>% write_csv(here('data', 'groundwater_depth.csv'))


# clean pfos data 
pfos_df <- pfos %>%
  select(chemical = GM_CHEMICAL_NAME,
         date = GM_SAMP_COLLECTION_DATE,
         latitude = GM_LATITUDE, 
         longitude = GM_LONGITUDE, 
         measurement = GM_RESULT, 
         units = GM_CHEMICAL_UNITS) %>%
  filter(chemical ==  c("Perfluorooctanoic acid (PFOA)", "Perfluorooctane sulfonate (PFOS)"))


# clean dwr data 
dwr_df <- dwr %>%
  select(chemical = GM_CHEMICAL_NAME, 
         date = GM_SAMP_COLLECTION_DATE,
         measurement = GM_RESULT,
         units = GM_CHEMICAL_UNITS, 
         latitude = GM_LATITUDE, 
         longitude = GM_LONGITUDE) %>%
  filter(chemical == c("Nitrate as N", 
                       "Lead", 
                       "Arsenic", 
                       "Alkalinity as CaCO3", 
                       "Mercury", 
                       "bicarbonate HCO3"))

# join dwr and pfos data 

water_quality <- full_join(pfos_df, dwr_df, by = NULL) %>%
  mutate(date = lubridate::mdy(date)) 

water_quality %>% write_csv(here('data', 'water_quality.csv'))














