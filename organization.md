---
title: 'Best Practices for targets Project Organization'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What are best practices for organizing `targets` projects?
- How does the organization of a `targets` workflow differ from a script-based analysis?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain how to organize `targets` projects for maximal reproducibility
- Understand how to use functions in the context of `targets`

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Demonstrate best-practices for project organization

:::::::::::::::::::::::::::::::::::::



## A simpler way to write workflow plans

The default way to specify targets in the plan is with the `tar_target()` function.
But this way of writing plans can be a bit verbose.

There is an alternative provided by the `tarchetypes` package, also written by the creator of `targets`, Will Landau.

::::::::::::::::::::::::::::::::::::: prereq

## Install `tarchetypes`

If you haven't done so yet, install `tarchetypes` with `install.packages("tarchetypes")`.

:::::::::::::::::::::::::::::::::::::

The purpose of the `tarchetypes` is to provide various shortcuts that make writing `targets` pipelines easier.
We will introduce just one for now, `tar_plan()`. This is used in place of `list()` at the end of the `_targets.R` script.
By using `tar_plan()`, instead of specifying targets with `tar_target()`, we can use a syntax like this: `target_name = target_command`.

Let's edit the penguins workflow to use the `tar_plan()` syntax:

<!-- The chunk below intersperses plan_2b with clean_penguin_data() to avoid writing it manually -->

``` r
library(targets)
library(tarchetypes)
library(palmerpenguins)
library(tidyverse)

clean_penguin_data <- function(penguins_data_raw) {
  penguins_data_raw |>
    select(
      species = Species,
      bill_length_mm = `Culmen Length (mm)`,
      bill_depth_mm = `Culmen Depth (mm)`
    ) |>
    remove_missing(na.rm = TRUE) |>
    # Split "species" apart on spaces, and only keep the first word
    separate(species, into = "species", extra = "drop")
}

tar_plan(
  penguins_csv_file = path_to_file("penguins_raw.csv"),
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  penguins_data = clean_penguin_data(penguins_data_raw)
)
```

I think it is easier to read, do you?

Notice that `tar_plan()` does not mean you have to write *all* targets this way; you can still use the `tar_target()` format within `tar_plan()`.
That is because `=`, while short and easy to read, does not provide all of the customization that `targets` is capable of.
This doesn't matter so much for now, but it will become important when you start to create more advanced `targets` workflows.

## Organizing files and folders

So far, we have been doing everything with a single `_targets.R` file.
This is OK for a small workflow, but does not work very well when the workflow gets bigger.
There are better ways to organize your code.

First, let's create a directory called `R` to store R code *other than* `_targets.R` (remember, `_targets.R` must be placed in the overall project directory, not in a subdirectory).
Create a new R file in `R/` called `functions.R`.
This is where we will put our custom functions.
Let's go ahead and put `clean_penguin_data()` in there now and save it.

Similarly, let's put the `library()` calls in their own script in `R/` called `packages.R` (this isn't the only way to do it though; see the ["Managing Packages" episode](https://joelnitta.github.io/targets-workshop/packages.html) for alternative approaches).

We will also need to modify our `_targets.R` script to call these scripts with `source`:


``` r
source("R/packages.R")
source("R/functions.R")

tar_plan(
  penguins_csv_file = path_to_file("penguins_raw.csv"),
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  penguins_data = clean_penguin_data(penguins_data_raw)
)
```

Now `_targets.R` is much more streamlined: it is focused just on the workflow and immediately tells us what happens in each step.

Finally, let's make some directories for storing data and output---files that are not code.
Create a new directory inside the targets cache called `user`: `_targets/user`.
Within `user`, create two more directories, `data` and `results`.
(If you use version control, you will probably want to ignore the `_targets` directory).

## A word about functions

We mentioned custom functions earlier in the lesson, but this is an important topic that deserves further clarification.
If you are used to analyzing data in R with a series of scripts instead of a single workflow like `targets`, you may not write many functions (using the `function()` function).

This is a major difference from `targets`.
It would be quite difficult to write an efficient `targets` pipeline without the use of custom functions, because each target you build has to be the output of a single command.

We don't have time in this curriculum to cover how to write functions in R, but the [Software Carpentry lesson](https://swcarpentry.github.io/r-novice-gapminder/10-functions) is recommended for reviewing this topic.

Another major difference is that **each target must have a unique name**.
You may be used to writing code that looks like this:


``` r
# Store a person's height in cm, then convert to inches
height <- 160
height <- height / 2.54
```

You would get an error if you tried to run the equivalent targets pipeline:


``` r
tar_plan(
    height = 160,
    height = height / 2.54
)
```


``` error
Error:
! Error running targets::tar_make()
Error messages: targets::tar_meta(fields = error, complete_only = TRUE)
Debugging guide: https://books.ropensci.org/targets/debugging.html
How to ask for help: https://books.ropensci.org/targets/help.html
Last error message:
    duplicated target names: height
Last error traceback:
    base::tryCatch(base::withCallingHandlers({ NULL base::saveRDS(base::do.c...
    tryCatchList(expr, classes, parentenv, handlers)
    tryCatchOne(tryCatchList(expr, names[-nh], parentenv, handlers[-nh]), na...
    doTryCatch(return(expr), name, parentenv, handler)
    tryCatchList(expr, names[-nh], parentenv, handlers[-nh])
    tryCatchOne(expr, names, parentenv, handlers[[1L]])
    doTryCatch(return(expr), name, parentenv, handler)
    base::withCallingHandlers({ NULL base::saveRDS(base::do.call(base::do.ca...
    base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("/tmp/R...
    base::do.call(base::do.call, base::c(base::readRDS("/tmp/Rtmp2buwCZ/call...
    (function (what, args, quote = FALSE, envir = parent.frame()) { if (!is....
    (function (targets_function, targets_arguments, options, envir = NULL, s...
    tryCatch(out <- withCallingHandlers(targets::tar_callr_inner_try(targets...
    tryCatchList(expr, classes, parentenv, handlers)
    tryCatchOne(expr, names, parentenv, handlers[[1L]])
    doTryCatch(return(expr), name, parentenv, handler)
    withCallingHandlers(targets::tar_callr_inner_try(targets_function = targ...
    targets::tar_callr_inner_try(targets_function = targets_function, target...
    pipeline_from_list(targets)
    pipeline_from_list.default(targets)
    pipeline_init(out)
    pipeline_targets_init(targets, clone_targets)
    tar_assert_unique_targets(names)
    tar_throw_validate(message)
    tar_error(message = paste0(...), class = c("tar_condition_validate", "ta...
    rlang::abort(message = message, class = class, call = tar_empty_envir)
    signal_abort(cnd, .file)
```

**A major part of working with `targets` pipelines is writing custom functions that are the right size.**
They should not be so small that each is just a single line of code; this would make your pipeline difficult to understand and be too difficult to maintain.
On the other hand, they should not be so big that each has large numbers of inputs and is thus overly sensitive to changes.

Striking this balance is more of art than science, and only comes with practice. I find a good rule of thumb is no more than three inputs per target.

::::::::::::::::::::::::::::::::::::: keypoints 

- Put code in the `R/` folder
- Put functions in `R/functions.R`
- Specify packages in `R/packages.R`
- Put other miscellaneous files in `_targets/user`
- Writing functions is a key skill for `targets` pipelines

::::::::::::::::::::::::::::::::::::::::::::::::
