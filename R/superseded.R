#' BdE superseded palettes
#'
#' @description
#' `r lifecycle::badge('superseded')`
#'
#' These functions have been superseded, see [bde_tidy_palettes()] as a
#' replacement.
#'
#' Custom palettes based on the publications of BdE.
#'
#'
#' @return A palette of colors.
#'
#'
#' @param ... Further arguments of the functions.
#'
#' @name bde_vivid_pal
#' @rdname bde_pals
#'
#' @export
#' @keywords internal
#' @examples
#'
#' # BdE vivid pal
#' scales::show_col(bde_vivid_pal()(6), labels = FALSE)
#'
#' # BdE rose pal
#' scales::show_col(bde_rose_pal()(6), labels = FALSE)
bde_vivid_pal <- function(...) {
  if (requireNamespace("lifecycle", quietly = TRUE)) {
    lifecycle::deprecate_soft(
      "0.3.5", "bde_vivid_pal()",
      "bde_tidy_palettes()"
    )
  }

  pal <- c("#4180C2", "#D86E7B", "#F89E63", "#5FBD6A", "#62C8D0", "#AC8771")
  scales::manual_pal(pal)
}

#' @rdname bde_pals
#' @keywords internal
#' @export
bde_rose_pal <- function(...) {
  if (requireNamespace("lifecycle", quietly = TRUE)) {
    lifecycle::deprecate_soft(
      "0.3.5", "bde_rose_pal()",
      "bde_tidy_palettes()"
    )
  }
  pal <- c("#b7365c", "#cb6e8a", "#db9aad", "#0a50a1", "#5385bd", "#89AEDA")
  scales::manual_pal(pal)
}
