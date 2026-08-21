#' JHU White Matter Tract Atlas
#'
#' JHU probabilistic white matter tract atlas with 20 tracts. Each tract is
#' reduced to a principal-curve centerline, drawn as a 3D tube for
#' [ggseg3d::ggseg3d()] and as a 2D projection over an anatomical silhouette.
#'
#' Tracts are built from the atlas's probabilistic maps rather than FSL's
#' distributed winner-take-all volume, in which tracts sharing a corridor
#' erode each other: the temporal part of the superior longitudinal
#' fasciculus survives there as 76 voxels of a bundle spanning several
#' centimetres. Left and right of a tract share a colour, since they are the
#' same anatomy.
#'
#' @family ggseg_atlases
#' @family tract_atlases
#'
#' @references Hua K, et al. (2008). Tract probability maps in
#'   stereotaxic spaces: analyses of white matter anatomy and
#'   tract-specific quantification. *NeuroImage*, 39(1):336-347.
#'   \doi{10.1016/j.neuroimage.2007.07.053}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (tract).
#' @export
#' @examples
#' jhu_tracts()
#' plot(jhu_tracts())
jhu_tracts <- function() .jhu_tracts
