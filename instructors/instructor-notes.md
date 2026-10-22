---
title: 'Instructor Notes'
---

## General notes

The examples gradually build up to a full analysis of the [Palmer Penguins dataset](https://allisonhorst.github.io/palmerpenguins/); the final version is in this repository: the workflow (`_targets.R`) is [`plan_11.R`](https://github.com/carpentries-incubator/targets-workshop/blob/main/episodes/files/plans/plan_11.R) (the last of the numbered plan files in `episodes/files/plans/`), the custom functions it uses are in [`tar_functions`](https://github.com/carpentries-incubator/targets-workshop/tree/main/episodes/files/tar_functions), and the report is [`penguin_report.qmd`](https://github.com/carpentries-incubator/targets-workshop/blob/main/episodes/files/penguin_report.qmd). However, in the "Managing Packages" episode, completely different code is demonstrated to explain a concept. Since a given `targets` project can only have one `_targets.R` file, this means the participants may have to delete their existing `_targets.R` file and write a new one to follow along with that example. This may cause frustration if they can't keep a record of what they have done so far. One solution would be to save the old `_targets.R` file as `_targets_old.R` or similar, then rename it when it should be run again.

## Optional episodes:
The "Function" episode is an optional episode and will depend on the learners coming to your workshop.
We would recommend having a show of hands (or stickies) who has experience with functions, and if you have learners who do not, run this episode.

targets relies so much on functions we believe it is worth spending a little time on if you have learners inexperienced with them, they will quickly fall behind and not be empowered to use targets at the end of the workshop if they don't get a short introduction.

