write_csv_file <- function(data, file, ...) {
  readr::write_csv(x = data, file = file, ...)
  file
}
