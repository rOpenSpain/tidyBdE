#' Database of selected Spanish macroeconomic indicators
#'
#' @description
#' Minimal metadata for selected Spanish macroeconomic indicators included in
#' the convenience functions of \CRANpkg{tidyBdE}. See [bde_indicators].
#' Full catalog metadata is available with [bde_catalog_load()].
#'
#' @details
#'
#' ```{r, echo=FALSE}
#' tb <- bde_ind_db
#' colnames(tb) <- paste0("**", colnames(tb), "**")
#' knitr::kable(tb)
#' ```
#'
#' @format
#' A [tibble][tibble::tbl_df] of `r nrow(bde_ind_db)` rows and
#' `r ncol(bde_ind_db)` columns with the following fields:
#'
#' \describe{
#'   \item{tidyBdE_fun}{Function name. See [bde_indicators].}
#'   \item{Numero_secuencial}{Sequential number. See [bde_series_load()].}
#'   \item{Descripcion_de_la_serie}{Description of the series in Spanish.}
#'   \item{Fecha_de_la_primera_observacion}{Starting date of the indicator.}
#'   \item{Fecha_de_la_ultima_observacion}{Most recent date available.}
#'   \item{Fuente}{Data source.}
#' }
#'
#' @family indicators
#'
#' @name bde_ind_db
#' @docType data
#'
#' @examples
#' data("bde_ind_db")
#' bde_ind_db
#'
#' @encoding UTF-8
NULL
