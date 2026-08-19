

<!-- README.md is generated from README.qmd. Please edit that file -->

# ggsegJHU

<!-- badges: start -->

[![R-CMD-check](https://github.com/ggsegverse/ggsegJHU/workflows/R-CMD-check/badge.svg)](https://github.com/ggsegverse/ggsegJHU/actions)
<!-- badges: end -->

This package provides JHU and ICBM white matter atlases formatted for
use with [ggseg](https://ggseg.github.io/ggseg/) and
[ggseg3d](https://ggseg.github.io/ggseg3d/).

| Atlas                  | Function       | Regions    | Reference          |
|------------------------|----------------|------------|--------------------|
| JHU Tracts             | `jhu_tracts()` | 20 tracts  | Hua et al. (2008)  |
| JHU ICBM-DTI-81 Labels | `jhu_wm()`     | 48 regions | Mori et al. (2005) |

To learn how to use these atlases, please look at the documentation for
[ggseg](https://ggseg.github.io/ggseg/) and
[ggseg3d](https://ggseg.github.io/ggseg3d/).

## Installation

You can install ggsegJHU from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ggsegverse/ggsegJHU")
```

## Atlases

``` r
library(ggsegJHU)

plot(jhu_tracts())
```

<img src="man/figures/README-jhu-tracts-1.png" style="width:100.0%" />

``` r
plot(jhu_wm())
```

<img src="man/figures/README-jhu-wm-1.png" style="width:100.0%" />

Both atlases also carry 3D geometry, for `ggseg3d::ggseg3d()`.

## Data source

Data obtained from the [FSL standard-space
atlases](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Atlases), which ship the
JHU white-matter tractography atlas and the ICBM-DTI-81 labels in
`$FSLDIR/data/atlases/JHU/`.
