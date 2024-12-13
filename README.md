# Introduction to the "targets" Package for Reproducible Data Analysis in R

This is a pre-alpha lesson about the [targets](https://github.com/ropensci/targets) R package built using [The Carpentries Workbench][workbench].

The lesson website is here: https://carpentries-incubator.github.io/targets-workshop/

[workbench]: https://carpentries.github.io/sandpaper-docs/

Materials licensed under [CC-BY 4.0](LICENSE.md) by the authors

## Paper

There is a paper accompanying the workshop. Please cite it if appropriate!

The paper can be rendered to PDF from `paper.md` with the following Docker command:

```
docker run --rm -it \
  -v $PWD:/data \
  -u $(id -u):$(id -g) \
  openjournals/inara \
  -o pdf,crossref \
  ./paper.md
```