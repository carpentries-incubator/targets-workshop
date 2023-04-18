---
title: 'The Workflow Lifecycle'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What happens if we re-run a workflow?
- How does `targets` know what steps to re-run?
- How can I override default settings?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain how `targets` helps increase efficiency
- Be able to inspect a workflow to see what parts are outdated
- Be able to run only a specific part of the workflow

::::::::::::::::::::::::::::::::::::::::::::::::



## Re-running the workflow

One of the features of `targets` is that it maximizes efficiency by only running the parts of the workflow that need to be run.

This is easiest to understand by trying it yourself. Let's try running the workflow again:


```r
tar_make()
```


```{.output}
✔ skip target my_data
✔ skip target my_summary
✔ skip pipeline [0.059 seconds]
```

Remember how the first time we ran the pipeline, `targets` printed out a list of each target as it was being built?

This time, it tells us it is skipping those targets; they have already been built, so there's no need to run that code again.

Remember, the fastest code is the code you don't have to run!

## Re-running the workflow after modification

What happens when we change one part of the workflow then run it again?

Let's modify the workflow to calculate the mean of both `x` and `y`.

Edit `_targets.R` so that the `summ()` function looks like this:


```r
summ <- function(dataset) {
    summarize(dataset, mean_x = mean(x), mean_y = mean(y))
  }
```

Then run it again.


```r
tar_make()
```


```{.output}
✔ skip target my_data
• start target my_summary
• built target my_summary [0.014 seconds]
• end pipeline [0.157 seconds]
```

What happened?

This time, it skipped `my_data` and only ran `my_summary`.

Of course, since our example workflow is so short we don't even notice the amount of time saved.
But imagine using this in a series of computationally intensive analysis steps.
The ability to automatically skip steps results in a massive increase in efficiency.

## Visualizing the workflow

Typically, you will be making edits to various places in your code, adding new targets, and running the workflow periodically.
It is good to be able to visualize the state of the workflow.

This can be done with `tar_visnetwork()`


```r
tar_visnetwork()
```

<!--html_preserve--><div class="visNetwork html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-fa6bfd20bed6c6f5cac5" style="width:504px;height:504px;"></div>
<script type="application/json" data-for="htmlwidget-fa6bfd20bed6c6f5cac5">{"x":{"nodes":{"name":["my_data","my_summary","summ"],"type":["stem","stem","function"],"status":["uptodate","uptodate","uptodate"],"seconds":[0.069,0.018,null],"bytes":[452,132,null],"branches":[null,null,null],"label":["my_data","my_summary","summ"],"color":["#354823","#354823","#354823"],"id":["my_data","my_summary","summ"],"level":[1,2,1],"shape":["dot","dot","triangle"]},"edges":{"from":["my_data","summ"],"to":["my_summary","my_summary"],"arrows":["to","to"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot","physics":false},"manipulation":{"enabled":false},"edges":{"smooth":{"type":"cubicBezier","forceDirection":"horizontal"}},"physics":{"stabilization":false},"interaction":{"zoomSpeed":1},"layout":{"hierarchical":{"enabled":true,"direction":"LR"}}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false,"style":"width: 150px; height: 26px","useLabels":true,"main":"Select by id"},"byselection":{"enabled":false,"style":"width: 150px; height: 26px","multiple":false,"hideColor":"rgba(200,200,200,0.5)","highlight":false},"main":{"text":"","style":"font-family:Georgia, Times New Roman, Times, serif;font-weight:bold;font-size:20px;text-align:center;"},"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)","highlight":{"enabled":true,"hoverNearest":false,"degree":{"from":1,"to":1},"algorithm":"hierarchical","hideColor":"rgba(200,200,200,0.5)","labelOnly":true},"collapse":{"enabled":true,"fit":false,"resetHighlight":true,"clusterOptions":null,"keepCoord":true,"labelSuffix":"(cluster)"},"legend":{"width":0.2,"useGroups":false,"position":"right","ncol":1,"stepX":100,"stepY":100,"zoom":true,"nodes":{"label":["Up to date","Stem","Function"],"color":["#354823","#899DA4","#899DA4"],"shape":["dot","dot","triangle"]},"nodesToDataframe":true},"tooltipStay":300,"tooltipStyle":"position: fixed;visibility:hidden;padding: 5px;white-space: nowrap;font-family: verdana;font-size:14px;font-color:#000000;background-color: #f5f4ed;-moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;border: 1px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

::::::::::::::::::::::::::::::::::::: caution 

You may encounter an error message `The package "visNetwork" is required.`

In this case, install it first with `install.packages("visNetwork")`.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- `targets` only runs the steps that have been affected by a change to the code
- `tar_visnetwork()` shows the current state of the workflow as a network
- `tar_progress()` shows the current state of the workflow as a data frame
- `tar_outdated()` lists outdated targets that will be built in the next `tar_make()`

::::::::::::::::::::::::::::::::::::::::::::::::
