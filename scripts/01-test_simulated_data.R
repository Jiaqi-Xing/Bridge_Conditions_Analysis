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

# Load simulated data
simulated_data <- read_csv("data/00-simulated_data/simulated_bridge_condition_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####
rules <- validator(
  # Dataset structure tests
  nrow(simulated_data) == 1000,                                  # Dataset must have 1000 rows
  ncol(simulated_data) == 4,                                     # Dataset must have 4 columns
  
  # Variable tests
  all(simulated_data$Located_Municipality %in% c("Town", "City", "Village")), # Valid Municipality types
  all(simulated_data$Owner_Group %in% c("NYSDOT", "Municipalities", "Other")), # Valid Owner_Group types
  all(!is.na(simulated_data)),                                   # No missing values
  all(simulated_data$Located_Municipality != "" & simulated_data$Owner_Group != ""), # No empty strings in specific columns
  
  # Value range and type tests
  all(simulated_data$AgeAtInspection > 0),                       # AgeAtInspection > 0
  all(simulated_data$Condition >= 1 & simulated_data$Condition <= 7), # Condition must be within 1-7
  any(simulated_data$AgeAtInspection %% 1 != 0),                 # AgeAtInspection contains floats
  any(simulated_data$Condition %% 1 != 0),                       # Condition contains floats
  
  # Uniqueness tests
  n_distinct(simulated_data$Located_Municipality) == 3,          # Located_Municipality must have 3 unique values
  n_distinct(simulated_data$Owner_Group) == 3                    # Owner_Group must have 3 unique values
)

# Evaluate the rules
results <- confront(simulated_data, rules)

# Print a summary of the validation results
summary(results)

