#' Write an example targets plan
#'
#' To save on repition and errors when repeatedly running examples
#'
#' @param plan_select Plan template to choose from; 1, 2, or 3.
#'
#' @return Writes out the plan to _targets.R in the working directory.
#' WILL OVERWRITE ANY EXISTING FILE WITH THE SAME NAME
#' @examples
#' library(targets)
#' tar_dir({
#'   write_example_plan(1)
#'   tar_make()
#' })
#'
write_example_plan <- function(plan_select) {
  # functions
  glance_with_mod_name_func <- c(
    "glance_with_mod_name <- function(model_in_list) {",
    "model_name <- names(model_in_list)",
    "model <- model_in_list[[1]]",
    "broom::glance(model) |>",
    "  mutate(model_name = model_name)",
    "}"
  )
  augment_with_mod_name_func <- c(
    "augment_with_mod_name <- function(model_in_list) {",
    "model_name <- names(model_in_list)",
    "model <- model_in_list[[1]]",
    "broom::augment(model) |>",
    "  mutate(model_name = model_name)",
    "}"
  )
  glance_slow_func <- c(
    "glance_with_mod_name_slow <- function(model_in_list) {",
    "Sys.sleep(4)",
    "model_name <- names(model_in_list)",
    "model <- model_in_list[[1]]",
    "broom::glance(model) |>",
    "  mutate(model_name = model_name)",
    "}"
  )
  augment_slow_func <- c(
    "augment_with_mod_name_slow <- function(model_in_list) {",
    "Sys.sleep(4)",
    "model_name <- names(model_in_list)",
    "model <- model_in_list[[1]]",
    "broom::augment(model) |>",
    "  mutate(model_name = model_name)",
    "}"
  )
  clean_penguin_data_func <- c(
    "clean_penguin_data <- function(penguins_data_raw) {",
    "  penguins_data_raw |>",
    "    select(",
    "      species = Species,",
    "      bill_length_mm = `Culmen Length (mm)`,",
    "      bill_depth_mm = `Culmen Depth (mm)`",
    "    ) |>",
    "    remove_missing(na.rm = TRUE) |>",
    "    separate(species, into = 'species', extra = 'drop')",
    "}"
  )
  # original plan
  plan_1 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "suppressPackageStartupMessages(library(tidyverse))",
    "clean_penguin_data <- function(penguins_data_raw) {",
    "  penguins_data_raw |>",
    "    select(",
    "      species = Species,",
    "      bill_length_mm = `Culmen Length (mm)`,",
    "      bill_depth_mm = `Culmen Depth (mm)`",
    "    ) |>",
    "    remove_missing(na.rm = TRUE)",
    "}",
    "list(",
    "  tar_target(penguins_csv_file, path_to_file('penguins_raw.csv')),",
    "  tar_target(penguins_data_raw, read_csv(",
    "    penguins_csv_file, show_col_types = FALSE)),",
    "  tar_target(penguins_data, clean_penguin_data(penguins_data_raw))",
    ")"
  )
  # separate species names
  plan_2 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "suppressPackageStartupMessages(library(tidyverse))",
    "clean_penguin_data <- function(penguins_data_raw) {",
    "  penguins_data_raw |>",
    "    select(",
    "      species = Species,",
    "      bill_length_mm = `Culmen Length (mm)`,",
    "      bill_depth_mm = `Culmen Depth (mm)`",
    "    ) |>",
    "    remove_missing(na.rm = TRUE) |>",
    "    separate(species, into = 'species', extra = 'drop')",
    "}",
    "list(",
    "  tar_target(penguins_csv_file, path_to_file('penguins_raw.csv')),",
    "  tar_target(penguins_data_raw, read_csv(",
    "    penguins_csv_file, show_col_types = FALSE)),",
    "  tar_target(penguins_data, clean_penguin_data(penguins_data_raw))",
    ")"
  )
  # tar_file_read
  plan_3 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "suppressPackageStartupMessages(library(tidyverse))",
    "clean_penguin_data <- function(penguins_data_raw) {",
    "  penguins_data_raw |>",
    "    select(",
    "      species = Species,",
    "      bill_length_mm = `Culmen Length (mm)`,",
    "      bill_depth_mm = `Culmen Depth (mm)`",
    "    ) |>",
    "    remove_missing(na.rm = TRUE) |>",
    "    separate(species, into = 'species', extra = 'drop')",
    "}",
    "tar_plan(",
   "   tar_file_read(",
   "       penguins_data_raw,",
   "       path_to_file('penguins_raw.csv'),",
   "       read_csv(!!.x, show_col_types = FALSE)",
   "     ),",
   "   penguins_data = clean_penguin_data(penguins_data_raw)",
   ")"
  )
  # add one model
  plan_4 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "suppressPackageStartupMessages(library(tidyverse))",
    "clean_penguin_data <- function(penguins_data_raw) {",
    "  penguins_data_raw |>",
    "    select(",
    "      species = Species,",
    "      bill_length_mm = `Culmen Length (mm)`,",
    "      bill_depth_mm = `Culmen Depth (mm)`",
    "    ) |>",
    "    remove_missing(na.rm = TRUE) |>",
    "    separate(species, into = 'species', extra = 'drop')",
    "}",
    "tar_plan(",
   "   tar_file_read(",
   "       penguins_data_raw,",
   "       path_to_file('penguins_raw.csv'),",
   "       read_csv(!!.x, show_col_types = FALSE)",
   "     ),",
   "   penguins_data = clean_penguin_data(penguins_data_raw),",
   "   combined_model = lm(",
   "       bill_depth_mm ~ bill_length_mm, data = penguins_data)",
   ")"
  )
  # add multiple models
  plan_5 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "library(broom)",
    "suppressPackageStartupMessages(library(tidyverse))",
    "clean_penguin_data <- function(penguins_data_raw) {",
    "  penguins_data_raw |>",
    "    select(",
    "      species = Species,",
    "      bill_length_mm = `Culmen Length (mm)`,",
    "      bill_depth_mm = `Culmen Depth (mm)`",
    "    ) |>",
    "    remove_missing(na.rm = TRUE) |>",
    "    separate(species, into = 'species', extra = 'drop')",
    "}",
    "tar_plan(",
    "   tar_file_read(",
    "       penguins_data_raw,",
    "       path_to_file('penguins_raw.csv'),",
    "       read_csv(!!.x, show_col_types = FALSE)",
    "     ),",
    "   penguins_data = clean_penguin_data(penguins_data_raw),",
    "   combined_model = lm(",
    "       bill_depth_mm ~ bill_length_mm, data = penguins_data),",
    "    species_model = lm(",
    "     bill_depth_mm ~ bill_length_mm + species, data = penguins_data),",
    "   interaction_model = lm(",
    "     bill_depth_mm ~ bill_length_mm * species, data = penguins_data),",
    "   combined_summary = glance(combined_model),",
    "   species_summary = glance(species_model),",
    "   interaction_summary = glance(interaction_model)",
    ")"
  )
  # add multiple models with branching
  plan_6 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "library(broom)",
    "suppressPackageStartupMessages(library(tidyverse))",
    clean_penguin_data_func,
    "tar_plan(",
    "   tar_file_read(",
    "       penguins_data_raw,",
    "       path_to_file('penguins_raw.csv'),",
    "       read_csv(!!.x, show_col_types = FALSE)",
    "     ),",
    "   penguins_data = clean_penguin_data(penguins_data_raw),",
    "   models = list(",
    "     combined_model = lm(",
    "       bill_depth_mm ~ bill_length_mm, data = penguins_data),",
    "     species_model = lm(",
    "       bill_depth_mm ~ bill_length_mm + species, data = penguins_data),",
    "     interaction_model = lm(",
    "       bill_depth_mm ~ bill_length_mm * species, data = penguins_data)",
    "   ),",
    "   tar_target(",
    "     model_summaries,",
    "     glance(models[[1]]),",
    "     pattern = map(models)",
    "   )",
    ")"
    )
  # add multiple models with branching, custom glance func
  plan_7 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "library(broom)",
    "suppressPackageStartupMessages(library(tidyverse))",
    glance_with_mod_name_func,
    clean_penguin_data_func,
    "tar_plan(",
    "   tar_file_read(",
    "       penguins_data_raw,",
    "       path_to_file('penguins_raw.csv'),",
    "       read_csv(!!.x, show_col_types = FALSE)",
    "     ),",
    "   penguins_data = clean_penguin_data(penguins_data_raw),",
    "   models = list(",
    "     combined_model = lm(",
    "       bill_depth_mm ~ bill_length_mm, data = penguins_data),",
    "     species_model = lm(",
    "       bill_depth_mm ~ bill_length_mm + species, data = penguins_data),",
    "     interaction_model = lm(",
    "       bill_depth_mm ~ bill_length_mm * species, data = penguins_data)",
    "   ),",
    "   tar_target(",
    "     model_summaries,",
    "     glance_with_mod_name(models),",
    "     pattern = map(models)",
    "   )",
    ")"
    )
  # adds future and predictions
  plan_8 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "library(broom)",
    "library(future)",
    "library(future.callr)",
    "suppressPackageStartupMessages(library(tidyverse))",
    glance_slow_func,
    augment_slow_func,
    clean_penguin_data_func,
    "plan(callr)",
    "tar_plan(",
    "   tar_file_read(",
    "       penguins_data_raw,",
    "       path_to_file('penguins_raw.csv'),",
    "       read_csv(!!.x, show_col_types = FALSE)",
    "     ),",
    "   penguins_data = clean_penguin_data(penguins_data_raw),",
    "   models = list(",
    "     combined_model = lm(",
    "       bill_depth_mm ~ bill_length_mm, data = penguins_data),",
    "     species_model = lm(",
    "       bill_depth_mm ~ bill_length_mm + species, data = penguins_data),",
    "     interaction_model = lm(",
    "       bill_depth_mm ~ bill_length_mm * species, data = penguins_data)",
    "   ),",
    "   tar_target(",
    "     model_summaries,",
    "     glance_with_mod_name_slow(models),",
    "     pattern = map(models)",
    "   ),",
    "   tar_target(",
    "     model_predictions,",
    "     augment_with_mod_name_slow(models),",
    "     pattern = map(models)",
    "   ),",
    ")"
    )
    # adds report
  plan_9 <- c(
    "library(targets)",
    "library(palmerpenguins)",
    "library(tarchetypes)",
    "library(broom)",
    "suppressPackageStartupMessages(library(tidyverse))",
    glance_with_mod_name_func,
    augment_with_mod_name_func,
    clean_penguin_data_func,
    "tar_plan(",
    "   tar_file_read(",
    "       penguins_data_raw,",
    "       path_to_file('penguins_raw.csv'),",
    "       read_csv(!!.x, show_col_types = FALSE)",
    "     ),",
    "   penguins_data = clean_penguin_data(penguins_data_raw),",
    "   models = list(",
    "     combined_model = lm(",
    "       bill_depth_mm ~ bill_length_mm, data = penguins_data),",
    "     species_model = lm(",
    "       bill_depth_mm ~ bill_length_mm + species, data = penguins_data),",
    "     interaction_model = lm(",
    "       bill_depth_mm ~ bill_length_mm * species, data = penguins_data)",
    "   ),",
    "   tar_target(",
    "     model_summaries,",
    "     glance_with_mod_name(models),",
    "     pattern = map(models)",
    "   ),",
    "   tar_target(",
    "     model_predictions,",
    "     augment_with_mod_name(models),",
    "     pattern = map(models)",
    "   ),",
    "   tar_quarto(",
    "     penguin_report,",
    "     path = 'penguin_report.qmd',",
    "     quiet = FALSE,",
    "     packages = c('targets', 'tidyverse')",
    "   )",
    ")"
    )
  switch(
    as.character(plan_select),
    "1" = readr::write_lines(plan_1, "_targets.R"),
    "2" = readr::write_lines(plan_2, "_targets.R"),
    "3" = readr::write_lines(plan_3, "_targets.R"),
    "4" = readr::write_lines(plan_4, "_targets.R"),
    "5" = readr::write_lines(plan_5, "_targets.R"),
    "6" = readr::write_lines(plan_6, "_targets.R"),
    "7" = readr::write_lines(plan_7, "_targets.R"),
    "8" = readr::write_lines(plan_8, "_targets.R"),
    "9" = readr::write_lines(plan_9, "_targets.R"),
    stop("plan_select must be 1, 2, 3, 4, 5, 6, 7, 8, or 9")
  )
}

glance_with_mod_name <- function(model_in_list) {
  model_name <- names(model_in_list)
  model <- model_in_list[[1]]
  broom::glance(model) |>
    mutate(model_name = model_name)
}
