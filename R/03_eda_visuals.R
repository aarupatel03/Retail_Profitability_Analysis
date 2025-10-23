suppressPackageStartupMessages({
  library(dplyr); library(ggplot2); library(scales); library(here)
})

if (!exists("retail")) stop("`retail` not found. Run 02_clean_transform.R first.")

by_region_plot <- retail |>
  group_by(region) |>
  summarise(sales = sum(sales), profit = sum(profit), .groups="drop") |>
  mutate(margin = profit / sales)

p_region <- ggplot(by_region_plot, aes(x=reorder(region, sales), y=sales)) +
  geom_col() + coord_flip() +
  scale_y_continuous(labels = dollar) +
  labs(title="Sales by Region", x=NULL, y="Sales")

by_category_plot <- retail |>
  group_by(category) |>
  summarise(sales = sum(sales), profit = sum(profit), .groups="drop") |>
  mutate(avg_margin = profit / sales)

p_margin_cat <- ggplot(by_category_plot, aes(x=reorder(category, avg_margin), y=avg_margin)) +
  geom_col() + coord_flip() +
  scale_y_continuous(labels = percent) +
  labs(title="Average Profit Margin by Category", x=NULL, y="Avg Margin")

p_discount <- retail |>
  filter(!is.na(profit_margin)) |>
  ggplot(aes(x=discount, y=profit_margin)) +
  geom_point(alpha=.25) +
  geom_smooth(method="lm", se=FALSE) +
  scale_y_continuous(labels = percent) +
  labs(title="Discount vs Profit Margin", x="Discount", y="Profit Margin")

ts_monthly_plot <- retail |>
  group_by(year_month) |>
  summarise(sales = sum(sales), profit = sum(profit), .groups="drop")

p_ts <- ggplot(ts_monthly_plot, aes(x=year_month, y=sales)) +
  geom_line() +
  scale_y_continuous(labels = dollar) +
  labs(title="Monthly Sales Trend", x=NULL, y="Sales")

# Save figures
ggsave(here("figs","sales_by_region.png"), p_region, width=7, height=4, dpi=150)
ggsave(here("figs","margin_by_category.png"), p_margin_cat, width=7, height=4, dpi=150)
ggsave(here("figs","discount_vs_margin.png"), p_discount, width=7, height=4, dpi=150)
ggsave(here("figs","monthly_sales.png"), p_ts, width=7, height=4, dpi=150)

message("Saved figures to figs/: sales_by_region.png, margin_by_category.png, discount_vs_margin.png, monthly_sales.png")
