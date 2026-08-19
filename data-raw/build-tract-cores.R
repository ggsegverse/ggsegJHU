# Build the JHU tract-core label volume from the probabilistic tract maps.
#
# FSL distributes the JHU white-matter tractography atlas in two forms. The
# maxprob volumes (JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz) are a
# winner-take-all projection: at every voxel only the single highest-probability
# tract survives, so tracts that share a corridor erode each other. The left
# SLF (temporal part) keeps just 76 voxels of a bundle spanning several
# centimetres, because the main SLF outcompetes it along their whole overlap.
# Fitting a centerline to what is left is meaningless.
#
# This script instead reads the 4D probabilistic stack
# (JHU-ICBM-tracts-prob-1mm.nii.gz, 20 volumes of 0-100% population overlap),
# thresholds each tract at a fraction of its own maximum so each is reduced to
# its dense core, and merges them highest-probability-wins. Thresholding
# per-tract rather than at a fixed percentage matters because the maxima differ
# more than two-fold across tracts (43% for the left hippocampal cingulum, 97%
# for the left SLF); a single absolute cut would erase the low-consensus
# bundles entirely.
#
# Data source: the FSL standard-space atlases, shipped in
# $FSLDIR/data/atlases/JHU/ and described at
# https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Atlases. The atlas itself is from
# Hua et al. (2008), NeuroImage 39(1):336-347.
#
# NOTE ON TRACT ORDER: FSL's tract order places the uncinate fasciculus
# (indices 17, 18) before the temporal part of the SLF (19, 20). An earlier
# version of data-raw/metadata/jhu_tracts.tsv had these swapped, which
# mislabelled both tracts. Verified against the volumes themselves: labels
# 17/18 sit at MNI (+/-35, +7, -15), the limen insulae, which is uncinate;
# 19/20 sit at (+/-43, -47, +4), posterior temporal, which is SLF-temporal.
#
# Volumes are not version-controlled (see .gitignore). Run:
#
#   Rscript data-raw/build-tract-cores.R    # -> jhu_tract_cores.nii.gz

library(RNifti)

prob_threshold <- as.numeric(Sys.getenv("JHU_THRESHOLD", "0.25"))

data_raw <- here::here("data-raw")
prob_file <- file.path(data_raw, "JHU-ICBM-tracts-prob-1mm.nii.gz")
meta_file <- file.path(data_raw, "metadata", "jhu_tracts.tsv")

if (!file.exists(prob_file)) {
  cli::cli_abort(c(
    "Probabilistic tract volume not found: {.path {prob_file}}",
    "i" = "Copy it from {.path $FSLDIR/data/atlases/JHU/}."
  ))
}

meta <- readr::read_tsv(meta_file, show_col_types = FALSE)
prob <- readNifti(prob_file)
dims <- dim(prob)

if (dims[4] != nrow(meta)) {
  cli::cli_abort(
    "Volume has {dims[4]} tracts but metadata describes {nrow(meta)}."
  )
}

merged <- array(0L, dim = dims[1:3])
best_prob <- array(0, dim = dims[1:3])
kept <- vector("list", nrow(meta))

for (i in seq_len(nrow(meta))) {
  # nolint next: commas_linter. air formats empty subscripts without spaces.
  tract <- prob[,,, i]
  peak <- max(tract)
  core <- tract >= prob_threshold * peak
  # Overlaps are resolved on each tract's probability *relative to its own
  # peak*, not on the raw value. Raw comparison hands every shared corridor to
  # whichever tract has the higher population consensus, which is a property of
  # how reliably the tract is reconstructed, not of whose fibres the voxel
  # holds. It costs the sub-bundles their whole existence: the temporal SLF
  # keeps 17% of its core against raw probability and 42% against relative.
  relative <- tract / peak
  wins <- core & relative > best_prob
  merged[wins] <- as.integer(meta$idx[i])
  best_prob[wins] <- relative[wins]
  retained <- sum(merged == meta$idx[i])
  kept[[i]] <- data.frame(
    idx = meta$idx[i],
    label = meta$label[i],
    hemi = meta$hemi[i],
    core = sum(core),
    retained = retained
  )
  cli::cli_alert_info(
    "{meta$label[i]} ({meta$hemi[i]}): core {sum(core)} voxels, \\
     retained {retained}"
  )
}

kept <- do.call(rbind, kept)
lost <- kept[kept$retained < 0.25 * kept$core, ]
if (nrow(lost) > 0) {
  cli::cli_warn(c(
    "Tracts losing >75% of their core to overlap:",
    stats::setNames(
      sprintf(
        "%s (%s): %d of %d",
        lost$label,
        lost$hemi,
        lost$retained,
        lost$core
      ),
      rep("!", nrow(lost))
    )
  ))
}

# Reference the 4D image, not a 3D slice of it. Subsetting returns a bare
# array carrying no header, so `asNifti()` would stamp the result with an
# identity xform and qform/sform code 0 -- and `mri_vol2vol --regheader`,
# having no spatial information to work from, resamples it clean outside the
# target brain.
out <- asNifti(merged, reference = prob)
writeNifti(
  out,
  file.path(data_raw, "jhu_tract_cores.nii.gz"),
  datatype = "int16"
)

cli::cli_alert_success(
  "Wrote {sum(merged > 0)} labelled voxels across \\
   {length(unique(merged[merged > 0]))} tracts (threshold {prob_threshold}) \\
   to {.path jhu_tract_cores.nii.gz}"
)
