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
library(arrow)

#### Clean data ####

# Load raw bridge condition data
raw_data <- read_delim(
  file = "data/01-raw_data/raw_bridge_condition_data.txt",  # Input file path for raw data
  delim = "\t",                                             # Specifies tab-separated values
  na = c("", "NA"),                                         # Treats empty strings and "NA" as missing values
  trim_ws = TRUE,                                           # Removes extra spaces around text entries
  guess_max = 20000                                         # Improves guessing of column types by sampling more rows
)

# Ensure the necessary columns are numeric and drop rows with missing values
raw_data <- raw_data %>%
  mutate(
    YearInspected = as.numeric(YearInspected),    # Convert YearInspected to numeric for calculations
    AgeAtInspection = as.numeric(AgeAtInspection), # Convert AgeAtInspection to numeric for calculations
    Built = as.numeric(Built) ) %>%                    # Convert Built to numeric for comparison
  drop_na()         

# Filter the data to check for bridges that may have been rebuilt.
# This identifies cases where the calculated construction year (YearInspected - AgeAtInspection)
# does not match the recorded "Built" year, potentially indicating a rebuild or data inconsistency.
filtered_data <- raw_data %>%
  filter(round(YearInspected - AgeAtInspection) != Built)

# Count how many rows were identified as potential rebuilds or inconsistencies.
nrow(filtered_data)

# Normalize Municipality names
raw_data <- raw_data %>%
  mutate(LastWord = str_extract(Municipality, "\\w+$")) %>%  # Add a column with the last word of Municipality
  mutate(
    Municipality = case_when(
      str_detect(LastWord, "^(Villag|Villa|Vil|V|Vill|Vi)$") ~ "Village",  # Standardize variations of "Village"
      str_detect(LastWord, "^(Cit)$") ~ "City",  # Standardize variations of "City"
      str_detect(LastWord, "\\b(P|Pt)$") ~ str_extract(Municipality, ".*\\b(\\w+)\\b (?=P|Pt)"),  # Handle "P" or "Pt"
      TRUE ~ Municipality  # Retain original values for all other cases
    )
  ) %>%
  mutate(Municipality = str_extract(Municipality, "\\w+$")) %>%  # Retain only the last cleaned word
  rename(Located_Municipality = Municipality)  # Rename Municipality to Located_Municipality for clarity

# Normalize and generalize Owner values
raw_data <- raw_data %>%
  mutate(Owner_Group = case_when(
    Owner == "NYSDOT" ~ "NYSDOT",  # Leave NYSDOT as its own category
    Owner %in% c("County", "Town", "City", "Village") ~ "Municipalities",  # Group municipalities
    TRUE ~ "Other"  # Group all other small categories as "other"
  ))

# Filter and prepare the cleaned dataset
cleaned_data <- raw_data %>%
  filter(AgeAtInspection > 0) %>%  # Remove rows where AgeAtInspection is <= 0
  select(Owner_Group, Located_Municipality, Condition, AgeAtInspection) %>%  # Retain only necessary columns
  drop_na()  # Remove rows with missing values

# Save cleaned data
write_parquet(cleaned_data, "data/02-analysis_data/cleaned_bridge_condition_data.parquet")  # Save as Parquet
