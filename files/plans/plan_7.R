options(tidyverse.quiet = TRUE)
source("R/functions.R")
source("R/packages.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Group data
  tar_group_by(
    penguins_data_grouped,
    penguins_data,
    species
  ),
  # Get summary of combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    model_glance(penguins_data_grouped),
    pattern = map(penguins_data_grouped)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_augment(penguins_data_grouped),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    model_augment(penguins_data_grouped),
    pattern = map(penguins_data_grouped)
  )
)
