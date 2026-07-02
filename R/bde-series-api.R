#' Load BdE time series from the Statistics web service (API)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' These functions retrieve BdE time series using the
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'   "[Statistics web service (API)]",
#'   "(https://www.bde.es/webbe/en/estadisticas/recursos/",
#'   "api-estadisticas-bde.html)."
#' ))
#' ```
#'
#' The API is a JSON web service that provides URL-based access to information
#' available in the Statistics section of Banco de España and the BIEST
#' application.
#'
#' The API defines two request types. [bde_series_api_latest()] uses the Latest
#' Data request to obtain the latest published observation for one or more
#' series. [bde_series_api_load()] uses the Series List request to obtain the
#' details of one or more complete series and their metadata.
#'
#' @param series_code A character vector of API series codes from the
#'   `Nombre_de_la_serie` field of the corresponding catalog. These values are
#'   passed to the API `series_list` parameter; they are not the stable
#'   sequential numbers used by [bde_series_load()].
#' @param language A string specifying the output language: `"es"` for Spanish
#'   or `"en"` for English.
#' @param time_range An optional string specifying a year or API range code. It
#'   can be a year, such as `"2024"`, or one of `"3M"`, `"12M"`, `"30M"`,
#'   `"36M"`, `"60M"` or `"MAX"`. If `NULL`, the API returns the smallest range
#'   for the series frequency. Range codes are validated against the frequency
#'   returned by [bde_series_api_latest()]. See **Details**.
#'
#' @inheritParams bde_series series_label out_format extract_metadata verbose
#'
#' @details
#' Allowed `time_range` values depend on the series frequency:
#'
#' - Daily frequency (`D`): `"3M"` (last 3 months), `"12M"` and `"36M"`.
#' - Monthly frequency (`M`): `"30M"`, `"60M"` and `"MAX"` (entire series).
#' - Quarterly frequency (`Q`): `"30M"`, `"60M"` and `"MAX"`.
#' - Annual frequency (`A`): `"60M"` and `"MAX"`.
#'
#' If `time_range` is not specified, the request returns the smallest range for
#' the series frequency. For example, monthly series return `"30M"`.
#'
#' @return
#' `bde_series_api_latest()` returns a [tibble][tibble::tbl_df] with the latest
#' published observation for each valid series. It includes fields returned by
#' the Latest Data request such as `serie`, `descripcionCorta`, `codFrecuencia`,
#' `decimales`, `simbolo`, `tendencia`, `fechaValor` and `valor`.
#'
#' `bde_series_api_load()` returns a [tibble][tibble::tbl_df]. When
#' `extract_metadata = FALSE`, API dates are parsed as [`Date`][as.Date()]
#' values and observations are returned in wide or long format according to
#' `out_format`. When `extract_metadata = TRUE`, it returns one row per valid
#' series with fields returned by the Series List request, including
#' `fechaInicio`, `fechaFin` and metadata fields derived from `informacion`.
#'
#' @inheritSection bde_series Series identifiers
#'
#' @seealso
#' - [bde_catalog_load()] and [bde_catalog_search()] help find API series codes.
#' - [bde_series_load()] loads time series from bulk CSV files.
#'
#' @family series
#'
#' @rdname bde_series_api
#' @name bde_series_api
#'
#' @encoding UTF-8
#' @export
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
#'
#' # Extract metadata.
#' xr |>
#'   slice_head(n = 1) |>
#'   pull(Nombre_de_la_serie) |>
#'   bde_series_api_load(
#'     language = "en", time_range = "12M",
#'     extract_metadata = TRUE
#'   ) |>
#'   glimpse()
#' }
bde_series_api_latest <- function(
  series_code,
  language = c("en", "es"),
  verbose = FALSE
) {
  if (missing(series_code)) {
    cli::cli_abort("{.arg series_code} cannot be missing.")
  }
  language <- match_arg_pretty(language)

  series_code <- trimws(as.character(series_code))
  # Drop invalid series codes created by coercion.
  series_code <- series_code[!is.na(series_code)]
  series_code <- series_code[nzchar(series_code)]

  if (length(series_code) == 0) {
    return(tibble::tibble())
  }

  # Prepare query.
  base_url <- paste0(
    "https://app.bde.es/bierest/resources/srdatosapp/favoritas?",
    "idioma=",
    language,
    "&series=",
    paste0(series_code, collapse = ",")
  )

  base_url <- utils::URLencode(base_url)

  # Try download.
  tmpjson <- tempfile("bdeapi_", fileext = ".json")
  result <- bde_hlp_download(base_url, tmpjson, verbose)
  if (isFALSE(result)) {
    unlink(tmpjson)
    s <- bde_hlp_return_null("Returning an empty {.cls tbl_df}.")
    return(s)
  }

  # Read JSON.
  api_res <- jsonlite::read_json(tmpjson)

  # Iterate over API errors.
  n_series <- seq_along(series_code)

  ok_results <- vapply(
    n_series,
    function(i) {
      err_num <- api_res[[i]]$errNum

      if (!is.null(err_num)) {
        cli::cli_alert_warning(paste0(
          "The query returned error {.val {err_num}} for ",
          "{.arg series_code} {.str {series_code[i]}}."
        ))
        cli::cli_alert_info("This series was omitted from the results.")
        return(FALSE)
      }

      TRUE
    },
    FUN.VALUE = logical(1)
  )

  if (!any(ok_results)) {
    cli::cli_alert_warning("No valid results for query {.url {base_url}}.")
    s <- bde_hlp_return_null("Returning an empty {.cls tbl_df}.")
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
#' @encoding UTF-8
#' @export
bde_series_api_load <- function(
  series_code,
  series_label = NULL,
  out_format = "wide",
  language = c("en", "es"),
  time_range = NULL,
  verbose = FALSE,
  extract_metadata = FALSE
) {
  if (missing(series_code)) {
    cli::cli_abort("{.arg series_code} cannot be missing.")
  }
  bde_hlp_abort_if_not(
    "{.arg verbose} must be a {.cls logical} vector." = is.logical(verbose),
    "{.arg extract_metadata} must be a {.cls logical} vector." = is.logical(
      extract_metadata
    )
  )
  language <- match_arg_pretty(language)
  out_format <- match_arg_pretty(out_format, c("wide", "long"))

  series_code <- trimws(as.character(series_code))
  # Drop invalid series codes created by coercion.
  series_code <- series_code[!is.na(series_code)]
  series_code <- series_code[nzchar(series_code)]

  if (length(series_code) == 0) {
    return(tibble::tibble())
  }

  if (is.null(series_label)) {
    series_label <- series_code
  }
  if (anyNA(series_label)) {
    cli::cli_abort("{.arg series_label} must not contain missing values.")
  }

  series_label <- unique(as.character(series_label))

  if (length(series_code) != length(series_label)) {
    cli::cli_abort(c(
      "{.arg series_label} and {.arg series_code} must have the same length.",
      "i" = paste0(
        "{.arg series_label} has length {.val {length(series_label)}} and ",
        "{.arg series_code} has length {.val {length(series_code)}}."
      )
    ))
  }

  if (!is.null(time_range)) {
    time_range <- trimws(as.character(time_range))
    if (length(time_range) != 1 || is.na(time_range) || !nzchar(time_range)) {
      cli::cli_abort(
        "{.arg time_range} must be a non-empty string or {.code NULL}."
      )
    }
  }

  bde_hlp_api_check_range(
    series_code = series_code,
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
    paste0(series_code, collapse = ",")
  )

  if (!is.null(time_range)) {
    base_url <- paste0(base_url, "&rango=", time_range)
  }

  base_url <- utils::URLencode(base_url)

  # Try download.
  tmpjson <- tempfile("bdeapi_", fileext = ".json")
  result <- bde_hlp_download(base_url, tmpjson, verbose)
  if (isFALSE(result)) {
    unlink(tmpjson)
    s <- bde_hlp_return_null("Returning an empty {.cls tbl_df}.")
    return(s)
  }

  # Read JSON.
  api_res <- jsonlite::read_json(tmpjson)

  if (extract_metadata) {
    meta <- lapply(api_res, function(x) {
      no_list <- x[!vapply(x, is.list, FUN.VALUE = logical(1))]
      tb <- dplyr::as_tibble(no_list)
      tb$fechaInicio <- as.Date(tb$fechaInicio)
      tb$fechaFin <- as.Date(tb$fechaFin)
      info <- lapply(x$informacion, function(y) {
        vals <- unlist(y, use.names = FALSE)
        tb <- dplyr::tibble(value = vals[2])
        names(tb) <- vals[1]
        tb
      })

      dplyr::bind_cols(tb, info)
    })
    meta <- dplyr::bind_rows(meta)
    return(dplyr::as_tibble(meta))
  }

  iter <- seq_along(series_code)

  df_list <- lapply(iter, function(i) {
    f <- api_res[[i]]$fechas
    v <- api_res[[i]]$valores

    # Replace NULL with NA.
    v <- lapply(v, function(x) {
      if (!is.null(x)) {
        return(x)
      }
      NA
    })

    tb_ind <- dplyr::tibble(
      a = unlist(f),
      b = rep(series_label[i], length(v)),
      c = unlist(v)
    )
    names(tb_ind) <- c("Date", "serie_name", "serie_value")
    tb_ind
  })

  # Bind the successfully loaded series before final reshaping.
  end <- dplyr::bind_rows(df_list)
  end$Date <- as.Date(end$Date)

  # Preserve the requested series order in plots.
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
#' @param series_code Character vector of API series codes.
#' @param language API language code.
#' @param time_range API time range code.
#' @param verbose Logical. If `TRUE`, display informative messages.
#'
#' @noRd
bde_hlp_api_check_range <- function(
  series_code,
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
    series_code = series_code,
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
    ok_ranges <- unlist(allowed_ranges[invalid_frequency]) # nolint
    cli::cli_abort(c(
      paste0(
        "{.arg time_range} {.str {time_range}} is not valid for ",
        "{qty(length(invalid_frequency))}series frequenc{?y/ies}: ",
        "{.str {invalid_frequency}}. ",
        "Use one of {.or {.str {ok_ranges}}}."
      ),
      "i" = "Invalid series: {.val {invalid_series}}."
    ))
  }

  invisible(TRUE)
}
