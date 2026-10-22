options(tidyverse.quiet = TRUE)
suppressPackageStartupMessages(library(crew))
source("R/functions.R")
source("R/packages.R")

# Set up parallelization
tar_option_set(
  controller = crew_controller_local(workers = 2)
)

tar_plan(
  # Load raw data
  penguins_csv_file = "data/penguins_raw.csv",
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Get species names
  species_name = penguins_data |> dplyr::pull(species) |> unique(),
  # Get summary of combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    penguins_data |> dplyr::filter(species == species_name) |> model_glance(),
    pattern = map(species_name)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_augment(penguins_data),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    penguins_data |> dplyr::filter(species == species_name) |> model_augment(),
    pattern = map(species_name)
  )
)
