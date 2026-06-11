#' Load BdE time series using the statistics web service (API)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' These functions are similar to [bde_series_load()] but they use the
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(" [Statistics web service (API)]",
#'       "(https://www.bde.es/webbe/en/estadisticas/recursos",
#'       "/api-estadisticas-bde.html)."))
#' ```
#'
#' [bde_series_api_latest()] allows you to obtain the latest published data for
#' one or more series.
#'
#' This API service uses the series alias as identifier (see
#' `vignette("csv_manual.qmd", package = "tidyBdE")`). The series alias is a
#' positional code showing the location (column and/or row) of the series in
#' the table. However, although it is unique, it is not a good candidate to be
#' used as the series ID, as it is subject to change.
#'
#' - If a series changes position in the table, its alias will also change.
#' - If a new series is inserted into a table, all the aliases that come after
#'   it will change and will not represent the same series.
#'
#' @param series_alias Character string or vector of time series alias from the
#'   `Nombre_de_la_serie` field of the corresponding series. See
#'   [bde_catalog_load()].
#' @param language Character string. It can can take the values `"es"` or
#'   `"en"`, to obtain the result in Spanish or English, respectively.
#'
#' @inheritParams bde_series_load
#'
#' @return
#' `bde_series_api_latest()` returns a [tibble][tibble::tbl_df] with the latest
#' published data supplemented with other variables such as frequency,
#' description, or trend.
#'
#' @seealso [bde_catalog_load()],
#' [bde_catalog_search()], [bde_indicators()]
#'
#' @rdname bde_series_api
#' @name bde_series_api
#'
#' @family series
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' xr <- bde_catalog_load(catalog = "TC")
#'
#' # Extract latest value
#' library(dplyr)
#' xr |>
#'   slice_head(n = 3) |>
#'   pull(Nombre_de_la_serie) |>
#'   bde_series_api_latest(language = "en") |>
#'   glimpse()
#' }
bde_series_api_latest <- function(
  series_alias,
  language = c("en", "es"),
  verbose = FALSE
) {
  if (missing(series_alias)) {
    cli::cli_abort("{.arg series_alias} cannot be missing.")
  }
  language <- match.arg(language)

  series_alias <- trimws(as.character(series_alias))
  # Drop invalid codes created by coercion.
  series_alias <- series_alias[!is.na(series_alias)]

  # Prepare query.
  base_url <- paste0(
    "https://app.bde.es/bierest/resources/srdatosapp/favoritas?",
    "idioma=",
    language,
    "&series=",
    paste0(series_alias, collapse = ",")
  )

  base_url <- utils::URLencode(base_url)

  # Try download.
  tmpjson <- tempfile("bdeapi_", fileext = ".json")
  result <- bde_hlp_download(base_url, tmpjson, verbose)
  if (isFALSE(result)) {
    unlink(tmpjson)
    s <- bde_hlp_return_null("Returning an empty tibble.")
    return(s)
  }

  # Read json.
  api_res <- jsonlite::read_json(tmpjson)

  # Iterate for errors
  n_series <- seq_along(series_alias)

  ok_results <- vapply(
    n_series,
    function(i) {
      err_num <- api_res[[i]]$errNum

      if (!is.null(err_num)) {
        cli::cli_alert_warning(
          c(
            "The query returned an error {.str {err_num}} ",
            "for {.arg series_alias} {.str {series_alias[i]}}."
          )
        )
        cli::cli_alert_info("Value omited on the results.")
        return(FALSE)
      }

      TRUE
    },
    FUN.VALUE = logical(1)
  )

  if (!any(ok_results)) {
    cli::cli_alert_warning("No valid results with query {.url {base_url}}")
    s <- bde_hlp_return_null("Returning an empty tibble.")
    return(s)
  }

  api_res <- api_res[ok_results]

  end <- lapply(api_res, function(x) {
    # Extract data

    dplyr::as_tibble(x)
  })

  end <- dplyr::bind_rows(end)
  end$fechaValor <- as.Date(end$fechaValor)
  end <- bde_hlp_guess(end)
  end <- dplyr::as_tibble(end)
  end
}
