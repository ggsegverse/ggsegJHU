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
[`jhu_wm()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_wm.md)

Other tract_atlases:
[`jhu_wm()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_wm.md)

## Examples

``` r
jhu_tracts()
#> Error in jhu_tracts(): could not find function "jhu_tracts"
```
