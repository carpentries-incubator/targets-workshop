---
title: 'A brief introduction to functions'
teaching: 20
exercises: 1
---

:::::::::::::::::::::::::::::::::::::: questions 

- What are functions?
- Why should we know how to write them?
- What are the main components of a function?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the usefulness of custom functions
- Understand the basic concepts around writing functions

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: {.instructor}

Episode summary: A very brief introduction to functions, when you have learners who have no experience with them.

::::::::::::::::::::::::::::::::::::::::::::::::



## Create a function

### About functions

Functions in R are something we are used to thinking of as something that comes from a package. You find, install and use specialized functions from packages to get your work done.

But you can, and arguably should, be writing your own functions too!
Functions are a great way of making it easy to repeat the same operation but with different settings.
How many times have you copy-pasted the exact same code in your script, only to change a couple of things (a variable, an input etc.) before running it again?
Only to then discover that there was an error in the code, and when you fix it, you need to remember to do so in all the places where you copied that code. 

Through writing functions you can reduce this back and forth, and create a more efficient workflow for yourself.
When you find the bug, you fix it in a single place, the function you made, and each subsequent call of that function will now be fixed.

Furthermore, `targets` makes extensive use of custom functions, so a basic understanding of how they work is very important to successfully using it.

### Writing a function

There is not much difference between writing your own function and writing other code in R, you are still coding with R!
Let's imagine we want to convert the millimeter measurements in the Penguins data to centimeters.


``` r
library(palmerpenguins)
library(tidyverse)
```

``` output
── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.4     ✔ readr     2.1.5
✔ forcats   1.0.0     ✔ stringr   1.5.1
✔ ggplot2   3.5.1     ✔ tibble    3.2.1
✔ lubridate 1.9.3     ✔ tidyr     1.3.1
✔ purrr     1.0.2     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

``` r
penguins |>
  mutate(
    bill_length_cm = bill_length_mm / 10,
    bill_depth_cm = bill_depth_mm / 10
  )
```

``` output
# A tibble: 344 × 10
   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
   <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
 1 Adelie  Torgersen           39.1          18.7               181        3750
 2 Adelie  Torgersen           39.5          17.4               186        3800
 3 Adelie  Torgersen           40.3          18                 195        3250
 4 Adelie  Torgersen           NA            NA                  NA          NA
 5 Adelie  Torgersen           36.7          19.3               193        3450
 6 Adelie  Torgersen           39.3          20.6               190        3650
 7 Adelie  Torgersen           38.9          17.8               181        3625
 8 Adelie  Torgersen           39.2          19.6               195        4675
 9 Adelie  Torgersen           34.1          18.1               193        3475
10 Adelie  Torgersen           42            20.2               190        4250
# ℹ 334 more rows
# ℹ 4 more variables: sex <fct>, year <int>, bill_length_cm <dbl>,
#   bill_depth_cm <dbl>
```

This is not a complicated operation, but we might want to make a convenient custom function that can do this conversion for us anyways.

To write a function, you need to use the `function()` function. 
With this function we provide what will be the input arguments of the function inside its parentheses, and what the function will subsequently do with those input arguments in curly braces `{}` after the function parentheses. 
The object name we assign this to, will become the function's name.


``` r
my_function <- function(argument1, argument2) {
  # the things the function will do
}
# call the function
my_function(1, "something")
```

For our mm to cm conversion the function would look like so:


``` r
mm2cm <- function(x) {
  x / 10
}
# use it
penguins |>
  mutate(
    bill_length_cm = mm2cm(bill_length_mm),
    bill_depth_cm = mm2cm(bill_depth_mm)
  )
```

``` output
# A tibble: 344 × 10
   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
   <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
 1 Adelie  Torgersen           39.1          18.7               181        3750
 2 Adelie  Torgersen           39.5          17.4               186        3800
 3 Adelie  Torgersen           40.3          18                 195        3250
 4 Adelie  Torgersen           NA            NA                  NA          NA
 5 Adelie  Torgersen           36.7          19.3               193        3450
 6 Adelie  Torgersen           39.3          20.6               190        3650
 7 Adelie  Torgersen           38.9          17.8               181        3625
 8 Adelie  Torgersen           39.2          19.6               195        4675
 9 Adelie  Torgersen           34.1          18.1               193        3475
10 Adelie  Torgersen           42            20.2               190        4250
# ℹ 334 more rows
# ℹ 4 more variables: sex <fct>, year <int>, bill_length_cm <dbl>,
#   bill_depth_cm <dbl>
```

Our custom function will now transform any numerical input by dividing it by 10. 

### Make a function from existing code

Many times, we might already have a piece of code that we'd like to use to create a function.
For instance, we've copy-pasted a section of code several times and realize that this piece of code is repetitive, so a function is in order.
Or, you are converting your workflow to `targets`, and need to change your script into a series of functions that `targets` will call.

Recall the code snippet we had to clean our Penguins data:


``` r
penguins_data_raw |>
  select(
    species = Species,
    bill_length_mm = `Culmen Length (mm)`,
    bill_depth_mm = `Culmen Depth (mm)`
  ) |>
  drop_na()
```

We need to adapt this code to become a function, and this function needs a single argument, which is the dataset it should clean.

It should look like this:

``` r
clean_penguin_data <- function(penguins_data_raw) {
  penguins_data_raw |>
    select(
      species = Species,
      bill_length_mm = `Culmen Length (mm)`,
      bill_depth_mm = `Culmen Depth (mm)`
    ) |>
    drop_na()
}
```

::::::::::::::::: callout

# RStudio function extraction

RStudio also has a handy helper to extract a function from a piece of code.
Once you have basic familiarity with functions, it may help you figure out the necessary input when turning code into a function.

To use it, highlight the piece of code you want to make into a function.
In our case that is the entire pipeline from `penguins_data_raw` to the `drop_na()` statement.
Once you have done this, in RStudio go to the "Code" section in the top bar, and select "Extract function" from the list.
A prompt will open asking you to hit enter, and you should have the following code in your script where the cursor was.

This function will not work however, because it contains more stuff than is needed as an argument.
This is because tidyverse uses non-standard evaluation, and we can write unquoted column names inside the `select()`. 
The function extractor thinks that all unquoted (or back-ticked) text in the code is a reference to an object.
You will need to do some manual cleaning to get the function working, which is why its more convenient if you have a little experience with functions already.

::::::::::::::::::

::::::::::::::::::::::::::::::::::::: {.challenge}

## Challenge: Write a function that takes a numerical vector and returns its mean divided by 10.

:::::::::::::::::::::::::::::::::: {.solution}


``` r
vecmean <- function(x) {
  mean(x) / 10
}
```

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::

Congratulations, you've started a whole new journey into functions!
This was a very brief introduction to functions, and you will likely need to get more help in learning about them.
There is an episode in the R Novice lesson from Carpentries that is [all about functions](https://swcarpentry.github.io/r-novice-gapminder/10-functions.html) which you might want to read.

::::::::::::::::::::::::::::::::::::: keypoints 

- Functions are crucial when repeating the same code many times with minor differences
- RStudio's "Extract function" tool can help you get started with converting code into functions
- Functions are an essential part of how `targets` works.

::::::::::::::::::::::::::::::::::::::::::::::::
