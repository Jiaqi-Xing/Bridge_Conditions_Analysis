#### Preamble ####
# Purpose: Tests the structure and validity of the simulated bridge condition data 
# Author: Ariel Xing
# Date: 25 November 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `NYS_Bridge_Condition_Analysis` rproj


#### Workspace setup ####
library(tidyverse)
library(validate)

simulated_data <- read_csv("data/00-simulated_data/simulated_bridge_condition_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####
rules <- validator(
  exists("simulated_data"),                                      # Test if the dataset was successfully loaded
  nrow(simulated_data) == 1000,                                  # Dataset must have 1000 rows
  ncol(simulated_data) == 4,                                     # Dataset must have 4 columns
  all(simulated_data$Municipality %in% c("Town", "City", "Village")), # Valid Municipality types
  all(simulated_data$SD.FO.Status %in% c("SD", "FO", "N")),      # Valid SD.FO.Status types
  all(!is.na(simulated_data)),                                   # No missing values
  all(simulated_data$Municipality != "" & simulated_data$SD.FO.Status != ""), # No empty strings in specific columns
  n_distinct(simulated_data$SD.FO.Status) == 3,                  # SD.FO.Status must have 3 unique values
  n_distinct(simulated_data$Municipality) == 3,                  # Municipality must have 3 unique values
  all(simulated_data$AgeAtInspection > 0),                       # AgeAtInspection > 0
  all(simulated_data$Condition > 0),                             # Condition > 0
  all(simulated_data$AgeAtInspection %% 1 != 0),                 # AgeAtInspection must not contain integers
  all(simulated_data$Condition %% 1 != 0)                        # Condition must not contain integers
)

# Evaluate the rules
results <- confront(simulated_data, rules)

# Print a summary of the validation results
summary(results)

