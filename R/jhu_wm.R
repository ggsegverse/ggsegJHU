#' ICBM-DTI-81 White Matter Atlases
#'
#' White matter label atlases derived from the ICBM DTI-81
#' probabilistic atlas of 81 normal subjects.
#'
#' `jhu_wm()` provides the full 48-region atlas with both 2D and
#' 3D geometry. `icbm()` is a legacy variant with 3D geometry only.
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
jhu_wm <- function() .jhu_wm

#' @rdname jhu_wm
#' @export
#' @examples
#' icbm()
icbm <- function() .icbm
