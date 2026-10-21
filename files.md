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

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to read and write external files

:::::::::::::::::::::::::::::::::::::



## Treating external files as a dependency

Almost all workflows will start by importing data, which is typically stored as an external file.

As a simple example, let's create an external data file in RStudio with the "New File" menu option. Enter a single line of text, "Hello World" and save it as "hello.txt" text file in `_targets/user/data/`.

We will read in the contents of this file and store it as `some_data` in the workflow by writing the following plan and running `tar_make()`:

::::::::::::::::::::::::::::::::::::: {.callout}

## Save your progress

You can only have one active `_targets.R` file at a time in a given project.

We are about to create a new `_targets.R` file, but you probably don't want to lose your progress in the one we have been working on so far (the penguins bill analysis). You can temporarily rename that one to something like `_targets_old.R` so that you don't overwrite it with the new example `_targets.R` file below. Then, rename them when you are ready to work on it again.

:::::::::::::::::::::::::::::::::::::


``` r
library(targets)
library(tarchetypes)

tar_plan(
  some_data = readLines("_targets/user/data/hello.txt")
)
```


``` output
+ some_data dispatched
✔ some_data completed [1ms, 64 B]
✔ ended pipeline [296ms, 1 completed, 0 skipped]
```

If we load `some_data` with `tar_load(some_data)` and inspect it, it will contain the string `"Hello World"` as expected.

Now say we edit "hello.txt", perhaps add some text: "Hello World. How are you?". Edit this in the RStudio text editor and save it. Now run the pipeline again.


``` r
library(targets)
library(tarchetypes)

tar_plan(
  some_data = readLines("_targets/user/data/hello.txt")
)
```


``` output
✔ skipped pipeline [241ms, 1 skipped]
```

The target `some_data` was skipped, even though the contents of the file changed.

That is because right now, targets is only tracking the **name** of the file, not its contents. We need to use a special function for that, `tar_file()` from the `tarchetypes` package. `tar_file()` will calculate the "hash" of a file---a unique digital signature that is determined by the file's contents. If the contents change, the hash will change, and this will be detected by `targets`.


``` r
library(targets)
library(tarchetypes)

tar_plan(
  tar_file(data_file, "_targets/user/data/hello.txt"),
  some_data = readLines(data_file)
)
```


``` output
+ data_file dispatched
✔ data_file completed [1ms, 26 B]
+ some_data dispatched
✔ some_data completed [1ms, 78 B]
✔ ended pipeline [351ms, 2 completed, 0 skipped]
```

This time we see that `targets` does successfully re-build `some_data` as expected.

## Other data loading functions

Note that this takes two targets: one to track the contents of the file (`data_file`, made with `tar_file()`), and one to store what we load from the file (`some_data`).

Although we used `readLines()` as an example here, you can use the same pattern for other functions that load data from external files, such as `readr::read_csv()`, `readxl::read_excel()`, and others (for example, `tar_file(csv_file, "data.csv")` followed by `my_data = read_csv(csv_file)`).

This is generally recommended so that your pipeline stays up to date with your input data.

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: Use `tar_file()` with the penguins example

We didn't know about `tar_file()` yet when we started on the penguins bill analysis, so `targets` only tracks the **name** of the CSV file, not its contents.

How can you use `tar_file()` to load the CSV file while tracking its contents?

:::::::::::::::::::::::::::::::::: {.solution}


``` r
source("R/packages.R")
source("R/functions.R")

tar_plan(
  tar_file(penguins_csv_file, path_to_file("penguins_raw.csv")),
  penguins_data_raw = read_csv(penguins_csv_file, show_col_types = FALSE),
  penguins_data = clean_penguin_data(penguins_data_raw)
)
```


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

+ penguins_csv_file dispatched
✔ penguins_csv_file completed [1ms, 53.10 kB]
+ penguins_data_raw dispatched
✔ penguins_data_raw completed [94ms, 10.40 kB]
+ penguins_data dispatched
✔ penguins_data completed [23ms, 1.49 kB]
✔ ended pipeline [409ms, 3 completed, 0 skipped]
```

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

## Writing out data

Writing to files is similar to loading in files: we will use the `tar_file()` function. There is one important caveat: in this case, the second argument of `tar_file()` (the command to build the target) **must return the path to the file**. Not all functions that write files do this (some return nothing; these treat the output file is a side-effect of running the function), so you may need to define a custom function that writes out the file and then returns its path.

Let's do this for `writeLines()`, the R function that writes character data to a file. Normally, its output would be `NULL` (nothing), as we can see here:


``` r
x <- writeLines("some text", "test.txt")
x
```


``` output
NULL
```

Here is our modified function that writes character data to a file and returns the name of the file (the `...` means "pass the rest of these arguments to `writeLines()`"):


``` r
write_lines_file <- function(text, file, ...) {
  writeLines(text = text, con = file, ...)
  file
}
```

Let's try it out:


``` r
x <- write_lines_file("some text", "test.txt")
x
```


``` output
[1] "test.txt"
```

We can now use this in a pipeline. For example let's change the text to upper case then write it out again:


``` r
library(targets)
library(tarchetypes)

source("R/functions.R")

tar_plan(
  tar_file(hello_file, "_targets/user/data/hello.txt"),
  hello = readLines(hello_file),
  hello_caps = toupper(hello),
  tar_file(
    hello_caps_out,
    write_lines_file(hello_caps, "_targets/user/results/hello_caps.txt")
  )
)
```


``` output
+ hello_file dispatched
✔ hello_file completed [1ms, 26 B]
+ hello dispatched
✔ hello completed [1ms, 78 B]
+ hello_caps dispatched
✔ hello_caps completed [0ms, 78 B]
+ hello_caps_out dispatched
✔ hello_caps_out completed [0ms, 26 B]
✔ ended pipeline [397ms, 4 completed, 0 skipped]
```

Take a look at `hello_caps.txt` in the `results` folder and verify it is as you expect.

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: What happens to file output if its modified?

Delete or change the contents of `hello_caps.txt` in the `results` folder.
What do you think will happen when you run `tar_make()` again?
Try it and see.

:::::::::::::::::::::::::::::::::: {.solution}

`targets` detects that `hello_caps_out` has changed (is "invalidated"), and re-runs the code to make it, thus writing out `hello_caps.txt` to `results` again.

So this way of writing out results makes your pipeline more robust: we have a guarantee that the contents of the file in `results` are generated solely by the code in your plan.

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `tarchetypes::tar_file()` tracks the contents of a file
- Use `tarchetypes::tar_file()` in combination with data loading functions like `read_csv()` to keep the pipeline in sync with your input data
- Use `tarchetypes::tar_file()` in combination with a function that writes to a file and returns its path to write out data

::::::::::::::::::::::::::::::::::::::::::::::::
