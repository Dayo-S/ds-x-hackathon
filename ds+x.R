library(dplyr)
library(tidyr)
library(ggplot2)
library(janitor)

options(scipen = 999)

df <- read.csv("dsdf.csv") %>%
  clean_names() %>%
  mutate(category = ifelse(category == "N/A" | is.na(category), "Uncategorized", category)) %>%
  filter(sector != "Total") %>%
  mutate(
    estimated_annual_generation_tons_year_category = as.numeric(estimated_annual_generation_tons_year_category),
    estimated_annual_generation_tons_year_sector = as.numeric(estimated_annual_generation_tons_year_sector),
    # Create combined label for legend
    sector_category = paste(sector, category, sep = " – ")
  ) %>%
  filter(!is.na(estimated_annual_generation_tons_year_category))

# Expanded earthy palette
earthy_palette <- c(
  "#8B5A2B", "#A0522D", "#556B2F", "#6B8E23", "#BDB76B",
  "darkgreen", "steelblue", "#8FBC8F", "#CD853F", "#4682B4",
  "#9ACD32", "#DEB887", "#2E8B57", "#DAA520"
)

ggplot(df, aes(x = reorder(sector, estimated_annual_generation_tons_year_sector, na.rm = TRUE),
               y = estimated_annual_generation_tons_year_category,
               fill = sector_category)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Estimated Annual Food Waste by Sector and Category",
       x = "Sector",
       y = "Tons per Year",
       fill = "Sector – Category") +
  theme_minimal(base_size = 13) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = earthy_palette) +
  theme(
    plot.title = element_text(face = "bold", size = rel(1.4), hjust = 0.5),
    axis.title = element_text(face = "bold", size = rel(1.1)),
    axis.text.y = element_text(face = "bold", size = rel(1)),
    axis.text.x = element_text(size = rel(0.9), color = "gray30"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray90", linetype = "dashed"),
    panel.grid.minor.x = element_blank(),
    plot.background = element_rect(fill = "#fcfcfc", color = NA),
    panel.background = element_rect(fill = "#fcfcfc", color = NA),
    plot.margin = margin(20, 20, 20, 20)
  )

# Baselines
baseline_date <- 2190000
baseline_retail <- 13665535

reductions <- 2:9

# Build table
df_stacked <- data.frame(
  Reduction_Percent = reductions,
  Avoided = baseline_date * (reductions / 100),
  Date_Remaining = baseline_date * (1 - reductions / 100)
) %>%
  mutate(
    Retail_Other = baseline_retail - baseline_date   # retail minus date-label slice
  ) %>%
  pivot_longer(cols = c("Avoided","Date_Remaining","Retail_Other"),
               names_to = "Category", values_to = "Tons") %>%
  mutate(
    Tons_Millions = Tons / 1e6,  # scale to millions of tons
    Category = factor(Category,
                      levels = c("Retail_Other","Date_Remaining","Avoided"),
                      labels = c("Other Retail Waste",
                                 "Remaining Date-Label Waste",
                                 "Avoided Waste"))
  )


# Baseline: 2.19 million tons of retail waste from date-label concerns
baseline_date <- 2190000

# Reduction percentages: 2,4,6,...,20
reductions <- seq(2, 20, by = 2)

# Build table
df_stacked <- data.frame(
  Reduction_Percent = reductions,
  Avoided = baseline_date * (reductions / 100),
  Not_Avoided = baseline_date * (1 - reductions / 100)
) %>%
  pivot_longer(cols = c("Avoided","Not_Avoided"),
               names_to = "Category", values_to = "Tons") %>%
  mutate(
    Tons_Millions = Tons / 1e6,  # scale to millions of tons
    Category = factor(Category,
                      levels = c("Not_Avoided","Avoided"),
                      labels = c("Not Avoided Waste","Avoided Waste"))
  )

# Plot stacked bar
ggplot(df_stacked, aes(x = factor(Reduction_Percent), y = Tons_Millions, fill = Category)) +
  geom_col() +
  labs(
    title = "Avoided vs Not Avoided Retail Date-Label Waste",
    subtitle = "Baseline = 2.19M tons; reductions shown from 2% to 20%",
    x = "Reduction Percent",
    y = "Millions of Tons",
    fill = ""
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Not Avoided Waste" = "#8FBC8F",
                               "Avoided Waste" = "#8B5A2B")) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "gray30"),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom"
  )
