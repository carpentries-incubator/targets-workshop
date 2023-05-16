---
title: 'First `targets` Workflow'
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
It is hard to remember what you were doing when you come back to a project after working on something else (a phenomenon called "context switching").
By using a standardized organization system, you will reduce confusion and lost time... in other words, you are increasing reproducibility!

This workshop will use RStudio, since it also works well with the project organization concept.

### Create a project in RStudio

Let's start a new project using RStudio.

Click "File", then select "New Project".

This will open the New Project Wizard, a set of menus to help you set up the project.

![The New Project Wizard](fig/basic-rstudio-wizard.png){alt="Screenshot of RStudio New Project Wizard menu"}

In the Wizard, click the first option, "New Directory", since we are making a brand-new project from scratch.
Click "New Project" in the next menu.
In "Directory name", enter a name that helps you remember the purpose of the project, such as "targets-demo" (follow best practices for naming files and folders).
Under "Create project as a subdirectory of...", click the "Browse" button to select a directory to put the project.
We recommend putting it on your Desktop so you can easily find it.

You can leave "Create a git repository" and "Use renv with this project" unchecked, but these are both excellent tools to improve reproducibility, and you should consider learning them and using them in the future, if you don't already.
They can be enabled at any later time, so you don't need to worry about trying to use them immediately.

Once you work through these steps, your RStudio session should look like this:

![Your newly created project](fig/basic-rstudio-project.png){alt="Screenshot of RStudio with a newly created project called 'targets-demo' open containing a single file, 'targets-demo.Rproj'"}

Our project now contains a single file, created by RStudio: `targets-demo.Rproj`. You should not edit this file by hand. Its purpose is to tell RStudio that this is a project folder and to store some RStudio settings (if you use version-control software, it is OK to commit this file). Also, you can open the project by double clicking on the `.Rproj` file in your file explorer (try it by quitting RStudio then navigating in your file browser to your Desktop, opening the "targets-demo" folder, and double clicking `targets-demo.Rproj`).

OK, now that our project is set up, we are ready to start using `targets`!

## Create a `_targets.R` file

Every `targets` project must include a special file, called `_targets.R` in the main project folder (the "project root").
The `_targets.R` file includes the specification of the workflow: directions for R to run your analysis, kind of like a recipe.
By using the `_targets.R` file, you won't have to remember to run specific scripts in a certain order.
Instead, R will do it for you (more reproducibility points)!

### Anatomy of a `_targets.R` file

We will now start to write a `_targets.R` file. Fortunately, `targets` comes with a function to help us do this.

In the R console, first load the `targets` package with `library(targets)`, then run the command `tar_script()`.


```r
library(targets)
tar_script()
```

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

::::::::::::::::::::::::::::::::::::: callout

## Edit `_targets.R`

Let's modify the default workflow: rename the names of the targets from `data` to `my_data` and `summary` to `my_summary`.
This is to avoid confusion with base R functions `data()` and `summary()`.
It is generally a good idea to avoid naming objects in R with the names of existing functions.

Make sure to rename `data` to `my_data` **each time it appears** (twice).
The names of the targets are very important: this is how `targets` knows how workflow steps depend on each other.

:::::::::::::::::::::::::::::::::::::

Your final `_targets.R` file should look like this:


```r
library(targets)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
summ <- function(dataset) {
  colMeans(dataset)
}

# Set target-specific options such as packages:
# tar_option_set(packages = "utils") # nolint

# End this file with a list of target objects.
list(
  tar_target(my_data, data.frame(x = sample.int(100), y = sample.int(100))),
  tar_target(my_summary, summ(my_data)) # Call your custom functions as needed.
)
```

## Run the workflow

Now that we have a workflow, we can run it with the `tar_make()` function.
Try running it, and you should see something like this:


```r
tar_make()
```


```{.output}
• start target my_data
• built target my_data [0.001 seconds]
• start target my_summary
• built target my_summary [0.001 seconds]
• end pipeline [0.079 seconds]
```

Congratulations, you've run your first workflow with `targets`!

::::::::::::::::::::::::::::::::::::: challenge

## Challenge: What happened during the workflow?

Inspect the list at the end of `_targets.R`. Can you describe the steps of the workflow?

:::::::::::::::::::::::::::::::::: solution

The first step of the workflow built a target called `my_data` that includes two variables, `x` and `y`.

The second step of the workflow built a target called `my_summ` that includes the mean of `x` and `y` calculated with a custom function called `summ()`.

::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Projects help keep our analyses organized so we can easily re-run them later
- Use the RStudio Project Wizard to create projects
- The `_targets.R` file is a special file that must be included in all `targets` projects, and defines the worklow
- Use `tar_script()` to create a default `_targets.R` file
- Use `tar_make()` to run the workflow

::::::::::::::::::::::::::::::::::::::::::::::::
