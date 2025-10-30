suppressPackageStartupMessages({
  library(tidyverse); library(janitor); library(here)
})

data_path <- here("data","Superstore.csv")
if (!file.exists(data_path)) {
  stop("Data file not found at: ", data_path,
       "\nPlace the Superstore CSV there and re-run 00_run_all.R.")
}

# Read and clean names
raw <- readr::read_csv(
  file   = data_path,
  guess_max = 200000,
  locale = readr::locale(encoding = "UTF-8")
) |>
  janitor::clean_names() |>
  mutate(
    across(where(is.character), ~ iconv(.x, from = "", to = "UTF-8", sub = ""))
  )

stopifnot(is.data.frame(raw), nrow(raw) > 0)
message("Loaded rows: ", nrow(raw))