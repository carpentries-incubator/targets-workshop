library(targets)
library(tarchetypes)

tar_plan(
  tar_target(
    adelie_data,
    filter(penguins, species == "Adelie"),
    packages = c("dplyr", "palmerpenguins")
  )
)