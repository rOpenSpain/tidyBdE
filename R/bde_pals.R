#' BdE color palettes
#'
#' Custom palettes based on the publications of BdE.
#'
#' @concept bde_plot
#'
#' @rdname bde_vivid_pal
#'
#' @return A palette of colors.
#'
#' @export
#'
#' @param ... Further arguments of the functions.
#'
#' @seealso [theme_bde()]
#'
#' @examples
#'
#' # BdE vivid pal
#' scales::show_col(bde_vivid_pal()(6), labels = FALSE)
#'
#' # BdE rose pal
#' scales::show_col(bde_rose_pal()(6), labels = FALSE)
bde_vivid_pal <- function(...) {
  pal <- c("#4180C2", "#D86E7B", "#F89E63", "#5FBD6A", "#62C8D0", "#AC8771")
  return(scales::manual_pal(pal))
}

#' @rdname bde_vivid_pal
#' @export
bde_rose_pal <- function(...) {
  pal <- c("#b7365c", "#cb6e8a", "#db9aad", "#0a50a1", "#5385bd", "#89AEDA")
  return(scales::manual_pal(pal))
}
