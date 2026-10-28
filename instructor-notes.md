---
title: 'Instructor Notes'
---

## General notes

The examples gradually build up to a full analysis of the [Palmer Penguins dataset](https://allisonhorst.github.io/palmerpenguins/), which is included in base R as `penguins` and `penguins_raw`; the final version is in this repository: the workflow (`_targets.R`) is [`plan_11.R`](https://github.com/carpentries-incubator/targets-workshop/blob/main/episodes/files/plans/plan_11.R) (the last of the numbered plan files in `episodes/files/plans/`), the custom functions it uses are in [`tar_functions`](https://github.com/carpentries-incubator/targets-workshop/tree/main/episodes/files/tar_functions), and the report is [`penguin_report.qmd`](https://github.com/carpentries-incubator/targets-workshop/blob/main/episodes/files/penguin_report.qmd).

## R version

The penguins datasets were added to base R in **R version 4.5.0**, so this lesson requires R 4.5.0 or later. Check that learners (and any shared server or cloud instance you plan to use) have a recent enough version of R before the workshop.

This lesson does not provide a hosted environment. If you want to run the workshop on a cloud service such as Posit Cloud, you will need to set one up yourself with R 4.5.0 or later and the packages listed in the [setup instructions](../learners/setup.md).

## Optional episodes:

The "Managing Packages" episode covers a more advanced topic (different ways to load packages, tracking package versions with `renv`, and namespace conflicts) and could be skipped if you are short on time. The rest of the lesson does not depend on it: the workflow already loads its packages with `library()`.

The "A Brief Introduction to Functions" episode is an optional episode and will depend on the learners coming to your workshop.
We would recommend having a show of hands (or stickies) who has experience with functions, and if you have learners who do not, run this episode.

targets relies so much on functions we believe it is worth spending a little time on if you have learners inexperienced with them, they will quickly fall behind and not be empowered to use targets at the end of the workshop if they don't get a short introduction.

