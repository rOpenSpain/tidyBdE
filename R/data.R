#' Database of selected macroeconomic indicators
#'
#' @description
#' Minimal metadata of the selected macroeconomic indicators included in helper
#' functions of \CRANpkg{tidyBdE} (see [bde_indicators]). Full metadata can be
#' accessed via [bde_catalog_load()]
#'
#' @docType data
#'
#' @family indicators
#'
#' @encoding UTF-8
#'
#' @name bde_ind_db
#'
#' @format
#' A [tibble][tibble::tbl_df] of `r nrow(bde_ind_db)` rows and
#' `r ncol(bde_ind_db)` columns with the following fields:
#'
#' \describe{
#'   \item{tidyBdE_fun}{Function name, see [bde_indicators].}
#'   \item{Numero_secuencial}{Series code, see [bde_series_load()].}
#'   \item{Descripcion_de_la_serie}{Description of the series in Spanish.}
#'   \item{Fecha_de_la_primera_observacion}{Starting date of the indicator.}
#'   \item{Fecha_de_la_ultima_observacion}{Most recent date available.}
#'   \item{Fuente}{Data source.}
#' }
#'
#' @details
#'
#' ```{r child = "man/chunks/bde_ind_db_meta.Rmd"}
#' ```
#'
#' @examples
#' data("bde_ind_db")
#' bde_ind_db
#'
NULL
