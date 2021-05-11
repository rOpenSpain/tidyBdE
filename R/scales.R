#' BdE scales for `ggplot2`.
#'
#' @description
#'
#' Scales to be used with the `ggplot2` package. Discrete palettes are named
#' as `scale_*_bde_d` while continuous palettes are named `scale_*_bde_c`.
#'
#' @seealso [bde_vivid_pal()]
#'
#' @concept bde_plot
#'
#' @export
#'
#' @rdname scales_bde
#'
#' @param palette Name of the BdE palette to apply. One of "bde_vivid_pal",
#'   "bde_rose_pal". See [bde_vivid_pal()] for details.
#'
#' @param ... Further arguments of [ggplot2::discrete_scale()] or
#'   [ggplot2::continuous_scale()]
#'
scale_color_bde_d <- function(palette = "bde_vivid_pal",
                              ...) {
  valid_pals <- c("bde_vivid_pal", "bde_rose_pal")

  if (!palette %in% valid_pals) {
    stop("palette should be one of: ", paste0(valid_pals, collapse = ", "))
  }

  cols <- switch(palette,
    "bde_vivid_pal" = bde_vivid_pal(),
    "bde_rose_pal" = bde_rose_pal()
  )
  ggplot2::discrete_scale(
    aesthetics = "color",
    scale_name = palette,
    palette = cols,
    ...
  )
}

#' @rdname scales_bde
#' @export
scale_fill_bde_d <- function(palette = "bde_vivid_pal",
                             ...) {
  valid_pals <- c("bde_vivid_pal", "bde_rose_pal")

  if (!palette %in% valid_pals) {
    stop("palette should be one of :", paste0(valid_pals, collapse = ", "))
  }

  cols <- switch(palette,
    "bde_vivid_pal" = bde_vivid_pal(),
    "bde_rose_pal" = bde_rose_pal()
  )
  ggplot2::discrete_scale(
    aesthetics = "fill",
    scale_name = palette,
    palette = cols,
    ...
  )
}


#' @rdname scales_bde
#' @export
scale_color_bde_c <- function(palette = "bde_vivid_pal",
                              ...) {
  valid_pals <- c("bde_vivid_pal", "bde_rose_pal")

  if (!palette %in% valid_pals) {
    stop("palette should be one of :", paste0(valid_pals, collapse = ", "))
  }

  cols <- switch(palette,
    "bde_vivid_pal" = bde_vivid_pal()(6),
    "bde_rose_pal" = c(bde_rose_pal()(6)[1:3], bde_rose_pal()(6)[6:4])
  )
  ggplot2::continuous_scale(
    aesthetics = "color",
    scale_name = palette,
    palette = scales::gradient_n_pal(cols),
    ...
  )
}

#' @rdname scales_bde
#' @export
scale_fill_bde_c <- function(palette = "bde_vivid_pal",
                             ...) {
  valid_pals <- c("bde_vivid_pal", "bde_rose_pal")

  if (!palette %in% valid_pals) {
    stop("palette should be one of :", paste0(valid_pals, collapse = ", "))
  }

  cols <- switch(palette,
    "bde_vivid_pal" = bde_vivid_pal()(6),
    "bde_rose_pal" = c(bde_rose_pal()(6)[1:3], bde_rose_pal()(6)[6:4])
  )
  ggplot2::continuous_scale(
    aesthetics = "fill",
    scale_name = palette,
    palette = scales::gradient_n_pal(cols),
    ...
  )
}
