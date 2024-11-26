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

simulated_data <- read_csv("data/00-simulated_data/simulated_bridge_condition_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####
# Test if the dataset has 1000 rows
if (nrow(simulated_data) == 1000) {
  message("Test Passed: The dataset has 1000 rows.")
} else {
  stop("Test Failed: The dataset does not have 1000 rows.")
}

# Test if the dataset has 4 columns
if (ncol(simulated_data) == 4) {
  message("Test Passed: The dataset has 4 columns.")
} else {
  stop("Test Failed: The dataset does not have 4 columns.")
}

# Check if the 'Municipality' column contains only valid types
valid_municipalities <- c("Town", "City", "Village")
if (all(simulated_data$Municipality %in% valid_municipalities)) {
  message("Test Passed: The 'Municipality' column contains only valid types.")
} else {
  stop("Test Failed: The 'Municipality' column contains invalid types.")
}

# Check if the 'SD.FO.Status' column contains only valid types
valid_sd_fo_status <- c("SD", "FO", "N")
if (all(simulated_data$SD.FO.Status %in% valid_sd_fo_status)) {
  message("Test Passed: The 'SD.FO.Status' column contains only valid types.")
} else {
  stop("Test Failed: The 'SD.FO.Status' column contains invalid types.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'Municipality' and 'SD.FO.Status' columns
if (all(simulated_data$Municipality != "" & simulated_data$SD.FO.Status != "")) {
  message("Test Passed: There are no empty strings in the 'Municipality' or 'SD.FO.Status' columns.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'SD.FO.Status' column has three unique values
if (n_distinct(simulated_data$SD.FO.Status) == 3) {
  message("Test Passed: The 'SD.FO.Status' column has three unique values.")
} else {
  stop("Test Failed: The 'SD.FO.Status' column does not have three unique values.")
}

# Check if the 'Municipality' column has three unique values
if (n_distinct(simulated_data$Municipality) == 3) {
  message("Test Passed: The 'Municipality' column has three unique values.")
} else {
  stop("Test Failed: The 'Municipality' column does not have three unique values.")
}

# Check if values in 'AgeAtInspection' column are all greater than zero
if (all(simulated_data$AgeAtInspection > 0)) {
  message("Test Passed: All values in 'AgeAtInspection' are greater than zero.")
} else {
  stop("Test Failed: Some values in 'AgeAtInspection' are not greater than zero.")
}

# Check if values in 'Condition' column are all greater than zero
if (all(simulated_data$Condition > 0)) {
  message("Test Passed: All values in 'Condition' are greater than zero.")
} else {
  stop("Test Failed: Some values in 'Condition' are not greater than zero.")
}

# Check if all values in the 'AgeAtInspection' column are not integers
if (all(simulated_bridges$AgeAtInspection %% 1 != 0)) {
  message("Test Passed: All values in 'AgeAtInspection' are not integers.")
} else {
  stop("Test Failed: Some values in 'AgeAtInspection' are integers.")
}

# Check if all values in the 'Condition' column are not integers
if (all(simulated_bridges$Condition %% 1 != 0)) {
  message("Test Passed: All values in 'Condition' are not integers.")
} else {
  stop("Test Failed: Some values in 'Condition' are integers.")
}

