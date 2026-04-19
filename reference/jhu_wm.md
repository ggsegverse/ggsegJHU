# ICBM-DTI-81 White Matter Atlases

White matter label atlases derived from the ICBM DTI-81 probabilistic
atlas of 81 normal subjects.

## Usage

``` r
jhu_wm()

icbm()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (subcortical).

## Details

`jhu_wm()` provides the full 48-region atlas with both 2D and 3D
geometry. `icbm()` is a legacy variant with 3D geometry only.

## References

Mori S, et al. (2005). MRI Atlas of Human White Matter. Elsevier. ISBN:
978-0444517418

Wakana S, et al. (2007). Reproducibility of quantitative tractography
methods applied to cerebral white matter. *NeuroImage*, 36(3):630-644.
[doi:10.1016/j.neuroimage.2007.02.049](https://doi.org/10.1016/j.neuroimage.2007.02.049)

## See also

Other ggseg_atlases:
[`jhu_tracts()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_tracts.md)

Other tract_atlases:
[`jhu_tracts()`](https://ggsegverse.github.io/ggsegJHU/reference/jhu_tracts.md)

## Examples

``` r
jhu_wm()
#> Error in jhu_wm(): could not find function "jhu_wm"
icbm()
#> Error in icbm(): could not find function "icbm"
```
