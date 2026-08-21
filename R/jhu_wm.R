#' ICBM-DTI-81 White Matter Atlas
#'
#' White matter label atlas derived from the ICBM DTI-81
#' probabilistic atlas of 81 normal subjects, with 48 regions
#' projected onto the FreeSurfer `cvs_avg35_inMNI152` anatomical
#' grid for cortical-reference context and smoother boundaries.
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
#' jhu_wm()
#' plot(jhu_wm())
jhu_wm <- function() .jhu_wm
