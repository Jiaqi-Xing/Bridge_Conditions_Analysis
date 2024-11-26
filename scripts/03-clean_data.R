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

# Load raw bridge condition data
raw_data <- read_delim(
  file = "data/01-raw_data/raw_bridge_condition_data.txt",  # Path to the raw data file
  delim = "\t",                                             # Tab-separated values
  na = c("", "NA"),                                         # Treat empty strings and "NA" as missing values
  trim_ws = TRUE,                                           # Remove extra spaces around text entries
  guess_max = 20000                                         # Ensure column types are guessed correctly by sampling more rows
)

# Extract the last word from the Municipality column
raw_data <- raw_data %>%
  mutate(LastWord = str_extract(Municipality, "\\w+$"))  # Add a `LastWord` column that captures the final word in each Municipality entry

# List all unique values in the LastWord column for review
unique_last_words <- raw_data %>%
  distinct(LastWord) %>%  # Identify distinct values in the `LastWord` column
  arrange(LastWord)       # Sort the unique values alphabetically

# Optional: View the unique last words for analysis and corrections
unique_last_words

# Normalize variations of "Village" in the Municipality column
raw_data <- raw_data %>%
  mutate(
    Municipality = case_when(
      str_detect(LastWord, "^(Villag|Villa|Vil|V|Vill|Vi)$") ~ "Village",  # Replace variations of "Village" with the standard "Village"
      TRUE ~ Municipality  # Keep original values for other cases
    )
  )

# Normalize variations of "City" in the Municipality column
raw_data <- raw_data %>%
  mutate(
    Municipality = case_when(
      str_detect(LastWord, "^(Cit)$") ~ "City",  # Replace variations of "City" with the standard "City"
      TRUE ~ Municipality  # Retain original values for other cases
    )
  )

# Handle cases where the last word is "P" or "Pt"
raw_data <- raw_data %>%
  mutate(
    Municipality = case_when(
      str_detect(LastWord, "\\b(P|Pt)$") ~ str_extract(Municipality, ".*\\b(\\w+)\\b (?=P|Pt)"),  # Replace "P" or "Pt" with the word before it
      TRUE ~ Municipality  # Keep original values for other cases
    )
  )

# Retain only the normalized last word in the Municipality column
raw_data$Municipality <- str_extract(raw_data$Municipality, "\\w+$")  # Extract and overwrite the Municipality column with the last word only

# Filter and clean the dataset
cleaned_data <- raw_data %>%
  filter(AgeAtInspection > 0) %>%  # Keep rows where AgeAtInspection is greater than 0
  select(Municipality, Condition, AgeAtInspection, SD.FO.Status) %>%  # Retain only useful columns
  drop_na()  # Remove rows with missing values

# Extract and review all unique Municipality names after cleaning
unique_Municipality <- cleaned_data %>%
  distinct(Municipality) %>%  # Identify unique Municipality values in the cleaned dataset
  arrange(Municipality)       # Sort the unique values alphabetically

# Optional: View the cleaned and unique Municipality names
unique_Municipality

#### Save cleaned data to a Parquet file ####
write_parquet(cleaned_data, "data/02-analysis_data/cleaned_bridge_condition_data.parquet")  # Save the cleaned dataset in Parquet format

