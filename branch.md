---
title: 'Branching'
teaching: 30
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we specify many targets without typing everything out?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Be able to specify targets using branching

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Episode summary: Show how to use branching

:::::::::::::::::::::::::::::::::::::



## Why branching?

One of the major strengths of `targets` is the ability to define many targets from a single line of code ("branching").
This not only saves you typing, it also **reduces the risk of errors** since there is less chance of making a typo.

## Types of branching

There are two types of branching, **dynamic branching** and **static branching**.
"Branching" refers to the idea that you can provide a single specification for how to make targets (the "pattern"), and `targets` generates multiple targets from it ("branches").
"Dynamic" means that the branches that result from the pattern do not have to be defined ahead of time---they are a dynamic result of the code.

In this workshop, we will only cover dynamic branching since it is generally easier to write (static branching requires use of [meta-programming](https://books.ropensci.org/targets/static.html#metaprogramming), an advanced topic). For more information about each and when you might want to use one or the other (or some combination of the two), [see the `targets` package manual](https://books.ropensci.org/targets/dynamic.html).

## Example without branching

To see how this works, let's continue our analysis of the `palmerpenguins` dataset.

**Our hypothesis is that bill depth decreases with bill length.**
We will test this hypothesis with a linear model.

For example, this is a model of bill depth dependent on bill length:


``` r
lm(bill_depth_mm ~ bill_length_mm, data = penguins_data)
```

We can add this to our pipeline. We will call it the `combined_model` because it combines all the species together without distinction:


``` r
source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Build model
  combined_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data
  )
)
```


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw
```

``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

✔ skipping targets (1 so far)...
▶ dispatched target combined_model
● completed target combined_model [0.032 seconds, 11.201 kilobytes]
▶ ended pipeline [0.164 seconds]
```

Let's have a look at the model. We will use the `glance()` function from the `broom` package. Unlike base R `summary()`, this function returns output as a tibble (the tidyverse equivalent of a dataframe), which as we will see later is quite useful for downstream analyses.


``` r
library(broom)
tar_load(combined_model)
glance(combined_model)
```

``` output
# A tibble: 1 × 12
  r.squared adj.r.squared sigma statistic   p.value    df logLik   AIC   BIC deviance df.residual  nobs
      <dbl>         <dbl> <dbl>     <dbl>     <dbl> <dbl>  <dbl> <dbl> <dbl>    <dbl>       <int> <int>
1    0.0552        0.0525  1.92      19.9 0.0000112     1  -708. 1422. 1433.    1256.         340   342
```

Notice the small *P*-value.
This seems to indicate that the model is highly significant.

But wait a moment... is this really an appropriate model? Recall that there are three species of penguins in the dataset. It is possible that the relationship between bill depth and length **varies by species**.

Let's try making one model *per* species (three models total) to see how that does (this is technically not the correct statistical approach, but our focus here is to learn `targets`, not statistics).

Now our workflow is getting more complicated. This is what a workflow for such an analysis might look like **without branching** (make sure to add `library(broom)` to `packages.R`):


``` r
source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Build models
  combined_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data
  ),
  adelie_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = filter(penguins_data, species == "Adelie")
  ),
  chinstrap_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = filter(penguins_data, species == "Chinstrap")
  ),
  gentoo_model = lm(
    bill_depth_mm ~ bill_length_mm,
    data = filter(penguins_data, species == "Gentoo")
  ),
  # Get model summaries
  combined_summary = glance(combined_model),
  adelie_summary = glance(adelie_model),
  chinstrap_summary = glance(chinstrap_model),
  gentoo_summary = glance(gentoo_model)
)
```


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw
```

``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

✔ skipping targets (1 so far)...
▶ dispatched target adelie_model
● completed target adelie_model [0.009 seconds, 6.476 kilobytes]
▶ dispatched target gentoo_model
● completed target gentoo_model [0.002 seconds, 5.879 kilobytes]
▶ dispatched target chinstrap_model
● completed target chinstrap_model [0.002 seconds, 4.535 kilobytes]
▶ dispatched target combined_summary
● completed target combined_summary [0.007 seconds, 348 bytes]
▶ dispatched target adelie_summary
● completed target adelie_summary [0.003 seconds, 348 bytes]
▶ dispatched target gentoo_summary
● completed target gentoo_summary [0.003 seconds, 348 bytes]
▶ dispatched target chinstrap_summary
● completed target chinstrap_summary [0.003 seconds, 348 bytes]
▶ ended pipeline [0.177 seconds]
```

Let's look at the summary of one of the models:


``` r
tar_read(adelie_summary)
```

``` output
# A tibble: 1 × 12
  r.squared adj.r.squared sigma statistic     p.value    df logLik   AIC   BIC deviance df.residual  nobs
      <dbl>         <dbl> <dbl>     <dbl>       <dbl> <dbl>  <dbl> <dbl> <dbl>    <dbl>       <int> <int>
1     0.153         0.148  1.12      27.0 0.000000667     1  -231.  468.  477.     188.         149   151
```

So this way of writing the pipeline works, but is repetitive: we have to call `glance()` each time we want to obtain summary statistics for each model.
Furthermore, each summary target (`adelie_summary`, etc.) is explicitly named and typed out manually.
It would be fairly easy to make a typo and end up with the wrong model being summarized.

Before moving on, let's define another **custom function** function: `model_glance()`.
You will need to write custom functions frequently when using `targets`, so it's good to get used to it!

As the name `model_glance()` suggests (it is good to write functions with names that indicate their purpose), this will build a model then immediately run `glance()` on it.
The reason for doing so is that we get a **dataframe as a result**, which is very helpful for branching, as we will see in the next section.
Save this in `R/functions.R`:


``` r
model_glance_orig <- function(penguins_data) {
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  broom::glance(model)
}
```

## Example with branching

### First attempt

Let's see how to write the same plan using **dynamic branching** (after running it, we will go through the new version in detail to understand each step):


``` r
source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Group data
  tar_group_by(
    penguins_data_grouped,
    penguins_data,
    species
  ),
  # Build combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Build one model per species
  tar_target(
    species_summary,
    model_glance(penguins_data_grouped),
    pattern = map(penguins_data_grouped)
  )
)
```

What is going on here?

First, let's look at the messages provided by `tar_make()`.


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw
```

``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

✔ skipping targets (1 so far)...
▶ dispatched target combined_summary
● completed target combined_summary [0.009 seconds, 348 bytes]
▶ dispatched target penguins_data_grouped
● completed target penguins_data_grouped [0.012 seconds, 1.527 kilobytes]
▶ dispatched branch species_summary_7fe6634f7c7f6a77
● completed branch species_summary_7fe6634f7c7f6a77 [0.005 seconds, 348 bytes]
▶ dispatched branch species_summary_c580675a85977909
● completed branch species_summary_c580675a85977909 [0.003 seconds, 348 bytes]
▶ dispatched branch species_summary_af3bb92d1b0f36d3
● completed branch species_summary_af3bb92d1b0f36d3 [0.003 seconds, 348 bytes]
● completed pattern species_summary 
▶ ended pipeline [0.187 seconds]
```

There is a series of smaller targets (branches) that are each named like species_summary_7fe6634f7c7f6a77, then one overall `species_summary` target.
That is the result of specifying targets using branching: each of the smaller targets are the "branches" that comprise the overall target.
Since `targets` has no way of knowing ahead of time how many branches there will be or what they represent, it names each one using this series of numbers and letters (the "hash").
`targets` builds each branch one at a time, then combines them into the overall target.

Next, let's look in more detail about how the workflow is set up, starting with how we set up the data:


``` r
  # Group data
  tar_group_by(
    penguins_data_grouped,
    penguins_data,
    species
  ),
```

Unlike the non-branching version, we added a step that **groups the data**.
This is because dynamic branching is similar to the [`tidyverse` approach](https://dplyr.tidyverse.org/articles/grouping.html) of applying the same function to a grouped dataframe.
So we use the `tar_group_by()` function to specify the groups in our input data: one group per species.

Next, take a look at the command to build the target `species_summary`.


``` r
  # Build one model per species
  tar_target(
    species_summary,
    model_glance(penguins_data_grouped),
    pattern = map(penguins_data_grouped)
  )
```

As before, the first argument to `tar_target()` is the name of the target to build, and the second is the command to build it.

Here, we apply our custom `model_glance()` function to each group (in other words, each species) in `penguins_data_grouped`.

Finally, there is an argument we haven't seen before, `pattern`, which indicates that this target should be built using dynamic branching.
`map` means to apply the function to each group of the input data (`penguins_data_grouped`) sequentially.

Now that we understand how the branching workflow is constructed, let's inspect the output:


``` r
tar_read(species_summary)
```


``` output
# A tibble: 3 × 12
  r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC deviance df.residual  nobs
      <dbl>         <dbl> <dbl>     <dbl>    <dbl> <dbl>  <dbl> <dbl> <dbl>    <dbl>       <int> <int>
1     0.153         0.148 1.12       27.0 6.67e- 7     1 -231.   468.  477.    188.          149   151
2     0.427         0.418 0.866      49.2 1.53e- 9     1  -85.7  177.  184.     49.5          66    68
3     0.414         0.409 0.754      85.5 1.02e-15     1 -139.   284.  292.     68.8         121   123
```

The model summary statistics are all included in a single dataframe.

But there's one problem: **we can't tell which row came from which species!** It would be unwise to assume that they are in the same order as the input data.

This is due to the way dynamic branching works: by default, there is no information about the provenance of each target preserved in the output.

How can we fix this?

### Second attempt

The key to obtaining useful output from branching pipelines is to include the necessary information in the output of each individual branch.
Here, we want to know the species that corresponds to each row of the model summaries.

We can achieve this by modifying our `model_glance` function. Be sure to save it after modifying it to include a column for species:


``` r
model_glance <- function(penguins_data) {
  # Make model
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  # Get species name
  species_name <- unique(penguins_data$species)
  # If this is the combined dataset with multiple
  # species, changed name to 'combined'
  if (length(species_name) > 1) {
    species_name <- "combined"
  }
  # Get model summary and add species name
  glance(model) |>
    mutate(species = species_name, .before = 1)
}
```

Our new pipeline looks exactly the same as before; we have made a modification, but to a **function**, not the pipeline.

Since `targets` tracks the contents of each custom function, it realizes that it needs to recompute `species_summary` and runs this target again with the newly modified function.


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

✔ skipping targets (1 so far)...
▶ dispatched target combined_summary
● completed target combined_summary [0.022 seconds, 371 bytes]
▶ dispatched branch species_summary_7fe6634f7c7f6a77
● completed branch species_summary_7fe6634f7c7f6a77 [0.009 seconds, 368 bytes]
▶ dispatched branch species_summary_c580675a85977909
● completed branch species_summary_c580675a85977909 [0.006 seconds, 372 bytes]
▶ dispatched branch species_summary_af3bb92d1b0f36d3
● completed branch species_summary_af3bb92d1b0f36d3 [0.006 seconds, 369 bytes]
● completed pattern species_summary 
▶ ended pipeline [0.196 seconds]
```

And this time, when we load the `model_summaries`, we can tell which model corresponds to which row (the `.before = 1` in `mutate()` ensures that it shows up before the other columns).


``` r
tar_read(species_summary)
```

``` output
# A tibble: 3 × 13
  species   r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC deviance df.residual  nobs
  <chr>         <dbl>         <dbl> <dbl>     <dbl>    <dbl> <dbl>  <dbl> <dbl> <dbl>    <dbl>       <int> <int>
1 Adelie        0.153         0.148 1.12       27.0 6.67e- 7     1 -231.   468.  477.    188.          149   151
2 Chinstrap     0.427         0.418 0.866      49.2 1.53e- 9     1  -85.7  177.  184.     49.5          66    68
3 Gentoo        0.414         0.409 0.754      85.5 1.02e-15     1 -139.   284.  292.     68.8         121   123
```

Next we will add one more target, a prediction of bill depth based on each model. These will be needed for plotting the models in the report.
Such a prediction can be obtained with the `augment()` function of the `broom` package, and we create a custom function that outputs predicted points as a dataframe much like we did for the model summaries.


::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: Add model predictions to the workflow

Can you add the model predictions using `augment()`? You will need to define a custom function just like we did for `glance()`.

:::::::::::::::::::::::::::::::::: {.solution}

Define the new function as `model_augment()`. It is the same as `model_glance()`, but use `augment()` instead of `glance()`:


``` r
model_augment <- function(penguins_data) {
  # Make model
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  # Get species name
  species_name <- unique(penguins_data$species)
  # If this is the combined dataset with multiple
  # species, changed name to 'combined'
  if (length(species_name) > 1) {
    species_name <- "combined"
  }
  # Get model summary and add species name
  augment(model) |>
    mutate(species = species_name, .before = 1)
}
```

Add the step to the workflow:


``` r
source("R/functions.R")
source("R/packages.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean data
  penguins_data = clean_penguin_data(penguins_data_raw),
  # Group data
  tar_group_by(
    penguins_data_grouped,
    penguins_data,
    species
  ),
  # Get summary of combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    model_glance(penguins_data_grouped),
    pattern = map(penguins_data_grouped)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_augment(penguins_data_grouped),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    model_augment(penguins_data_grouped),
    pattern = map(penguins_data_grouped)
  )
)
```

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

### Further simplify the workflow

You may have noticed that we can further simplify the workflow: there is no need to have separate `penguins_data` and `penguins_data_grouped` dataframes.
In general it is best to keep the number of named objects as small as possible to make it easier to reason about your code.
Let's combine the cleaning and grouping step into a single command:


``` r
source("R/functions.R")
source("R/packages.R")

tar_plan(
  # Load raw data
  tar_file_read(
    penguins_data_raw,
    path_to_file("penguins_raw.csv"),
    read_csv(!!.x, show_col_types = FALSE)
  ),
  # Clean and group data
  tar_group_by(
    penguins_data,
    clean_penguin_data(penguins_data_raw),
    species
  ),
  # Get summary of combined model with all species together
  combined_summary = model_glance(penguins_data),
  # Get summary of one model per species
  tar_target(
    species_summary,
    model_glance(penguins_data),
    pattern = map(penguins_data)
  ),
  # Get predictions of combined model with all species together
  combined_predictions = model_augment(penguins_data),
  # Get predictions of one model per species
  tar_target(
    species_predictions,
    model_augment(penguins_data),
    pattern = map(penguins_data)
  )
)
```

And run it once more:


``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw
```

``` output

Attaching package: ‘palmerpenguins’

The following objects are masked from ‘package:datasets’:

    penguins, penguins_raw

✔ skipping targets (1 so far)...
▶ dispatched target penguins_data
● completed target penguins_data [0.027 seconds, 1.527 kilobytes]
▶ dispatched target combined_summary
● completed target combined_summary [0.014 seconds, 371 bytes]
▶ dispatched branch species_summary_1598bb4431372f32
● completed branch species_summary_1598bb4431372f32 [0.011 seconds, 368 bytes]
▶ dispatched branch species_summary_6b9109ba2e9d27fd
● completed branch species_summary_6b9109ba2e9d27fd [0.005 seconds, 372 bytes]
▶ dispatched branch species_summary_625f9fbc7f62298a
● completed branch species_summary_625f9fbc7f62298a [0.013 seconds, 369 bytes]
● completed pattern species_summary 
▶ dispatched target combined_predictions
● completed target combined_predictions [0.008 seconds, 25.908 kilobytes]
▶ dispatched branch species_predictions_1598bb4431372f32
● completed branch species_predictions_1598bb4431372f32 [0.009 seconds, 11.581 kilobytes]
▶ dispatched branch species_predictions_6b9109ba2e9d27fd
● completed branch species_predictions_6b9109ba2e9d27fd [0.004 seconds, 6.248 kilobytes]
▶ dispatched branch species_predictions_625f9fbc7f62298a
● completed branch species_predictions_625f9fbc7f62298a [0.004 seconds, 9.625 kilobytes]
● completed pattern species_predictions 
▶ ended pipeline [0.27 seconds]
```

::::::::::::::::::::::::::::::::::::: {.callout}

## Best practices for branching

Dynamic branching is designed to work well with **dataframes** (it can also use [lists](https://books.ropensci.org/targets/dynamic.html#list-iteration), but that is more advanced, so we recommend using dataframes when possible).

It is recommended to write your custom functions to accept dataframes as input and return them as output, and always include any necessary metadata as a column or columns.

:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: What other kinds of patterns are there?

So far, we have only used a single function in conjunction with the `pattern` argument, `map()`, which applies the function to each element of its input in sequence.

Can you think of any other ways you might want to apply a branching pattern?

:::::::::::::::::::::::::::::::::: {.solution}

Some other ways of applying branching patterns include:

- crossing: one branch per combination of elements (`cross()` function)
- slicing: one branch for each of a manually selected set of elements (`slice()` function)
- sampling: one branch for each of a randomly selected set of elements (`sample()` function)

You can [find out more about different branching patterns in the `targets` manual](https://books.ropensci.org/targets/dynamic.html#patterns).

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Dynamic branching creates multiple targets with a single command
- You usually need to write custom functions so that the output of the branches includes necessary metadata 

::::::::::::::::::::::::::::::::::::::::::::::::
