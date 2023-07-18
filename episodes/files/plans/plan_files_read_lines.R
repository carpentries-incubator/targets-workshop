library(targets)
library(tarchetypes)

tar_plan(
  some_data = readLines("_targets/user/data/hello.txt")
)
