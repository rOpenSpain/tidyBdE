#' BdE scales for \CRANpkg{ggplot2}
#'
#' @description
#'
#' Scales to be used with the \CRANpkg{ggplot2} package. Discrete palettes are
#' named `scale_*_bde_d`, while continuous palettes are named `scale_*_bde_c`.
#'
#' @seealso [ggplot2::discrete_scale()], [ggplot2::continuous_scale()]
#'
#' @family bde_plot
#'
#' @export
#'
#' @return A \CRANpkg{ggplot2} color scale.
#'
#' @rdname scales_bde
#'
#' @name scales_bde
#'
#' @param palette Name of the BdE palette to apply. See [bde_tidy_palettes()]
#'   for details.
#'
#' @inheritParams bde_tidy_palettes
#' @inheritParams ggplot2::continuous_scale
#'
#' @param ... Further arguments of [ggplot2::discrete_scale()] or
#'   [ggplot2::continuous_scale()].
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
#'
#' ggplot(txsamp, aes(x = sales, y = median)) +
#'   geom_point(aes(colour = city)) +
#'   scale_color_bde_d("bde_qual_pal") +
#'   theme_minimal()
#'
scale_color_bde_d <- function(
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  ...
) {
  palette <- match.arg(palette)

  cols_v <- bde_tidy_palettes(palette = palette, alpha = alpha, rev = rev)
  pal <- scales::manual_pal(cols_v)

  ggplot2::discrete_scale(aesthetics = "color", palette = pal, ...)
}

#' @rdname scales_bde
#' @name scales_bde
#' @export
#' @usage NULL
scale_colour_bde_d <- scale_color_bde_d

#' @rdname scales_bde
#' @name scales_bde
#' @export
scale_fill_bde_d <- function(
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  ...
) {
  palette <- match.arg(palette)

  cols_v <- bde_tidy_palettes(palette = palette, alpha = alpha, rev = rev)
  pal <- scales::manual_pal(cols_v)

  ggplot2::discrete_scale(aesthetics = "fill", palette = pal, ...)
}


#' @rdname scales_bde
#' @name scales_bde
#' @export
scale_color_bde_c <- function(
  palette = c("bde_rose_pal", "bde_vivid_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  guide = "colorbar",
  ...
) {
  palette <- match.arg(palette)

  cols <- switch(palette,
    "bde_vivid_pal" = bde_tidy_palettes(
      6,
      "bde_vivid_pal",
      alpha = alpha,
      rev = rev
    ),
    "bde_qual_pal" = bde_tidy_palettes(
      6,
      "bde_qual_pal",
      alpha = alpha,
      rev = rev
    ),
    "bde_rose_pal" = bde_tidy_palettes(
      6,
      "bde_rose_pal",
      alpha = alpha,
      rev = rev
    )[c(1, 2, 3, 6, 5, 4)]
  )
  ggplot2::continuous_scale(
    aesthetics = "color",
    palette = scales::gradient_n_pal(cols),
    guide = guide,
    ...
  )
}

#' @rdname scales_bde
#' @name scales_bde
#' @export
#' @usage NULL
scale_colour_bde_c <- scale_color_bde_c

#' @rdname scales_bde
#' @name scales_bde
#' @export
scale_fill_bde_c <- function(
  palette = c("bde_rose_pal", "bde_vivid_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  guide = "colorbar",
  ...
) {
  palette <- match.arg(palette)

  cols <- switch(palette,
    "bde_vivid_pal" = bde_tidy_palettes(
      6,
      "bde_vivid_pal",
      alpha = alpha,
      rev = rev
    ),
    "bde_qual_pal" = bde_tidy_palettes(
      6,
      "bde_qual_pal",
      alpha = alpha,
      rev = rev
    ),
    "bde_rose_pal" = bde_tidy_palettes(
      6,
      "bde_rose_pal",
      alpha = alpha,
      rev = rev
    )[c(1, 2, 3, 6, 5, 4)]
  )

  ggplot2::continuous_scale(
    aesthetics = "fill",
    palette = scales::gradient_n_pal(cols),
    guide = guide,
    ...
  )
}
