options(tidyverse.quiet = TRUE)
library(targets)
library(tarchetypes)
source("R/functions.R")

tar_plan(
  penguins_csv_file = "data/penguins_raw.csv",
  penguins_data_raw = readr::read_csv(penguins_csv_file, show_col_types = FALSE),
  penguins_data = clean_penguin_data(penguins_data_raw)
)
