---
title: 'Loading Workflow Objects'
teaching: 10
exercises: 2
---



:::::::::::::::::::::::::::::::::::::: questions 

- Where does the workflow happen?
- How can we inspect the objects built by the workflow?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain where `targets` runs the workflow and why
- Be able to load objects built by the workflow into your R session

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to get at the objects that we built

:::::::::::::::::::::::::::::::::::::

## Where does the workflow happen?

So we just finished running our first workflow.
Now you probably want to look at its output.
But, if we just call the name of the object (for example, `penguins_data`), we get an error.

```r
penguins_data
```

```{.error}
Error in eval(expr, envir, enclos): object 'penguins_data' not found
```

Where are the results of our workflow?

::::::::::::::::::::::::::::::::::::: instructor

- To reinforce the concept of `targets` running in a separate R session, you may want to pretend trying to run `penguins_data`, then feigning surprise when it doesn't work and using it as a teaching moment (errors are pedagogy!).

::::::::::::::::::::::::::::::::::::::::::::::::

We don't see the workflow results because `targets` **runs the workflow in a separate R session** that we can't interact with.
This is for reproducibility---the objects built by the workflow should only depend on the code in your project, not any commands you may have interactively given to R.

Fortunately, `targets` has two functions that can be used to load objects built by the workflow into our current session, `tar_load()` and `tar_read()`.
Let's see how these work.

## tar_load()

`tar_load()` loads an object built by the workflow into the current session.
Its first argument is the name of the object you want to load.
Let's use this to load `penguins_data` and get an overview of the data with `summary()`.




```r
tar_load(penguins_data)
summary(penguins_data)
```


```{.output}
   species          bill_length_mm  bill_depth_mm  
 Length:342         Min.   :32.10   Min.   :13.10  
 Class :character   1st Qu.:39.23   1st Qu.:15.60  
 Mode  :character   Median :44.45   Median :17.30  
                    Mean   :43.92   Mean   :17.15  
                    3rd Qu.:48.50   3rd Qu.:18.70  
                    Max.   :59.60   Max.   :21.50  
```

Note that `tar_load()` is used for its **side-effect**---loading the desired object into the current R session.
It doesn't actually return a value.

## tar_read()

`tar_read()` is similar to `tar_load()` in that it is used to retrieve objects built by the workflow, but unlike `tar_load()`, it returns them directly as output.

Let's try it with `penguins_csv_file`.


```r
tar_read(penguins_csv_file)
```


```{.output}
[1] "/home/runner/.local/share/renv/cache/v5/R-4.3/x86_64-pc-linux-gnu/palmerpenguins/0.1.1/6c6861efbc13c1d543749e9c7be4a592/palmerpenguins/extdata/penguins_raw.csv"
```

We immediately see the contents of `penguins_csv_file`.
But it has not been loaded into the environment.
If you try to run `penguins_csv_file` now, you will get an error:


```r
penguins_csv_file
```

```{.error}
Error in eval(expr, envir, enclos): object 'penguins_csv_file' not found
```

## When to use which function

`tar_load()` tends to be more useful when you want to load objects and do things with them.
`tar_read()` is more useful when you just want to immediately inspect an object.

## The targets cache

If you close your R session, then re-start it and use `tar_load()` or `tar_read()`, you will notice that it can still load the workflow objects.
In other words, the workflow output is **saved across R sessions**.
How is this possible?

You may have noticed a new folder has appeared in your project, called `_targets`.
This is the **targets cache**.
It contains all of the workflow output; that is how we can load the targets built by the workflow even after quitting then restarting R.

**You should not edit the contents of the cache by hand** (with one exception).
Doing so would make your analysis non-reproducible.

The one exception to this rule is a special subfolder called `_targets/user`.
This folder does not exist by default.
You can create it if you want, and put whatever you want inside.

Generally, `_targets/user` is a good place to store files that are not code, like data and output.

Note that if you don't have anything in `_targets/user` that you need to keep around, it is possible to "reset" your workflow by simply deleting the entire `_targets` folder. Of course, this means you will need to run everything over again, so don't do this lightly!

::::::::::::::::::::::::::::::::::::: keypoints 

- `targets` workflows are run in a separate, non-interactive R session
- `tar_load()` loads a workflow object into the current R session
- `tar_read()` reads a workflow object and returns its value
- The `_targets` folder is the cache and generally should not be edited by hand

::::::::::::::::::::::::::::::::::::::::::::::::
