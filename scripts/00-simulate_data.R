#### Preamble ####
# Purpose: Simulates a dataset of Bridge Condition data
# Author: Ariel Xing
# Date: 25 November 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `NYS_Bridge_Condition_Analysis` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(811)


#### Simulate data ####
# Municipality
municipality <- c("City", "Town", "Village")

# SD.FO.Status
SD_FO_Status <- c("N", "SD", "FO") #bridge is considered structurally deficient (SD), functionally obsolete (FO), or neither (N) 

# Predict probabilities for Municipality and SD.FO.Status
municipality_probs <- c(City = 0.5, Town = 0.3, Village = 0.2)
sd_fo_status_probs <- c(N = 0.6, SD = 0.2, FO = 0.2) 

# Create a dataset by randomly assigning municipality, SD.FO.Status, AgeAtInspection and SD.FO. status to 1000 bridges
n <- 1000
simulated_bridges <- tibble(
  Municipality = sample(municipality, n, replace = TRUE, prob = municipality_probs),
  SD.FO.Status = sample(SD_FO_Status, n, replace = TRUE, prob = sd_fo_status_probs),
  AgeAtInspection = round(rexp(n, rate = 0.05)), 
  #Expected more bridges to be constructed recently; use an exponential distribution to simulate, as it favors smaller numbers.
  Condition = round(runif(n, 1, 7), 1) # Random condition scores (1-7)
)


#### Save data ####
write_csv(simulated_bridges, "data/00-simulated_data/simulated_bridge_condition_data.csv")
