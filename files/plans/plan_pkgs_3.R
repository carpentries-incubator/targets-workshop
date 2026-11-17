options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

tar_plan(
  penguins_csv_file = "data/penguins_raw.csv",
  tar_target(
    penguins_data_raw,
    read_csv(penguins_csv_file, show_col_types = FALSE),
    packages = "readr"
  ),
  tar_target(
    penguins_data,
    clean_penguin_data(penguins_data_raw),
    packages = c("dplyr", "tidyr")
  )
)
