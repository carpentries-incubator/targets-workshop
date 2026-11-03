clean_penguin_data <- function(penguins_data_raw) {
  penguins_data_raw |>
    dplyr::select(
      species = Species,
      bill_length_mm = `Culmen Length (mm)`,
      bill_depth_mm = `Culmen Depth (mm)`
    ) |>
    tidyr::drop_na() |>
    # Split "species" apart on spaces, and only keep the first word
    tidyr::separate(species, into = "species", extra = "drop")
}
