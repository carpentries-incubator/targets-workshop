options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
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
  combined_summary = glance(combined_model),
  adelie_summary = glance(adelie_model),
  chinstrap_summary = glance(chinstrap_model),
  gentoo_summary = glance(gentoo_model)
)
