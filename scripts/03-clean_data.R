#### Preamble ####
# Purpose: Cleans the raw bridge conditions data
# Author: Ariel Xing
# Date: 24 November 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: raw bridge conditions data
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(stringr)
library(arrow)

#### Clean data ####

# Read the data 
raw_data <- read_delim(
  file = "data/01-raw_data/raw_bridge_conditions_data.txt",
  delim = "\t",              # Tab delimiter
  na = c("", "NA"),          # Treat blanks as NA
  trim_ws = TRUE,            # Trim whitespace
  guess_max = 20000          # Ensure guessing column types works for all rows
)

# Modify the Municipality column to keep only the last word
raw_data$Municipality <- str_extract(raw_data$Municipality, "\\w+$")

# Extract useful columns and remove N/A
cleaned_data <- raw_data %>%
  filter(AgeAtInspection > 0) %>%
  select(Municipality, Condition, AgeAtInspection, SD.FO.Status) %>%
  drop_na()

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/cleaned_bridge_condition_data.parquet")
