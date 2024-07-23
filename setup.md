---
title: Setup
---

## Local setup

Follow these instructions to install the required software on your computer.

- [Download and install the latest version of R](https://www.r-project.org/).
- [Download and install RStudio](https://www.rstudio.com/products/rstudio/download/#download). RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features, including the [Quarto](https://quarto.org/) publishing system. You will need the free Desktop version for your computer.
- Install the necessary R packages with the following command:

```r
install.packages(
  c(
    "conflicted",
    "crew",
    "palmerpenguins",
    "quarto",
    "tarchetypes",
    "targets",
    "tidyverse",
    "visNetwork"
  )
)
```

## Alternative: In the cloud

There is a [Posit Cloud](https://posit.cloud/) instance with RStudio and all necessary packages pre-installed available, so you don't need to install anything on your own computer. You may need to create an account (free).

Click this link to open: <https://posit.cloud/content/6064275>
