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
  all(cleaned_data$Located_Municipality %in% c("Town", "City", "Village")), # Valid Located_Municipality values
  all(cleaned_data$Owner_Group %in% c("NYSDOT", "Municipalities", "Other")), # Valid Owner_Group values
  all(cleaned_data$AgeAtInspection > 0),                   # AgeAtInspection must be > 0
  all(cleaned_data$Condition >= 1 & cleaned_data$Condition <= 7), # Condition must be between 1 and 7
  n_distinct(cleaned_data$Located_Municipality) == 3,      # Located_Municipality should have 3 unique values
  n_distinct(cleaned_data$Owner_Group) == 3                # Owner_Group should have 3 unique values
)

# Evaluate the rules
results <- confront(cleaned_data, rules)

# Print summary of the validation results
summary(results)
