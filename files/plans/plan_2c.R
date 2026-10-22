options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

list(
  tar_target(penguins_csv_file, "data/penguins_raw.csv"),
  tar_target(penguins_data_raw, read_csv(penguins_csv_file)),
  tar_target(penguins_data, clean_penguin_data(penguins_data_raw))
)
