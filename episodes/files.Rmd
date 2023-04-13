---
title: 'Working with External Files'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we load external data?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to load external data into a workflow
- Configure the workflow to rerun if the contents of the external data change

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `tarchetypes::tar_file_read()` is used to load external data
- A target defined by `tarchetypes::tar_file_read()` will become outdated if the external data changes

::::::::::::::::::::::::::::::::::::::::::::::::
