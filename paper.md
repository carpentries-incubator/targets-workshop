---
title: 'A Carpentries-style workshop for reproducible analysis workflows in R using the `targets` package'
tags:
  - R
  - reproducibility
  - workshop
authors:
  - name: Joel H. Nitta
    orcid: 0000-0003-4719-7472
    affiliation: 1
  - name: Author
    affiliation: 2
affiliations:
 - name: Graduate School of Global and Transdisciplinary Studies, College of Liberal Arts and Sciences, Chiba University, Chiba, Japan
   index: 1
 - name: Institution 2
   index: 2
date: 13 December 2024
bibliography: paper.bib

---

# Summary

Reproducibility is critical for sustainable science [@Diaba-Nuhoho2021a].
While reproducibility of data analysis can be greatly improved by using code, the results of loosely or poorly organized code may be difficult or impossible to reproduce [@Trisovic2022].
Furthermore, as a project grows in complexity, it becomes difficult to manually track which steps of an analysis need to be re-run due to changes in the code base.
The `targets` R package [@Landau2021] automates data analysis workflows in R, thus greatly improving both reproducibility and efficiency, and is rapidly becoming the de-facto workflow manager package in R.
However, `targets` adopts a functions-focused approach that is different from the way most beginners write R code, and little documentation exists to help onboard researchers seeking to use `targets`.

Here, we present a one-day workshop based on the highly successful [Carpentries](https://www.carpentries.org) format to teach `targets` to beginners [@Wilson2016].
Although no specialized knowledge of any field is required, the workshop is designed for researchers at the advanced undergraduate level and above, and presumes a basic working knowledge of R.
The workshop curriculum is openly available under a [CC-BY 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license at <https://github.com/carpentries-incubator/targets-workshop>.

# Statement of Need

`targets` is difficult for beginners to learn because it executes R code in an non-interactive session and heavily relies on user-defined functions.
While the documentation provided by the package is extensive, it is not necessarily easy for beginners to access.
This workshop fills the need for `targets` curriculum focused on researchers with basic R skills but who have never used `targets` before and may be unfamiliar with writing functions or executing code in non-interactive sessions.

# Curriculum design

The curriculum takes a project-based approach, using the Palmer Penguins dataset to model the relationship between bill depth and length in three different species of penguins [@Horst2020a].
The end result of the analysis demonstrates Simpson's paradox: the observed relationship when pooling data from all species together is actually opposite to that observed in each species individually [@Blyth1972a].
The workflow follows the typical steps of a scientific data analysis, starting from loading the raw data, then cleaning the data, fitting models, and finally visualizing the results and writing out a report.

Following The Carpentries' model of curriculum design, the workshop is split up into modules with estimated teaching time of ca. 10 to 30 min. each, known as "episodes" (Table 1). Based on our experience of running the workshop four times to date, we estimate that the workshop can be finished in a half day to a full day, depending on the skill level of the participants and amount of detail covered in each episode.
Episodes build on each other, so they should be taught in order.

Episode | Description
---------|----------
1. Introduction | Concepts of reproducibility and workflows
2. First `targets` Workflow | Creation of a minimal `targets` workflow
3. Loading Workflow Objects | How to load objects created by `targets` into an interactive R session
3. The Workflow Lifecycle | Understanding why `targets` is able to only re-run the steps needed to reproduce a workflow after a change
4. Best Practices for `targets` Project Organization | How to organize code and files
5. Managing Packages | Understanding how `targets` handles R packages
6. Working with External Files | Understanding how to track the contents of a file
7. Branching | How `targets` can efficiently create workflow steps in an automated fashion
8. Parallel Processing | Speeding up analysis with parallel processing
9. Reproducible Reports with Quarto | Generating a completely reproducible report for a broader audience

Table 1: Summary of the `targets` workshop curriculum contents.

# Story of the workshop

The workshop developed out of the repeated need to teach `targets` to researchers.
JHN started teaching `targets` without the use of a curriculum in 2022 for the [AsiaR meetup](https://www.youtube.com/watch?v=XMvinGSG72k&t=1346s) and [Bio"Pack"athon meetup](https://www.youtube.com/watch?v=qwZsMKUMu6U).
When it became clear that the demand for `targets` instruction was only increasing, he realized it benefit not only himself but others to have a standardized curriculum.

The next major impetus for curriculum creation occurred when JHN visited Norway in Summer of 2023 to teach an unrelated [workshop on spatial phylogenetics](https://www.forbio.uio.no/events/courses/2023/Workshop%20in%20Spatial%20Phylogenetics).
He reached out to his colleague and fellow R practitioner Dr. Athanasia Mowinckel about the possibility of getting together for coffee, who suggested the idea of running a `targets` workshop at the University of Oslo, as described in this [blog post](https://ropensci.org/blog/2023/07/20/teaching-targets-with-penguins/).
JHN realized this was the motivation he needed to draft a Carpentries-style curriculum to teach `targets`.
Prior to the workshop, JHN and AM collaborated through GitHub to craft the curriculum that was used at the workshop and is the basis for the current curriculum.

The next major phase of curriculum development occurred in 2023, when MM taught the workshop at XXX.
Based on the needs of participants there, MM added an episode for using targets in the context of high-performance computing, as well as contributing improvements to the code base of the lesson to simplify authoring `targets` code chunks.

The workshop was taught by JHN twice more during 2024 at Chiba University, Japan.
Solicitation of feedback from participants, including comments on what went well vs. could be improved, has lead to gradual improvements in the curriculum.
These are all documented as [issues](https://github.com/carpentries-incubator/targets-workshop/issues) in the GitHub repository.
For example, we have made attempts to minimize mental load by [simplifying the code related to branching](https://github.com/carpentries-incubator/targets-workshop/pull/51).

As development of the curriculum is [collaborative](https://carpentries.github.io/lesson-development-training/) and conducted openly on [GitHub](https://github.com/carpentries-incubator/targets-workshop), we hope that other researchers will teach the workshop and provide feedback and/or contributions to make further improvements going forward.

# Acknowledgements

We thank all participants in the workshop so far for their helpful feedback that has been used to improve the curriculum. We thank The Carpentries for providing the infrastructure to develop and maintain workshop curricula, in particular Zhian N. Kamvar and Toby Hodges.