#' BdE color palettes
#'
#' @description
#' Manually defined palettes based on BdE publications. Each palette contains
#' at most six colors.
#'
#' @param n The number of colors to return. Must be at least `1`.
#' @param palette A palette name: `"bde_vivid_pal"`, `"bde_rose_pal"` or
#'   `"bde_qual_pal"`.
#' @param alpha Alpha transparency level in the range `[0, 1]`, where `0` is
#'   transparent and `1` is opaque. If `alpha = NULL`, the function does not
#'   append opacity codes (`"FF"`) to individual color hex codes. See
#'   [ggplot2::alpha()].
#' @param rev Logical. If `TRUE`, reverse the color order.
#'
#' @return A character vector of hex color codes.
#'
#' @family bde_plot
#'
#' @encoding UTF-8
#' @export
#'
#' @examples
#' # Show the BdE vivid palette.
#' scales::show_col(bde_tidy_palettes(palette = "bde_vivid_pal"),
#'   labels = FALSE
#' )
#'
#' # Show the BdE rose palette.
#' scales::show_col(bde_tidy_palettes(palette = "bde_rose_pal"),
#'   labels = FALSE
#' )
#'
#' # Show the BdE qualitative palette.
#' scales::show_col(bde_tidy_palettes(palette = "bde_qual_pal"),
#'   labels = FALSE
#' )
bde_tidy_palettes <- function(
  n = 6,
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE
) {
  # Validate input arguments.
  cli_abort_if_not(
    "{.arg n} must be a {.cls numeric} vector." = is.numeric(n),
    "{.arg n} must be greater than or equal to {.val 1}." = n >= 1,
    "{.arg alpha} must be a {.cls numeric} vector or {.val NULL}." = any(
      is.null(alpha),
      is.numeric(alpha)
    ),
    "{.arg alpha} must contain values between {.val 0} and {.val 1}." = any(
      is.null(alpha),
      all(alpha >= 0 & alpha <= 1)
    ),
    "{.arg rev} must be a {.cls logical} vector." = is.logical(rev)
  )
  palette <- match_arg_pretty(palette)

  cols <- switch(palette,
    "bde_vivid_pal" = c(
      "#4180C2",
      "#D86E7B",
      "#F89E63",
      "#5FBD6A",
      "#62C8D0",
      "#AC8771"
    ),
    "bde_rose_pal" = c(
      "#b7365c",
      "#cb6e8a",
      "#db9aad",
      "#0a50a1",
      "#5385bd",
      "#89AEDA"
    ),
    "bde_qual_pal" = c(
      "#b55b4a",
      "#2e76bc",
      "#fece64",
      "#68be57",
      "#858788",
      "#f9b4af"
    )
  )

  n_col <- length(cols)
  if (n > n_col) {
    cli::cli_alert_warning(paste0(
      "Palette {.str {palette}} contains {n_col} color{?s}; ",
      "{.arg n} requested {.val {n}}. Returning all {n_col} color{?s}."
    ))

    n <- n_col
  }

  endcols <- cols[seq_len(n)]

  # Apply palette options.
  if (rev) {
    endcols <- rev(endcols)
  }
  if (!is.null(alpha)) {
    endcols <- ggplot2::alpha(endcols, alpha)
  }

  endcols
}
