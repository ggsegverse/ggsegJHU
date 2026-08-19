# ggsegJHU 3.0.0

## Breaking changes

- `jhu_tracts()` is now a **tract** atlas (`atlas_type()` returns `"tract"`,
  and the object is a `tract_atlas`) rather than a subcortical one. Each
  tract carries a principal-curve centerline, drawn as a 3D tube for
  `ggseg3d()` and as a 2D projection over an anatomical silhouette. Code
  that dispatched on `subcortical_atlas` will no longer match it.
- **The uncinate fasciculus and the temporal part of the superior
  longitudinal fasciculus were swapped in previous releases.** FSL orders the
  uncinate (volume indices 17, 18) before the temporal SLF (19, 20), and the
  metadata assumed the reverse, so both tracts carried the other's name.
  Verified against the volumes: labels 17/18 sit at MNI (±35, +7, −15), the
  limen insulae, which is uncinate; 19/20 at (±43, −47, +4), posterior
  temporal, which is SLF-temporal. Any analysis that selected `uncf` or
  `sltf` from an earlier release selected the wrong tract.

## Pipeline improvements

- Tracts are now built from JHU's **probabilistic** maps rather than the
  distributed `maxprob-thr25` volume. That volume keeps only the single
  highest-probability tract at each voxel, so tracts sharing a corridor erode
  each other: the left temporal SLF survived as 76 voxels of a bundle
  spanning several centimetres, far too little to fit a meaningful
  centerline. Each tract is now thresholded at 25% of its own maximum and
  merged, raising the labelled volume roughly four-fold.
- Overlaps are resolved on each tract's probability **relative to its own
  peak** rather than on the raw value. JHU's per-tract maxima range from 43%
  to 97%, and raw comparison hands every shared corridor to whichever tract
  is more reliably reconstructed rather than to whichever the voxel belongs
  to. Worst-case retention rises from 17% to 37% of a tract's core, and the
  total labelled volume is unchanged — only the assignment differs.
- 2D projections are taken at five fixed anatomical positions, specified in
  RAS millimetres rather than voxel indices so they stay correct if the
  reference volume changes: axial at +30, +8 and −14 mm, coronal at −18 mm
  and sagittal at −30 mm, each projected over a ±8-slice slab. Tracts are
  projections through the slab; the silhouette framing them is a true slice,
  taken from wherever in the slab holds the most cortex.
- Each view draws only the tracts substantially represented in it, rather
  than every tract that happens to intersect the slab, which left each panel
  cluttered and each tract repeated. Left and right stay together, and every
  tract is drawn in at least one view.
- Tracts are coloured per bundle, with left and right sharing a hue, giving
  10 distinguishable colours. Earlier releases coloured by the coarser
  `group` (projection/association/limbic/commissure), leaving only four
  colours for 20 tracts. FSL ships no colour table for this atlas, so the
  palette is chosen rather than inherited.

## `jhu_wm()`

`jhu_wm()` stays a subcortical atlas — the ICBM-DTI-81 labels are white-matter
_parcels_ rather than pathways — but its build was broken and is repaired:

- **The right superior longitudinal fasciculus was missing entirely**, and the
  other 47 regions were eroded. The labels were projected with
  `protect_cortex = TRUE`, which shields cortex _and cerebral white matter_
  from being overwritten. That guard suits the deep grey structures the
  subcortical pipeline was built around, and is exactly wrong here: it
  protected a white-matter atlas out of the only tissue it describes. The
  projection now runs with the guard off, and all 48 regions survive.
- Regions are coloured per structure, with left and right sharing a hue, for
  27 distinguishable colours. Previously all 48 shared five `group` colours.
- The FreeSurfer anatomy the labels are projected into is now correctly kept
  as grey context rather than promoted into the atlas. It had been leaking
  into `core` and the palette, so `atlas_regions()` reported cortical parcels
  as though they were JHU white-matter labels.
- The sagittal views read properly. A sagittal cut runs along the cortical
  ribbon rather than across it, so the thin slabs used for axial and coronal
  caught the ribbon only where it happened to sit in-plane and broke the
  outline into fragments; the sagittal slabs are now wider. The silhouette
  itself is a single slice, so widening alone could not fill it — `ggseg.extra`
  now picks that slice by cortex content, which moves the mid-sagittal
  reference off the interhemispheric fissure (x=134 rather than 128) and cuts
  the medial wall as a ribbon instead of grazing it.
- Region outlines are smoothed, and pieces below 20 px² are dropped, so the
  parcels read as shapes rather than as rasterised voxel staircases.
- The build script no longer aborts against current `ggseg.extra`: it used
  `project_volume_anatomical()`'s removed `output_file` return field, plus the
  deprecated `views` argument and `write_ctab()`.

# ggsegJHU 2.1.0

## Breaking changes

- `icbm()` has been removed. It was a legacy variant of the
  ICBM-DTI-81 white matter atlas with no 2D geometry, undivided
  hemispheres, and no `group` column. Use `jhu_wm()` instead, which
  covers the same anatomy with both 2D and 3D geometry.
- `jhu_labels()` (introduced in 2.0.0) is now `jhu_wm()`.

## Pipeline improvements

- Both atlases are now resampled onto the FreeSurfer
  `cvs_avg35_inMNI152` `aparc+aseg` grid before the 2D pipeline
  runs. The JHU NIfTIs and `cvs_avg35_inMNI152` are both already in
  MNI152 1mm space, so resampling uses the existing xforms via
  `--regheader` (no `mri_coreg` step, which would binarise the
  white-matter labels into a non-brain mask and distort the fit).
  This produces:
  - smoother region boundaries (trilinear resampling + argmax
    replaces the voxel-grid jaggedness of the raw 1mm masks);
  - a true cortical-reference outline behind the white-matter
    regions on every 2D slice, anatomically aligned with the
    labels.
- Custom view ranges replace the default subcortical views so
  brainstem and lateral structures are not clipped.
- The `core` table now carries a `group` column for both atlases.

# ggsegJHU 2.0.0

## Breaking changes

- `jhu` and `jhu_3d` data objects have been removed
- Use `jhu_tracts()` and `jhu_wm()` accessor functions instead
- `ggseg.formats` is now a hard dependency

## Minor changes

- Added `icbm()` atlas (formerly in `ggsegICBM` package)
- Package URLs updated to `ggsegverse` GitHub organisation

# ggsegJHU 1.0.01

- Adapted atlases to ggseg <= 1.6.0
