library(targets)
library(tarchetypes)

tar_option_set(packages = c("dplyr", "palmerpenguins"))

tar_plan(
  adelie_data = filter(penguins, species == "Adelie")
)