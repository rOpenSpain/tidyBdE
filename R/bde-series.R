#' Load BdE time series from bulk CSV files
#'
#' @description
#' These functions load BdE time series from the bulk CSV files published by
#' Banco de España.
#'
#' `bde_series_load()` extracts one or more series by their stable sequential
#' number. `bde_series_full_load()` loads a complete bulk CSV file and returns
#' all series included in that file.
#'
#' See `vignette("csv_manual", package = "tidyBdE")` for details.
#'
#' @param series_code A numeric vector of stable BdE sequential numbers, or
#'   values coercible with [base::as.double()], from the `Numero_secuencial`
#'   field of the corresponding series. This is not the API series code. See
#'   [bde_catalog_load()].
#' @param series_csv A bulk CSV file name for a series, as defined in the field
#'   `Nombre_del_archivo_con_los_valores_de_la_serie` of the corresponding
#'   catalog. See [bde_catalog_load()] and the **About BdE file naming**
#'   section.
#' @param series_label An optional character vector of labels to assign to the
#'   extracted series.
#' @param out_format The output format, either `"wide"` or `"long"`. See
#'   **Value** for details and the **Examples** section.
#' @param parse_numeric Logical. If `TRUE`, parse observation columns as double
#'   vectors. See **Note**.
#' @param extract_metadata Logical. If `TRUE`, return the metadata associated
#'   with the requested series.
#' @inheritParams bde_catalogs parse_dates update_cache cache_dir verbose
#'
#' @return
#' `bde_series_load()` returns a [tibble][tibble::tbl_df] with a `Date` column:
#'
#' - With `out_format = "wide"`, each series is presented in a separate column
#'   with the name defined by `series_label`.
#' - With `out_format = "long"`, the tibble has two additional columns:
#'   `serie_name` contains the label of each series; `serie_value` contains the
#'   corresponding value.
#'
#' `"wide"` format is more suitable for exporting to a CSV file;
#' `"long"` format is more suitable for creating plots with
#' [ggplot2::ggplot()]. See also [tidyr::pivot_longer()] and
#' [tidyr::pivot_wider()].
#'
#' `bde_series_full_load()` returns a [tibble][tibble::tbl_df] with a `Date`
#' column and the aliases of the time series columns as described in catalog
#' metadata. See [bde_catalog_load()] and
#' `vignette("csv_manual", package = "tidyBdE")` for details.
#'
#' @inherit bde_catalogs source
#'
#' @note
#' These functions attempt to parse columns as double values. For some time
#' series, a warning may be displayed if parsing fails. Set
#' `parse_numeric = FALSE` to disable numeric parsing.
#'
#' @section About BdE file naming:
#' A series alias is a positional code that identifies the location, column or
#' row of a series in a table. An alias is unique within its context but is not
#' stable because it may change when a series moves.
#'
#' A single time series may appear in different tables, so it can have several
#' aliases. Use `bde_series_full_load()` when you need to work with aliases or
#' load a complete file.
#'
#' The series alias is also used in full CSV files. For example, table
#' **be_6_1** represents Table 1, Chapter 6 of the Statistical Bulletin
#' ("BE"). Although it is unique, it is subject to change, for example when a
#' new table is inserted before it.
#'
#' @section Series identifiers:
#' BdE identifies each series with a stable sequential number
#' (`Numero_secuencial`) in bulk CSV files and an API series code
#' (`Nombre_de_la_serie`) in the Statistics web service.
#' [bde_series_load()] accepts stable sequential numbers in `series_code`.
#' [bde_series_api_latest()] and [bde_series_api_load()] use the same argument
#' for API series codes. Use [bde_catalog_load()] or [bde_catalog_search()] to
#' find both identifiers.
#'
#' @seealso
#' - [bde_catalog_load()] and [bde_catalog_search()] help find stable sequential
#'   numbers.
#' - [Indicator wrappers][bde_indicators] retrieve commonly used Spanish
#'   macroeconomic series.
#'
#' @family series
#'
#' @rdname bde_series
#' @name bde_series
#'
#' @encoding UTF-8
#' @export
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' # Show metadata.
#' bde_series_load(573234, verbose = TRUE, extract_metadata = TRUE)
#'
#' # Load data.
#' bde_series_load(573234, extract_metadata = FALSE)
#'
#' # Load multiple series.
#' bde_series_load(c(573234, 573214),
#'   series_label = c("US/EUR", "GBP/EUR"),
#'   extract_metadata = TRUE
#' )
#'
#' wide <- bde_series_load(c(573234, 573214),
#'   series_label = c("US/EUR", "GBP/EUR")
#' )
#'
#' # Show wide output.
#' wide
#'
#' # Show long output.
#' long <- bde_series_load(c(573234, 573214),
#'   series_label = c("US/EUR", "GBP/EUR"),
#'   out_format = "long"
#' )
#'
#' long
#'
#' # Use with ggplot2.
#' library(ggplot2)
#'
#' ggplot(long, aes(Date, serie_value)) +
#'   geom_line(aes(group = serie_name, color = serie_name)) +
#'   scale_color_bde_d() +
#'   theme_tidybde()
#'
#' # Show metadata for a complete bulk CSV file.
#' bde_series_full_load("TI_1_1.csv", extract_metadata = TRUE)
#'
#' # Load a complete bulk CSV file.
#' bde_series_full_load("TI_1_1.csv")
#' }
bde_series_load <- function(
  series_code,
  series_label = NULL,
  out_format = "wide",
  parse_dates = TRUE,
  parse_numeric = TRUE,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  extract_metadata = FALSE
) {
  if (missing(series_code)) {
    cli::cli_abort("{.arg series_code} cannot be missing.")
  }

  series_code <- as.double(series_code)
  # Drop invalid codes created by coercion.
  series_code <- series_code[!is.na(series_code)]

  if (is.null(series_label)) {
    series_label <- as.character(series_code)
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

  # Search catalog metadata.
  all_catalogs <- bde_catalog_load(
    catalog = "ALL",
    parse_dates = parse_dates,
    cache_dir = cache_dir,
    update_cache = update_cache,
    verbose = verbose
  )

  if (nrow(all_catalogs) == 0) {
    tbl <- bde_hlp_return_null()
    return(tbl)
  }

  all_catalogs <- all_catalogs[!is.na(all_catalogs[[2]]), c(2, 3, 4)]

  df_list <- lapply(series_code, function(x) {
    if (verbose) {
      cli::cli_alert_info("Extracting series {.val {x}}.")
    }

    # Match the stable sequential number to the first catalog record available.
    csv_file <- all_catalogs[all_catalogs[[1]] == x, c(2, 3)]

    if (nrow(csv_file) == 0) {
      cli::cli_alert_warning(
        "{.arg series_code} {.val {x}} was not found in catalog metadata."
      )
      tbl <- bde_hlp_return_null()
      return(tbl)
    }

    # Use the first available alias when a series appears in multiple tables.
    csv_file_name <- as.character(csv_file[1, 2])
    alias_serie <- as.character(csv_file[1, 1])

    if (verbose) {
      cli::cli_alert_info(paste0(
        "Downloading series {.val {x}} from file ",
        "{.file {csv_file_name}} (alias {.val {alias_serie}})."
      ))
    }

    # Download and extract the series.
    serie_file <- bde_series_full_load(
      csv_file_name,
      parse_dates = parse_dates,
      parse_numeric = parse_numeric,
      cache_dir = cache_dir,
      update_cache = update_cache,
      verbose = verbose,
      extract_metadata = extract_metadata
    )

    if (nrow(serie_file) == 0) {
      tbl <- bde_hlp_return_null()
      return(tbl)
    }
    if (!(alias_serie %in% names(serie_file))) {
      if (verbose) {
        cli::cli_alert_warning(paste0(
          "Series alias {.val {alias_serie}} is not available in ",
          "{.file {csv_file_name}}."
        ))
      }

      # Return an empty tibble if the alias is not available.
      return(bde_hlp_return_null())
    } else {
      serie_file <- serie_file[c("Date", alias_serie)]
    }

    i <- match(x, series_code)
    names(serie_file) <- c("Date", "serie_value")
    serie_file$serie_name <- as.character(series_label[i])
    # Place the date, label and value columns first.
    serie_file <- serie_file[c("Date", "serie_name", "serie_value")]

    serie_file
  })

  # Keep non-empty results.
  nrows <- unlist(lapply(df_list, nrow)) > 0

  df_list <- df_list[nrows]

  # Check that all data frames have a Date field.
  has_date <- vapply(
    df_list,
    function(x) {
      "Date" %in% names(x)
    },
    FUN.VALUE = logical(1)
  )

  df_list <- df_list[has_date]

  # Return early when every requested series failed to load.
  if (length(df_list) == 0) {
    return(bde_hlp_return_null())
  }

  # Bind the successfully loaded series before final reshaping.
  end <- dplyr::bind_rows(df_list)
  # Preserve the requested series order in plots.
  end$serie_name <- factor(end$serie_name, levels = unique(end$serie_name))

  if (out_format == "wide" || isTRUE(extract_metadata)) {
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

#' @rdname bde_series
#'
#' @encoding UTF-8
#' @export
bde_series_full_load <- function(
  series_csv,
  parse_dates = TRUE,
  parse_numeric = TRUE,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  extract_metadata = FALSE
) {
  bde_hlp_abort_if_not(
    "{.arg cache_dir} must be a {.cls character} vector or {.val NULL}." = any(
      is.null(cache_dir),
      is.character(cache_dir)
    ),
    "{.arg verbose} must be a {.cls logical} vector." = is.logical(verbose),
    "{.arg parse_dates} must be a {.cls logical} vector." = is.logical(
      parse_dates
    ),
    "{.arg update_cache} must be a {.cls logical} vector." = is.logical(
      update_cache
    )
  )

  if (length(grep(".csv", series_csv)) == 0) {
    series_csv <- paste0(series_csv, ".csv")
  }

  pp <- substr(series_csv, 1, 2)

  # Resolve the cache directory for the series family.
  cache_dir <- bde_hlp_cachedir(
    cache_dir = cache_dir,
    verbose = verbose,
    suffix = pp
  )

  # Ensure downloads have a family-specific destination.
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }

  base_url <- paste0(
    "https://www.bde.es/webbe/es/estadisticas/",
    "compartido/datos/csv/"
  )

  serie_file <- tolower(series_csv)

  full_url <- paste0(base_url, serie_file)
  local_file <- file.path(cache_dir, serie_file)

  # Download the series if it is missing or must be refreshed.
  if (update_cache || isFALSE(file.exists(local_file))) {
    if (!bde_check_access()) {
      tbl <- bde_hlp_return_null()
      return(tbl)
    }

    result <- bde_hlp_download(
      url = full_url,
      local_file = local_file,
      verbose = verbose
    )

    if (isFALSE(result)) {
      # Remove the invalid file if the failed download created one.
      file_full_path <- path.expand(local_file)
      if (file.exists(file_full_path)) {
        unlink(file_full_path, force = TRUE, recursive = TRUE)
      }
      return(invisible())
    }
  } else {
    if (verbose) {
      cli::cli_alert_success("Reading file {.file {serie_file}} from cache.")
    }
  }

  # Reject empty files before encoding detection.
  r <- readLines(local_file, warn = FALSE, n = 1000)
  if (length(r) == 0) {
    cli::cli_alert_warning("File {.file {local_file}} is empty.")
    unlink(local_file)
    return(invisible())
  }

  # Read the raw CSV after detecting its encoding.
  enc <- readr::guess_encoding(local_file)[[1]][[1]]

  serie_load <- suppressWarnings(read.csv2(
    local_file,
    sep = ",",
    stringsAsFactors = FALSE,
    na.strings = c("", "-", "_"),
    header = FALSE,
    fileEncoding = enc
  ))

  serie_load <- tibble::as_tibble(serie_load)

  # BdE series files store column names in the third row.
  newnames <- as.character(serie_load[3, ])
  newnames[1] <- "Date"

  names(serie_load) <- newnames

  # Preserve the file-level metadata rows.
  meta_serie <- serie_load[seq_len(6), ]

  # Keep source and notes with the metadata used for aliases.
  source_notes <- serie_load[serie_load[[1]] %in% c("FUENTE", "NOTAS"), ]

  if (extract_metadata) {
    return(meta_serie)
  }

  meta_serie <- dplyr::bind_rows(meta_serie, source_notes)

  # Keep observation rows after removing metadata.
  data_serie <- serie_load[-seq_len(6), ]

  data_serie <- data_serie[
    !toupper(data_serie$Date) %in% c("FUENTE", "NOTAS"),
  ]

  newnames_data <- as.character(meta_serie[4, ])
  newnames_data[1] <- "Date"

  # Parse date fields before numeric conversion.
  if (parse_dates) {
    if (verbose) {
      cli::cli_alert_info("Parsing date columns as {.cls Date}.")
    }
    date_fields <- names(data_serie)[grep(
      "Date",
      names(data_serie),
      fixed = TRUE
    )]

    for (i in seq_along(date_fields)) {
      field <- date_fields[i]

      data_serie[field] <- bde_parse_dates(data_serie[[field]])
    }
  }

  if (parse_numeric) {
    if (verbose) {
      cli::cli_alert_info("Parsing numeric fields as {.cls numeric} vectors.")
    }
    # Preserve dates while converting observations to double precision.
    data_serie <- bde_hlp_todouble(data_serie, preserve = "Date")
  }
  data_serie
}
