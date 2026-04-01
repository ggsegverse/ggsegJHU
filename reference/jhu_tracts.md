# JHU White Matter Tract Atlas

JHU probabilistic white matter tract atlas with 20 tracts, thresholded
at 25% probability. Contains 3D mesh geometry for
[`ggseg3d::ggseg3d()`](https://ggsegverse.github.io/ggseg3d/reference/ggseg3d.html).

## Usage

``` r
jhu_tracts()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (subcortical).

## References

Hua K, et al. (2008). Tract probability maps in stereotaxic spaces:
analyses of white matter anatomy and tract-specific quantification.
*NeuroImage*, 39(1):336-347.
[doi:10.1016/j.neuroimage.2007.07.053](https://doi.org/10.1016/j.neuroimage.2007.07.053)

## See also

Other ggseg_atlases:
[`icbm()`](https://ggsegverse.github.io/ggsegJHU/reference/icbm.md),
[`jhu_labels()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_labels.md)

Other tract_atlases:
[`icbm()`](https://ggsegverse.github.io/ggsegJHU/reference/icbm.md),
[`jhu_labels()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_labels.md)

## Examples

``` r
jhu_tracts()
#> 
#> ── jhu_tracts ggseg atlas ──────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 20
#> Hemispheres: NA
#> Views: axial_1, axial_2, axial_3, axial_4, axial_5, coronal_3, coronal_4,
#> sagittal, coronal_1, coronal_2
#> Palette: ✖
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 20 × 3
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
```
