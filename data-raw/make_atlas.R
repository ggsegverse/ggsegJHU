# Create JHU White Matter Atlases
#
# Two subcortical atlases from JHU/ICBM volumetric data, both with
# anatomical (cortical) reference outlines from the FreeSurfer
# cvs_avg35_inMNI152 subject:
# 1. jhu_tracts: JHU white matter tract atlas (20 tracts, thresholded at 25%)
# 2. jhu_wm:     ICBM-DTI-81 white matter labels (48 regions)
#
# The pipeline coregisters each JHU volume to cvs_avg35_inMNI152 and then
# trilinear-resamples each label onto the FreeSurfer aparc+aseg grid
# (argmax across labels). This:
#   * smooths the voxel-grid jaggedness of the raw 1mm masks
#   * merges the labels into aparc+aseg so the 2D slice generator picks
#     up cortex labels (1000-2999) and draws a real cortical outline
#     around the white-matter regions.
#
# Source data (in data-raw/):
#   - JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz (FSL)
#   - JHU-ICBM-labels-1mm.nii.gz (FSL)
#
# Metadata (in data-raw/metadata/):
#   - jhu_tracts.tsv / jhu_wm.tsv: idx, label, region, hemi, group
#
# Run with: Rscript data-raw/make_atlas.R

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(ggseg.extra)
  library(ggseg.formats)
})

fs_home <- Sys.getenv("FREESURFER_HOME", "/Applications/freesurfer/7.4.1")
Sys.setenv(FREESURFER_HOME = fs_home)
Sys.setenv(SUBJECTS_DIR = file.path(fs_home, "subjects"))
target_subject <- "cvs_avg35_inMNI152"
id_offset <- 200L

build_lut <- function(meta_path, out_path) {
  meta <- read_tsv(meta_path, show_col_types = FALSE)
  groups <- sort(unique(meta$group))
  group_palette <- setNames(
    grDevices::hcl.colors(length(groups), palette = "Set2"),
    groups
  )
  meta_lut <- meta |>
    mutate(
      hemi_prefix = case_when(
        hemi == "left" ~ "lh_",
        hemi == "right" ~ "rh_",
        TRUE ~ ""
      ),
      label_full = paste0(hemi_prefix, label),
      hex = unname(group_palette[group])
    )
  rgb_mat <- grDevices::col2rgb(meta_lut$hex)
  lut <- tibble(
    idx = as.integer(meta_lut$idx),
    label = meta_lut$label_full,
    R = as.integer(rgb_mat["red", ]),
    G = as.integer(rgb_mat["green", ]),
    B = as.integer(rgb_mat["blue", ]),
    A = 0L
  )
  write_tsv(lut, out_path)
  invisible(lut)
}

enrich_core <- function(atlas, meta_path) {
  meta <- read_tsv(meta_path, show_col_types = FALSE) |>
    mutate(
      hemi_prefix = case_when(
        hemi == "left" ~ "lh_",
        hemi == "right" ~ "rh_",
        TRUE ~ ""
      ),
      label_full = paste0(hemi_prefix, label)
    ) |>
    select(label = label_full, region, group)

  core_enriched <- atlas$core |>
    left_join(meta, by = "label") |>
    select(any_of(c("hemi", "region", "label", "group")))

  ggseg_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = core_enriched,
    data = atlas$data
  )
}

build_jhu_atlas <- function(input_volume, atlas_name, meta_path) {
  cli::cli_h1("Building {.val {atlas_name}}")

  lut_path <- file.path(
    "data-raw", "metadata", paste0(atlas_name, "_lut.tsv")
  )
  build_lut(meta_path, lut_path)

  prep <- prepare_subcortical_anatomical(
    input_volume = input_volume,
    lut = lut_path,
    target_subject = target_subject,
    id_offset = id_offset,
    output_file = here::here(
      "data-raw", paste0(atlas_name, "_anatomical.nii.gz")
    ),
    output_lta = here::here(
      "data-raw", paste0(atlas_name, "_to_cvs.lta")
    ),
    skip_existing = TRUE,
    verbose = TRUE
  )

  shifted_lut <- file.path(
    "data-raw", "metadata", paste0(atlas_name, "_lut_shifted.tsv")
  )
  write_tsv(prep$lut, shifted_lut)

  raw <- create_subcortical_from_volume(
    input_volume = prep$output_file,
    input_lut = shifted_lut,
    atlas_name = atlas_name,
    output_dir = "data-raw",
    skip_existing = TRUE,
    cleanup = FALSE,
    verbose = TRUE
  )

  enrich_core(raw, meta_path)
}

jhu_tracts <- build_jhu_atlas(
  input_volume = here::here(
    "data-raw", "JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz"
  ),
  atlas_name = "jhu_tracts",
  meta_path = here::here("data-raw", "metadata", "jhu_tracts.tsv")
)

jhu_wm <- build_jhu_atlas(
  input_volume = here::here("data-raw", "JHU-ICBM-labels-1mm.nii.gz"),
  atlas_name = "jhu_wm",
  meta_path = here::here("data-raw", "metadata", "jhu_wm.tsv")
)

cli::cli_alert_success("jhu_tracts: {nrow(jhu_tracts$core)} regions")
print(jhu_tracts)
plot(jhu_tracts)

cli::cli_alert_success("jhu_wm: {nrow(jhu_wm$core)} regions")
print(jhu_wm)
plot(jhu_wm)

.jhu_tracts <- jhu_tracts
.jhu_wm <- jhu_wm
usethis::use_data(
  .jhu_tracts, .jhu_wm,
  overwrite = TRUE, compress = "xz", internal = TRUE
)
