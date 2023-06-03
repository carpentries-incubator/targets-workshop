---
title: Setup
---

Follow these instructions to install the required software on your computer.

- [Download and install the latest version of R](https://www.r-project.org/).
- [Download and install RStudio](https://www.rstudio.com/products/rstudio/download/#download). RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features. You will need the free Desktop version for your computer.
- Install the necessary R packages with the following command:

```r
install.packages(
  c(
    "conflicted",
    "future.callr",
    "future",
    "palmerpenguins",
    "quarto",
    "tarchetypes",
    "targets",
    "tidyverse",
    "visNetwork"
  )
)
```
