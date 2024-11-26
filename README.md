# NYS_Bridge_Condition_Analysis

## Overview

This project analyzes bridge condition data from New York State in 2016. The analysis involves simulating, cleaning, and modeling the data to understand factors affecting bridge conditions and to predict potential deficiencies.

## File Structure

The repo is structured as:

-   `data/simulated_data` contains the simulated bridge condition data that was constructed.
-   `data/raw_data` Contains the raw bridge condition data for New York State in 2016, as         obtained from The Data and Story Library. (Link to raw data download: https://dasl.datadescription.com/datafile/new-york-bridges-2016/?_sf_s=Bridge&_sfm_cases=4+59943)
-   `data/analysis_data` contains the cleaned bridge condition data used for analysis
-   `models` contains fitted models. 
-   `other` contains details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including:
     - PDF of the paper
     - the Quarto document
     - reference bibliography file
-   `scripts` contains R scripts used to simulate, download, clean, and test the data. Also      includes scripts for model building and evaluation.


## Statement on LLM usage

The code and the entire paper were developed with the assistance of ChatGPT-4o, and the complete chat history is documented in other/llm_usage/usage.txt.


