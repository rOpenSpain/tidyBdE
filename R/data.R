#' Database of selected Spanish macroeconomic indicators
#'
#' @description
#' Minimal metadata for the selected Spanish macroeconomic indicators available
#' through the convenience functions in \CRANpkg{tidyBdE}. See
#' [indicator wrappers][bde_indicators].
#' Full catalog metadata is available with [bde_catalog_load()].
#'
#' @details
#'
#' ```{r, echo=FALSE}
#' tb <- tidyBdE::bde_ind_db
#' colnames(tb) <- paste0("**", colnames(tb), "**")
#' knitr::kable(tb)
#' ```
#'
#' @format
#' A [tibble][tibble::tbl_df] of `r nrow(tidyBdE::bde_ind_db)` rows and
#' `r ncol(tidyBdE::bde_ind_db)` columns with the following fields:
#'
#' \describe{
#'   \item{tidyBdE_fun}{Function name. See
#'     [indicator wrappers][bde_indicators].}
#'   \item{Numero_secuencial}{Sequential number. See [bde_series_load()].}
#'   \item{Nombre_de_la_serie}{API series code. See
#'     [API series functions][bde_series_api].}
#'   \item{Descripcion_de_la_serie}{Description of the series in Spanish.}
#'   \item{Fecha_de_la_primera_observacion}{Starting date of the indicator.}
#'   \item{Fecha_de_la_ultima_observacion}{Most recent date available.}
#'   \item{Fuente}{Data source.}
#' }
#'
#' @seealso `vignette("csv_manual", package = "tidyBdE")`.
#'
#' @family indicators
#'
#' @name bde_ind_db
#' @docType data
#'
#' @keywords datasets
#' @concept datasets
#'
#' @encoding UTF-8
#'
#' @examples
#' data("bde_ind_db")
#' bde_ind_db
NULL
