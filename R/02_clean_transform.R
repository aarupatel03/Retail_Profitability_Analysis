suppressPackageStartupMessages({
  library(dplyr); library(lubridate)
})

if (!exists("raw")) stop("`raw` not found. Run 01_load_data.R first.")

# Ensure expected columns exist 
needed <- c("order_date","ship_date","sales","profit","discount","quantity","region","category")
missing <- setdiff(needed, names(raw))
if (length(missing)) stop("Missing columns in raw data: ", paste(missing, collapse = ", "))

retail <- raw |>
  mutate(
    order_date    = suppressWarnings(mdy(order_date)),
    ship_date     = suppressWarnings(mdy(ship_date)),
    year_month    = floor_date(order_date, "month"),
    profit_margin = if_else(sales > 0, profit / sales, NA_real_),
    discount_bucket = cut(
      discount,
      breaks = c(-Inf, 0, .1, .2, .3, .4, Inf),
      labels = c("0","0–10%","10–20%","20–30%","30–40%","40%+"),
      right = TRUE
    )
  ) |>
  filter(!is.na(order_date), sales >= 0, quantity > 0) |>
  mutate(
    across(where(is.character), trimws)
  )

stopifnot(is.data.frame(retail), nrow(retail) > 0)
message("Cleaned rows: ", nrow(retail))                          
