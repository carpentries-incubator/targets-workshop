---
title: 'Best Practices for `targets` Project Organization'
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



## A simpler way to write workflow plans

The default way to specify targets in the plan is with the `tar_target()` function.
But this way of writing plans can be a bit verbose.

There is an alternative provided by the `tarchetypes` package, also written by the creator of `targets`, Will Landau.
If you haven't already, install it with `install.packages("tarchetypes")`.

The purpose of the `tarchetypes` is to provide various shortcuts that make writing `targets` pipelines easier.
We will introduce just one for now, `tar_plan()`. This is used in place of `list()` at the end of the `_targets.R` script.
By using `tar_plan()`, instead of specifying targets with `tar_target()`, we can use a syntax like this: `target_name = target_command`.

For example, try this short targets script:


```r
library(targets)
library(tarchetypes)

tar_plan(
  height_cm = 160,
  height_in = height_cm / 2.54
)
```


```{.output}
• start target height_cm
• built target height_cm [0.001 seconds]
• start target height_in
• built target height_in [0 seconds]
• end pipeline [0.065 seconds]
```

Notice that `tar_plan()` does not mean you have to write *all* targets this way; you can still use the `tar_target()` format within `tar_plan()`.
That is because `=`, while short and easy to read, does not provide all of the customization that `targets` is capable of.
This doesn't matter so much for now, but it will become important when you start to create more advanced `targets` workflows.

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge 1: Try `tar_plan()`

How can we use `tar_plan()` to rewrite `_targets.R` with simpler syntax?

:::::::::::::::::::::::::::::::::: {.solution}


```r
library(targets)
library(tarchetypes)

summarize_data <- function(dataset) {
  rowMeans(dataset)
}

tar_plan(
  my_data = data.frame(x = sample.int(100), y = sample.int(100)),
  my_summary = summarize_data(data)
)
```

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

## Organizing files and folders

So far, we have been doing everything with a single `_targets.R` file.
This is OK for a small workflow, but does not work very well when the workflow gets bigger.
There are better ways to organize your code.

First, let's create a directory called `R` to store R code *other than* `_targets.R` (remember, `_targets.R` must be placed in the overall project directory, not in a subdirectory).
Create a new R file in `R/` called `functions.R`.
This is where we will put our custom functions.
Let's go ahead and put `summ()` in there now and save it.

We will also need to modify our `_targets.R` script.

Next, let's make some directories for storing data and output---files that are not code.
Create a new directory inside the targets cache called `user`: `_targets/user`.
Within `user`, create two more directories, `data` and `results`.
(If you use version control, you will probably want to ignore the `_targets` directory).

## A word about functions

If you are used to analyzing data in R with a series of scripts instead of a single workflow like `targets`, you may not write many functions (using the `function()` function).

This is a major difference from `targets`.
It would be quite difficult to write an efficient `targets` pipeline without the use of custom functions, because each target you build has to be the output of a single function.

We don't have time in this curriculum to cover how to write functions in R, but the Software Carpentry lesson is recommended for reviewing this topic.

Another major difference is that **each target must have a unique name**.
You may be used to writing code that looks like this:


```r
# Store a person's height in cm, then convert to inches
height <- 160
height <- height / 2.54
```

You would get an error if you tried to run the equivalent targets pipeline:


```r
tar_plan(
  height = 160,
  height = height / 2.54
)
```


```{.error}
Error:
! Error running targets::tar_make()
  Error messages: targets::tar_meta(fields = error, complete_only = TRUE)
  Debugging guide: https://books.ropensci.org/targets/debugging.html
  How to ask for help: https://books.ropensci.org/targets/help.html
  Last error: duplicated target names: height
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

::::::::::::::::::::::::::::::::::::::::::::::::

