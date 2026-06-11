#' Load BdE time series from the Statistics web service (API)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' These functions query BdE time series through the
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(" [Statistics web service (API)]",
#'       "(https://www.bde.es/webbe/en/estadisticas/recursos",
#'       "/api-estadisticas-bde.html)."))
#' ```
#'
#' The API is a JSON web service that provides access through URL requests to
#' information available in the Statistics section of the Banco de España and
#' the BIEST application.
#'
#' The API defines two request types. [bde_series_api_latest()] uses the Latest
#' Data request to obtain the latest published observation for one or more
#' series. [bde_series_api_load()] uses the Series List request to obtain the
#' details of one or more complete series and their metadata.
#'
#' This API service uses the series alias as the identifier (see
#' `vignette("csv_manual", package = "tidyBdE")`). The series alias is a
#' positional code showing the location (column and/or row) of the series in
#' the table. However, although it is unique, it is not a good candidate to be
#' used as the series ID because it is subject to change.
#'
#' - If a series changes position in the table, its alias will also change.
#' - If a new series is inserted into a table, all the aliases that come after
#'   it will change and will not represent the same series.
#'
#' @param series_alias Character string or vector of time series aliases from
#'   the `Nombre_de_la_serie` field of the corresponding series. See
#'   [bde_catalog_load()].
#' @param language Character string. It can take the values `"es"` or `"en"` to
#'   obtain results in Spanish or English, respectively.
#' @param time_range Character string. Optional annual range or API range code.
#'   It can be a year, such as `"2024"`, or a range code such as `"3M"`,
#'   `"12M"`, `"30M"`, `"36M"`, `"60M"` or `"MAX"`. If `NULL`, the API returns
#'   the smallest range for the series frequency. Range codes are validated
#'   against the frequency returned by [bde_series_api_latest()].
#'
#' @inheritParams bde_series_load
#'
#' @return
#' `bde_series_api_latest()` returns a [tibble][tibble::tbl_df] with the latest
#' published observation for each valid series, with fields returned by the
#' Latest Data request such as `serie`, `descripcionCorta`, `codFrecuencia`,
#' `decimales`, `simbolo`, `tendencia`, `fechaValor` and `valor`.
#'
#' `bde_series_api_load()` returns a [tibble][tibble::tbl_df]. When
#' `extract_metadata = FALSE`, it returns observations in wide or long format
#' according to `out_format`. When `extract_metadata = TRUE`, it returns one row
#' per valid series with fields returned by the Series List request, including
#' list columns for `informacion`, `fechas` and `valores`.
#'
#' @seealso [bde_catalog_load()], [bde_catalog_search()],
#'   [bde_indicators()]
#'
#' @family series
#'
#' @rdname bde_series_api
#' @name bde_series_api
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' xr <- bde_catalog_load(catalog = "TC")
#'
#' # Extract the latest value.
#' library(dplyr)
#' xr |>
#'   slice_head(n = 3) |>
#'   pull(Nombre_de_la_serie) |>
#'   bde_series_api_latest(language = "en") |>
#'   glimpse()
#'
#' # Extract the latest months.
#' xr |>
#'   slice_head(n = 1) |>
#'   pull(Nombre_de_la_serie) |>
#'   bde_series_api_load(language = "en", time_range = "12M") |>
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
  series_alias <- series_alias[nzchar(series_alias)]

  if (length(series_alias) == 0) {
    return(tibble::tibble())
  }

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
  result <- bde_hlp_api_download(base_url, tmpjson, verbose)
  if (isFALSE(result)) {
    unlink(tmpjson)
    s <- bde_hlp_return_null("Returning an empty tibble.")
    return(s)
  }

  # Read json.
  api_res <- jsonlite::read_json(tmpjson)

  # Iterate over API errors.
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
        cli::cli_alert_info("Value omitted from the results.")
        return(FALSE)
      }

      TRUE
    },
    FUN.VALUE = logical(1)
  )

  if (!any(ok_results)) {
    cli::cli_alert_warning("No valid results with query {.url {base_url}}.")
    s <- bde_hlp_return_null("Returning an empty tibble.")
    return(s)
  }

  api_res <- api_res[ok_results]

  end <- lapply(api_res, function(x) {
    # Extract data.
    dplyr::as_tibble(x)
  })

  end <- dplyr::bind_rows(end)
  end$fechaValor <- as.Date(end$fechaValor)
  end <- bde_hlp_guess(end)
  end <- dplyr::as_tibble(end)
  end
}

#' @rdname bde_series_api
#'
#' @export
#' @encoding UTF-8
bde_series_api_load <- function(
  series_alias,
  series_label = NULL,
  out_format = "wide",
  parse_dates = TRUE,
  language = c("en", "es"),
  time_range = NULL,
  verbose = FALSE,
  extract_metadata = FALSE
) {
  if (missing(series_alias)) {
    cli::cli_abort("{.arg series_alias} cannot be missing.")
  }
  stopifnot(
    is.logical(parse_dates),
    is.logical(verbose),
    is.logical(extract_metadata)
  )
  language <- match.arg(language)
  out_format <- match.arg(out_format, c("wide", "long"))

  series_alias <- trimws(as.character(series_alias))
  # Drop invalid codes created by coercion.
  series_alias <- series_alias[!is.na(series_alias)]
  series_alias <- series_alias[nzchar(series_alias)]

  if (length(series_alias) == 0) {
    return(tibble::tibble())
  }

  if (is.null(series_label)) {
    series_label <- series_alias
  }
  if (anyNA(series_label)) {
    cli::cli_abort("{.arg series_label} must not contain missing values.")
  }

  series_label <- unique(as.character(series_label))

  if (length(series_alias) != length(series_label)) {
    cli::cli_abort(
      "{.arg series_label} and {.arg series_alias} must have the same length."
    )
  }

  if (!is.null(time_range)) {
    time_range <- trimws(as.character(time_range))
    if (length(time_range) != 1 || is.na(time_range) || !nzchar(time_range)) {
      cli::cli_abort("{.arg time_range} must be a non-empty string or `NULL`.")
    }
  }

  bde_hlp_api_check_range(
    series_alias = series_alias,
    language = language,
    time_range = time_range,
    verbose = verbose
  )

  # Prepare query.
  base_url <- paste0(
    "https://app.bde.es/bierest/resources/srdatosapp/listaSeries?",
    "idioma=",
    language,
    "&series=",
    paste0(series_alias, collapse = ",")
  )

  if (!is.null(time_range)) {
    base_url <- paste0(base_url, "&rango=", time_range)
  }

  base_url <- utils::URLencode(base_url)

  # Try download.
  tmpjson <- tempfile("bdeapi_", fileext = ".json")
  result <- bde_hlp_api_download(base_url, tmpjson, verbose)
  if (isFALSE(result)) {
    unlink(tmpjson)
    s <- bde_hlp_return_null("Returning an empty tibble.")
    return(s)
  }

  # Read json.
  api_res <- jsonlite::read_json(tmpjson)

  if (length(api_res) == 0) {
    return(tibble::tibble())
  }

  # Iterate over API errors.
  n_series <- seq_along(api_res)

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
        cli::cli_alert_info("Value omitted from the results.")
        return(FALSE)
      }

      TRUE
    },
    FUN.VALUE = logical(1)
  )

  if (!any(ok_results)) {
    cli::cli_alert_warning("No valid results with query {.url {base_url}}.")
    s <- bde_hlp_return_null("Returning an empty tibble.")
    return(s)
  }

  api_res <- api_res[ok_results]

  meta <- lapply(
    api_res,
    bde_hlp_api_metadata,
    parse_dates = parse_dates
  )
  meta <- dplyr::bind_rows(meta)
  i <- match(meta$serie, series_alias)
  meta$serie_name <- as.character(series_label[i])
  meta <- meta[c(
    "serie",
    "serie_name",
    setdiff(names(meta), c("serie", "serie_name"))
  )]

  if (isTRUE(extract_metadata)) {
    return(tibble::as_tibble(meta))
  }

  end <- lapply(seq_len(nrow(meta)), function(i) {
    if (length(meta$fechas[[i]]) == 0) {
      return(tibble::tibble())
    }

    tibble::tibble(
      Date = meta$fechas[[i]],
      serie_name = meta$serie_name[i],
      serie_value = meta$valores[[i]]
    )
  })

  end <- dplyr::bind_rows(end)

  if (nrow(end) == 0) {
    return(bde_hlp_return_null())
  }

  end$serie_name <- factor(end$serie_name, levels = unique(end$serie_name))

  if (out_format == "wide") {
    end <- tidyr::pivot_wider(
      end,
      id_cols = "Date",
      names_from = "serie_name",
      values_from = "serie_value"
    )
  }

  end <- tibble::as_tibble(end)
  end
}

#' Validate the Series List time range against each series frequency
#'
#' @param series_alias Character vector of series aliases.
#' @param language API language code.
#' @param time_range API time range code.
#' @param verbose Logical indicating whether to display informative messages.
#'
#' @noRd
bde_hlp_api_check_range <- function(
  series_alias,
  language,
  time_range,
  verbose
) {
  if (is.null(time_range) || grepl("^[0-9]{4}$", time_range)) {
    return(invisible(TRUE))
  }

  allowed_ranges <- list(
    D = c("3M", "12M", "36M"),
    M = c("30M", "60M", "MAX"),
    Q = c("30M", "60M", "MAX"),
    A = c("60M", "MAX")
  )

  latest <- bde_series_api_latest(
    series_alias = series_alias,
    language = language,
    verbose = verbose
  )

  if (nrow(latest) == 0) {
    return(invisible(TRUE))
  }

  invalid <- vapply(
    seq_len(nrow(latest)),
    function(i) {
      frequency <- latest$codFrecuencia[i]
      allowed <- allowed_ranges[[frequency]]

      if (is.null(allowed)) {
        return(FALSE)
      }

      !(time_range %in% allowed)
    },
    FUN.VALUE = logical(1)
  )

  if (any(invalid)) {
    invalid_series <- latest$serie[invalid] # nolint
    invalid_frequency <- unique(latest$codFrecuencia[invalid]) # nolint
    cli::cli_abort(
      c(
        paste0(
          "{.arg time_range} {.str {time_range}} is not valid for ",
          "series frequency {.str {invalid_frequency}}."
        ),
        "i" = "Invalid series: {.val {invalid_series}}."
      )
    )
  }

  invisible(TRUE)
}

#' Download from the BdE API with an API-specific timeout
#'
#' @param url Resource URL.
#' @param local_file Local file path to create or overwrite.
#' @param verbose Logical indicating whether to display informative messages.
#'
#' @noRd
bde_hlp_api_download <- function(url, local_file, verbose) {
  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout), add = TRUE)

  timeout <- getOption("bde_api_timeout", 10)
  options(timeout = min(old_timeout, timeout))

  bde_hlp_download(url, local_file, verbose, retry = FALSE)
}

#' Normalize metadata from a single Series List API result
#'
#' @param result Parsed JSON object for one series.
#' @param parse_dates Logical indicating whether to parse API dates.
#'
#' @noRd
bde_hlp_api_metadata <- function(result, parse_dates = TRUE) {
  info <- lapply(result$informacion, dplyr::as_tibble)
  info <- dplyr::bind_rows(info)

  fecha_inicio <- result$fechaInicio
  fecha_fin <- result$fechaFin
  fechas <- unlist(result$fechas)

  if (isTRUE(parse_dates)) {
    fecha_inicio <- as.Date(fecha_inicio)
    fecha_fin <- as.Date(fecha_fin)
    fechas <- as.Date(fechas)
  }

  tibble::tibble(
    serie = result$serie,
    descripcion = result$descripcion,
    descripcionCorta = result$descripcionCorta,
    codFrecuencia = result$codFrecuencia,
    decimales = result$decimales,
    simbolo = result$simbolo,
    informacion = list(info),
    fechaInicio = fecha_inicio,
    fechaFin = fecha_fin,
    fechas = list(fechas),
    valores = list(unlist(result$valores))
  )
}
