# Functions used in the lesson `.Rmd` files, but that learners
# aren't exposed to, and aren't used inside the Targets pipelines

make_tempdir <- function() {
  x <- tempfile()
  dir.create(x, showWarnings = FALSE)
  x
}

files_root <- normalizePath("files")
plan_root <- file.path(files_root, "plans")
utility_funcs <- file.path(files_root, "tar_functions") |>
  list.files(full.names = TRUE, pattern = "\\.R$") |>
  lapply(readLines) |>
  unlist()
package_script <- file.path(files_root, "packages.R")

#' @param file The path to another file to use as a workflow
#' @param chunk The chunk name to use as a targets workflow
write_example_plan <- function(file = NULL, chunk = NULL) {
  # Write the utility functions into the R/ directory

  if (!dir.exists("R")) {
    dir.create("R")

    # Write the functions.R script
    file.path("R", "functions.R") |>
      writeLines(utility_funcs, con = _)

    # Copy the packages.R script
    file.path("R", "packages.R") |>
      file.copy(from = package_script, to = _)
  }

  # Write the workflow
  if (!is.null(file)) {
    file.path(plan_root, file) |>
        file.copy(from = _, to = "_targets.R", overwrite = TRUE)
  }
  if (!is.null(chunk)) {
    writeLines(text = knitr::knit_code$get(chunk), con = "_targets.R")
  }

  invisible()
}

directory_stack <- getwd()

pushd <- function(dir) {
  directory_stack <<- c(dir, directory_stack)
  setwd(directory_stack[1])
  invisible()
}

popd <- function() {
  directory_stack <<- directory_stack[-1]
  setwd(directory_stack[1])
  invisible()
}
