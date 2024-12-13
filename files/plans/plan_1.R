options(tidyverse.quiet = TRUE)
library(targets)
library(tidyverse)
library(palmerpenguins)

clean_penguin_data <- function(penguins_data_raw) {
  penguins_data_raw |>
    select(
      species = Species,
      bill_length_mm = `Culmen Length (mm)`,
      bill_depth_mm = `Culmen Depth (mm)`
    ) |>
    remove_missing(na.rm = TRUE)
}

list(
  tar_target(penguins_csv_file, path_to_file("penguins_raw.csv")),
  tar_target(penguins_data_raw, read_csv(
    penguins_csv_file, show_col_types = FALSE)),
  tar_target(penguins_data, clean_penguin_data(penguins_data_raw))
)
