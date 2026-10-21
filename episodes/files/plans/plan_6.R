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
  # Get species names
  species_name = penguins_data |> dplyr::pull(species) |> unique(),
  # Build combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Build one model per species
  tar_target(
    species_summary,
    penguins_data |> dplyr::filter(species == species_name) |> model_glance(),
    pattern = map(species_name)
  )
)
