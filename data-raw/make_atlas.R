# Create JHU White Matter Atlases
#
# Creates two subcortical atlases from JHU/ICBM volumetric data:
# 1. jhu_tracts: JHU white matter tract atlas (20 tracts, thresholded at 25%)
# 2. jhu_labels: ICBM-DTI-81 white matter labels (48 regions)
#
# Source data (included in data-raw/):
#   - JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz (from FSL)
#   - JHU-ICBM-labels-1mm.nii.gz (from FSL)
#
# References:
#   Hua et al. (2008) NeuroImage 39(1):336-347
#   Mori et al. (2005) MRI Atlas of Human White Matter. Elsevier.
#
# Run with: Rscript data-raw/make_atlas.R

library(ggseg.extra)
library(ggseg.formats)

# ── JHU Tracts ────────────────────────────────────────────────────
jhu_tracts <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz"),
  atlas_name = "jhu_tracts",
  output_dir = "data-raw",
  skip_existing = FALSE,
  cleanup = FALSE
)

if (is.null(jhu_tracts$palette) || length(jhu_tracts$palette) == 0) {
  labels <- jhu_tracts$core$label[!is.na(jhu_tracts$core$label)]
  jhu_tracts$palette <- setNames(
    grDevices::hcl.colors(length(labels), palette = "Set2"),
    labels
  )
}

print(jhu_tracts)
plot(jhu_tracts)

# ── ICBM-DTI-81 Labels ───────────────────────────────────────────
jhu_labels <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "JHU-ICBM-labels-1mm.nii.gz"),
  atlas_name = "jhu_labels",
  output_dir = "data-raw",
  skip_existing = FALSE,
  cleanup = FALSE
)

if (is.null(jhu_labels$palette) || length(jhu_labels$palette) == 0) {
  labels <- jhu_labels$core$label[!is.na(jhu_labels$core$label)]
  jhu_labels$palette <- setNames(
    grDevices::hcl.colors(length(labels), palette = "Set2"),
    labels
  )
}

print(jhu_labels)
plot(jhu_labels)

# ── Save as internal data ────────────────────────────────────────
.jhu_tracts <- jhu_tracts
.jhu_labels <- jhu_labels
usethis::use_data(.jhu_tracts, .jhu_labels,
  overwrite = TRUE, compress = "xz", internal = TRUE
)
