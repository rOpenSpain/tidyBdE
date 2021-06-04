#' @title Scales for `ggplot2`
#'
#' @description
#' `r lifecycle::badge("deprecated")`. These scales are deprecated in favor of
#' [scale_color_bde_d()] and similar functions, in order to align the naming
#' with the current practices (see [ggplot2::scale_fill_viridis_c()]) and
#' similar functions).
#'
#' @rdname deprecated_scales
#' @keywords internal
#'
#' @param ... Ignored
#'
#' @export
bde_scale_colour_vivid <- function(...) {
  lifecycle::deprecate_stop("0.1.0.9000", "bde_scale_colour_vivid()", "scale_color_bde_d()")
}

#' @rdname deprecated_scales
#' @keywords internal
#'
#' @export
bde_scale_color_vivid <- function(...) {
  lifecycle::deprecate_stop("0.1.0.9000", "bde_scale_color_vivid()", "scale_color_bde_d()")
}


#' @rdname deprecated_scales
#' @keywords internal
#'
#' @export
bde_scale_fill_vivid <- function(...) {
  lifecycle::deprecate_stop("0.1.0.9000", "bde_scale_fill_vivid()", "scale_fill_bde_d()")
}


#' @rdname deprecated_scales
#' @keywords internal
#'
#' @export
bde_scale_colour_rose <- function(...) {
  lifecycle::deprecate_stop("0.1.0.9000", "bde_scale_colour_rose()", "scale_color_bde_d()")
}

#' @rdname deprecated_scales
#' @keywords internal
#'
#' @export
bde_scale_color_rose <- function(...) {
  lifecycle::deprecate_stop("0.1.0.9000", "bde_scale_color_rose()", "scale_color_bde_d()")
}

#' @rdname deprecated_scales
#' @keywords internal
#'
#' @export
bde_scale_fill_rose <- function(...) {
  lifecycle::deprecate_stop("0.1.0.9000", "bde_scale_fill_rose()", "scale_fill_bde_d()")
}
