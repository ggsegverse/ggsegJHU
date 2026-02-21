#' JHU White Matter Tract Atlas
#'
#' Probabilistic white matter tract atlas based on the
#' Johns Hopkins University DTI-based tractography.
#'
#' @references Hua et al. (2008) Tract probability maps in stereotaxic spaces:
#'   analysis of white matter anatomy and tract-specific quantification.
#'   NeuroImage, 39(1):336-347
#'   \doi{10.1016/j.neuroimage.2007.07.053}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @import ggseg.formats
#' @export
#' @family ggseg_atlases
#' @examples
#' jhu()
jhu <- function() .jhu
