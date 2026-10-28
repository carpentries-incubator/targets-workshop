---
title: Setup
---

Follow these instructions to install the required software on your computer.

- [Download and install the latest version of R](https://www.r-project.org/). This lesson requires **R version 4.5.0 or later**, because the penguins data we use is included in base R starting with that version.
- [Download and install RStudio](https://www.rstudio.com/products/rstudio/download/#download). RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features, including the [Quarto](https://quarto.org/) publishing system. You will need the free Desktop version for your computer.
- Install the necessary R packages with the following command:

```r
install.packages(
  c(
    "crew",
    "quarto",
    "tarchetypes",
    "targets",
    "tidyverse",
    "visNetwork"
  )
)
```
