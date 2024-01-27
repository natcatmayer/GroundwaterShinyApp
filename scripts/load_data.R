
library(tidyverse)
library(here)

# upload data 

nitrate <- read_tsv(here::here('data', 'ucdavis_nitrate_data.txt'))
pfos <- read_tsv(here('data', 'statewide_pfos_data.txt'))
dwr <- read_tsv(here('data', 'dwr_water_quality_data.txt'))
depth <- read_tsv(here('data', 'depth_to_water_and_groundwater_elevation_data.txt'))

enviro <- read_csv(here('data', 'SB353_tract.csv'))
enviro_all <- read_csv(here('data', 'SB353_tract_all.csv'))
tribal <- read_csv(here('data', 'SB353_tribal_area.csv'))





