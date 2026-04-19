# JHU White Matter Tract Atlas

Probabilistic white matter tract atlas based on the Johns Hopkins
University DTI-based tractography.

## Usage

``` r
jhu()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (subcortical).

## References

Hua et al. (2008) Tract probability maps in stereotaxic spaces: analysis
of white matter anatomy and tract-specific quantification. NeuroImage,
39(1):336-347
[doi:10.1016/j.neuroimage.2007.07.053](https://doi.org/10.1016/j.neuroimage.2007.07.053)

## Examples

``` r
jhu()
#> 
#> ── jhu ggseg atlas ─────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 11
#> Hemispheres: right, left, center
#> Views: upper axial, lower axial, coronal
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 20 × 3
#>    hemi   region                                           label  
#>    <chr>  <chr>                                            <chr>  
#>  1 right  Anterior thalamic radiation                      rh_atr 
#>  2 left   Anterior thalamic radiation                      lh_atr 
#>  3 right  Cingulum (cingulate gyrus)                       rh_ccg 
#>  4 left   Cingulum (cingulate gyrus)                       lh_ccg 
#>  5 left   Cingulum (hippocampus)                           lh_cab 
#>  6 right  Cingulum (hippocampus)                           rh_cab 
#>  7 right  Corticospinal tract                              rh_cst 
#>  8 left   Corticospinal tract                              lh_cst 
#>  9 center Forceps major                                    fmajor 
#> 10 center Forceps minor                                    fminor 
#> 11 left   Inferior fronto-occipital fasciculus             lh_ifof
#> 12 right  Inferior fronto-occipital fasciculus             rh_ifof
#> 13 right  Inferior longitudinal fasciculus                 rh_ilf 
#> 14 left   Inferior longitudinal fasciculus                 lh_ilf 
#> 15 right  Superior longitudinal fasciculus                 rh_slf 
#> 16 left   Superior longitudinal fasciculus                 lh_slf 
#> 17 right  Superior longitudinal fasciculus (temporal part) rh_slft
#> 18 left   Superior longitudinal fasciculus (temporal part) lh_slft
#> 19 left   Uncinate fasciculus                              lh_unc 
#> 20 right  Uncinate fasciculus                              rh_unc 
```
