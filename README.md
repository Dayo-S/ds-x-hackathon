---

# 📊 DS+X Hackathon: Food Waste Visualization & Modeling

## Overview

This project explores U.S. retail food waste, with a focus on date-label driven losses. It combines data wrangling, custom visualizations, and scenario modeling to communicate the impact of reduction strategies. Built for the DS+X Hackathon, the script uses R to transform raw CSV data into compelling insights.

## Features

- 🧹 **Data Cleaning**: Uses `janitor::clean_names()` and custom logic to handle missing categories and filter out aggregate rows.
- 🎨 **Custom Visualization**: Earthy-themed stacked bar charts show food waste by sector and category.
- 📉 **Scenario Modeling**: Simulates reductions in date-label waste from 2% to 20%, visualizing avoided vs. remaining tons.
- 📦 **Modular Code**: Organized into clear sections for data prep, palette setup, and plotting.

## Data Source

- Input file: `dsdf.csv`
- Columns used:
  - `sector`
  - `category`
  - `estimated_annual_generation_tons_year_category`
  - `estimated_annual_generation_tons_year_sector`

## How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/Dayo-S/ds-x-hackathon.git
   ```
2. Open `ds+x.R` in RStudio or your preferred IDE.
3. Ensure `dsdf.csv` is in the working directory.
4. Run the script to generate two plots:
   - Estimated Annual Food Waste by Sector and Category
   - Avoided vs. Not Avoided Retail Date-Label Waste

## Dependencies

```r
library(dplyr)
library(tidyr)
library(ggplot2)
library(janitor)
```

## Visualization Highlights

- Uses a custom earthy palette for clarity and realism.
- Axis labels, legend formatting, and gridlines are optimized for readability.
- Plots are scaled to millions of tons and include informative subtitles.

## Author

Created by [Adedayo Sanusi](https://github.com/Dayo-S) for the DS+X Hackathon.

---
