#' Relevant Indicators of Spain
#'
#' @description
#' Set of helper functions for downloading some of the most relevant
#' macroeconomic indicators of Spain.
#'
#' @rdname bde_indicators
#'
#' @export
#'
#' @concept indicators
#'
#' @encoding UTF-8
#'
#' @inheritParams bde_series_load
#'
#' @inheritDotParams bde_series_load -series_code
#'
#' @seealso [bde_series_load()], [bde_catalog_search()]
#'
#' @details
#' This functions are convenient wrappers of [bde_series_load()] referencing
#' specific series. Use `verbose = TRUE/extract_metadata = TRUE` to see the
#' specification and the source.
#'
#' @examples
#' \donttest{
#' bde_ind_euribor_12m_monthly()
#' }
bde_ind_gdp_var <- function(series_label = "GDP_YoY", ...) {
  seq_num <- 3779313

  econom_ind <-
    bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  return(econom_ind)
}

#' @rdname bde_indicators
#'
#' @export
bde_ind_unemployment_rate <-
  function(series_label = "Unemployment_Rate", ...) {
    seq_num <- 2357793

    econom_ind <-
      bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    return(econom_ind)
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_euribor_12m_monthly <-
  function(series_label = "Euribor_12M_Monthly",
           ...) {
    seq_num <- 2737989

    econom_ind <-
      bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    return(econom_ind)
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_euribor_12m_daily <-
  function(series_label = "Euribor_12M_Daily", ...) {
    seq_num <- 905842

    econom_ind <-
      bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    return(econom_ind)
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_cpi_var <-
  function(series_label = "Consumer_price_index_YoY", ...) {
    seq_num <- 2973313

    econom_ind <-
      bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    return(econom_ind)
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_ibex <- function(series_label = "IBEX_index_month", ...) {
  seq_num <- 254433

  econom_ind <-
    bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  return(econom_ind)
}