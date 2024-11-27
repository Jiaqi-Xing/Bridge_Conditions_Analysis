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

# Located_Municipality
located_municipality <- c("City", "Town", "Village")

# Owner_Group
owner_group <- c("NYSDOT", "Municipalities", "Other") #bridge is considered structurally deficient (SD), functionally obsolete (FO), or neither (N) 

# Predict probabilities for Municipality and SD.FO.Status
located_municipality_probs <- c(City = 0.5, Town = 0.3, Village = 0.2)
owner_group_probs <- c(NYSDOT = 0.5, Municipalities = 0.4, Other = 0.1) 

# Number of bridges
n <- 1000

# Create a simulated dataset
simulated_bridges <- tibble(
  Located_Municipality = sample(located_municipality, n, replace = TRUE, prob = located_municipality_probs),  # Random assignment of municipality
  Owner_Group = sample(owner_group, n, replace = TRUE, prob = owner_group_probs),  # Random assignment of owner group
  AgeAtInspection = rexp(n, rate = 0.05) 
  # Expect more bridges are recently built, and age must be >0, which this distribution satisfies.
)

# Simulate Condition based on AgeAtInspection with noise
simulated_bridges <- simulated_bridges %>%
  mutate(
    Condition = 7 - (AgeAtInspection / 20) +  # Steady deterioration with age
      rnorm(n, mean = 0, sd = 0.2),  # Add random noise for variability
    Condition = Condition + case_when(  
      Owner_Group == "NYSDOT" ~ 0.1,  # Slightly better conditions for NYSDOT-owned bridges
      Owner_Group == "other" ~ -0.2,  # Slightly worse conditions for other
      TRUE ~ 0  # No adjustment for Municipalities
    ),
    Condition = Condition + case_when(
      Located_Municipality == "City" ~ -0.2,  # Slightly worse conditions for city bridges
      Located_Municipality == "Town" ~ 0.2,  # Slightly better conditions for town bridges
      TRUE ~ 0  # No adjustment for Village
    ),
    Condition = pmax(pmin(Condition, 7), 1)  # Ensure condition values stay within the 1-7 range
  )


#### Save data ####

# Save the simulated dataset as a CSV file
write_csv(simulated_bridges, "data/00-simulated_data/simulated_bridge_condition_data.csv")
