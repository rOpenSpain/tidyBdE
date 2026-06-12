#' Selected Spanish macroeconomic indicators
#'
#' @description
#' Convenience functions for downloading selected Spanish macroeconomic
#' indicators. Metadata is available in [bde_ind_db].
#'
#' @inheritParams bde_series_load
#' @inheritDotParams bde_series_load -series_code
#'
#' @details
#' These functions are convenient wrappers around [bde_series_load()] for
#' specific series. Use `verbose = TRUE, extract_metadata = TRUE` to inspect the
#' metadata and source.
#'
#' @return A [tibble][tibble::tbl_df] with the required series.
#'
#' @seealso [bde_series_load()], [bde_catalog_search()]
#'
#' @family indicators
#'
#' @rdname bde_indicators
#' @name bde_indicators
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' bde_ind_gdp_var()
#' }
bde_ind_gdp_var <- function(series_label = "GDP_YoY", ...) {
  bde_hlp_indicator("bde_ind_gdp_var", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_unemployment_rate <- function(series_label = "Unemployment_Rate", ...) {
  bde_hlp_indicator("bde_ind_unemployment_rate", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_euribor_12m_monthly <- function(
  series_label = "Euribor_12M_Monthly",
  ...
) {
  bde_hlp_indicator("bde_ind_euribor_12m_monthly", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_euribor_12m_daily <- function(series_label = "Euribor_12M_Daily", ...) {
  bde_hlp_indicator("bde_ind_euribor_12m_daily", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_cpi_var <- function(series_label = "Consumer_price_index_YoY", ...) {
  bde_hlp_indicator("bde_ind_cpi_var", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_ibex_monthly <- function(series_label = "IBEX_index_month", ...) {
  bde_hlp_indicator("bde_ind_ibex_monthly", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_ibex_daily <- function(series_label = "IBEX_index_day", ...) {
  bde_hlp_indicator("bde_ind_ibex_daily", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_gdp_quarterly <- function(series_label = "GDP_quarterly_value", ...) {
  bde_hlp_indicator("bde_ind_gdp_quarterly", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @export
#' @encoding UTF-8
bde_ind_population <- function(series_label = "Population_Spain", ...) {
  bde_hlp_indicator("bde_ind_population", series_label, ...)
}

#' @rdname bde_indicators
#' @usage NULL
#'
#' @export
#' @encoding UTF-8
bde_ind_ibex <- bde_ind_ibex_monthly

#' Load one indicator wrapper
#'
#' @param function_name Name used in `bde_ind_db$tidyBdE_fun`.
#' @param series_label Series label to pass to [bde_series_load()].
#' @param ... Additional arguments passed to [bde_series_load()].
#'
#' @noRd
bde_hlp_indicator <- function(function_name, series_label, ...) {
  db <- tidyBdE::bde_ind_db
  seq_num <- db[db$tidyBdE_fun == function_name, "Numero_secuencial"]
  seq_num <- as.character(seq_num)

  econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind[!is.na(econom_ind[[2]]), ]
}
