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
▶ dispatched target some_data
● completed target some_data [0.001 seconds]
▶ ended pipeline [0.083 seconds]
```

If we inspect the contents of `some_data` with `tar_read(some_data)`, it will contain the string `"Hello World"` as expected.

Now say we edit "hello.txt", perhaps add some text: "Hello World. How are you?". Edit this in the RStudio text editor and save it. Now run the pipeline again.


``` r
library(targets)
library(tarchetypes)

tar_plan(
  some_data = readLines("_targets/user/data/hello.txt")
)
```


``` output
✔ skipped target some_data
✔ skipped pipeline [0.082 seconds]
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
▶ dispatched target data_file
● completed target data_file [0 seconds]
▶ dispatched target some_data
● completed target some_data [0 seconds]
▶ ended pipeline [0.106 seconds]
```

This time we see that `targets` does successfully re-build `some_data` as expected.

## A shortcut (or, About target factories)

However, also notice that this means we need to write two targets instead of one: one target to track the contents of the file (`data_file`), and one target to store what we load from the file (`some_data`).

It turns out that this is a common pattern in `targets` workflows, so `tarchetypes` provides a shortcut to express this more concisely, `tar_file_read()`.


``` r
library(targets)
library(tarchetypes)

tar_plan(
  tar_file_read(
    hello,
    "_targets/user/data/hello.txt",
    readLines(!!.x)
  )
)
```

Let's inspect this pipeline with `tar_manifest()`:


``` r
tar_manifest()
```


``` output
# A tibble: 2 × 2
  name       command                           
  <chr>      <chr>                             
1 hello_file "\"_targets/user/data/hello.txt\""
2 hello      "readLines(hello_file)"           
```

Notice that even though we only specified one target in the pipeline (`hello`, with `tar_file_read()`), the pipeline actually includes **two** targets, `hello_file` and `hello`.

That is because `tar_file_read()` is a special function called a **target factory**, so-called because it makes **multiple** targets at once. One of the main purposes of the `tarchetypes` package is to provide target factories to make writing pipelines easier and less error-prone.

## Non-standard evaluation

What is the deal with the `!!.x`? That may look unfamiliar even if you are used to using R. It is known as "non-standard evaluation," and gets used in some special contexts. We don't have time to go into the details now, but just remember that you will need to use this special notation with `tar_file_read()`. If you forget how to write it (this happens frequently!) look at the examples in the help file by running `?tar_file_read`.

## Other data loading functions

Although we used `readLines()` as an example here, you can use the same pattern for other functions that load data from external files, such as `readr::read_csv()`, `xlsx::read_excel()`, and others (for example, `read_csv(!!.x)`, `read_excel(!!.x)`, etc.).

This is generally recommended so that your pipeline stays up to date with your input data.

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: Use `tar_file_read()` with the penguins example

We didn't know about `tar_file_read()` yet when we started on the penguins bill analysis.

How can you use `tar_file_read()` to load the CSV file while tracking its contents?

:::::::::::::::::::::::::::::::::: {.solution}


``` r
source("R/packages.R")
source("R/functions.R")

tar_plan(
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  penguins_data = clean_penguin_data(penguins_data_raw)
)
```


``` output
▶ dispatched target penguins_data_raw_file
● completed target penguins_data_raw_file [0.001 seconds]
▶ dispatched target penguins_data_raw
● completed target penguins_data_raw [0.095 seconds]
▶ dispatched target penguins_data
● completed target penguins_data [0.015 seconds]
▶ ended pipeline [0.337 seconds]
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
  tar_file_read(
    hello,
    "_targets/user/data/hello.txt",
    readLines(!!.x)
  ),
  hello_caps = toupper(hello),
  tar_file(
    hello_caps_out,
    write_lines_file(hello_caps, "_targets/user/results/hello_caps.txt")
  )
)
```


``` output
▶ dispatched target hello_file
● completed target hello_file [0 seconds]
▶ dispatched target hello
● completed target hello [0 seconds]
▶ dispatched target hello_caps
● completed target hello_caps [0 seconds]
▶ dispatched target hello_caps_out
● completed target hello_caps_out [0 seconds]
▶ ended pipeline [0.102 seconds]
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
- Use `tarchetypes::tar_file_read()` in combination with data loading functions like `read_csv()` to keep the pipeline in sync with your input data
- Use `tarchetypes::tar_file()` in combination with a function that writes to a file and returns its path to write out data

::::::::::::::::::::::::::::::::::::::::::::::::
