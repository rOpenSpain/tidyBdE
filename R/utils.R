#' Parse dates from strings
#'
#' @description
#' Parse strings representing dates with [as.Date()]. This function is tailored
#' to date formats used in this package and may fail with other datasets. See
#' **Examples** for formats that are supported.
#'
#' ## Date formats
#'
#' ```{r, echo=FALSE}
#'
#' dates <- tibble::tribble(
#'   ~FREQUENCY, ~FORMAT, ~EXAMPLES,
#'   "**Daily / Business day**", "`DD MMMMYYYY`", "`02 FEB2019`",
#'   "**Monthly**", "`MMM YYYY`", "`MAR 2020`",
#'   "**Quarterly**", paste(
#'     "`MMM YYYY`, where `MMM` is the first",
#'     "or the last month of the",
#'     "quarter, depending on the value of",
#'     "its variable OBSERVED."
#'   ),
#'   "For the first quarter of 2020: `ENE 2020`, `MAR 2020`",
#'   "**Half-yearly**", paste(
#'     "`MMM YYYY`, where `MMM` is the first or the last month",
#'     "of the half-year period, depending on the value of its",
#'     "variable OBSERVED."
#'   ),
#'   "For the first half of 2020: `ENE 2020`, `JUN 2020`",
#'   "**Annual**", "`YYYY`", "`2020`"
#' )
#' names(dates) <- paste0("**", names(dates), "**")
#'
#' knitr::kable(dates)
#' ```
#' See `vignette("csv_manual", package = "tidyBdE")` for details.
#'
#' @param dates_to_parse Character vector of dates to parse.
#'
#' @return A vector of [`Date`][as.Date()] values.
#'
#' @seealso [as.Date()]
#'
#' @family utils
#'
#' @export
#' @encoding UTF-8
#'
#' @examples
#' # Supported formats.
#' would_parse <- c(
#'   "02 FEB2019", "15 ABR 1890", "MAR 2020", "ENE2020",
#'   "2020", "12-1993", "01-02-2014", "01/02/1990"
#' )
#'
#' parsed_ok <- bde_parse_dates(would_parse)
#'
#' class(parsed_ok)
#'
#' tibble::tibble(raw = would_parse, parsed = parsed_ok)
#'
#' # Unsupported formats.
#'
#' wont_parse <- c("JAN2001", "2010-01-12", "01 APR 2017", "01/31/1990")
#'
#' parsed_fail <- bde_parse_dates(wont_parse)
#'
#' class(parsed_fail)
#'
#' tibble::tibble(raw = wont_parse, parsed = parsed_fail)
bde_parse_dates <- function(dates_to_parse) {
  dateformat <- gsub(" ", "", toupper(dates_to_parse), fixed = TRUE)
  dateformat <- gsub("-", "", dateformat, fixed = TRUE)
  dateformat <- gsub("/", "", dateformat, fixed = TRUE)

  months_esp <- c(
    "ENE",
    "FEB",
    "MAR",
    "ABR",
    "MAY",
    "JUN",
    "JUL",
    "AGO",
    "SEP",
    "OCT",
    "NOV",
    "DIC"
  )

  # Map Spanish month names to numbers.
  for (i in seq_along(months_esp)) {
    dateformat <- gsub(months_esp[i], sprintf("%02d", i), dateformat)
  }

  # Normalize the date format to dd-mm-yyyy.
  for (j in seq_along(dateformat)) {
    s2 <- dateformat[j]

    if (is.na(s2) || nchar(s2) < 4) {
      # Return missing values for incomplete dates.
      dateformat[j] <- NA
    } else if (nchar(s2) == 4) {
      # If only a year is provided, add month and day.
      dateformat[j] <- paste0("3112", s2)
    } else if (nchar(s2) == 6) {
      # If month and year are provided, add day.
      dateformat[j] <- paste0("01", s2)
    }
  }

  # Convert normalized values to dates.
  dateformat <- as.Date(dateformat, "%d%m%Y")
  dateformat
}

#' Resolve a cache directory
#'
#' @param cache_dir Path to a cache directory.
#' @param verbose Logical indicating whether to display informative messages.
#' @param suffix Optional suffix to append to the path.
#'
#' @noRd
bde_hlp_cachedir <- function(cache_dir = NULL, verbose = FALSE, suffix = NULL) {
  # Prefer an explicit cache directory, then an option, then a temp directory.
  if (is.null(cache_dir)) {
    # Respect the global cache option when no directory is supplied.
    cache_dir <- getOption("bde_cache_dir", NULL)

    if (is.null(cache_dir)) {
      # Keep default caching disposable when no cache is configured.
      cache_dir <- tempdir()

      if (!is.null(suffix)) {
        cache_dir <- file.path(cache_dir, suffix)
      }

      if (verbose) {
        cli::cli_alert_info(
          "Using temporary cache directory {.path {cache_dir}}."
        )
      }
      return(cache_dir)
    } else {
      # Report the configured cache location when requested.
      if (verbose) {
        cli::cli_alert_info(
          "Using cache directory from options: {.path {cache_dir}}."
        )
      }
    }
  }

  # Keep family-specific series files in a stable subdirectory.
  if (!is.null(suffix)) {
    cache_dir <- file.path(gsub(file.path("", suffix), "", cache_dir), suffix)
  }

  if (dir.exists(cache_dir)) {
    if (verbose) {
      cli::cli_alert_success("Using cache directory {.path {cache_dir}}.")
    }
    return(cache_dir)
  }

  dir.create(cache_dir, recursive = TRUE)
  if (verbose) {
    cli::cli_alert_success("Created cache directory {.path {cache_dir}}.")
  }
  cache_dir
}

#' Download a file
#'
#' @param url Resource URL.
#'
#' @param local_file Local file path to create or overwrite.
#'
#' @param verbose Logical indicating whether to display informative messages.
#'
#' @noRd
bde_hlp_download <- function(url, local_file, verbose) {
  if (verbose) {
    cli::cli_alert_info("Downloading file from {.url {url}}.")
  }

  err_dwnload <- tryCatch(
    download.file(url, local_file, quiet = isFALSE(verbose), mode = "wb"),
    warning = function(e) {
      TRUE
    }
  )

  # Retry once because intermittent warnings are common for remote files.

  if (isTRUE(err_dwnload)) {
    if (verbose) {
      cli::cli_alert_warning("Download failed. Trying again.")
    }

    err_dwnload <- tryCatch(
      download.file(url, local_file, quiet = isFALSE(verbose), mode = "wb"),
      warning = function(e) {
        cli::cli_alert_warning(
          paste0(
            "URL {.url {url}} is not reachable. ",
            "If this looks like a bug, please open an issue."
          )
        )
        TRUE
      }
    )
  }

  # Signal download failure without raising an error.
  if (isTRUE(err_dwnload)) {
    return(FALSE)
  }
  TRUE
}

#' Infer column types in a tibble
#'
#' @param tbl The tibble to process.
#' @param preserve Vector of names to preserve.
#' @noRd
bde_hlp_guess <- function(tbl, preserve = "") {
  for (i in names(tbl)) {
    if (class(tbl[[i]])[1] == "character" && !(i %in% preserve)) {
      tbl[i] <- readr::parse_guess(
        tbl[[i]],
        locale = readr::locale(grouping_mark = "", decimal_mark = "."),
        na = c("_", "...")
      )
    }
  }
  tbl
}

#' Convert columns to character vectors
#'
#' @param tbl A tibble.
#' @param preserve Vector of names to preserve.
#' @noRd
bde_hlp_tochar <- function(tbl, preserve = "") {
  for (i in names(tbl)) {
    if (class(tbl[[i]])[1] != "character" && !(i %in% preserve)) {
      tbl[i] <- as.character(tbl[[i]])
    }
  }
  tbl
}

#' Convert columns to double-precision numbers
#'
#' @param tbl A tibble.
#' @param preserve Vector of names to preserve.
#' @noRd
bde_hlp_todouble <- function(tbl, preserve = "") {
  for (i in names(tbl)) {
    if (class(tbl[[i]])[1] == "character" && !(i %in% preserve)) {
      tbl[i] <- readr::parse_double(
        tbl[[i]],
        locale = readr::locale(grouping_mark = "", decimal_mark = "."),
        na = c("_", "...")
      )
    }
  }
  tbl
}

#' Return an empty tibble with an informative message
#'
#' @param msg Message to display before returning the empty tibble.
#'
#' @return A [tibble][tibble::tbl_df].
#'
#' @examples
#' bde_hlp_return_null()
#'
#' @noRd
bde_hlp_return_null <- function(
  msg = "BdE is offline. Returning an empty tibble."
) {
  cli::cli_alert_info(msg)
  tbl <- tibble::tibble(x = NULL)
  tbl
}
