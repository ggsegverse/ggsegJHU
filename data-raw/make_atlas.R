# Create JHU White Matter Atlases
#
# Creates two subcortical atlases from JHU/ICBM volumetric data:
# 1. jhu_tracts: JHU white matter tract atlas (20 tracts, thresholded at 25%)
# 2. jhu_wm: ICBM-DTI-81 white matter labels (48 regions)
#
# Source data (included in data-raw/):
#   - JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz (from FSL)
#   - JHU-ICBM-labels-1mm.nii.gz (from FSL)
#
# Metadata (included in data-raw/metadata/):
#   - jhu_tracts.tsv: tract names, hemispheres, groups
#   - jhu_wm.tsv: ICBM-DTI-81 label names, hemispheres, groups
#
# References:
#   Hua et al. (2008) NeuroImage 39(1):336-347
#   Mori et al. (2005) MRI Atlas of Human White Matter. Elsevier.
#
# Run with: Rscript data-raw/make_atlas.R

library(dplyr)
library(ggseg.extra)
library(ggseg.formats)

enrich_atlas <- function(atlas_raw, metadata_path) {
  meta <- utils::read.delim(metadata_path, stringsAsFactors = FALSE)

  old_labels <- atlas_raw$core$label
  old_idx <- as.integer(gsub("region_", "", old_labels))

  new_labels <- character(length(old_labels))
  new_regions <- character(length(old_labels))
  new_hemis <- character(length(old_labels))
  new_groups <- character(length(old_labels))

  for (i in seq_along(old_labels)) {
    row <- meta[meta$idx == old_idx[i], ]
    if (nrow(row) == 0) {
      new_labels[i] <- old_labels[i]
      new_regions[i] <- atlas_raw$core$region[i]
      new_hemis[i] <- atlas_raw$core$hemi[i]
      new_groups[i] <- NA_character_
      next
    }
    new_hemis[i] <- row$hemi[1]
    new_regions[i] <- row$region[1]
    new_groups[i] <- row$group[1]
    new_labels[i] <- if (row$hemi[1] %in% c("left", "right")) {
      paste0(ifelse(row$hemi[1] == "left", "lh_", "rh_"), row$label[1])
    } else {
      row$label[1]
    }
  }

  label_map <- setNames(new_labels, old_labels)

  if (!is.null(atlas_raw$palette) && length(atlas_raw$palette) > 0) {
    new_palette <- setNames(
      unname(atlas_raw$palette[old_labels]),
      new_labels
    )
    new_palette <- new_palette[!is.na(new_palette)]
  } else {
    new_palette <- character(0)
  }
  if (length(new_palette) == 0) {
    new_palette <- setNames(
      grDevices::hcl.colors(length(new_labels), palette = "Set2"),
      new_labels
    )
  }

  rename_labels <- function(x) unname(label_map[x])

  data <- atlas_raw$data
  if (!is.null(data$sf) && "label" %in% names(data$sf)) {
    data$sf$label <- rename_labels(data$sf$label)
  }
  if (!is.null(data$meshes) && "label" %in% names(data$meshes)) {
    data$meshes$label <- rename_labels(data$meshes$label)
  }

  core_enriched <- tibble(
    hemi = new_hemis,
    region = new_regions,
    label = new_labels,
    group = new_groups
  )

  ggseg_atlas(
    atlas = atlas_raw$atlas,
    type = atlas_raw$type,
    palette = new_palette,
    core = core_enriched,
    data = data
  )
}

# ── JHU Tracts ────────────────────────────────────────────────────
cli::cli_h1("Creating JHU tracts atlas")

jhu_tracts_raw <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz"),
  atlas_name = "jhu_tracts",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
)

jhu_tracts <- enrich_atlas(
  jhu_tracts_raw,
  here::here("data-raw", "metadata", "jhu_tracts.tsv")
)

cli::cli_alert_success("JHU tracts: {nrow(jhu_tracts$core)} regions")
print(jhu_tracts)
plot(jhu_tracts)

# ── JHU White Matter (ICBM-DTI-81) ───────────────────────────────
cli::cli_h1("Creating JHU white matter atlas")

jhu_wm_raw <- create_subcortical_from_volume(
  input_volume = here::here("data-raw", "JHU-ICBM-labels-1mm.nii.gz"),
  atlas_name = "jhu_wm",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
)

jhu_wm <- enrich_atlas(
  jhu_wm_raw,
  here::here("data-raw", "metadata", "jhu_wm.tsv")
)

cli::cli_alert_success("JHU labels: {nrow(jhu_wm$core)} regions")
print(jhu_wm)
plot(jhu_wm)

# ── ICBM (legacy, preserved from ggsegICBM) ──────────────────────
# The ICBM atlas has proper region names from the old ggsegICBM package.
# Load it from the existing sysdata rather than rebuilding.
icbm_sysdata <- here::here("R", "sysdata.rda")
if (file.exists(icbm_sysdata)) {
  icbm_env <- new.env(parent = emptyenv())
  load(icbm_sysdata, envir = icbm_env)
  if (exists(".icbm", envir = icbm_env)) {
    .icbm <- icbm_env$.icbm
    cli::cli_alert_success("Loaded ICBM atlas from existing sysdata")
  }
}

# ── Save as internal data ────────────────────────────────────────
.jhu_tracts <- jhu_tracts
.jhu_wm <- jhu_wm
usethis::use_data(.jhu_tracts, .jhu_wm, .icbm,
  overwrite = TRUE, compress = "xz", internal = TRUE
)
