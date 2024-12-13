---
title: 'Managing Packages'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How should I manage packages for my `targets` project?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Demonstrate best practices for managing packages

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to load packages and maintain package versions

:::::::::::::::::::::::::::::::::::::



## Loading packages

Almost every R analysis relies on packages for functions beyond those available in base R.

There are three main ways to load packages in `targets` workflows.

### Method 1: `library()` {#method-1}

This is the method you are almost certainly more familiar with, and is the method we have been using by default so far.

Like any other R script, include `library()` calls near the top of the `_targets.R` script. Alternatively (and as the <!-- FIXME ADD LINK -->recommended best practice for project organization), you can put all of the `library()` calls in a separate script---this is typically called `packages.R` and stored in the `R/` directory of your project.

The potential downside to this approach is that if you have a long list of packages to load, certain functions like `tar_visnetwork()`, `tar_outdated()`, etc., may take an unnecessarily long time to run because they have to load all the packages, even though they don't necessarily use them.

### Method 2: `tar_option_set()` {#method-2}

In this method, use the `tar_option_set()` function in `_targets.R` to specify the packages to load when running the workflow.

This will be demonstrated using the pre-cleaned dataset from the `palmerpenguins` package. Let's say we want to filter it down to just data for the Adelie penguin.

::::::::::::::::::::::::::::::::::::: {.callout}

## Save your progress

You can only have one active `_targets.R` file at a time in a given project.

We are about to create a new `_targets.R` file, but you probably don't want to lose your progress in the one we have been working on so far (the penguins bill analysis). You can temporarily rename that one to something like `_targets_old.R` so that you don't overwrite it with the new example `_targets.R` file below. Then, rename them when you are ready to work on it again.

:::::::::::::::::::::::::::::::::::::

This is what using the `tar_option_set()` method looks like:


``` r
library(targets)
library(tarchetypes)

tar_option_set(packages = c("dplyr", "palmerpenguins"))

tar_plan(
  adelie_data = filter(penguins, species == "Adelie")
)
```


``` output
▶ dispatched target adelie_data
● completed target adelie_data [0.017 seconds, 1.544 kilobytes]
▶ ended pipeline [0.106 seconds]
```

This method gets around the slow-downs that may sometimes be experienced with Method 1.

### Method 3: `packages` argument of `tar_target()` {#method-3}

The main function for defining targets, `tar_target()` includes a `packages` argument that will load the specified packages **only for that target**.

Here is how we could use this method, modified from the same example as above.


``` r
library(targets)
library(tarchetypes)

tar_plan(
  tar_target(
    adelie_data,
    filter(penguins, species == "Adelie"),
    packages = c("dplyr", "palmerpenguins")
  )
)
```


``` output
▶ dispatched target adelie_data
● completed target adelie_data [0.016 seconds, 1.544 kilobytes]
▶ ended pipeline [0.106 seconds]
```

This can be more memory efficient in some cases than loading all packages, since not every target is always made during a typical run of the workflow.
But, it can be tedious to remember and specify packages needed on a per-target basis.

### One more option

Another alternative that does not actually involve loading packages is to specify the package associated with each function by using the `::` notation, for example, `dplyr::mutate()`.
This means you can **avoid loading packages altogether**.

Here is how to write the plan using this method:


``` r
library(targets)
library(tarchetypes)

tar_plan(
  adelie_data = dplyr::filter(palmerpenguins::penguins, species == "Adelie")
)
```


``` output
▶ dispatched target adelie_data
● completed target adelie_data [0.009 seconds, 1.544 kilobytes]
▶ ended pipeline [0.098 seconds]
```

The benefits of this approach are that the origins of all functions is explicit, so you could browse your code (for example, by looking at its source in GitHub), and immediately know where all the functions come from.
The downside is that it is rather verbose because you need to type the package name every time you use one of its functions.

### Which is the right way?

**There is no "right" answer about how to load packages**---it is a matter of what works best for your particular situation.

Often a reasonable approach is to load your most commonly used packages with `library()` (such as `tidyverse`) in `packages.R`, then use `::` notation for less frequently used functions whose origins you may otherwise forget.

## Maintaining package versions

### Tracking of custom functions vs. functions from packages

A critical thing to understand about `targets` is that **it only tracks custom functions and targets**, not functions provided by packages.

However, the content of packages can change, and packages typically get updated on a regular basis. **The output of your workflow may depend not only on the packages you use, but their versions**.

Therefore, it is a good idea to track package versions.

### About `renv`

Fortunately, you don't have to do this by hand: there are R packages available that can help automate this process. We recommend [renv](https://rstudio.github.io/renv/index.html), but there are others available as well (e.g., [groundhog](https://groundhogr.com/)). We don't have the time to cover detailed usage of `renv` in this lesson. To get started with `renv`, see the ["Introduction to renv" vignette](https://rstudio.github.io/renv/articles/renv.html).

You can generally use `renv` the same way you would for a `targets` project as any other R project. However, there is one exception: if you load packages using `tar_option_set()` or the `packages` argument of `tar_target()` ([Method 2](#method-2) or [Method 3](#method-3), respectively), `renv` will not detect them (because it expects packages to be loaded with `library()`, `require()`, etc.).

The solution in this case is to use the [`tar_renv()` function](https://docs.ropensci.org/targets/reference/tar_renv.html). This will write a separate file with `library()` calls for each package used in the workflow so that `renv` will properly detect them.

### Selective tracking of functions from packages

Because `targets` doesn't track functions from packages, if you update a package and the contents of one of its functions changes, `targets` **will not re-build the target that was generated by that function**.

However, it is possible to change this behavior on a per-package basis.
This is best done only for a small number of packages, since adding too many would add too much computational overhead to `targets` when it has to calculate dependencies.
For example, you may want to do this if you are using your own custom package that you update frequently.

The way to do so is by using `tar_option_set()`, specifying the **same** package name in both `packages` and `imports`. Here is a modified version of the earlier code that demonstrates this for `dplyr` and `palmerpenguins`.


``` r
library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("dplyr", "palmerpenguins"),
  imports = c("dplyr", "palmerpenguins")
)

tar_plan(
  adelie_data = filter(penguins, species == "Adelie")
)
```

If we were to re-install either `dplyr` or `palmerpenguins` and one of the functions used from those in the pipeline changes (for example, `filter()`), any target depending on that function will be rebuilt.

## Resolving namespace conflicts

There is one final best-practice to mention related to packages: resolving namespace conflicts.

"Namespace" refers to the idea that a certain set of unique names are only unique **within a particular context**.
For example, all the function names of a package have to be unique, but only within that package.
Function names could be duplicated across packages.

As you may imagine, this can cause confusion.
For example, the `filter()` function appears in both the `stats` package and the `dplyr` package, but does completely different things in each.
This is a **namespace conflict**: how do we know which `filter()` we are talking about?

The `conflicted` package can help prevent such confusion by stopping you if you try to use an ambiguous function, and help you be explicit about which package to use.
We don't have time to cover the details here, but you can read more about how to use `conflicted` at its [website](https://conflicted.r-lib.org/).

When you use `conflicted`, you will typically run a series of commands to explicitly resolve namespace conflicts, like `conflicts_prefer(dplyr::filter)` (this would tell R that we want to use `filter` from `dplyr`, not `stats`).

To use this in a `targets` workflow, you should put all calls to `conflicts_prefer` in a special file called `.Rprofile` that is located in the main folder of your project. This will ensure that the conflicts are always resolved for each target.

The recommended way to edit your `.Rprofile` is to use `usethis::edit_r_profile("project")`.
This will open `.Rprofile` in your editor, where you can edit it and save it.

For example, your `.Rprofile` could include this:


``` r
library(conflicted)
conflicts_prefer(dplyr::filter)
```

Note that you don't need to run `source()` to run the code in `.Rprofile`.
It will always get run at the start of each R session automatically.

::::::::::::::::::::::::::::::::::::: keypoints 

- There are multiple ways to load packages with `targets`
- `targets` only tracks user-defined functions, not packages
- Use `renv` to manage package versions
- Use the `conflicted` package to manage namespace conflicts

::::::::::::::::::::::::::::::::::::::::::::::::
