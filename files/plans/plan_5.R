options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Load raw data
  penguins_csv_file = "data/penguins_raw.csv",
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Build models
  combined_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data
  ),
  adelie_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = filter(penguins_data, species == "Adelie")
  ),
  chinstrap_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = filter(penguins_data, species == "Chinstrap")
  ),
  gentoo_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = filter(penguins_data, species == "Gentoo")
  ),
  # Get model summaries
  combined_summary = broom::glance(combined_model),
  adelie_summary = broom::glance(adelie_model),
  chinstrap_summary = broom::glance(chinstrap_model),
  gentoo_summary = broom::glance(gentoo_model)
)
