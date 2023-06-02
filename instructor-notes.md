---
title: 'Instructor Notes'
---

## General notes

Most of the examples are very short so that the participants can easily type them and don't get overwhelmed. However, there are a few downsides to this approach:

- First, this makes it difficult to demonstrate a realistic (longer) workflow. There is a demo available at <https://github.com/joelnitta/penguins-targets> of a more typical workflow based on the [Palmer Penguins dataset](https://allisonhorst.github.io/palmerpenguins/). The demo first shows up in "Best Practices for targets Project Organization", but could be shown earlier if needed. The instructor could even clone and run the demo.

- Second, since a given `targets` project can only have one `_targets.R` file, this means the participants may have to frequently delete their existing `_targets.R` file and write a new one to follow along with the examples. This may cause frustration if they can't keep a record of what they have done so far. One solution would be to save old `_targets.R` files as `_targets_1.R`, `_targets_2.R`, etc. instead of overwriting them.
