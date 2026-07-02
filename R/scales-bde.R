#' BdE color scales
#'
#' @description
#' Color scales for \CRANpkg{ggplot2}. Discrete scales are named
#' `scale_*_bde_d`; continuous scales are named `scale_*_bde_c`.
#'
#' @param palette A BdE palette to apply. See [bde_tidy_palettes()] for details.
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::continuous_scale()].
#' @inheritParams bde_tidy_palettes alpha rev
#' @inheritParams ggplot2::continuous_scale
#'
#' @return A \CRANpkg{ggplot2} scale object.
#'
#' @seealso [ggplot2::discrete_scale()] and [ggplot2::continuous_scale()] for
#'   the underlying scale constructors.
#'
#' @family bde_plot
#'
#' @rdname scales_bde
#' @name scales_bde
#'
#' @encoding UTF-8
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' set.seed(596)
#' txsamp <- subset(
#'   txhousing,
#'   city %in% c(
#'     "Houston", "Fort Worth",
#'     "San Antonio", "Dallas", "Austin"
#'   )
#' )
#'
#' ggplot(txsamp, aes(x = sales, y = median)) +
#'   geom_point(aes(colour = city)) +
#'   scale_color_bde_d() +
#'   theme_minimal()
#'
#' ggplot(txsamp, aes(x = sales, y = median)) +
#'   geom_point(aes(colour = city)) +
#'   scale_color_bde_d("bde_qual_pal") +
#'   theme_minimal()
scale_color_bde_d <- function(
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  ...
) {
  palette <- match_arg_pretty(palette)
  bde_scale_bde_d(
    aesthetics = "color",
    palette = palette,
    alpha = alpha,
    rev = rev,
    ...
  )
}

#' @rdname scales_bde
#' @usage NULL
#'
#' @encoding UTF-8
#' @export
scale_colour_bde_d <- scale_color_bde_d

#' @rdname scales_bde
#'
#' @encoding UTF-8
#' @export
scale_fill_bde_d <- function(
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  ...
) {
  palette <- match_arg_pretty(palette)
  bde_scale_bde_d(
    aesthetics = "fill",
    palette = palette,
    alpha = alpha,
    rev = rev,
    ...
  )
}

#' @rdname scales_bde
#'
#' @encoding UTF-8
#' @export
scale_color_bde_c <- function(
  palette = c("bde_rose_pal", "bde_vivid_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  guide = "colorbar",
  ...
) {
  palette <- match_arg_pretty(palette)
  bde_scale_bde_c(
    aesthetics = "color",
    palette = palette,
    alpha = alpha,
    rev = rev,
    guide = guide,
    ...
  )
}

#' @rdname scales_bde
#' @usage NULL
#'
#' @encoding UTF-8
#' @export
scale_colour_bde_c <- scale_color_bde_c

#' @rdname scales_bde
#'
#' @encoding UTF-8
#' @export
scale_fill_bde_c <- function(
  palette = c("bde_rose_pal", "bde_vivid_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  guide = "colorbar",
  ...
) {
  palette <- match_arg_pretty(palette)
  bde_scale_bde_c(
    aesthetics = "fill",
    palette = palette,
    alpha = alpha,
    rev = rev,
    guide = guide,
    ...
  )
}

#' Build a discrete BdE scale
#'
#' @param aesthetics Scale aesthetics to map.
#' @param palette BdE palette to apply.
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()].
#' @param .envir Environment to evaluate the glue expressions in.
#' @inheritParams bde_tidy_palettes alpha rev
#'
#' @noRd
bde_scale_bde_d <- function(
  aesthetics,
  palette,
  alpha,
  rev,
  ...,
  .envir = parent.frame()
) {
  # Validate input arguments.
  bde_hlp_abort_if_not(
    "{.arg alpha} must be a {.cls numeric} vector or {.val NULL}." = any(
      is.null(alpha),
      is.numeric(alpha)
    ),
    "{.arg alpha} must contain values between {.val 0} and {.val 1}." = any(
      is.null(alpha),
      all(alpha >= 0 & alpha <= 1)
    ),
    "{.arg rev} must be a {.cls logical} vector." = is.logical(rev),
    .envir = .envir
  )

  cols <- bde_tidy_palettes(palette = palette, alpha = alpha, rev = rev)
  ggplot2::discrete_scale(
    aesthetics = aesthetics,
    palette = scales::manual_pal(cols),
    ...
  )
}

#' Build a continuous BdE scale
#'
#' @param aesthetics Scale aesthetics to map.
#' @param palette BdE palette to apply.
#' @param ... Additional arguments passed to [ggplot2::continuous_scale()].
#' @param .envir Environment to evaluate the glue expressions in.
#' @inheritParams bde_tidy_palettes alpha rev
#' @inheritParams ggplot2::continuous_scale
#'
#' @noRd
bde_scale_bde_c <- function(
  aesthetics,
  palette,
  alpha,
  rev,
  guide,
  ...,
  .envir = parent.frame()
) {
  # Validate input arguments.
  bde_hlp_abort_if_not(
    "{.arg alpha} must be a {.cls numeric} vector or {.val NULL}." = any(
      is.null(alpha),
      is.numeric(alpha)
    ),
    "{.arg alpha} must contain values between {.val 0} and {.val 1}." = any(
      is.null(alpha),
      all(alpha >= 0 & alpha <= 1)
    ),
    "{.arg rev} must be a {.cls logical} vector." = is.logical(rev),
    "{.arg guide} must be a {.cls character} vector." = is.character(guide),
    .envir = .envir
  )

  cols <- bde_scale_bde_c_cols(palette, alpha = alpha, rev = rev)
  ggplot2::continuous_scale(
    aesthetics = aesthetics,
    palette = scales::gradient_n_pal(cols),
    guide = guide,
    ...
  )
}

#' Return colors for continuous BdE scales
#'
#' @param palette BdE palette to apply.
#' @inheritParams bde_tidy_palettes alpha rev
#'
#' @noRd
bde_scale_bde_c_cols <- function(palette, alpha, rev) {
  cols <- bde_tidy_palettes(6, palette, alpha = alpha, rev = rev)
  if (palette == "bde_rose_pal") {
    cols <- cols[c(1, 2, 3, 6, 5, 4)]
  }
  cols
}
