---
title: 'Loading Workflow Objects'
teaching: 10
exercises: 5
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

So we just finished running our workflow.
Now you probably want to look at its output.
But, if we just call the name of the object (for example, `penguins_data`), we get an error.

``` r
penguins_data
```

``` error
Error:
! object 'penguins_data' not found
```

Where are the results of our workflow?

::::::::::::::::::::::::::::::::::::: instructor

- To reinforce the concept of `targets` running in a separate R session, you may want to pretend trying to run `penguins_data`, then feigning surprise when it doesn't work and using it as a teaching moment (errors are pedagogy!).

::::::::::::::::::::::::::::::::::::::::::::::::

We don't see the workflow results because `targets` **runs the workflow in a separate R session** that we can't interact with.
This is for reproducibility---the objects built by the workflow should only depend on the code in your project, not any commands you may have interactively given to R.

Fortunately, `targets` has a function that can be used to load objects built by the workflow into our current session, `tar_load()`.
Let's see how it works.

## tar_load()

`tar_load()` loads an object built by the workflow into the current session.
Its first argument is the name of the object you want to load.
Let's use this to load `penguins_data` and get an overview of the data with `summary()`.




``` r
tar_load(penguins_data)
summary(penguins_data)
```

``` output
      species    bill_length_mm  bill_depth_mm  
 Length   :342   Min.   :32.10   Min.   :13.10  
 N.unique :  3   1st Qu.:39.23   1st Qu.:15.60  
 N.blank  :  0   Median :44.45   Median :17.30  
 Min.nchar: 33   Mean   :43.92   Mean   :17.15  
 Max.nchar: 41   3rd Qu.:48.50   3rd Qu.:18.70  
                 Max.   :59.60   Max.   :21.50  
```

Note that `tar_load()` is used for its **side-effect**---loading the desired object into the current R session.
It doesn't actually return a value.

## The targets cache

If you close your R session, then re-start it and use `tar_load()`, you will notice that it can still load the workflow objects.
In other words, the workflow output is **saved across R sessions**.
How is this possible?

You may have noticed a new folder has appeared in your project, called `_targets`.
This is the **targets cache**.
It contains all of the workflow output; that is how we can load the targets built by the workflow even after quitting then restarting R.

**You should not edit the contents of the cache by hand.**
Doing so would make your analysis non-reproducible.

Note that it is possible to "reset" your workflow by simply deleting the entire `_targets` folder. Of course, this means you will need to run everything over again, so don't do this lightly!

::::::::::::::::::::::::::::::::::::: challenge

## Optional challenge: `tar_read()`

*This challenge is optional.*

If you look at the comment at the top of the `_targets.R` file that `tar_script()` created for you, you will see that it mentions another function, `tar_read()`.
Like `tar_load()`, it retrieves an object built by the workflow.

Try `tar_read(penguins_csv_file)`, and then try running `penguins_csv_file`.
What do you see?
What is the difference between **loading** the contents of a target into your R session as an object, and **reading** them?
When might you want to use one rather than the other?

:::::::::::::::::::::::::::::::::: solution

`tar_read()` returns the value of the target, so we immediately see it:


``` r
tar_read(penguins_csv_file)
```

``` output
[1] "data/penguins_raw.csv"
```

But it has not been loaded into the environment, so if we try to run `penguins_csv_file`, we get an error:


``` r
penguins_csv_file
```

``` error
Error:
! object 'penguins_csv_file' not found
```

In contrast, `tar_load()` creates an object in your R session with the same name as the target, and returns nothing visible.
Afterwards, you can use that object as many times as you like.

`tar_load()` tends to be more useful when you want to load objects and do things with them.
`tar_read()` is more useful when you just want to immediately inspect a target, or to store its value in an object with a different name (for example, `my_data <- tar_read(penguins_data)`).

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `targets` workflows are run in a separate, non-interactive R session
- `tar_load()` loads a workflow object into the current R session
- The `_targets` folder is the cache and generally should not be edited by hand

::::::::::::::::::::::::::::::::::::::::::::::::
