---
title: 'Advanced topics'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can I control the building of each target?
- How can I maintain multiple workflows within a single project?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to run only a specific part of the workflow
- Understand how to control project settings with a YAML file

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show some trickier aspects of targets, such as only running a specific target or managing multiple projects

:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- You can provide names of specific targets to build to `tar_make()`
- You can delete targets with `tar_delete()` and manually invalidate them with `tar_invalidate()`
- The settings for each targets project are contained in the `_targets.yaml` file

::::::::::::::::::::::::::::::::::::::::::::::::

