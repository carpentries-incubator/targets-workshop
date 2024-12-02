options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

tar_plan(
  penguins_csv_file = path_to_file("penguins_raw.csv"),
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  penguins_data = clean_penguin_data(penguins_data_raw)
)
