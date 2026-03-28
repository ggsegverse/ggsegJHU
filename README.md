
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggsegJHU

<!-- badges: start -->

[![R-CMD-check](https://github.com/ggsegverse/ggsegJHU/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ggsegverse/ggsegJHU/actions/workflows/R-CMD-check.yaml)
[![r-universe](https://ggsegverse.r-universe.dev/badges/ggsegJHU)](https://ggsegverse.r-universe.dev/ggsegJHU)
<!-- badges: end -->

JHU White Matter Atlases for the ggsegverse Ecosystem.

## Installation

``` r
# From r-universe
install.packages("ggsegJHU", repos = "https://ggsegverse.r-universe.dev")

# From GitHub
# install.packages("remotes")
remotes::install_github("ggsegverse/ggsegJHU")
```

## Atlases

### jhu_tracts

JHU white matter tract atlas (20 tracts).

``` r
library(ggsegJHU)
plot(jhu_tracts())
```

<img src="man/figures/README-jhu_tracts-1.png" alt="" width="100%" />

### jhu_labels

ICBM-DTI-81 white matter labels (48 regions).

``` r
plot(jhu_labels())
```

<img src="man/figures/README-jhu_labels-1.png" alt="" width="100%" />
\## Data source

JHU-ICBM white matter atlases from FSL.

- **Reference**: Hua et al. (2008) NeuroImage 39(1):336-347; Mori et
  al. (2005)
- **Date obtained**: 2020-03-27
