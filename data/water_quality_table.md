library(tidyverse)
library(here)
library(kableExtra)

epa_levels <- read_csv(here('data', 'epa_levels.csv'))

epa_levels %>%
kbl() %>%
kable_classic()