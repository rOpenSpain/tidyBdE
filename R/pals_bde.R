#' BdE colour palettes
#'
#' Custom `ggplot2` theme based on the publications of BdE.
#'
#' @concept bde_plot
#'
#' @rdname bde_pals
#'
#' @export
#'
#' @param ... Further arguments of the functions.
#'
#' @seealso [theme_bde()]
#'
#' @examples
#'
#' scales::show_col(bde_vivid_pal()(6))
bde_vivid_pal <- function(...) {
  pal <- c("#4180C2", "#D86E7B", "#F89E63", "#5FBD6A", "#62C8D0", "#AC8771")
  return(scales::manual_pal(pal))
}

#' @rdname bde_pals
#' @export
bde_scale_colour_vivid <- function(...) {
  ggplot2::discrete_scale("colour", "bde", bde_vivid_pal(), ...)
}

#' @rdname bde_pals
#' @export
bde_scale_color_vivid <- function(...) {
  bde_scale_colour_vivid(...)
}

#' @rdname bde_pals
#' @export
bde_scale_fill_vivid <- function(...) {
  ggplot2::discrete_scale("fill", "bde", bde_vivid_pal(), ...)
}
