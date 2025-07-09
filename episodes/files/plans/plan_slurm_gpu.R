graphics_devices <- function(){
  system2("lshw", c("-class", "display"), stdout=TRUE, stderr=FALSE)
}

library(crew)
library(targets)
library(tarchetypes)
library(crew.cluster)

source("R/packages.R")
source("R/functions.R")

tar_option_set(
  controller = crew_controller_group(
    crew_controller_slurm(
      name = "cpu_worker",
      workers = 1,
      options_cluster = crew_options_slurm(
      script_lines = "module load R",
        memory_gigabytes_per_cpu = 1,
        cpus_per_task = 1
      )
    ),

    crew_controller_slurm(
      name = "gpu_worker",
      workers = 1,
      options_cluster = crew_options_slurm(
        script_lines = c(
          "#SBATCH --partition=gpuq",
          "#SBATCH --gres=gpu:1",
          "module load R"
        ),
        memory_gigabytes_per_cpu = 1,
        cpus_per_task = 1
      )
    )
  )
)

tar_plan(
  tar_target(
    cpu_hardware,
    graphics_devices(),
    resources = tar_resources(
      crew = tar_resources_crew(controller = "cpu_worker")
    )
  ),
  tar_target(
    gpu_hardware,
    graphics_devices(),
    resources = tar_resources(
      crew = tar_resources_crew(controller = "gpu_worker")
    )
  )
)
