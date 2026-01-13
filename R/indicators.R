#' Relevant Indicators of Spain
#'
#' @description
#' Set of helper functions for downloading some of the most relevant
#' macroeconomic indicators of Spain. Metadata available in [bde_ind_db].
#'
#' @rdname bde_indicators
#' @name bde_indicators
#'
#' @export
#'
#' @family indicators
#'
#' @encoding UTF-8
#'
#' @inheritParams bde_series_load
#'
#' @inheritDotParams bde_series_load -series_code
#'
#' @return A [tibble][tibble::tbl_df] with the required series.
#'
#' @seealso [bde_series_load()], [bde_catalog_search()]
#'
#' @details
#' These functions are convenient wrappers around [bde_series_load()] for
#' specific series. Use `verbose = TRUE, extract_metadata = TRUE` to see the
#' specification and the source.
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' bde_ind_gdp_var()
#' }
bde_ind_gdp_var <- function(series_label = "GDP_YoY", ...) {
  db <- tidyBdE::bde_ind_db
  seq_num <- db[db$tidyBdE_fun == "bde_ind_gdp_var", "Numero_secuencial"]
  seq_num <- as.character(seq_num)

  econom_ind <-
    bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  econom_ind
}

#' @rdname bde_indicators
#'
#' @export
bde_ind_unemployment_rate <-
  function(series_label = "Unemployment_Rate", ...) {
    db <- tidyBdE::bde_ind_db
    seq_num <- db[
      db$tidyBdE_fun == "bde_ind_unemployment_rate",
      "Numero_secuencial"
    ]
    seq_num <- as.character(seq_num)

    econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    econom_ind
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_euribor_12m_monthly <-
  function(series_label = "Euribor_12M_Monthly", ...) {
    db <- tidyBdE::bde_ind_db
    seq_num <- db[
      db$tidyBdE_fun == "bde_ind_euribor_12m_monthly",
      "Numero_secuencial"
    ]
    seq_num <- as.character(seq_num)

    econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    econom_ind
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_euribor_12m_daily <-
  function(series_label = "Euribor_12M_Daily", ...) {
    db <- tidyBdE::bde_ind_db
    seq_num <- db[
      db$tidyBdE_fun == "bde_ind_euribor_12m_daily",
      "Numero_secuencial"
    ]
    seq_num <- as.character(seq_num)

    econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    econom_ind
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_cpi_var <-
  function(series_label = "Consumer_price_index_YoY", ...) {
    db <- tidyBdE::bde_ind_db
    seq_num <- db[
      db$tidyBdE_fun == "bde_ind_cpi_var",
      "Numero_secuencial"
    ]
    seq_num <- as.character(seq_num)

    econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
    econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

    econom_ind
  }

#' @rdname bde_indicators
#'
#' @export
bde_ind_ibex_monthly <- function(series_label = "IBEX_index_month", ...) {
  db <- tidyBdE::bde_ind_db
  seq_num <- db[
    db$tidyBdE_fun == "bde_ind_ibex_monthly",
    "Numero_secuencial"
  ]
  seq_num <- as.character(seq_num)

  econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  econom_ind
}

#' @rdname bde_indicators
#'
#' @export
bde_ind_ibex_daily <- function(series_label = "IBEX_index_day", ...) {
  db <- tidyBdE::bde_ind_db
  seq_num <- db[
    db$tidyBdE_fun == "bde_ind_ibex_daily",
    "Numero_secuencial"
  ]
  seq_num <- as.character(seq_num)

  econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  econom_ind
}

#' @rdname bde_indicators
#'
#' @export
bde_ind_gdp_quarterly <- function(series_label = "GDP_quarterly_value", ...) {
  db <- tidyBdE::bde_ind_db
  seq_num <- db[
    db$tidyBdE_fun == "bde_ind_gdp_quarterly",
    "Numero_secuencial"
  ]
  seq_num <- as.character(seq_num)

  econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  econom_ind
}


#' @rdname bde_indicators
#'
#' @export
bde_ind_population <- function(series_label = "Population_Spain", ...) {
  db <- tidyBdE::bde_ind_db
  seq_num <- db[
    db$tidyBdE_fun == "bde_ind_population",
    "Numero_secuencial"
  ]
  seq_num <- as.character(seq_num)

  econom_ind <- bde_series_load(seq_num, series_label = series_label, ...)
  econom_ind <- econom_ind[!is.na(econom_ind[[2]]), ]

  econom_ind
}

#' @export
#' @rdname bde_indicators
#' @usage NULL
bde_ind_ibex <- bde_ind_ibex_monthly
