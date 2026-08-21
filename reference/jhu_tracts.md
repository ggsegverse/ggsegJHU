# JHU White Matter Tract Atlas

JHU probabilistic white matter tract atlas with 20 tracts. Each tract is
reduced to a principal-curve centerline, drawn as a 3D tube for
[`ggseg3d::ggseg3d()`](https://ggsegverse.github.io/ggseg3d/reference/ggseg3d.html)
and as a 2D projection over an anatomical silhouette.

## Usage

``` r
jhu_tracts()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (tract).

## Details

Tracts are built from the atlas's probabilistic maps rather than FSL's
distributed winner-take-all volume, in which tracts sharing a corridor
erode each other: the temporal part of the superior longitudinal
fasciculus survives there as 76 voxels of a bundle spanning several
centimetres. Left and right of a tract share a colour, since they are
the same anatomy.

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
#> 
#> ── jhu_tracts ggseg atlas ──────────────────────────────────────────────────────
#> Type: tract
#> Regions: 11
#> Hemispheres: left, right, midline
#> Views: coronal, inferior_axial, mid_axial, sagittal, superior_axial
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (centerlines)
#> ────────────────────────────────────────────────────────────────────────────────
#>       hemi  region   label
#> 1     left     atr  lh_atr
#> 2    right     atr  rh_atr
#> 3     left     cst  lh_cst
#> 4    right     cst  rh_cst
#> 5     left     ccg  lh_ccg
#> 6    right     ccg  rh_ccg
#> 7     left    chip lh_chip
#> 8    right    chip rh_chip
#> 9  midline forcmaj forcmaj
#> 10 midline forcmin forcmin
#> ... with 10 more rows
plot(jhu_tracts())
```
