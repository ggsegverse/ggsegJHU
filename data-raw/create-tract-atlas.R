# Create the JHU white-matter tract atlas for the ggseg ecosystem
#
# The 20 JHU tracts are built from their probabilistic maps rather than FSL's
# distributed winner-take-all volume -- see data-raw/build-tract-cores.R, which
# writes jhu_tract_cores.nii.gz. Each tract is then reduced to a
# principal-curve centerline and built into a proper tract atlas
# (type = "tract") with create_tract_from_volume(): a 3D tube per tract, and a
# 2D projection over the grey anatomical silhouette.
#
# Both the JHU volumes and FreeSurfer's cvs_avg35_inMNI152 subject are already
# in MNI152 1mm space, so the cores are resampled onto the aseg grid through
# the existing header xforms (--regheader). No registration is estimated: an
# intensity fit would have to run against a label volume that is white matter
# only, which mri_coreg binarises into a non-brain mask and misaligns.
#
# Source: JHU white-matter tractography atlas, distributed with FSL in
#   $FSLDIR/data/atlases/JHU/ (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Atlases).
#   The source volumes are not version-controlled; see build-tract-cores.R.
# Reference: Hua K, et al. (2008). "Tract probability maps in stereotaxic
#   spaces: analyses of white matter anatomy and tract-specific
#   quantification." NeuroImage, 39(1), 336-347.
#   <doi:10.1016/j.neuroimage.2007.07.053>
#
# Requires: ggseg.extra, ggseg.formats, RNifti, FreeSurfer 7.4.1 with
#   cvs_avg35_inMNI152.
#
# Run with: Rscript data-raw/create-tract-atlas.R

library(dplyr)
library(ggseg.extra)
library(ggseg.formats)

future::plan(future::sequential)
progressr::handlers("cli")
progressr::handlers(global = TRUE)

data_raw <- here::here("data-raw")
cores_file <- file.path(data_raw, "jhu_tract_cores.nii.gz")
meta_file <- file.path(data_raw, "metadata", "jhu_tracts.tsv")
if (!file.exists(cores_file)) {
  cli::cli_abort(c(
    "Tract cores not found: {.path {cores_file}}",
    "i" = "Run {.file data-raw/build-tract-cores.R} first."
  ))
}

fs_home <- Sys.getenv("FREESURFER_HOME", "/Applications/freesurfer/7.4.1")
Sys.setenv(FREESURFER_HOME = fs_home)
subject_mri <- file.path(
  fs_home,
  "subjects",
  "cvs_avg35_inMNI152",
  "mri"
)
aseg_mgz <- file.path(subject_mri, "aseg.mgz")

meta <- readr::read_tsv(meta_file, show_col_types = FALSE)

# ── Tract colour table ───────────────────────────────────────────────────
# FSL ships no colour lookup table for the JHU atlas, so the palette is ours
# to choose. Colour is assigned per tract *family*, with left and right
# sharing a hue: the hemispheres of one bundle are the same anatomy, and
# giving them separate colours implies a distinction that does not exist.
# That yields 10 hues for 20 tracts. Colouring by the coarser `group`
# (projection/association/limbic/commissure) instead, as earlier releases did,
# left only four colours and made distinct tracts indistinguishable.
families <- unique(meta$label)
family_colours <- setNames(
  grDevices::hcl.colors(length(families), palette = "Dark 3"),
  families
)
tract_lut <- data.frame(
  idx = as.integer(meta$idx),
  label = ifelse(
    meta$hemi == "midline",
    meta$label,
    paste0(substr(meta$hemi, 1, 1), "h_", meta$label)
  ),
  stringsAsFactors = FALSE
)
rgb_mat <- grDevices::col2rgb(family_colours[meta$label])
tract_lut$R <- as.integer(rgb_mat["red", ])
tract_lut$G <- as.integer(rgb_mat["green", ])
tract_lut$B <- as.integer(rgb_mat["blue", ])
tract_lut$A <- 0L
cli::cli_alert_info("Tracts: {nrow(tract_lut)} in {length(families)} families")

# ── Resample the tract cores onto the anatomical grid ────────────────────
# create_tract_from_volume() expects the label volume and the anatomical
# reference to share a space. Nearest-neighbour: a label volume must not be
# interpolated.
cli::cli_h1("Resampling tract cores onto cvs_avg35_inMNI152")
cores_resampled <- file.path(data_raw, "jhu_tract_cores_resampled.nii.gz")
if (!file.exists(cores_resampled)) {
  status <- system2(
    file.path(fs_home, "bin", "mri_vol2vol"),
    c(
      "--mov",
      cores_file,
      "--targ",
      aseg_mgz,
      "--regheader",
      "--nearest",
      "--o",
      cores_resampled
    )
  )
  if (status != 0 || !file.exists(cores_resampled)) {
    cli::cli_abort("mri_vol2vol failed (status {status}).")
  }
}

# ── Projection slabs at fixed anatomical positions ───────────────────────
# Slice positions are given in RAS millimetres so they are anatomically
# meaningful and independent of the template's voxel grid, and each slab spans
# +/- slab_halfwidth slices around its midpoint. Positions were chosen from
# where the tracts actually are: the superior axial cut crosses the SLF and
# the corona radiata, the middle one the forceps and thalamic radiations, the
# inferior one the uncinate and the inferior temporal bundles; the coronal cut
# catches the corticospinal tract at the internal capsule; and the sagittal
# cut sits lateral enough to slice the association bundles along their length
# rather than across it.
slab_halfwidth <- 8L
slice_mm <- data.frame(
  name = c(
    "superior_axial",
    "mid_axial",
    "inferior_axial",
    "coronal",
    "sagittal"
  ),
  type = c("axial", "axial", "axial", "coronal", "sagittal"),
  mm = c(30, 8, -14, -18, -30),
  stringsAsFactors = FALSE
)

# RAS millimetres -> index along the corresponding axis of the RAS+ reoriented
# volume. Derived from the template's own affine rather than hard-coded, so it
# stays correct if the reference volume changes.
ras_mm_to_index <- function(vox2ras, dims, ras_axis, mm) {
  native_axis <- which.max(abs(vox2ras[ras_axis, 1:3]))
  scale <- vox2ras[ras_axis, native_axis]
  native <- (mm - vox2ras[ras_axis, 4]) / scale
  index <- if (scale > 0) native else dims[native_axis] - 1 - native
  as.integer(round(index)) + 1L
}

aseg_vox2ras <- freesurferformats::mghheader.vox2ras(
  freesurferformats::read.fs.mgh(aseg_mgz, with_header = TRUE)$header
)
aseg_dims <- rep(256L, 3L)
ras_axis <- c(axial = 3L, coronal = 2L, sagittal = 1L)

slice_mm$mid <- mapply(
  function(type, mm) {
    ras_mm_to_index(aseg_vox2ras, aseg_dims, ras_axis[[type]], mm)
  },
  slice_mm$type,
  slice_mm$mm
)

tract_slabs <- data.frame(
  name = slice_mm$name,
  type = slice_mm$type,
  start = slice_mm$mid - slab_halfwidth,
  end = slice_mm$mid + slab_halfwidth,
  stringsAsFactors = FALSE
)
print(tract_slabs)

# ── Fit a centerline per tract and build the tract atlas ─────────────────
cli::cli_h1("Fitting tract centerlines")
rebuild <- !identical(Sys.getenv("JHU_REBUILD", ""), "")
if (rebuild) {
  unlink(file.path(data_raw, "jhu_tracts"), recursive = TRUE)
}
jhu_tracts <- create_tract_from_volume(
  input_volume = cores_resampled,
  input_lut = tract_lut,
  input_aseg = aseg_mgz,
  atlas_name = "jhu_tracts",
  output_dir = data_raw,
  slabs = tract_slabs,
  skip_existing = !rebuild,
  cleanup = FALSE
)

stopifnot("jhu_tracts must be a tract atlas" = is_tract_atlas(jhu_tracts))

# Views come back alphabetically; order them superior -> inferior, then the
# other planes, so the panels read anatomically.
jhu_tracts <- atlas_view_reorder(jhu_tracts, slice_mm$name)

# Cache the unsmoothed atlas so smoothing can be retuned without rebuilding.
saveRDS(jhu_tracts, file.path(data_raw, "jhu_tracts_unsmoothed.rds"))

# ── Smooth and simplify ──────────────────────────────────────────────────
# Post-hoc, so retuning never means rerunning the pipeline. Smooth first, then
# simplify: smoothing interpolates vertices, so simplifying first would just
# have its saving undone.
#
# The two structures want different smoothing. Tracts are solid centerline
# tubes with no holes to lose, so morphological closing rounds them freely.
# The cortex is a thin ribbon whose sulci are enclosed holes, and closing
# fills any hole narrower than the smoothing distance -- so it gets
# "ksmooth", which low-pass filters the outline without dilating it.
# Volumetric projection leaves stray specks detached from their tract; those
# are dropped first. The cortex is spared: a thin ribbon's gyral
# cross-sections are legitimately small pieces, not specks.
jhu_tracts <- jhu_tracts |>
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

# ── Choose which tracts each view draws ────────────────────────
# A slab catches a passing tract in cross-section as readily as along its
# length, so most tracts leave a sliver in most views -- which leaves every
# panel cluttered and every tract drawn several times over.
jhu_tracts <- atlas_view_select(jhu_tracts, threshold = 0.3)

cli::cli_alert_success("jhu_tracts: {length(atlas_labels(jhu_tracts))} tracts")
print(jhu_tracts)

saveRDS(jhu_tracts, file.path(data_raw, "jhu_tracts_final.rds"))
