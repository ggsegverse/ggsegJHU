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
