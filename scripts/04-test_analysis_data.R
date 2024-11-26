#### Preamble ####
# Purpose: Tests cleaned bridge condition data
# Author: Ariel Xing
# Date: 25 November 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: cleaned bridge condition data
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(validate)
library(arrow)
cleaned_data <- read_parquet("data/02-analysis_data/cleaned_bridge_condition_data.parquet")

# Test if the data was successfully loaded
if (exists("data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####
rules <- validator(
  nrow(cleaned_data) > 0,                                  # Dataset must have rows
  all(!is.na(cleaned_data)),                               # No missing values in any column
  ncol(cleaned_data) >= 4,                                 # Ensure at least 4 columns exist
  all(cleaned_data$Municipality %in% c("Town", "City", "Village")), # Valid Municipality values
  all(cleaned_data$SD.FO.Status %in% c("N", "SD", "FO")),  # Valid SD.FO.Status values
  all(cleaned_data$AgeAtInspection > 0),                   # AgeAtInspection must be > 0
  all(cleaned_data$Condition >= 1 & cleaned_data$Condition <= 7), # Condition must be between 1 and 7
  n_distinct(cleaned_data$Municipality) == 3,              # Municipality column should have 3 unique values
  n_distinct(cleaned_data$SD.FO.Status) == 3               # SD.FO.Status column should have 3 unique values
)

# Evaluate the rules
results <- confront(cleaned_data, rules)

# Print summary of the validation results
summary(results)

# Show detailed violations (if any)
violations(results)

unique_municipalities <- unique(cleaned_data$Municipality)

# Print the unique Municipality values
print(unique_municipalities)
