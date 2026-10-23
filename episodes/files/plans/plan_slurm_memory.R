library(crew)
library(targets)
library(tarchetypes)
library(crew.cluster)

source("R/packages.R")
source("R/functions.R")

small_memory <- crew_controller_slurm(
  name = "small_memory",
  options_cluster = crew_options_slurm(
    script_lines = "module load R",
    memory_gigabytes_required = 1
  )
)
big_memory <- crew_controller_slurm(
  name = "big_memory",
  options_cluster = crew_options_slurm(
    script_lines = "module load R",
    memory_gigabytes_required = 2
  )
)

tar_option_set(
  controller = crew_controller_group(small_memory, big_memory)
)

list(
  tar_target(
    name = big_memory_task,
    command = Sys.getenv("SLURM_MEM_PER_NODE"),
    resources = tar_resources(
      crew = tar_resources_crew(controller = "big_memory")
    )
  ),
  tar_target(
    name = small_memory_task,
    command = Sys.getenv("SLURM_MEM_PER_NODE"),
    resources = tar_resources(
      crew = tar_resources_crew(controller = "small_memory")
    )
  )
)
