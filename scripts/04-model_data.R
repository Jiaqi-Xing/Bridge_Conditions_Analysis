#### Preamble ####
# Purpose: Models the relationship between bridge condition and explanatory variables
# Author: Ariel Xing
# Date: 26 November 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: Cleaned bridge condition data saved in Parquet format
# Any other information needed? Ensure the tidyverse and arrow packages are installed


#### Workspace setup ####
library(tidyverse)  
library(arrow)      

#### Read data ####
# Load the cleaned analysis dataset from Parquet file
#### Read data ####
bridge_data <- read_parquet("data/02-analysis_data/cleaned_bridge_condition_data.parquet")

### Model data ####

# Fit a linear model with AgeAtInspection , Located_Municipality and Owner_Group
model <- lm(Condition ~ AgeAtInspection + Located_Municipality + Owner_Group, data = bridge_data)

summary(model)

#### Save model ####
# Save the model object for future use
saveRDS(model, file = "models/regression_model.rds")
