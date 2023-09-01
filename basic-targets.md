---
title: 'First targets Workflow'
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

::::::::::::::::::::::::::::::::::::: {.instructor}

Episode summary: First chance to get hands dirty by writing a very simple workflow

:::::::::::::::::::::::::::::::::::::



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

## Set up `_targets.R` file to run example analysis

### Background: non-`targets` version

We will use this template to start building our analysis of bill shape in penguins.
First though, to get familiar with the functions and packages we'll use, let's run the code like you would in a "normal" R script without using `targets`.

Recall that we are using the `palmerpenguins` R package to obtain the data.
This package actually includes two variations of the dataset: one is an external CSV file with the raw data, and another is the cleaned data loaded into R.
In real life you are probably have externally stored raw data, so **let's use the raw penguin data** as the starting point for our analysis too.

The `path_to_file()` function in `palmerpenguins` provides the path to the raw data CSV file (it is inside the `palmerpenguins` R package source code that you downloaded to your computer when you installed the package).


```r
library(palmerpenguins)

# Get path to CSV file
penguins_csv_file <- path_to_file("penguins_raw.csv")

penguins_csv_file
```

```{.output}
[1] "/home/runner/.local/share/renv/cache/v5/R-4.3/x86_64-pc-linux-gnu/palmerpenguins/0.1.1/6c6861efbc13c1d543749e9c7be4a592/palmerpenguins/extdata/penguins_raw.csv"
```

We will use the `tidyverse` set of packages for loading and manipulating the data. We don't have time to cover all the details about using `tidyverse` now, but if you want to learn more about it, please see the ["Manipulating, analyzing and exporting data with tidyverse" lesson](https://datacarpentry.org/R-ecology-lesson/03-dplyr.html).

Let's load the data with `read_csv()`.


```r
library(tidyverse)

# Read CSV file into R
penguins_data_raw <- read_csv(penguins_csv_file)

penguins_data_raw
```


```{.output}
Rows: 344 Columns: 17
── Column specification ────────────────────────────────────────────────────────
Delimiter: ","
chr  (9): studyName, Species, Region, Island, Stage, Individual ID, Clutch C...
dbl  (7): Sample Number, Culmen Length (mm), Culmen Depth (mm), Flipper Leng...
date (1): Date Egg

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```{.output}
# A tibble: 344 × 17
   studyName `Sample Number` Species         Region Island Stage `Individual ID`
   <chr>               <dbl> <chr>           <chr>  <chr>  <chr> <chr>          
 1 PAL0708                 1 Adelie Penguin… Anvers Torge… Adul… N1A1           
 2 PAL0708                 2 Adelie Penguin… Anvers Torge… Adul… N1A2           
 3 PAL0708                 3 Adelie Penguin… Anvers Torge… Adul… N2A1           
 4 PAL0708                 4 Adelie Penguin… Anvers Torge… Adul… N2A2           
 5 PAL0708                 5 Adelie Penguin… Anvers Torge… Adul… N3A1           
 6 PAL0708                 6 Adelie Penguin… Anvers Torge… Adul… N3A2           
 7 PAL0708                 7 Adelie Penguin… Anvers Torge… Adul… N4A1           
 8 PAL0708                 8 Adelie Penguin… Anvers Torge… Adul… N4A2           
 9 PAL0708                 9 Adelie Penguin… Anvers Torge… Adul… N5A1           
10 PAL0708                10 Adelie Penguin… Anvers Torge… Adul… N5A2           
# ℹ 334 more rows
# ℹ 10 more variables: `Clutch Completion` <chr>, `Date Egg` <date>,
#   `Culmen Length (mm)` <dbl>, `Culmen Depth (mm)` <dbl>,
#   `Flipper Length (mm)` <dbl>, `Body Mass (g)` <dbl>, Sex <chr>,
#   `Delta 15 N (o/oo)` <dbl>, `Delta 13 C (o/oo)` <dbl>, Comments <chr>
```

We see the raw data has some awkward column names with spaces (these are hard to type out and can easily lead to mistakes in the code), and far more columns than we need.
For the purposes of this analysis, we only need species name, bill length, and bill depth.
In the raw data, the rather technical term "culmen" is used to refer to the bill.

![Illustration of bill (culmen) length and depth. Artwork by @allison_horst.](https://allisonhorst.github.io/palmerpenguins/reference/figures/culmen_depth.png)

Let's clean up the data to make it easier to use for downstream analyses.
We will also remove any rows with missing data, because this could cause errors for some functions later.


```r
# Clean up raw data
penguins_data <- penguins_data_raw |>
  # Rename columns for easier typing and
  # subset to only the columns needed for analysis
  select(
    species = Species,
    bill_length_mm = `Culmen Length (mm)`,
    bill_depth_mm = `Culmen Depth (mm)`
  ) |>
  # Delete rows with missing data
  remove_missing(na.rm = TRUE)

penguins_data
```

```{.output}
# A tibble: 342 × 3
   species                             bill_length_mm bill_depth_mm
   <chr>                                        <dbl>         <dbl>
 1 Adelie Penguin (Pygoscelis adeliae)           39.1          18.7
 2 Adelie Penguin (Pygoscelis adeliae)           39.5          17.4
 3 Adelie Penguin (Pygoscelis adeliae)           40.3          18  
 4 Adelie Penguin (Pygoscelis adeliae)           36.7          19.3
 5 Adelie Penguin (Pygoscelis adeliae)           39.3          20.6
 6 Adelie Penguin (Pygoscelis adeliae)           38.9          17.8
 7 Adelie Penguin (Pygoscelis adeliae)           39.2          19.6
 8 Adelie Penguin (Pygoscelis adeliae)           34.1          18.1
 9 Adelie Penguin (Pygoscelis adeliae)           42            20.2
10 Adelie Penguin (Pygoscelis adeliae)           37.8          17.1
# ℹ 332 more rows
```

That's better!

### `targets` version

What does this look like using `targets`?

The biggest difference is that we need to **put each step of the workflow into the list at the end**.

We also define a custom function for the data cleaning step.
That is because the list of targets at the end **should look like a high-level summary of your analysis**.
You want to avoid lengthy chunks of code when defining the targets; instead, put that code in the custom functions.
The other steps (setting the file path and loading the data) are each just one function call so there's not much point in putting those into their own custom functions.

Finally, each step in the workflow is defined with the `tar_target()` function.


```r
library(targets)
library(tidyverse)
library(palmerpenguins)

clean_penguin_data <- function(penguins_data_raw) {
  penguins_data_raw |>
    select(
      species = Species,
      bill_length_mm = `Culmen Length (mm)`,
      bill_depth_mm = `Culmen Depth (mm)`
    ) |>
    remove_missing(na.rm = TRUE)
}

list(
  tar_target(penguins_csv_file, path_to_file("penguins_raw.csv")),
  tar_target(penguins_data_raw, read_csv(
    penguins_csv_file, show_col_types = FALSE)),
  tar_target(penguins_data, clean_penguin_data(penguins_data_raw))
)
```

I have set `show_col_types = FALSE` in `read_csv()` because we know from the earlier code that the column types were set correctly by default (character for species and numeric for bill length and depth), so we don't need to see the warning it would otherwise issue.

## Run the workflow

Now that we have a workflow, we can run it with the `tar_make()` function.
Try running it, and you should see something like this:


```r
tar_make()
```

```{.output}
• start target penguins_csv_file
• built target penguins_csv_file [0.002 seconds]
• start target penguins_data_raw
• built target penguins_data_raw [0.18 seconds]
• start target penguins_data
• built target penguins_data [0.014 seconds]
• end pipeline [0.385 seconds]
```

Congratulations, you've run your first workflow with `targets`!

::::::::::::::::::::::::::::::::::::: keypoints 

- Projects help keep our analyses organized so we can easily re-run them later
- Use the RStudio Project Wizard to create projects
- The `_targets.R` file is a special file that must be included in all `targets` projects, and defines the worklow
- Use `tar_script()` to create a default `_targets.R` file
- Use `tar_make()` to run the workflow

::::::::::::::::::::::::::::::::::::::::::::::::
