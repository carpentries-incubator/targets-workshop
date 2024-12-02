model_glance <- function(penguins_data) {
  # Make model
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  # Get species name
  species_name <- unique(penguins_data$species)
  # If this is the combined dataset with multiple
  # species, changed name to 'combined'
  if (length(species_name) > 1) {
    species_name <- "combined"
  }
  # Get model summary and add species name
  augment(model) |>
    mutate(species = species_name, .before = 1)
}
