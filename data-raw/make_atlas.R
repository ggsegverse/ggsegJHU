# Assemble the JHU atlas package data
#
# Builds jhu_wm, the ICBM-DTI-81 white matter label atlas (48 regions), and
# writes it to R/sysdata.rda alongside the tract atlas.
#
# jhu_wm is a set of white-matter *parcels* rather than pathways, so it stays
# a subcortical atlas. jhu_tracts is built separately, and as a tract atlas
# with centerlines, by data-raw/create-tract-atlas.R -- which must be run
# first, since this script only reads its output.
#
# jhu_wm is coregistered to cvs_avg35_inMNI152 and trilinear-resampled onto
# the FreeSurfer aparc+aseg grid (argmax across labels). This:
#   * smooths the voxel-grid jaggedness of the raw 1mm masks
#   * merges the labels into aparc+aseg so the 2D slice generator picks
#     up cortex labels (1000-2999) and draws a real cortical outline
#     around the white-matter regions.
#
# Source data (in data-raw/): JHU-ICBM-labels-1mm.nii.gz (FSL).
# Metadata (in data-raw/metadata/): jhu_wm.tsv -- idx, label, region, hemi,
# group.
#
# Run with:
#   Rscript data-raw/create-tract-atlas.R
#   Rscript data-raw/make_atlas.R

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

# Higher snapshot resolution + more contour smoothing reduces the
# voxel-grid stair-stepping in the 2D outlines. The default 800x800
# raster gives ~3 pixels per voxel which is right at the aliasing
# limit; 1600 halves the stair amplitude.
options(ggseg.extra.snapshot_dim = 1600)
options(ggseg.extra.smoothness = 12)

# FSL ships no colour lookup table for these atlases, so the palette is ours
# to choose. Colour is assigned per structure, with left and right sharing a
# hue: the hemispheres of one bundle are the same anatomy, and giving them
# separate colours implies a distinction that does not exist. Colouring by the
# coarser `group` (projection/association/limbic/commissure/brainstem)
# instead, as earlier releases did, left five colours for 48 regions and made
# distinct structures indistinguishable.
build_lut <- function(meta_path) {
  meta <- read_tsv(meta_path, show_col_types = FALSE)
  families <- unique(meta$label)
  family_palette <- setNames(
    grDevices::hcl.colors(length(families), palette = "Dark 3"),
    families
  )
  meta_lut <- meta |>
    mutate(
      hemi_prefix = case_when(
        hemi == "left" ~ "lh_",
        hemi == "right" ~ "rh_",
        TRUE ~ ""
      ),
      label_full = paste0(hemi_prefix, label),
      hex = unname(family_palette[label])
    )
  rgb_mat <- grDevices::col2rgb(meta_lut$hex)
  data.frame(
    idx = as.integer(meta_lut$idx),
    label = meta_lut$label_full,
    R = as.integer(rgb_mat["red", ]),
    G = as.integer(rgb_mat["green", ]),
    B = as.integer(rgb_mat["blue", ]),
    A = 0L,
    stringsAsFactors = FALSE
  )
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
    select(label = label_full, region, group, hemi_meta = hemi)

  core_enriched <- atlas$core |>
    select(-any_of("region")) |>
    left_join(meta, by = "label") |>
    mutate(hemi = coalesce(hemi_meta, hemi)) |>
    select(hemi, region, label, group)

  ggseg_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = core_enriched,
    data = atlas$data
  )
}

# Nine views chosen to cover all 20 jhu_tracts regions and all 48
# jhu_wm regions while keeping per-view clutter manageable
# (max ~25 regions per view, most 10-20). Anatomical levels were
# picked from per-slab region counts on the cvs_avg35_inMNI152 grid:
#
#   axial_inferior  z=80-84   brainstem (CST, ICP, mlemn)
#   axial_middle    z=104-108 internal capsule limbs, basal ganglia
#   axial_superior  z=128-132 corona radiata, SLF
#   coronal_anterior  y=98-102  genu CC, frontal projections
#   coronal_middle    y=126-130 mid-brain, fornix, internal capsule
#   coronal_posterior y=156-160 splenium, posterior radiations
#   sagittal_left   x=94-102  left lateral tracts
#   sagittal_mid    x=118-138 midline commissural fibres
#   sagittal_right  x=154-162 right lateral tracts
#
# The sagittal slabs are wider than the axial and coronal ones. A sagittal cut
# runs along the cortical ribbon rather than across it, so a thin slab catches
# only where the ribbon happens to sit exactly in-plane and breaks the outline
# into fragments -- sagittal_mid was a single slice and came out moth-eaten.
#
# sagittal_mid stays centred on the midline. The silhouette behind the regions
# is a true slice, and exactly at the midline it lands in the interhemispheric
# fissure with almost no cortex to draw -- but ggseg.extra now picks that slice
# by cortex content within the slab rather than taking the midpoint, and lands
# on x=134 here without being told to.
jhu_views <- rbind(
  data.frame(name = "axial_inferior", type = "axial", start = 80, end = 84),
  data.frame(name = "axial_middle", type = "axial", start = 104, end = 108),
  data.frame(name = "axial_superior", type = "axial", start = 128, end = 132),
  data.frame(
    name = "coronal_anterior",
    type = "coronal",
    start = 98,
    end = 102
  ),
  data.frame(name = "coronal_middle", type = "coronal", start = 126, end = 130),
  data.frame(
    name = "coronal_posterior",
    type = "coronal",
    start = 156,
    end = 160
  ),
  data.frame(name = "sagittal_left", type = "sagittal", start = 94, end = 102),
  data.frame(name = "sagittal_mid", type = "sagittal", start = 118, end = 138),
  data.frame(name = "sagittal_right", type = "sagittal", start = 154, end = 162)
)

build_jhu_atlas <- function(input_volume, atlas_name, meta_path) {
  cli::cli_h1("Building {.val {atlas_name}}")

  meta <- read_tsv(meta_path, show_col_types = FALSE)
  lut_df <- build_lut(meta_path)

  # Both volumes are already in MNI152 1mm space (the JHU NIfTIs are
  # built in MNI152 and cvs_avg35_inMNI152 is too), so we skip
  # mri_coreg and just trust the xforms via --regheader. mri_coreg
  # would binarise the JHU label volume to a "brain mask" that is
  # white-matter-only and produce a distorted 12-DOF fit against
  # cvs's whole-brain mask, misaligning the regions.
  prep <- project_volume_anatomical(
    input_volume = input_volume,
    lut = lut_df,
    registration = NULL,
    target_subject = target_subject,
    id_offset = id_offset,
    # These are white-matter labels. The default guard protects cortex *and*
    # cerebral white matter from being overwritten, which is right for deep
    # grey structures but here deletes the atlas from the only tissue it
    # describes -- the right SLF vanished entirely. The cortical outline still
    # survives: the labels only reach where the projected probability clears
    # `threshold`, which is inside white matter, not out at the ribbon.
    protect_cortex = FALSE,
    output_file = here::here(
      "data-raw",
      paste0(atlas_name, "_anatomical.nii.gz")
    ),
    verbose = TRUE
  )

  # Pass the atlas's own labels only. project_volume_anatomical() returns a LUT
  # covering the whole merged volume -- the aparc+aseg cortex and deep-grey
  # labels it was projected into as well as the atlas's own -- and handing that
  # back would promote all of them to atlas regions rather than leaving them as
  # the anatomical backdrop they are meant to be.
  shifted_lut_path <- here::here(
    "data-raw",
    "metadata",
    paste0(atlas_name, "_lut_shifted.txt")
  )
  # Select the atlas's own ids exactly, not every id at or above the offset.
  # project_volume_anatomical() shifts the atlas to id_offset + its own indices
  # (201-248 here), but aparc+aseg occupies 251-255 and 1000+, so a `>=` filter
  # sweeps FreeSurfer's own labels back in.
  atlas_ids <- id_offset + as.integer(meta$idx)
  atlas_lut <- prep$lut[prep$lut$idx %in% atlas_ids, , drop = FALSE]
  stopifnot(
    "shifted LUT must cover every atlas label" = nrow(atlas_lut) == nrow(meta)
  )
  write_lut(atlas_lut, shifted_lut_path)

  # The volume the pipeline reads holds the aparc+aseg anatomy the atlas was
  # projected into as well as the atlas's own labels, and structures are
  # enumerated from the volume rather than the LUT. Name the atlas's own labels
  # as the focus so everything else stays grey anatomical context instead of
  # being promoted to an atlas region.
  focus <- paste0(
    "^(",
    paste(atlas_lut$label, collapse = "|"),
    ")$"
  )

  raw <- create_subcortical_from_volume(
    input_volume = prep$volume,
    input_lut = shifted_lut_path,
    atlas_name = atlas_name,
    slabs = jhu_views,
    context = list(focus = focus, match_on = "label"),
    output_dir = "data-raw",
    skip_existing = TRUE,
    cleanup = FALSE,
    verbose = TRUE
  )

  enrich_core(raw, meta_path)
}

# jhu_tracts is no longer built here. It is a tract atlas now, built from the
# probabilistic maps by data-raw/create-tract-atlas.R, which must run first;
# this script only assembles both atlases into R/sysdata.rda.
tracts_rds <- here::here("data-raw", "jhu_tracts_final.rds")
if (!file.exists(tracts_rds)) {
  cli::cli_abort(c(
    "Tract atlas not found: {.path {tracts_rds}}",
    "i" = "Run {.file data-raw/create-tract-atlas.R} first."
  ))
}
jhu_tracts <- readRDS(tracts_rds)

jhu_wm <- build_jhu_atlas(
  input_volume = here::here("data-raw", "JHU-ICBM-labels-1mm.nii.gz"),
  atlas_name = "jhu_wm",
  meta_path = here::here("data-raw", "metadata", "jhu_wm.tsv")
)

cli::cli_alert_success(
  "jhu_tracts: {length(ggseg.formats::atlas_labels(jhu_tracts))} tracts"
)
print(jhu_tracts)

cli::cli_alert_success(
  "jhu_wm: {length(ggseg.formats::atlas_labels(jhu_wm))} regions"
)
print(jhu_wm)

# ── Smooth and simplify ──────────────────────────────────────────────────
# Post-hoc, so retuning never means rerunning the pipeline. Smooth first, then
# simplify: smoothing interpolates vertices, so simplifying first would have
# its saving undone.
#
# The regions are solid volumetric parcels with no holes to lose, so
# morphological closing rounds them freely. The cortex outline is a thin
# ribbon whose sulci are enclosed holes, and closing fills any hole narrower
# than the smoothing distance -- so it gets "ksmooth", which low-pass filters
# the outline without dilating it. Stray specks left by volumetric projection
# are dropped first; the cortex is spared, since a thin ribbon's gyral
# cross-sections are legitimately small pieces rather than specks.
jhu_wm <- jhu_wm |>
  atlas_view_remove_small(
    min_area = 20,
    scope = "piece",
    exclude = "^cortex"
  ) |>
  atlas_smooth(
    keep = 1,
    smoothness = 0.8,
    method = "close",
    exclude = "^cortex"
  ) |>
  atlas_smooth(
    keep = 1,
    smoothness = 0.6,
    method = "ksmooth",
    labels = "^cortex"
  ) |>
  atlas_smooth(keep = 0.4, labels = "^cortex") |>
  atlas_smooth(keep = 0.2, exclude = "^cortex")

.jhu_tracts <- jhu_tracts
.jhu_wm <- jhu_wm
usethis::use_data(
  .jhu_tracts,
  .jhu_wm,
  overwrite = TRUE,
  compress = "xz",
  internal = TRUE
)
