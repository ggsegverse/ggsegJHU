#' JHU White Matter Atlas
#'
#' Brain atlas for the JHU white matter tractography with 11 tracts
#' per hemisphere. Contains both 2D polygon geometry for
#' [ggseg::geom_brain()] and 3D mesh geometry for [ggseg3d::ggseg3d()].
#'
#' @docType data
#' @name jhu
#' @usage data(jhu)
#' @keywords datasets
#' @family ggseg_atlases
#'
#' @references Hua et al. (2008) Tract probability maps in stereotaxic spaces:
#' analysis of white matter anatomy and tract-specific quantification.
#' NeuroImage, 39(1):336-347
#' (\href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2724595/}{PubMed})
#'
#' @format A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @examples
#' data(jhu)
#' jhu
"jhu"
