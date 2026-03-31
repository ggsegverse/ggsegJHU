#' JHU White Matter Tract Atlas
#'
#' JHU probabilistic white matter tract atlas with 20 tracts.
#'
#' @family ggseg_atlases
#' @family tract_atlases
#' @references Hua K, et al. (2008). Tract probability maps in stereotaxic
#'   spaces. *NeuroImage*, 39(1):336-347.
#'   \doi{10.1016/j.neuroimage.2007.07.053}
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @import ggseg.formats
#' @export
#' @examples
#' jhu_tracts()
#' plot(jhu_tracts())
jhu_tracts <- function() .jhu_tracts

#' JHU ICBM-DTI-81 White Matter Labels
#'
#' ICBM-DTI-81 white matter labels atlas with 48 regions.
#'
#' @family ggseg_atlases
#' @family tract_atlases
#' @references Mori S, et al. (2005). MRI Atlas of Human White Matter.
#'   Elsevier. ISBN: 978-0444517418
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @export
#' @examples
#' jhu_labels()
#' plot(jhu_labels())
jhu_labels <- function() .jhu_labels
