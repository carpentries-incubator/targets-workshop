---
title: Setup
---

This lesson assumes you have R, RStudio, and the `targets` R package installed on your computer.

- [Download and install the latest version of R](https://www.r-project.org/).
- [Download and install RStudio](https://www.rstudio.com/products/rstudio/download/#download). RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features. You will need the free Desktop version for your computer.
- Install the `targets` package by running the command `install.packages("targets")` in R.

We will also be using a couple extra packages related to `targets`, and you should install these also:

```r
install.packages(c
    "visNetwork",           # visualising the workflow
    "tarchetypes"           # simpler write-up of workflows
    "palmerpenguins".       # example data
    "broom".                # tidy model outputs
    "purrr".                # iterative operations
    "future",               # parallell processing
    "future.batchtools",    # parallell processing
    "future.callr",         # parallell processing
    "quarto"                # report generation
))
```
