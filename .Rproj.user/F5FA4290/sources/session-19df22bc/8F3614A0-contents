suppressPackageStartupMessages({
  library(dplyr)
})

if (!exists("retail")) stop("`retail` not found. Run 02_clean_transform.R first.")

by_region <- retail |>
  group_by(region) |>
  summarise(sales = sum(sales), profit = sum(profit), .groups="drop") |>
  mutate(profit_margin = profit / sales)

by_category <- retail |>
  group_by(category) |>
  summarise(sales = sum(sales), profit = sum(profit), .groups="drop") |>
  mutate(avg_margin = profit / sales)

ts_monthly <- retail |>
  group_by(year_month) |>
  summarise(sales = sum(sales), profit = sum(profit), .groups="drop")

stopifnot(nrow(by_region) > 0, nrow(by_category) > 0, nrow(ts_monthly) > 0)
message("Prepared summary tables: by_region, by_category, ts_monthly")
