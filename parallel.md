---
title: 'Parallel Processing'
teaching: 15
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we build targets in parallel?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to build targets in parallel

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to use parallel processing

:::::::::::::::::::::::::::::::::::::



Once a pipeline starts to include many targets, you may want to think about parallel processing.
This takes advantage of multiple processors in your computer to build multiple targets at the same time.

::::::::::::::::::::::::::::::::::::: {.callout}

## When to use parallel processing

Parallel processing should only be used if your workflow has independent tasks---if your workflow only consists of a linear sequence of targets, then there is nothing to parallelize.
Most workflows that use branching can benefit from parallelism.

:::::::::::::::::::::::::::::::::::::

`targets` includes support for high-performance computing, cloud computing, and various parallel backends.
Here, we assume you are running this analysis on a laptop and so will use a relatively simple backend.
If you are interested in high-performance computing, [see the `targets` manual](https://books.ropensci.org/targets/hpc.html).

### Set up workflow

To enable parallel processing with `crew` you only need to load the `crew` package, then tell `targets` to use it using `tar_option_set`.
Specifically, the following lines enable crew, and tells it to use 2 parallel workers.
You can increase this number on more powerful machines:

```r
library(crew)
tar_option_set(
  controller = crew_controller_local(workers = 2)
)
```

Make these changes to the penguins analysis.
It should now look like this:


``` r
source("R/functions.R")
source("R/packages.R")

# Set up parallelization
library(crew)
tar_option_set(
  controller = crew_controller_local(workers = 2)
)

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean and group data
  tar_group_by(
    penguins_data,
    clean_penguin_data(penguins_data_raw),
    species
  ),
  # Get summary of combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    model_glance(penguins_data),
    pattern = map(penguins_data)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_augment(penguins_data),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    model_augment(penguins_data),
    pattern = map(penguins_data)
  )
)
```

There is still one more thing we need to modify only for the purposes of this demo: if we ran the analysis in parallel now, you wouldn't notice any difference in compute time because the functions are so fast.

So let's make "slow" versions of `model_glance()` and `model_augment()` using the `Sys.sleep()` function, which just tells the computer to wait some number of seconds.
This will simulate a long-running computation and enable us to see the difference between running sequentially and in parallel.

Add these functions to `functions.R` (you can copy-paste the original ones, then modify them):


``` r
model_glance_slow <- function(penguins_data) {
  Sys.sleep(4)
  # Make model
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  # Get species name
  species_name <- unique(penguins_data$species)
  # If this is the combined dataset with multiple
  # species, changed name to 'combined'
  if (length(species_name) > 1) {
    species_name <- "combined"
  }
  # Get model summary and add species name
  glance(model) |>
    mutate(species = species_name, .before = 1)
}
model_augment_slow <- function(penguins_data) {
  Sys.sleep(4)
  # Make model
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  # Get species name
  species_name <- unique(penguins_data$species)
  # If this is the combined dataset with multiple
  # species, changed name to 'combined'
  if (length(species_name) > 1) {
    species_name <- "combined"
  }
  # Get model summary and add species name
  augment(model) |>
    mutate(species = species_name, .before = 1)
}
```

Then, change the plan to use the "slow" version of the functions:


``` r
source("R/functions.R")
source("R/packages.R")

# Set up parallelization
library(crew)
tar_option_set(
  controller = crew_controller_local(workers = 2)
)

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean and group data
  tar_group_by(
    penguins_data,
    clean_penguin_data(penguins_data_raw),
    species
  ),
  # Get summary of combined model with all species together
  combined_summary = model_glance_slow(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    model_glance_slow(penguins_data),
    pattern = map(penguins_data)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_augment_slow(penguins_data),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    model_augment_slow(penguins_data),
    pattern = map(penguins_data)
  )
)
```

Finally, run the pipeline with `tar_make()` as normal.


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw
```

``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

+ combined_summary dispatched
+ species_summary declared [3 branches]
+ species_predictions declared [3 branches]
✔ combined_summary completed [4s, 371 B]
+ combined_predictions dispatched
✔ species_summary completed [12.8s, 1.11 kB]
✔ combined_predictions completed [4s, 25.91 kB]
✔ species_predictions completed [12s, 27.45 kB]
✔ ended pipeline [19.1s, 8 completed, 3 skipped]
```

Notice that although the time required to build each individual target is about 4 seconds, the total time to run the entire workflow is less than the sum of the individual target times! That is proof that processes are running in parallel **and saving you time**.

The unique and powerful thing about targets is that **we did not need to change our custom function to run it in parallel**. We only adjusted *the workflow*. This means it is relatively easy to refactor (modify) a workflow for running sequentially locally or running in parallel in a high-performance context.

Now that we have demonstrated how this works, you can change your analysis plan back to the original versions of the functions you wrote.

::::::::::::::::::::::::::::::::::::: keypoints 

- Dynamic branching creates multiple targets with a single command
- You usually need to write custom functions so that the output of the branches includes necessary metadata 
- Parallel computing works at the level of the workflow, not the function

::::::::::::::::::::::::::::::::::::::::::::::::
