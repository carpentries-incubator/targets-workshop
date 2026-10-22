options(tidyverse.quiet = TRUE)
source("R/packages.R")
source("R/functions.R")

tar_plan(
  tar_file(penguins_csv_file, path_to_file("penguins_raw.csv")),
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  penguins_data = clean_penguin_data(penguins_data_raw),
  tar_file(species_note_file, "data/species_note.txt"),
  species_note = readLines(species_note_file),
  tar_file(
    penguins_data_file,
    write_csv_file(penguins_data, "results/penguins_data.csv")
  )
)
