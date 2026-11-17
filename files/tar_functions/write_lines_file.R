write_lines_file <- function(text, file, ...) {
  writeLines(text = text, con = file, ...)
  file
}
