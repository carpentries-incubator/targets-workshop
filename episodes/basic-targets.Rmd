---
title: 'basic-targets'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What are best practices for organizing analyses?
- What is a `_targets.R` file for?
- What is the content of the `_targets.R` file?
- How do you run a workflow? 

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Create a project in RStudio
- Explain the purpose of the `_targets.R` file
- Write a basic `_targets.R` file
- Use a `_targets.R` file to run a workflow

::::::::::::::::::::::::::::::::::::::::::::::::

## Create a project

### About projects

`targets` uses the "project" concept for organizing analyses: all of the files needed for a given project are put in a single folder, the project folder.
The project folder has additional subfolders for organization, such as folders for data, code, and results.

By using projects, it makes it straightforward to re-orient yourself if you return to an analysis after time spent elsewhere.
This wouldn't be a problem if we only ever work on one thing at a time until completion, but that is almost never the case.
It is hard to remember what you were doing when you come back to a project (a phenomenon called "context switching").
By using a standardized organization system, you will reduce confusion and lost time... in other words, you are increasing reproducibility!

This workshop will use RStudio, since it also works well with the project organization concept.

## Create a project in RStudio

Let's start a new project using RStudio.

Click "File", then select "New Project".

This will open the New Project Wizard, a set of menus to help you set up the project.
In the Wizard, click the first option, "New Directory", since we are making a brand-new project from scratch.
Click "New Project" in the next menu.
In "Directory name", enter a name that helps you remember the purpose of the project, such as "targets-demo" (follow best practices for naming files and folders).
Under "Create project as a subdirectory of...", click the "Browse" button to select a directory to put the project.
We recommend putting it on your Desktop so you can easily find it.

You can leave "Create a git repository" and "Use renv with this project" unchecked, but these are both excellent tools to improve reproducibility, and you should consider learning them and using them in the future, if you don't already.
They can be enabled at any later time, so you don't need to worry about trying to use them immediately.

Once you work through these steps, your RStudio session should look like this (notice "targets-demo" in the title):

Our project now contains a single file, created by RStudio: `.Rproj`. You should not edit this file by hand. Its purpose is to tell RStudio that this is a project folder and to store some RStudio settings (if you use version-control software, it is OK to commit this file). Also, you can open the project by double clicking on the `.Rproj` file in your file explorer (try it by quitting RStudio then navigating in your file browser to your Desktop, opening the "targets-demo" folder, and double clicking `.Rproj`).

OK, now that our project is set up, we are ready to start using `targets`!

## Create a `_targets.R` file

Every `targets` project must include a special file, called `_targets.R` in the main project folder (the "project root").
The `_targets.R` file includes the specification of the workflow: directions for R to run your analysis, kind of like a recipe.
By using the `_targets.R` file, you won't have to remember to run specific scripts in a certain order.
Instead, R will do it for you (more reproducibility points)!

### Anatomy of a `_targets.R` file

We will now start to write a `_targets.R` file. Fortunately, `targets` comes with a function to help us do this.

In the R console, first load the `targets` package with `library(targets)`, then run the command `tar_script()`.

Nothing will happen in the console, but in the file viewer, you should see a new file, `_targets.R` appear. Open it using the File menu or by clicking on it.

We can see this default `_targets.R` file includes three main parts:
- Loading packages with `library()`
- Defining a custom function with `function()`
- Defining a list with `list()`.

The last part, the list, is the most important part of the `_targets.R` file.
It defines the steps in the workflow.
The `_targets.R` file must always end with this list.

Furthermore, each item in the list is a call of the `tar_target()` function.
The first argument of `tar_target()` is name of the target to build, and the second argument is the command used to build it.
Note that the name of the target is **unquoted**, that is, it is written without any surrounding quotation marks.

## Run the workflow

Now that we have a workflow, we can run it with `targets`.

The command to do that is `tar_make()`.

Try it and see what happens!

You should see some messages that R has built the steps of the workflow.

Congratulations, you've run your first workflow with `targets`!

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: What happened during the workflow?

Inspect the list at the end of `_targets.R`. Can you describe the steps of the workflow?

::::::::::::::::::::::::::::::::::::: solution



:::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::: keypoints 

- Projects help keep our analyses organized so we can easily re-run them later
- Use the RStudio Project Wizard to create projects
- The `_targets.R` file is a special file that must be included in all `targets` projects, and defines the worklow
- Use `tar_script()` to create a default `_targets.R` file
- Use `tar_make()` to execute the workflow

::::::::::::::::::::::::::::::::::::::::::::::::

