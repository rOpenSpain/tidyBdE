#' BdE `ggplot2` theme
#'
#' A custom `ggplot2` theme based on the publications of BdE.
#'
#' @concept bde_plot
#'
#' @export
#'
#' @return A [`ggplot2::theme()`].
#'
#' @param ... Ignored.
#'
#' @seealso [`ggplot2::theme()`]
#'
#' @examples
#' \donttest{
#' library(tidyverse)
#'
#' series_TC <- bde_series_full_load("TC_1_1.csv")
#'
#' # If download was OK then plot
#' if (nrow(series_TC) > 0) {
#'   series_TC <- series_TC[c(1, 2)]
#'
#'   series_TC_pivot <- series_TC %>%
#'     filter(
#'       Date >= "2020-01-01" & Date <= "2020-12-31",
#'       !is.na(series_TC[[2]])
#'     )
#'
#'   names(series_TC_pivot) <- c("x", "y")
#'
#'   ggplot(series_TC_pivot, aes(x = x, y = y)) +
#'     geom_line(size = 0.8, color = bde_vivid_pal()(1)) +
#'     labs(
#'       title = "Title",
#'       subtitle = "Some metric",
#'       caption = "Bank of Spain"
#'     ) +
#'     theme_bde()
#' }
#' }
#'
theme_bde <- function(...) {
  # nocov start
  ggplot2::theme_classic() +
    ggplot2::theme(
      plot.background = element_rect(fill = NA),
      plot.margin = unit(rep(10, 4), "pt"),
      panel.background = element_rect(fill = NA),
      panel.grid.major.y = element_line(
        colour = "grey70",
        linetype = "dashed"
      ),
      axis.title = element_blank(),
      axis.ticks.length = unit(-3, "pt"),
      axis.text.x.bottom = element_text(
        size = 8,
        margin = unit(c(10, 5, 0, 5), "pt")
      ),
      axis.text.x.top = element_text(
        size = 8,
        margin = unit(c(0, 5, 10, 5), "pt")
      ),
      axis.text.y.left = element_text(
        size = 8,
        margin = unit(c(5, 10, 5, 0), "pt")
      ),
      axis.text.y.right = element_text(
        size = 8,
        margin = unit(c(5, 0, 5, 10), "pt")
      ),
      legend.position = "bottom",
      legend.justification = c(0, 0),
      legend.title = element_blank(),
      legend.key = element_blank(),
      legend.key.width = unit(25, "pt"),
      legend.text = element_text(size = 9),
      plot.title = element_text(size = 12, margin = unit(c(rep(
        5, 4
      )), "pt")),
      plot.subtitle = element_text(size = 8, margin = unit(c(rep(
        5, 4
      )), "pt")),
      plot.caption = element_text(size = 8, margin = unit(c(rep(
        8, 4
      )), "pt"))
    )
  # nocov end
}
