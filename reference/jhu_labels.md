# JHU ICBM-DTI-81 White Matter Labels

ICBM-DTI-81 white matter labels atlas with 48 regions derived from a
probabilistic atlas of 81 normal subjects. Contains 3D mesh geometry for
[`ggseg3d::ggseg3d()`](https://ggsegverse.github.io/ggseg3d/reference/ggseg3d.html).

## Usage

``` r
jhu_labels()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (subcortical).

## References

Mori S, et al. (2005). MRI Atlas of Human White Matter. Elsevier. ISBN:
978-0444517418

Wakana S, et al. (2007). Reproducibility of quantitative tractography
methods applied to cerebral white matter. *NeuroImage*, 36(3):630-644.
[doi:10.1016/j.neuroimage.2007.02.049](https://doi.org/10.1016/j.neuroimage.2007.02.049)

## See also

Other ggseg_atlases:
[`icbm()`](https://ggsegverse.github.io/ggsegJHU/reference/icbm.md),
[`jhu_tracts()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_tracts.md)

Other tract_atlases:
[`icbm()`](https://ggsegverse.github.io/ggsegJHU/reference/icbm.md),
[`jhu_tracts()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_tracts.md)

## Examples

``` r
jhu_labels()
#> 
#> ── jhu_labels ggseg atlas ──────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 48
#> Hemispheres: NA
#> Views: axial_2, axial_3, axial_4, axial_5, coronal_1, coronal_2, coronal_3,
#> coronal_4, sagittal, axial_1
#> Palette: ✖
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 48 × 3
#>    hemi  region      label      
#>    <chr> <chr>       <chr>      
#>  1 NA    region 0001 region_0001
#>  2 NA    region 0002 region_0002
#>  3 NA    region 0003 region_0003
#>  4 NA    region 0004 region_0004
#>  5 NA    region 0005 region_0005
#>  6 NA    region 0006 region_0006
#>  7 NA    region 0007 region_0007
#>  8 NA    region 0008 region_0008
#>  9 NA    region 0009 region_0009
#> 10 NA    region 0010 region_0010
#> 11 NA    region 0011 region_0011
#> 12 NA    region 0012 region_0012
#> 13 NA    region 0013 region_0013
#> 14 NA    region 0014 region_0014
#> 15 NA    region 0015 region_0015
#> 16 NA    region 0016 region_0016
#> 17 NA    region 0017 region_0017
#> 18 NA    region 0018 region_0018
#> 19 NA    region 0019 region_0019
#> 20 NA    region 0020 region_0020
#> 21 NA    region 0021 region_0021
#> 22 NA    region 0022 region_0022
#> 23 NA    region 0023 region_0023
#> 24 NA    region 0024 region_0024
#> 25 NA    region 0025 region_0025
#> 26 NA    region 0026 region_0026
#> 27 NA    region 0027 region_0027
#> 28 NA    region 0028 region_0028
#> 29 NA    region 0029 region_0029
#> 30 NA    region 0030 region_0030
#> 31 NA    region 0031 region_0031
#> 32 NA    region 0032 region_0032
#> 33 NA    region 0033 region_0033
#> 34 NA    region 0034 region_0034
#> 35 NA    region 0035 region_0035
#> 36 NA    region 0036 region_0036
#> 37 NA    region 0037 region_0037
#> 38 NA    region 0038 region_0038
#> 39 NA    region 0039 region_0039
#> 40 NA    region 0040 region_0040
#> 41 NA    region 0041 region_0041
#> 42 NA    region 0042 region_0042
#> 43 NA    region 0043 region_0043
#> 44 NA    region 0044 region_0044
#> 45 NA    region 0045 region_0045
#> 46 NA    region 0046 region_0046
#> 47 NA    region 0047 region_0047
#> 48 NA    region 0048 region_0048
```
