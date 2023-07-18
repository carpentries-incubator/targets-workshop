library(targets)
library(tarchetypes)

tar_plan(
  adelie_data = dplyr::filter(palmerpenguins::penguins, species == "Adelie")
)