---
title: 'Advanced topics'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can I control the building of each target?
- How can I maintain multiple workflows within a single project?
- How can I make sure the workflow is in sync with the R packages it uses?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to run only a specific part of the workflow
- Understand how to control project settings with a YAML file
- Adhere to best practices for maintaining package versions

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- You can provide names of specific targets to build to `tar_make()`
- You can delete targets with `tar_delete()` and manually invalidate them with `tar_invalidate()`
- The settings for each targets project are contained in the `_targets.yaml` file
- `targets` does not track the content of R packages by default
- `renv` should be used for tracking package versions

::::::::::::::::::::::::::::::::::::::::::::::::

