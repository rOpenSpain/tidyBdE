#' Load a single BdE time-series
#'
#' Load a single time-series provided by BdE.
#'
#' @export
#'
#' @family series
#'
#'
#' @encoding UTF-8
#'
#' @param series_code a numeric (or coercible with [base::as.double()] value
#'   or vector with time-series code(s), as defined in the field
#'   `Número secuencial` of the corresponding series. See [bde_catalog_load()].
#'
#' @param series_label Optional. Character vector or value. Allows to specify a
#'   custom label for the series extracted. It should have the same length than
#'   `series_code`.
#'
#' @param out_format Defines if the format must be returned as a "long" dataset
#'   or a "wide" dataset. Possible values are `"wide"` or `"long"`. See
#'   **Value** for Details and Section **Examples**.
#' @inheritParams bde_series_full_load
#'
#'
#' @return
#' A [`tibble`][tibble::tibble] with a field `Date` and :
#' - With `out_format = "wide"` each series is presented in a separate
#'   column with the name defined by `series_label`.
#' - With `out_format = "long"` the `tibble` would have two more columns,
#'   `serie_name` with the labels of each series and `serie_value` with the
#'   value of the series.
#'
#' `"wide"` format is more suitable for exporting to a `.csv` file while
#' `"long"` format is more suitable for producing plots with
#' [ggplot2::ggplot()]. See also [tidyr::pivot_longer()] and
#' [tidyr::pivot_wider()].
#'
#' @description
#'
#' The series alias is a positional code showing the location (column and/or
#' row) of the series in the table. However, although it is unique, it is not
#' a good candidate to be used as the series ID, as it is subject to change.
#'  If a series changes position in the table, its alias will also change.
#'
#' To ensure series can still be identified, even after these changes, they
#' are assigned a sequential number (`series_code` on this function) which
#' will remain unchanged throughout the series' lifetime.
#'
#' Note that a single series could be used on different tables, so it can have
#' several aliases. If you need to search by alias it is recommended to use
#' [bde_series_full_load()].
#'
#' @note
#' This function tries to coerce the columns to numbers. For some series a
#' warning may be displayed if the parser fails. You can override the default
#' behavior with `parse_numeric = FALSE`
#'
#' @seealso [bde_catalog_load()],
#' [bde_catalog_search()], [bde_indicators()]
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' # Metadata
#' bde_series_load(573234, verbose = TRUE, extract_metadata = TRUE)
#'
#' # Data
#' bde_series_load(573234, extract_metadata = FALSE)
#'
#' # Vectorized
#' bde_series_load(c(573234, 573214),
#'   series_label = c("US/EUR", "GBP/EUR"),
#'   extract_metadata = TRUE
#' )
#'
#' wide <- bde_series_load(c(573234, 573214),
#'   series_label = c("US/EUR", "GBP/EUR")
#' )
#'
#' # Wide format
#' wide
#'
#'
#' # Long format
#' long <- bde_series_load(c(573234, 573214),
#'   series_label = c("US/EUR", "GBP/EUR"),
#'   out_format = "long"
#' )
#'
#' long
#'
#'
#' # Use with ggplot
#' library(ggplot2)
#'
#'
#' ggplot(long, aes(Date, serie_value)) +
#'   geom_line(aes(group = serie_name, color = serie_name)) +
#'   scale_color_bde_d() +
#'   theme_tidybde()
#' }
bde_series_load <- function(series_code, series_label = NULL,
                            out_format = "wide", parse_dates = TRUE,
                            parse_numeric = TRUE, cache_dir = NULL,
                            update_cache = FALSE, verbose = FALSE,
                            extract_metadata = FALSE) {
  if (missing(series_code)) {
    stop("`series_code` can't be NULL")
  }

  series_code <- as.double(series_code)
  # Remove NAs
  series_code <- series_code[!is.na(series_code)]

  if (is.null(series_label)) {
    series_label <- as.character(series_code)
  }
  if (any(is.na(series_label))) {
    stop("`series_label` should not contain NA values")
  }

  series_label <- unique(as.character(series_label))

  if (length(series_code) != length(series_label)) {
    stop("`series_label` and `series_code` should have the same length")
  }

  # Lookup on catalogs
  all_catalogs <- bde_catalog_load(
    catalog = "ALL", parse_dates = parse_dates,
    cache_dir = cache_dir,
    update_cache = update_cache,
    verbose = verbose
  )

  # nocov start
  if (nrow(all_catalogs) == 0) {
    tbl <- bde_hlp_return_null()
    return(tbl)
  }
  # nocov end

  all_catalogs <- all_catalogs[!is.na(all_catalogs[[2]]), c(2, 3, 4)]

  df_list <- lapply(series_code, function(x) {
    if (verbose) message("tidyBdE> Extracting series ", x, "\n\n")

    # Select file

    csv_file <- all_catalogs[all_catalogs[[1]] == x, c(2, 3)]

    if (nrow(csv_file) == 0) {
      message("`series_code` not found on catalogs.")
      tbl <- bde_hlp_return_null()
      return(tbl)
    }

    # Select first record
    csv_file_name <- as.character(csv_file[1, 2])
    alias_serie <- as.character(csv_file[1, 1])

    if (verbose) {
      message(
        "tidyBdE> Downloading serie ", x, " from file ",
        csv_file_name, " (alias ", alias_serie, ")."
      )
    }


    # Download and select series
    serie_file <- bde_series_full_load(csv_file_name,
      parse_dates = parse_dates,
      parse_numeric = parse_numeric,
      cache_dir = cache_dir,
      update_cache = update_cache,
      verbose = verbose,
      extract_metadata = extract_metadata
    )

    # nocov start
    if (nrow(serie_file) == 0) {
      tbl <- bde_hlp_return_null()
      return(tbl)
    }
    if (!(alias_serie %in% names(serie_file))) {
      if (verbose) {
        message(
          "tidyBdE> ", "Serie with alias '", alias_serie,
          "' not available on ", csv_file_name, ". "
        )
      }

      # Prevent deprecation

      return(bde_hlp_return_null())

      # nocov end
    } else {
      serie_file <- serie_file[c("Date", alias_serie)]
    }

    i <- match(x, series_code)
    names(serie_file) <- c("Date", "serie_value")
    serie_file$serie_name <- as.character(series_label[i])
    # Rearrange
    serie_file <- serie_file[c("Date", "serie_name", "serie_value")]

    serie_file
  })

  # Clean
  nrows <- unlist(lapply(df_list, nrow)) > 0

  df_list <- df_list[nrows]

  # Check that all dfs have Date field

  has_date <- vapply(df_list, function(x) {
    "Date" %in% names(x)
  },
  FUN.VALUE = logical(1)
  )

  df_list <- df_list[has_date]

  # Check number of series and merge (if needed)
  if (length(df_list) == 0) {
    return(bde_hlp_return_null())
  }

  # To long
  end <- dplyr::bind_rows(df_list)
  # As factors
  end$serie_name <- factor(end$serie_name, levels = unique(end$serie_name))
  # Factors

  if (out_format == "wide" || isTRUE(extract_metadata)) {
    end <- tidyr::pivot_wider(end,
      id_cols = "Date", names_from = "serie_name",
      values_from = "serie_value"
    )
  }

  end <- tibble::as_tibble(end)
  return(end)
}





#' Load BdE full time-series files
#'
#' Load a full time-series file provided by BdE.
#'
#' ## About BdE file naming
#'
#' The series name is a positional code showing the location of the table. For
#' example, table **be_6_1** represents the Table 1, Chapter 6 of the
#' Statistical Bulletin ("BE"). Although it is a unique value, it is subject
#' to change (i.e. a new table is inserted before).
#'
#' For that reason, the function [bde_series_load()] is more suitable for
#' extracting specific time-series.
#'
#'
#' @export
#'
#' @family series
#'
#'
#' @encoding UTF-8
#'
#' @param series_csv csv file of a series, as defined in the field
#'   `Nombre del archivo con los valores de la serie` of the corresponding
#'   catalog. See [bde_catalog_load()].
#'
#' @inheritParams bde_catalog_load
#'
#' @param parse_numeric Logical. If `TRUE` the columns would be parsed to
#'   double (numeric) values. See **Note**.
#'
#' @param extract_metadata Logical `TRUE/FALSE`. On `TRUE` the output is the
#'   metadata of the requested series.
#'
#' @return A [tibble][tibble::tibble] with a field `Date` and the alias of the
#' fields series as described on the catalogs. See [bde_catalog_load()].
#'
#' @note
#' This function tries to coerce the columns to numbers. For some series a
#' warning may be displayed if the parser fails. You can override the default
#' behavior with `parse_numeric = FALSE`
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' # Metadata
#' bde_series_full_load("TI_1_1.csv", extract_metadata = TRUE)
#'
#' # Data
#' bde_series_full_load("TI_1_1.csv")
#' }
bde_series_full_load <- function(series_csv, parse_dates = TRUE,
                                 parse_numeric = TRUE, cache_dir = NULL,
                                 update_cache = FALSE, verbose = FALSE,
                                 extract_metadata = FALSE) {
  stopifnot(
    is.null(cache_dir) || is.character(cache_dir),
    is.logical(verbose),
    is.logical(parse_dates),
    is.logical(update_cache)
  )

  if (length(grep(".csv", series_csv)) == 0) {
    series_csv <- paste0(series_csv, ".csv")
  }

  pp <- substr(series_csv, 1, 2)

  # Get cache dir
  cache_dir <- bde_hlp_cachedir(
    cache_dir = cache_dir, verbose = verbose,
    suffix = pp
  )

  # Create if not exist
  if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)


  base_url <- paste0(
    "https://www.bde.es/webbe/es/estadisticas/",
    "compartido/datos/csv/"
  )


  serie_file <- tolower(series_csv)

  full_url <- paste0(base_url, serie_file)
  local_file <- file.path(cache_dir, serie_file)

  # If no serie is found, update
  if (update_cache || isFALSE(file.exists(local_file))) {
    if (!bde_check_access()) {
      tbl <- bde_hlp_return_null()
      return(tbl)
    }

    result <- bde_hlp_download(
      url = full_url, local_file = local_file,
      verbose = verbose
    )

    if (isFALSE(result)) {
      # Clean up the file if it was produced. Is not valid
      file_full_path <- path.expand(local_file)
      if (file.exists(file_full_path)) {
        unlink(file_full_path, force = TRUE, recursive = TRUE)
      }
      return(invisible())
    }
  } else {
    if (verbose) {
      message("tidyBdE> Reading file ", serie_file, " from cache.")
    }
  }


  # Catch error
  # nocov start
  r <- readLines(local_file)
  if (length(r) == 0) {
    message("File ", local_file, " not valid")
    return(invisible())
  }
  # nocov end


  # Serie load
  serie_load <- read.csv2(local_file,
    sep = ",", stringsAsFactors = FALSE,
    na.strings = "", header = FALSE,
    fileEncoding = "latin1"
  )

  serie_load <- tibble::as_tibble(serie_load)

  # Always in third line
  newnames <- as.character(serie_load[3, ])
  newnames[1] <- "Date"

  names(serie_load) <- newnames


  # Metadata
  # Always lines 1 to 6
  meta_serie <- serie_load[seq_len(6), ]

  # Add FUENTE and NOTAS
  source_notes <-
    serie_load[serie_load[[1]] %in% c("FUENTE", "NOTAS"), ]

  if (extract_metadata) {
    return(meta_serie)
  }

  meta_serie <- dplyr::bind_rows(meta_serie, source_notes)

  # Data: the rest of lines
  data_serie <- serie_load[-seq_len(6), ]

  data_serie <-
    data_serie[!toupper(data_serie$Date) %in% c("FUENTE", "NOTAS"), ]

  newnames_data <- as.character(meta_serie[4, ])
  newnames_data[1] <- "Date"

  # Parse dates dates
  if (parse_dates) {
    if (verbose) {
      message("tidyBdE> Parsing dates")
    }
    date_fields <- names(data_serie)[grep("Date", names(data_serie))]

    for (i in seq_len(length(date_fields))) {
      field <- date_fields[i]

      data_serie[field] <- bde_parse_dates(data_serie[[field]])
    }
  }

  if (parse_numeric) {
    if (verbose) message("tidyBdE> Parsing fields to double")
    # Fields to double
    data_serie <- bde_hlp_todouble(data_serie, preserve = "Date")
  }
  return(data_serie)
}
