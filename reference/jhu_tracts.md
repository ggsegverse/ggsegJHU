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
#> 
#> ── jhu_tracts ggseg atlas ──────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 11
#> Hemispheres: left, right, midline
#> Views: axial_1, axial_2, axial_3, axial_4, axial_5, coronal_3, coronal_4,
#> sagittal, coronal_1, coronal_2
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 20 × 4
#>    hemi    region                                      label   group      
#>    <chr>   <chr>                                       <chr>   <chr>      
#>  1 left    anterior thalamic radiation                 lh_atr  projection 
#>  2 right   anterior thalamic radiation                 rh_atr  projection 
#>  3 left    corticospinal tract                         lh_cst  projection 
#>  4 right   corticospinal tract                         rh_cst  projection 
#>  5 left    cingulum (cingulate gyrus)                  lh_ccg  limbic     
#>  6 right   cingulum (cingulate gyrus)                  rh_ccg  limbic     
#>  7 left    cingulum (hippocampus)                      lh_chip limbic     
#>  8 right   cingulum (hippocampus)                      rh_chip limbic     
#>  9 midline forceps major                               forcmaj commissure 
#> 10 midline forceps minor                               forcmin commissure 
#> 11 left    inferior fronto-occipital fasciculus        lh_ifof association
#> 12 right   inferior fronto-occipital fasciculus        rh_ifof association
#> 13 left    inferior longitudinal fasciculus            lh_ilf  association
#> 14 right   inferior longitudinal fasciculus            rh_ilf  association
#> 15 left    superior longitudinal fasciculus            lh_slf  association
#> 16 right   superior longitudinal fasciculus            rh_slf  association
#> 17 left    superior longitudinal fasciculus (temporal) lh_sltf association
#> 18 right   superior longitudinal fasciculus (temporal) rh_sltf association
#> 19 left    uncinate fasciculus                         lh_uncf association
#> 20 right   uncinate fasciculus                         rh_uncf association
```
