pkgs <- c("tidyverse", "lubridate", "janitor", "here", "scales", "readr", "ggplot2")
new <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(new)) install.packages(new, quiet = TRUE)
invisible(lapply(pkgs, library, character.only = TRUE))

dir.create(here::here("output", "figs"), recursive = TRUE, showWarnings = FALSE)
dir.create(here::here("output", "tables"), recursive = TRUE, showWarnings = FALSE)

# Script Run
source(here::here("R", "01_load_data.R"))        
source(here::here("R", "02_clean_transform.R"))  
source(here::here("R", "03_eda_visuals.R"))      
source(here::here("R", "04_export_outputs.R"))        


message("Retail Profitability Analysis Complete!")
