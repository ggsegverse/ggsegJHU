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
#> 
#> ── jhu_wm ggseg atlas ──────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 27
#> Hemispheres: midline, right, left
#> Views: axial_2, axial_3, axial_4, axial_5, coronal_1, coronal_2, coronal_3,
#> coronal_4, sagittal, axial_1
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 48 × 4
#>    hemi    region                                   label    group      
#>    <chr>   <chr>                                    <chr>    <chr>      
#>  1 midline middle cerebellar peduncle               mcp      brainstem  
#>  2 midline pontine crossing tract                   pct      brainstem  
#>  3 midline genu of corpus callosum                  gcc      commissure 
#>  4 midline body of corpus callosum                  bcc      commissure 
#>  5 midline splenium of corpus callosum              scc      commissure 
#>  6 midline fornix (column and body)                 fornix   limbic     
#>  7 right   corticospinal tract                      rh_cst   projection 
#>  8 left    corticospinal tract                      lh_cst   projection 
#>  9 right   medial lemniscus                         rh_mlemn brainstem  
#> 10 left    medial lemniscus                         lh_mlemn brainstem  
#> 11 right   inferior cerebellar peduncle             rh_icp   brainstem  
#> 12 left    inferior cerebellar peduncle             lh_icp   brainstem  
#> 13 right   superior cerebellar peduncle             rh_scp   brainstem  
#> 14 left    superior cerebellar peduncle             lh_scp   brainstem  
#> 15 right   cerebral peduncle                        rh_cp    projection 
#> 16 left    cerebral peduncle                        lh_cp    projection 
#> 17 right   anterior limb of internal capsule        rh_alic  projection 
#> 18 left    anterior limb of internal capsule        lh_alic  projection 
#> 19 right   posterior limb of internal capsule       rh_plic  projection 
#> 20 left    posterior limb of internal capsule       lh_plic  projection 
#> 21 right   retrolenticular part of internal capsule rh_ric   projection 
#> 22 left    retrolenticular part of internal capsule lh_ric   projection 
#> 23 right   anterior corona radiata                  rh_acr   projection 
#> 24 left    anterior corona radiata                  lh_acr   projection 
#> 25 right   superior corona radiata                  rh_scr   projection 
#> 26 left    superior corona radiata                  lh_scr   projection 
#> 27 right   posterior corona radiata                 rh_pcr   projection 
#> 28 left    posterior corona radiata                 lh_pcr   projection 
#> 29 right   posterior thalamic radiation             rh_ptr   projection 
#> 30 left    posterior thalamic radiation             lh_ptr   projection 
#> 31 right   sagittal stratum                         rh_sags  association
#> 32 left    sagittal stratum                         lh_sags  association
#> 33 right   external capsule                         rh_exc   association
#> 34 left    external capsule                         lh_exc   association
#> 35 right   cingulum (cingulate gyrus)               rh_ccg   limbic     
#> 36 left    cingulum (cingulate gyrus)               lh_ccg   limbic     
#> 37 right   cingulum (hippocampus)                   rh_chip  limbic     
#> 38 left    cingulum (hippocampus)                   lh_chip  limbic     
#> 39 right   fornix (cres) / stria terminalis         rh_forcr limbic     
#> 40 left    fornix (cres) / stria terminalis         lh_forcr limbic     
#> 41 right   superior longitudinal fasciculus         rh_slf   association
#> 42 left    superior longitudinal fasciculus         lh_slf   association
#> 43 right   superior fronto-occipital fasciculus     rh_sfof  association
#> 44 left    superior fronto-occipital fasciculus     lh_sfof  association
#> 45 right   uncinate fasciculus                      rh_uncf  association
#> 46 left    uncinate fasciculus                      lh_uncf  association
#> 47 right   tapetum                                  rh_tap   commissure 
#> 48 left    tapetum                                  lh_tap   commissure 
icbm()
#> 
#> ── icbm ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 26
#> Hemispheres: subcort
#> Palette: ✔
#> Rendering: ✖ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 47 × 3
#>    hemi    region                                                          label
#>    <chr>   <chr>                                                           <chr>
#>  1 subcort Middle cerebellar peduncle                                      mcp  
#>  2 subcort Pontine crossing tract (a part of MCP)                          pct  
#>  3 subcort Genu of corpus callosum                                         gcc  
#>  4 subcort Body of corpus callosum                                         bcc  
#>  5 subcort Splenium of corpus callosum                                     scc  
#>  6 subcort Corticospinal tract                                             rh_c…
#>  7 subcort Corticospinal tract                                             lh_c…
#>  8 subcort Medial lemniscus                                                rh_m…
#>  9 subcort Medial lemniscus                                                lh_m…
#> 10 subcort Inferior cerebellar peduncle                                    rh_i…
#> 11 subcort Inferior cerebellar peduncle                                    lh_i…
#> 12 subcort Superior cerebellar peduncle                                    rh_s…
#> 13 subcort Superior cerebellar peduncle                                    lh_s…
#> 14 subcort Cerebral peduncle                                               rh_cp
#> 15 subcort Cerebral peduncle                                               lh_cp
#> 16 subcort Anterior limb of internal capsule                               rh_a…
#> 17 subcort Anterior limb of internal capsule                               lh_a…
#> 18 subcort Posterior limb of internal capsule                              rh_p…
#> 19 subcort Posterior limb of internal capsule                              lh_p…
#> 20 subcort Retrolenticular part of internal capsule                        rh_r…
#> 21 subcort Retrolenticular part of internal capsule                        lh_r…
#> 22 subcort Anterior corona radiata                                         rh_a…
#> 23 subcort Anterior corona radiata                                         lh_a…
#> 24 subcort Superior corona radiata                                         rh_s…
#> 25 subcort Superior corona radiata                                         lh_s…
#> 26 subcort Posterior corona radiata                                        rh_p…
#> 27 subcort Posterior corona radiata                                        lh_p…
#> 28 subcort Posterior thalamic radiation (include optic radiation)          rh_p…
#> 29 subcort Posterior thalamic radiation (include optic radiation)          lh_p…
#> 30 subcort Sagittal stratum (include inferior longitidinal fasciculus and… rh_s…
#> 31 subcort Sagittal stratum (include inferior longitidinal fasciculus and… lh_s…
#> 32 subcort External capsule                                                rh_e…
#> 33 subcort External capsule                                                lh_e…
#> 34 subcort Cingulum (cingulate gyrus)                                      rh_c…
#> 35 subcort Cingulum (cingulate gyrus)                                      lh_c…
#> 36 subcort Cingulum (hippocampus)                                          rh_c…
#> 37 subcort Cingulum (hippocampus)                                          lh_c…
#> 38 subcort Fornix (cres) / Stria terminalis (can not be resolved with cur… rh_f…
#> 39 subcort Fornix (cres) / Stria terminalis (can not be resolved with cur… lh_f…
#> 40 subcort Superior longitudinal fasciculus                                rh_s…
#> 41 subcort Superior longitudinal fasciculus                                lh_s…
#> 42 subcort Superior fronto-occipital fasciculus (could be a part of anter… rh_s…
#> 43 subcort Superior fronto-occipital fasciculus (could be a part of anter… lh_s…
#> 44 subcort Uncinate fasciculus                                             rh_u…
#> 45 subcort Uncinate fasciculus                                             lh_u…
#> 46 subcort Tapetum                                                         rh_t…
#> 47 subcort Tapetum                                                         lh_t…
```
