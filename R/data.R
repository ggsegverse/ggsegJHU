#' JHU White Matter Tract Atlas
#'
#' JHU probabilistic white matter tract atlas with 20 tracts,
#' thresholded at 25% probability. Contains 3D mesh geometry
#' for [ggseg3d::ggseg3d()].
#'
#' @family ggseg_atlases
#' @family tract_atlases
#'
#' @references Hua K, et al. (2008). Tract probability maps in
#'   stereotaxic spaces: analyses of white matter anatomy and
#'   tract-specific quantification. *NeuroImage*, 39(1):336-347.
#'   \doi{10.1016/j.neuroimage.2007.07.053}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @export
#' @examples
#' jhu_tracts()
jhu_tracts <- function() .jhu_tracts

#' JHU ICBM-DTI-81 White Matter Labels
#'
#' ICBM-DTI-81 white matter labels atlas with 48 regions
#' derived from a probabilistic atlas of 81 normal subjects.
#' Contains 3D mesh geometry for [ggseg3d::ggseg3d()].
#'
#' @family ggseg_atlases
#' @family tract_atlases
#'
#' @references Mori S, et al. (2005). MRI Atlas of Human White
#'   Matter. Elsevier. ISBN: 978-0444517418
#'
#'   Wakana S, et al. (2007). Reproducibility of quantitative
#'   tractography methods applied to cerebral white matter.
#'   *NeuroImage*, 36(3):630-644.
#'   \doi{10.1016/j.neuroimage.2007.02.049}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @export
#' @examples
#' jhu_labels()
jhu_labels <- function() .jhu_labels

#' ICBM-DTI-81 White Matter Atlas
#'
#' Brain atlas for the ICBM DTI-81 white matter labels with 26
#' tracts. Contains 3D mesh geometry for [ggseg3d::ggseg3d()].
#' No 2D polygon geometry is available for this atlas.
#'
#' @family ggseg_atlases
#' @family tract_atlases
#'
#' @references Mori S, et al. (2005). MRI Atlas of Human White
#'   Matter. Elsevier. ISBN: 978-0444517418
#'
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @export
#' @examples
#' icbm()
icbm <- function() .icbm
