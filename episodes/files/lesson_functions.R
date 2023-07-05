# Functions used in the lesson `.Rmd` files, but that learners
# aren't exposed to, and aren't used inside the Targets pipelines

make_tempdir <- function() {
  x <- tempfile()
  dir.create(x)
  x
}

files_root <- normalizePath("files")
plan_root <- file.path(files_root, "plans")
utility_funcs <- file.path(files_root, "tar_functions") |>
  list.files(full.names = TRUE, pattern = "\\.R$") |>
  lapply(readLines) |>
  unlist()

execute_plan <- function(name, ...) {
  # Write the utility functions into the R/ directory
  dir.create("R")
  file.path("R", "functions.R") |>
    writeLines(utility_funcs, con = _)

  script_path <- file.path(plan_root, name)
  targets::tar_make(script = script_path, ...)
}

subset_file <- function(path, lines) {
  readLines(path)[lines] |>
    c("```{r}", content=_, "```") |>
    paste(collapse = "\n") |>
    cat()
}
