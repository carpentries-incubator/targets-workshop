options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Load raw data
  penguins_csv_file = "data/penguins_raw.csv",
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Build model
  combined_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data
  )
)
