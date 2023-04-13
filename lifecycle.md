---
title: 'The Workflow Lifecycle'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What happens if we re-run a workflow?
- How does `targets` know what steps to re-run?
- How can I override default settings?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain how `targets` helps increase efficiency
- Be able to inspect a workflow to see what parts are outdated
- Be able to run only a specific part of the workflow

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `targets` only runs the steps that have been affected by a change to the code
- `tar_visnetwork()` shows the current state of the workflow as a network
- `tar_progress()` shows the current state of the workflow as a data frame
- `tar_outdated()` lists outdated targets that will be built in the next `tar_make()`

::::::::::::::::::::::::::::::::::::::::::::::::
