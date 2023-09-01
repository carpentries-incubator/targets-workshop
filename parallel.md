---
title: 'Parallel Processing'
teaching: 10
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

### Install R packages for parallel computing

For this demo, we will use the new [`crew` backend](https://wlandau.github.io/crew/).

::::::::::::::::::::::::::::::::::::: {.prereq}

### Install required packages

You will need to install several packages to use the `crew` backend:


```r
install.packages("nanonext", repos = "https://shikokuchuo.r-universe.dev")
install.packages("mirai", repos = "https://shikokuchuo.r-universe.dev")
install.packages("crew", type = "source")
```

:::::::::::::::::::::::::::::::::::::

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


```r
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
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Build models
  models = list(
    combined_model = lm(
      bill_depth_mm ~ bill_length_mm, data = penguins_data),
    species_model = lm(
      bill_depth_mm ~ bill_length_mm + species, data = penguins_data),
    interaction_model = lm(
      bill_depth_mm ~ bill_length_mm * species, data = penguins_data)
  ),
  # Get model summaries
  tar_target(
    model_summaries,
    glance_with_mod_name(models),
    pattern = map(models)
  ),
  # Get model predictions
  tar_target(
    model_predictions,
    augment_with_mod_name(models),
    pattern = map(models)
  )
)
```

There is still one more thing we need to modify only for the purposes of this demo: if we ran the analysis in parallel now, you wouldn't notice any difference in compute time because the functions are so fast.

So let's make "slow" versions of `glance_with_mod_name()` and `augment_with_mod_name()` using the `Sys.sleep()` function, which just tells the computer to wait some number of seconds.
This will simulate a long-running computation and enable us to see the difference between running sequentially and in parallel.

Add these functions to `functions.R` (you can copy-paste the original ones, then modify them):


```r
glance_with_mod_name_slow <- function(model_in_list) {
  Sys.sleep(4)
  model_name <- names(model_in_list)
  model <- model_in_list[[1]]
  broom::glance(model) |>
    mutate(model_name = model_name)
}
augment_with_mod_name_slow <- function(model_in_list) {
  Sys.sleep(4)
  model_name <- names(model_in_list)
  model <- model_in_list[[1]]
  broom::augment(model) |>
    mutate(model_name = model_name)
}
```

Then, change the plan to use the "slow" version of the functions:


```r
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
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Build models
  models = list(
    combined_model = lm(
      bill_depth_mm ~ bill_length_mm, data = penguins_data),
    species_model = lm(
      bill_depth_mm ~ bill_length_mm + species, data = penguins_data),
    interaction_model = lm(
      bill_depth_mm ~ bill_length_mm * species, data = penguins_data)
  ),
  # Get model summaries
  tar_target(
    model_summaries,
    glance_with_mod_name_slow(models),
    pattern = map(models)
  ),
  # Get model predictions
  tar_target(
    model_predictions,
    augment_with_mod_name_slow(models),
    pattern = map(models)
  )
)
```

Finally, run the pipeline with `tar_make()` as normal.


```{.output}
✔ skip target penguins_data_raw_file
✔ skip target penguins_data_raw
✔ skip target penguins_data
✔ skip target models
• start branch model_predictions_5ad4cec5
• start branch model_predictions_c73912d5
• start branch model_predictions_91696941
• start branch model_summaries_5ad4cec5
• start branch model_summaries_c73912d5
• start branch model_summaries_91696941
• built branch model_predictions_5ad4cec5 [5.917 seconds]
• built branch model_predictions_c73912d5 [5.959 seconds]
• built branch model_predictions_91696941 [4.012 seconds]
• built pattern model_predictions
• built branch model_summaries_5ad4cec5 [4.025 seconds]
• built branch model_summaries_c73912d5 [4.017 seconds]
• built branch model_summaries_91696941 [4.009 seconds]
• built pattern model_summaries
• end pipeline [19.876 seconds]
```

Notice that although the time required to build each individual target is about 4 seconds, the total time to run the entire workflow is less than the sum of the individual target times! That is proof that processes are running in parallel **and saving you time**.

The unique and powerful thing about targets is that **we did not need to change our custom function to run it in parallel**. We only adjusted *the workflow*. This means it is relatively easy to refactor (modify) a workflow for running sequentially locally or running in parallel in a high-performance context.

Now that we have demonstrated how this works, you can change your analysis plan back to the original versions of the functions you wrote.

::::::::::::::::::::::::::::::::::::: keypoints 

- Dynamic branching creates multiple targets with a single command
- You usually need to write custom functions so that the output of the branches includes necessary metadata 
- Parallel computing works at the level of the workflow, not the function

::::::::::::::::::::::::::::::::::::::::::::::::
