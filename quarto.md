---
title: 'Reproducible Reports with Quarto'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we create reproducible reports?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to generate a report using `targets`

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to write reports with Quarto

:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `tarchetypes::tar_quarto()` is used to render Quarto documents
- You should load targets within the Quarto document using `tar_load()` and `tar_read()`
- It is recommended to do heavy computations in the main targets workflow, and lighter formatting and plot generation in the Quarto document

::::::::::::::::::::::::::::::::::::::::::::::::
