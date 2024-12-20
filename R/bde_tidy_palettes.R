#' BdE color palettes
#'
#' Custom palettes based on the publications of BdE. These are manual palettes
#' with a maximum of 6 colors.
#'
#' @family bde_plot
#'
#'
#' @return A vector of colors.
#'
#' @export
#' @param n The number of colors (`>= 1`) to be in the palette.
#' @param palette	A valid palette name.
#' @param alpha An alpha-transparency level in the range `[0,1]` (`0` means
#'   transparent and `1` means opaque). A missing, i.e., `alpha = NULL`, does
#'   not add opacity codes (`"FF"`) to the individual color hex codes. See
#'   [ggplot2::alpha()].
#' @param rev Logical indicating whether the ordering of the colors should be
#'   reversed.
#' @examples
#'
#' # BdE vivid pal
#' scales::show_col(bde_tidy_palettes(palette = "bde_vivid_pal"),
#'   labels = FALSE
#' )
#'
#' # BdE rose pal
#' scales::show_col(bde_tidy_palettes(palette = "bde_rose_pal"), labels = FALSE)
#'
#' # BdE qual pal
#' scales::show_col(bde_tidy_palettes(palette = "bde_qual_pal"), labels = FALSE)
bde_tidy_palettes <- function(n = 6,
                              palette = c(
                                "bde_vivid_pal", "bde_rose_pal",
                                "bde_qual_pal"
                              ),
                              alpha = NULL, rev = FALSE) {
  palette <- match.arg(palette)

  cols <- switch(palette,
    "bde_vivid_pal" = c(
      "#4180C2", "#D86E7B", "#F89E63",
      "#5FBD6A", "#62C8D0", "#AC8771"
    ),
    "bde_rose_pal" = c(
      "#b7365c", "#cb6e8a", "#db9aad",
      "#0a50a1", "#5385bd", "#89AEDA"
    ),
    "bde_qual_pal" = c(
      "#b55b4a", "#2e76bc", "#fece64",
      "#68be57", "#858788", "#f9b4af"
    )
  )

  n_col <- length(cols)
  if (n > n_col) {
    message(
      "tidyBdE> ", palette, " has ", n_col, ", requested ", n,
      ". Returning ", n_col, " colors."
    )

    n <- n_col
  }

  endcols <- cols[seq_len(n)]

  # Options
  if (rev) endcols <- rev(endcols)
  if (!is.null(alpha)) endcols <- ggplot2::alpha(endcols, alpha)

  endcols
}
