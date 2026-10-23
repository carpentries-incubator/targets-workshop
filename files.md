---
title: 'Working with External Files'
teaching: 25
exercises: 10
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we load external data?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to load external data into a workflow
- Configure the workflow to rerun if the contents of the external data change

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to read and write external files

:::::::::::::::::::::::::::::::::::::



## Treating external files as a dependency

Almost all workflows will start by importing data, which is typically stored as an external file.

So far, our penguins workflow has read its data from a CSV file in the `data/` folder of our project.
Let's add a second, much smaller data file that we create ourselves: some information about the islands where the penguins were measured.
Later we will use this in a report.

Create a new text file in RStudio with the "New File" menu option.
Enter the following lines (copy-and-paste is fine) and save it as "islands.csv" in the `data/` folder of your project (we created this folder in the [first workflow episode](episodes/basic-targets.Rmd); if you do not have it yet, create it now in your project folder).
These coordinates are approximate.

```
island,latitude,longitude
Biscoe,-65.43,-65.50
Dream,-64.73,-64.23
Torgersen,-64.77,-64.08

```

We will read in the contents of this file and store it as `island_data` in the workflow.
Add a new target to the end of the plan in `_targets.R` (note the comma that is now needed after the previous target), then run `tar_make()`:


``` r
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    penguins_data |> dplyr::filter(species == species_name) |> model_augment(),
    pattern = map(species_name)
  ),
  # Read island data
  island_data = read_csv("data/islands.csv", show_col_types = FALSE)
)
```


``` output
+ island_data dispatched
✔ island_data completed [107ms, 365 B]
+ species_summary declared [3 branches]
+ species_predictions declared [3 branches]
✔ ended pipeline [375ms, 1 completed, 12 skipped]
```

If we load `island_data` with `tar_load(island_data)` and inspect it, it will contain the three islands as expected.

Now say we find a more precise latitude for Torgersen Island, and edit "islands.csv" to change `-64.77` to `-64.80`. Edit this in the RStudio text editor and save it. Now run the pipeline again.


``` r
tar_make()
```

``` output
+ species_summary declared [3 branches]
+ species_predictions declared [3 branches]
✔ skipped pipeline [199ms, 13 skipped]
```

The target `island_data` was skipped, even though the contents of the file changed.

That is because right now, targets is only tracking the **name** of the file, not its contents. We need to use a special function for that, `tar_file()` from the `tarchetypes` package. `tar_file()` will calculate the "hash" of a file---a unique digital signature that is determined by the file's contents. If the contents change, the hash will change, and this will be detected by `targets`.

Change the end of the plan in `_targets.R` to use `tar_file()` for the island file, and run `tar_make()`:


``` r
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    penguins_data |> dplyr::filter(species == species_name) |> model_augment(),
    pattern = map(species_name)
  ),
  # Read island data
  tar_file(island_file, "data/islands.csv"),
  island_data = read_csv(island_file, show_col_types = FALSE)
)
```

Then edit "islands.csv" once more, perhaps changing the longitude of Dream Island from `-64.23` to `-64.25`. Save it, and run the pipeline again.


``` output
+ island_file dispatched
✔ island_file completed [1ms, 91 B]
+ island_data dispatched
✔ island_data completed [95ms, 358 B]
+ species_summary declared [3 branches]
+ species_predictions declared [3 branches]
✔ ended pipeline [415ms, 2 completed, 12 skipped]
```

This time we see that `targets` does successfully re-build `island_data` as expected.

## Other data loading functions

Note that this takes two targets: one to track the contents of the file (`island_file`, made with `tar_file()`), and one to store what we load from the file (`island_data`).

Although we used `read_csv()` as an example here, you can use the same pattern for other functions that load data from external files, such as `readxl::read_excel()`, `readLines()`, and others (for example, `tar_file(excel_file, "data.xlsx")` followed by `my_data = read_excel(excel_file)`).

This is generally recommended so that your pipeline stays up to date with your input data.

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: Use `tar_file()` with the penguins example

We didn't know about `tar_file()` yet when we started on the penguins bill analysis, so `targets` only tracks the **name** of the penguins CSV file, not its contents.

How can you use `tar_file()` to load the CSV file while tracking its contents?

:::::::::::::::::::::::::::::::::: {.solution}

Use `tar_file()` for the `penguins_csv_file` target, at the start of the plan:


``` r
tar_plan(
  # Load raw data
  tar_file(penguins_csv_file, "data/penguins_raw.csv"),
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
```


``` output
+ penguins_csv_file dispatched
✔ penguins_csv_file completed [1ms, 57.98 kB]
+ penguins_data_raw dispatched
✔ penguins_data_raw completed [97ms, 10.40 kB]
+ species_summary declared [3 branches]
+ species_predictions declared [3 branches]
✔ ended pipeline [417ms, 2 completed, 12 skipped]
```

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

## Writing out data

Writing to files is similar to loading in files: we will use the `tar_file()` function. This works because `tar_file()` does not care whether a file is an input or an output. In both cases the value of the target is the **path** to a file, and `targets` tracks the file's contents (its hash) as well as its name. It does not matter whether the file was already there (like "islands.csv") or is created by the command that builds the target. There is one important caveat: in this case, the second argument of `tar_file()` (the command to build the target) **must return the path to the file**. Not all functions that write files do this (some return the data that was written, or nothing at all; these treat the output file as a side-effect of running the function), so you may need to define a custom function that writes out the file and then returns its path.

Let's do this for `write_csv()`, the `readr` function that writes a data frame to a CSV file. Its output is the data that was written, not the path to the file, as we can see here:


``` r
x <- readr::write_csv(head(penguins, 3), "test.csv")
x
```


``` output
  species    island bill_len bill_dep flipper_len body_mass    sex year
1  Adelie Torgersen     39.1     18.7         181      3750   male 2007
2  Adelie Torgersen     39.5     17.4         186      3800 female 2007
3  Adelie Torgersen     40.3     18.0         195      3250 female 2007
```

Here is our modified function that writes a data frame to a CSV file and returns the name of the file (the `...` means "pass the rest of these arguments to `write_csv()`"). Add it to `R/functions.R`:


``` r
write_csv_file <- function(data, file, ...) {
  readr::write_csv(x = data, file = file, ...)
  file
}
```

Let's try it out:


``` r
x <- write_csv_file(head(penguins, 3), "test.csv")
x
```


``` output
[1] "test.csv"
```

We can now use this in the workflow. For example, let's write out the results of the models for each species (`species_summary`) by adding one more target to the end of the plan:


``` r
  # Read island data
  tar_file(island_file, "data/islands.csv"),
  island_data = read_csv(island_file, show_col_types = FALSE),
  # Write out the summary of one model per species
  tar_file(
    species_summary_file,
    write_csv_file(species_summary, "results/species_summary.csv")
  )
)
```


``` output
+ species_summary declared [3 branches]
+ species_predictions declared [3 branches]
+ species_summary_file dispatched
✔ species_summary_file completed [75ms, 664 B]
✔ ended pipeline [367ms, 1 completed, 14 skipped]
```

Take a look at `species_summary.csv` in the `results` folder and verify it is as you expect.

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: What happens to file output if its modified?

Delete or change the contents of `species_summary.csv` in the `results` folder.
What do you think will happen when you run `tar_make()` again?
Try it and see.

:::::::::::::::::::::::::::::::::: {.solution}

`targets` detects that `species_summary_file` has changed (is "invalidated"), and re-runs the code to make it, thus writing out `species_summary.csv` to `results` again.

So this way of writing out results makes your pipeline more robust: we have a guarantee that the contents of the file in `results` are generated solely by the code in your plan.

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `tarchetypes::tar_file()` tracks the contents of a file
- Use `tarchetypes::tar_file()` in combination with data loading functions like `read_csv()` to keep the pipeline in sync with your input data
- Use `tarchetypes::tar_file()` in combination with a function that writes to a file and returns its path to write out data

::::::::::::::::::::::::::::::::::::::::::::::::
