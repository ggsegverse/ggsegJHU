# Create JHU ICBM-DTI-81 White Matter Labels (Segments) Atlas
#
# Adds the JHU ICBM-DTI-81 white matter labels atlas to ggsegJHU.
# This complements the existing JHU white matter tracts atlas with
# a volumetric segmentation of white matter regions.
#
# The ICBM-DTI-81 labels atlas contains 48 white matter structure labels
# derived from a probabilistic atlas of 81 normal subjects.
#
# Source: FSL distribution (JHU-ICBM-labels-1mm.nii.gz)
# Can also be downloaded from:
#   https://neurovault.org/collections/262/
#
# Reference: Mori S, et al. (2005). "MRI Atlas of Human White Matter."
#   Elsevier. ISBN: 978-0444517418
#
# Reference: Wakana S, et al. (2007). "Reproducibility of quantitative
#   tractography methods applied to cerebral white matter." NeuroImage,
#   36(3):630-644. DOI: 10.1016/j.neuroimage.2007.02.049
#
# Requirements:
#   - ggseg.extra package
#   - ggseg.formats package
#
# Run with: Rscript data-raw/make_jhu_segments.R

library(dplyr)
library(ggseg.extra)
library(ggseg.formats)

options(chromote.timeout = 120)
future::plan(future::sequential)
progressr::handlers("cli")
progressr::handlers(global = TRUE)

# ── Obtain JHU ICBM-DTI-81 labels volume ─────────────────────────
# The JHU labels atlas ships with FSL. If FSL is installed, the volume is at
# JHU-ICBM-labels-1mm.nii.gz under data/atlases/JHU in $FSLDIR.
#
# Otherwise download from NeuroVault or place manually:

vol_file <- here::here("data-raw", "JHU-ICBM-labels-1mm.nii.gz")

if (!file.exists(vol_file)) {
  cli::cli_alert_info("Downloading JHU ICBM-DTI-81 labels atlas")
  fsl_dir <- Sys.getenv("FSLDIR")
  fsl_path <- file.path(
    fsl_dir,
    "data",
    "atlases",
    "JHU",
    "JHU-ICBM-labels-1mm.nii.gz"
  )
  if (file.exists(fsl_path)) {
    file.copy(fsl_path, vol_file)
  } else {
    cli::cli_abort(c(
      "JHU labels volume not found",
      "i" = "Copy from FSL: \\
             {.path $FSLDIR/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz}",
      "i" = "Or download from: {.url https://neurovault.org/collections/262/}"
    ))
  }
}

# ── Create atlas from volume ─────────────────────────────────────
cli::cli_h1("Creating JHU white matter segments atlas")

jhu_seg <- create_subcortical_from_volume(
  input_volume = vol_file,
  atlas_name = "jhu_seg",
  output_dir = here::here("data-raw"),
  skip_existing = TRUE,
  cleanup = FALSE
)

jhu_seg <- jhu_seg |>
  atlas_region_contextual("unknown|Background", "label")

cli::cli_alert_success("jhu_seg: {nrow(jhu_seg$core)} regions")
print(jhu_seg)

# ── Update palettes (merge with existing tracts palette) ──────────
existing_pals <- NULL
sysdata_path <- here::here("R/sysdata.rda")
if (file.exists(sysdata_path)) {
  load(sysdata_path)
  existing_pals <- brain_pals
}

brain_pals <- c(
  existing_pals,
  stats::setNames(
    list(jhu_seg$palette),
    jhu_seg$atlas
  )
)
save(brain_pals, file = sysdata_path, compress = "xz")

usethis::use_data(jhu_seg, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/jhu_seg.rda")
