---
title: Setup
---

This lesson assumes you have R, RStudio, and the `targets` R package installed on your computer.

- [Download and install the latest version of R](https://www.r-project.org/).
- [Download and install RStudio](https://www.rstudio.com/products/rstudio/download/#download). RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features. You will need the free Desktop version for your computer.
- Install the `targets` package by running the command `install.packages("targets")` in R.

We will also be using some extra packages related to `targets`, and you should install these also:

```r
install.packages(c(
    "visNetwork",           # visualizing the workflow
    "tarchetypes",           # target and plan formatting
    "palmerpenguins",       # example data
    "broom",                # tidy model outputs
    "purrr",                # iterative operations
    "future",               # parallel processing
    "future.batchtools",    # parallel processing
    "future.callr",         # parallel processing
    "quarto"                # report generation
))
```
