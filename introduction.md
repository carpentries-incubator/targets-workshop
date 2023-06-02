---
title: "Introduction"
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- Why should we care about reproducibility?
- How can `targets` help us achieve reproducibility?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain why reproducibility is important for science
- Describe the features of `targets` that enhance reproducibility

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: {.instructor}

Episode summary: Introduce the idea of reproducibility and why / who would want to use `targets`

:::::::::::::::::::::::::::::::::::::

## What is reproducibility?

Reproducibility is the ability for others (including your future self) to reproduce your analysis.

We can only have confidence in the results of scientific analyses if they can be reproduced.

However, reproducibility is not a binary concept (not reproducible vs. reproducible); rather, there is a scale from **less** reproducible to **more** reproducible.

`targets` goes a long ways towards making your analyses **more reproducible**.

Other practices you can use to further enhance reproducibility include controlling your computing environment with tools like Docker, conda, or renv, but we don't have time to cover those in this workshop.

## What is `targets`?

`targets` is a workflow management package for the R programming language developed and maintained by Will Landau.

The major features of `targets` include:

- **Automation** of workflow
- **Caching** of workflow steps
- **Batch creation** of workflow steps
- **Parallelization** at the level of the workflow

This allows you to do the following:

- return to a project after working on something else and immediately pick up where you left off without confusion or trying to remember what you were doing
- change the workflow, then only re-run the parts that that are affected by the change
- massively scale up the workflow without changing individual functions

... and of course, it will help others reproduce your analysis.

## Who should use `targets`?

`targets` is by no means the only workflow management software.
There is a large number of similar tools, each with varying features and use-cases.
For example, snakemake is a popular workflow tool for python, and `make` is a tool that has been around for a very long time for automating bash scripts.
`targets` is designed to work specifically with R, so it makes the most sense to use it if you primarily use R, or intend to.
If you mostly code with other tools, you may want to consider an alternative.

The **goal** of this workshop is to **learn how to use `targets` to reproducible data analysis in R**.

::::::::::::::::::::::::::::::::::::: keypoints 

- We can only have confidence in the results of scientific analyses if they can be reproduced by others
- "Others" includes your future self
- `targets` helps achieve reproducibility by automating workflow
- `targests` is designed for use with the R programming language

::::::::::::::::::::::::::::::::::::::::::::::::
