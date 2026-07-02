#' Selected Spanish macroeconomic indicators
#'
#' @description
#' Retrieve selected Spanish macroeconomic indicators. Metadata is available in
#' [bde_ind_db].
#'
#' @inheritParams bde_series series_label
#' @inheritDotParams bde_series -series_code -series_csv
#'
#' @details
#' These functions are convenient wrappers for [bde_series_load()] that
#' retrieve specific series. Use `verbose = TRUE, extract_metadata = TRUE` to
#' inspect the metadata and source.
#'
#' @return A [tibble][tibble::tbl_df] with the requested indicator series.
#'
#' @inherit bde_catalogs source
#'
#' @inherit bde_series note
#'
#' @seealso [bde_series_load()] for loading arbitrary bulk CSV series and
#'   [bde_catalog_search()] for finding series in catalog metadata.
#'
#' @family indicators
#'
#' @rdname bde_indicators
#' @name bde_indicators
#'
#' @encoding UTF-8
#' @export
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
#' @encoding UTF-8
#' @export
bde_ind_unemployment_rate <- function(series_label = "Unemployment_Rate", ...) {
  bde_hlp_indicator("bde_ind_unemployment_rate", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_euribor_12m_monthly <- function(
  series_label = "Euribor_12M_Monthly",
  ...
) {
  bde_hlp_indicator("bde_ind_euribor_12m_monthly", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_euribor_12m_daily <- function(series_label = "Euribor_12M_Daily", ...) {
  bde_hlp_indicator("bde_ind_euribor_12m_daily", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_cpi_var <- function(series_label = "Consumer_price_index_YoY", ...) {
  bde_hlp_indicator("bde_ind_cpi_var", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_ibex_monthly <- function(series_label = "IBEX_index_month", ...) {
  bde_hlp_indicator("bde_ind_ibex_monthly", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_ibex_daily <- function(series_label = "IBEX_index_day", ...) {
  bde_hlp_indicator("bde_ind_ibex_daily", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_gdp_quarterly <- function(series_label = "GDP_quarterly_value", ...) {
  bde_hlp_indicator("bde_ind_gdp_quarterly", series_label, ...)
}

#' @rdname bde_indicators
#'
#' @encoding UTF-8
#' @export
bde_ind_population <- function(series_label = "Population_Spain", ...) {
  bde_hlp_indicator("bde_ind_population", series_label, ...)
}

#' @rdname bde_indicators
#' @usage NULL
#'
#' @encoding UTF-8
#' @export
bde_ind_ibex <- bde_ind_ibex_monthly

#' Load one indicator wrapper
#'
#' @param function_name Name used in `bde_ind_db$tidyBdE_fun`.
#' @param series_label Series label passed to [bde_series_load()].
#' @param ... Additional arguments passed to [bde_series_load()].
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @noRd
bde_hlp_indicator <- function(
  function_name,
  series_label,
  ...,
  .envir = parent.frame()
) {
  # Validate input arguments.
  bde_hlp_abort_if_not(
    "{.arg series_label} must be a {.cls character} vector." = is.character(
      series_label
    ),
    .envir = .envir
  )
  db <- tidyBdE::bde_ind_db
  seq_num <- db[db$tidyBdE_fun == function_name, "Numero_secuencial"]
  seq_num <- as.character(seq_num)

  econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind[!is.na(econom_ind[[2]]), ]
}
