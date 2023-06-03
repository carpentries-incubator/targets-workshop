---
title: Setup
---

## Local setup

Follow these instructions to install the required software on your computer.

- [Download and install the latest version of R](https://www.r-project.org/).
- [Download and install RStudio](https://www.rstudio.com/products/rstudio/download/#download). RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features. You will need the free Desktop version for your computer.
- [Download and install Quarto](https://quarto.org/docs/download/). Quarto is a program for authoring documents in a variety of formats using code. It is used in this workshop to generate a dynamic report.
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

## Alternative: In the cloud

There is a [Binder](https://mybinder.org/) instance with RStudio and all necessary packages pre-installed available, so you don't need to install anything on your own computer.

Click the "Launch Binder" button below:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/joelnitta/penguins-targets/HEAD?urlpath=rstudio)
