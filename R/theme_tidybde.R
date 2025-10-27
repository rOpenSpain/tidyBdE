#' BdE \CRANpkg{ggplot2} theme
#'
#' A custom \CRANpkg{ggplot2} theme based on the publications of BdE.
#'
#' @family bde_plot
#'
#' @export
#'
#' @return A \CRANpkg{ggplot2} [`theme()`][ggplot2::theme_classic()].
#'
#' @inheritDotParams ggplot2::theme_classic
#'
#' @seealso [ggplot2::theme_classic()]
#'
#' @details
#'
#' Theme based on [ggplot2::theme_classic()].
#'
#' @importFrom ggplot2 %+replace% rel margin
#' @examplesIf bde_check_access()
#' \donttest{
#' library(ggplot2)
#' library(dplyr)
#' library(tidyr)
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
#'     geom_line(linewidth = 0.8, color = bde_tidy_palettes(n = 1)) +
#'     labs(
#'       title = "Title",
#'       subtitle = "Some metric",
#'       caption = "Bank of Spain"
#'     ) +
#'     theme_tidybde()
#' }
#' }
#'
theme_tidybde <- function(...) {
  # nocov start
  ggplot2::theme_classic(...) %+replace%
    ggplot2::theme(
      line = element_line(linewidth = rel(0.5)),
      plot.background = element_rect(fill = "white", colour = NA),
      plot.margin = unit(rep(5.5, 4) * 3, "pt"),
      plot.title = element_text(
        margin = margin(b = 4),
        hjust = 0,
        vjust = 1,
        size = rel(1.1)
      ),
      plot.subtitle = element_text(
        hjust = 0,
        vjust = 1,
        size = rel(0.9),
        margin = margin(t = 4, b = 4)
      ),
      plot.caption = element_text(
        hjust = 1,
        vjust = 0,
        size = rel(.75)
      ),
      panel.background = element_rect(fill = "white", colour = NA),
      panel.grid.major.y = element_line(
        colour = "grey70",
        linetype = "dashed"
      ),
      axis.title = element_blank(),
      axis.ticks.length = unit(-2.75, "pt"),
      axis.text.x.bottom = element_text(
        margin = margin(t = 7.5, b = 5, unit = "pt"),
        size = rel(.9)
      ),
      axis.text.x.top = element_text(
        margin = margin(b = 7.5, t = 5, unit = "pt"),
        size = rel(.9)
      ),
      axis.text.y.left = element_text(
        hjust = 1,
        margin = margin(r = 7.5, l = 5, unit = "pt"),
        size = rel(.9)
      ),
      axis.text.y.right = element_text(
        hjust = 0,
        margin = margin(l = 7.5, r = 5, unit = "pt"),
        size = rel(.9)
      ),
      legend.position = "bottom",
      legend.justification = c(0, 0),
      legend.title.align = 0,
      legend.title = element_blank(),
      legend.key = element_blank(),
      legend.key.width = unit(25, "pt"),
      legend.text = element_text(size = rel(0.9))
    )
  # nocov end
}
