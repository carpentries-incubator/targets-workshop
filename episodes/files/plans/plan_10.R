options(tidyverse.quiet = TRUE)
suppressPackageStartupMessages(library(crew))
source("R/functions.R")
source("R/packages.R")

# Set up parallelization
library(crew)
tar_option_set(
  controller = crew_controller_local(workers = 2)
)

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean and group data
  tar_group_by(
    penguins_data,
    clean_penguin_data(penguins_data_raw),
    species
  ),
  # Get summary of combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    model_glance_slow(penguins_data),
    pattern = map(penguins_data)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_glance_slow(penguins_data),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    model_augment_slow(penguins_data),
    pattern = map(penguins_data)
  )
)
