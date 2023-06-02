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
#'   write_example_plan(2)
#'   tar_make()
#' })
#'
write_example_plan <- function(plan_select) {
  # default example plan from tar_script()
  plan_1 <- c(
    "library(targets)",
    "# This is an example _targets.R file. Every",
    "# {targets} pipeline needs one.",
    "# Use tar_script() to create _targets.R and tar_edit()",
    "# to open it again for editing.",
    "# Then, run tar_make() to run the pipeline",
    "# and tar_read(summary) to view the results.",
    "",
    "# Define custom functions and other global objects.",
    "# This is where you write source(\\\"R/functions.R\\\")",
    "# if you keep your functions in external scripts.",
    "summ <- function(dataset) {",
    "  colMeans(dataset)",
    "}",
    "",
    "# Set target-specific options such as packages:",
    "# tar_option_set(packages = \"utils\") # nolint",
    "",
    "# End this file with a list of target objects.",
    "list(",
    "  tar_target(data, data.frame(x = sample.int(100), y = sample.int(100))),",
    "  tar_target(summary, summ(data)) # Call your custom functions as needed.",
    ")"
  )
  # change names to "my_data" and "my_summary"
  plan_2 <- c(
    "library(targets)",
    "# This is an example _targets.R file. Every",
    "# {targets} pipeline needs one.",
    "# Use tar_script() to create _targets.R and tar_edit()",
    "# to open it again for editing.",
    "# Then, run tar_make() to run the pipeline",
    "# and tar_read(summary) to view the results.",
    "",
    "# Define custom functions and other global objects.",
    "# This is where you write source(\\\"R/functions.R\\\")",
    "# if you keep your functions in external scripts.",
    "summ <- function(dataset) {",
    "  colMeans(dataset)",
    "}",
    "",
    "# Set target-specific options such as packages:",
    "# tar_option_set(packages = \"utils\") # nolint",
    "",
    "# End this file with a list of target objects.",
    "list(",
    "  tar_target(my_data, data.frame(x = sample.int(100), y = sample.int(100))),", # nolint
    "  tar_target(my_summary, summ(my_data)) # Call your custom functions as needed.", # nolint
    ")"
  )
  # Return row sums instead of col sums
  plan_3 <- c(
    "library(targets)",
    "# This is an example _targets.R file. Every",
    "# {targets} pipeline needs one.",
    "# Use tar_script() to create _targets.R and tar_edit()",
    "# to open it again for editing.",
    "# Then, run tar_make() to run the pipeline",
    "# and tar_read(summary) to view the results.",
    "",
    "# Define custom functions and other global objects.",
    "# This is where you write source(\\\"R/functions.R\\\")",
    "# if you keep your functions in external scripts.",
    "summ <- function(dataset) {",
    "  rowMeans(dataset)",
    "}",
    "",
    "# Set target-specific options such as packages:",
    "# tar_option_set(packages = \"utils\") # nolint",
    "",
    "# End this file with a list of target objects.",
    "list(",
    "  tar_target(my_data, data.frame(x = sample.int(100), y = sample.int(100))),", # nolint
    "  tar_target(my_summary, summ(my_data)) # Call your custom functions as needed.", # nolint
    ")"
  )
  switch(
    as.character(plan_select),
    "1" = readr::write_lines(plan_1, "_targets.R"),
    "2" = readr::write_lines(plan_2, "_targets.R"),
    "3" = readr::write_lines(plan_3, "_targets.R"),
    stop("plan_select must be 1, 2, or 3")
  )
}

glance_with_mod_name <- function(model_in_list) {
  model_name <- names(model_in_list)
  model <- model_in_list[[1]]
  broom::glance(model) %>%
    mutate(model_name = model_name)
}