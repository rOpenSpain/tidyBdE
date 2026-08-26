#' Parse date strings
#'
#' @description
#' Parses date strings with [as.Date()]. This function is tailored to the date
#' formats used in this package and may not parse other datasets. See
#' **Examples** for supported formats.
#'
#' @details
#' ## Date formats
#'
#' ```{r, echo=FALSE}
#'
#' dates <- dplyr::tribble(
#'   ~FREQUENCY, ~FORMAT, ~EXAMPLES,
#'   "**Daily / Business day**", "`DD MMMYYYY`", "`02 FEB2019`",
#'   "**Monthly**", "`MMM YYYY`", "`MAR 2020`",
#'   "**Quarterly**", paste(
#'     "`MMM YYYY`, where `MMM` is the first",
#'     "or last month of the",
#'     "quarter, depending on the value of",
#'     "the `OBSERVED` variable."
#'   ),
#'   "For the first quarter of 2020: `ENE 2020`, `MAR 2020`",
#'   "**Half-yearly**", paste(
#'     "`MMM YYYY`, where `MMM` is the first or last month",
#'     "of the half-year period, depending on the value of its",
#'     "`OBSERVED` variable."
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
#' @param dates_to_parse A character vector of date strings to parse.
#'
#' @return A vector of [`Date`][as.Date()] values.
#'
#' @seealso
#' - [bde_catalog_load()] and [bde_series_load()] use this parser.
#' - [as.Date()] provides base R date conversion.
#'
#' @concept utils
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
#' dplyr::tibble(raw = would_parse, parsed = parsed_ok)
#'
#' # Unsupported formats.
#'
#' wont_parse <- c("JAN2001", "2010-01-12", "01 APR 2017", "01/31/1990")
#'
#' parsed_fail <- bde_parse_dates(wont_parse)
#'
#' class(parsed_fail)
#'
#' dplyr::tibble(raw = wont_parse, parsed = parsed_fail)
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

  # Map Spanish month abbreviations to numbers.
  for (i in seq_along(months_esp)) {
    dateformat <- gsub(months_esp[i], sprintf("%02d", i), dateformat)
  }

  # Normalize dates to day-month-year order.
  for (j in seq_along(dateformat)) {
    s2 <- dateformat[j]

    if (is.na(s2) || nchar(s2) < 4) {
      # Use missing values for incomplete dates.
      dateformat[j] <- NA
    } else if (nchar(s2) == 4) {
      # Use December 31 when only a year is provided.
      dateformat[j] <- paste0("3112", s2)
    } else if (nchar(s2) == 6) {
      # Use the first day when only a month and year are provided.
      dateformat[j] <- paste0("01", s2)
    }
  }

  dateformat <- as.Date(dateformat, "%d%m%Y")
  dateformat
}

#' Resolve a cache directory
#'
#' @param suffix Optional suffix to append to the cache path.
#' @inheritParams bde_catalogs cache_dir verbose
#'
#' @noRd
bde_hlp_cachedir <- function(cache_dir = NULL, verbose = FALSE, suffix = NULL) {
  # Prefer an explicit cache directory, then an option, then a temp directory.
  if (is.null(cache_dir)) {
    cache_dir <- getOption("bde_cache_dir", NULL)

    if (is.null(cache_dir)) {
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
      if (verbose) {
        cli::cli_alert_info(paste0(
          "Using cache directory from option {.code bde_cache_dir}: ",
          "{.path {cache_dir}}."
        ))
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
#' @param local_file Local file path to create or overwrite.
#' @param retry Logical. If `TRUE`, retry once after a failed download.
#' @inheritParams bde_catalogs verbose
#'
#' @noRd
bde_hlp_download <- function(url, local_file, verbose, retry = TRUE) {
  resource <- basename(sub("\\?.*$", "", url))
  if (!nzchar(resource)) {
    resource <- basename(local_file)
  }

  if (verbose) {
    cli::cli_alert_info("Downloading {.file {resource}}.")
  }

  err_dwnload <- tryCatch(
    download.file(url, local_file, quiet = isFALSE(verbose), mode = "wb"),
    warning = function(e) {
      TRUE
    }
  )

  # Retry once because intermittent warnings are common for remote files.
  if (isTRUE(err_dwnload) && isTRUE(retry)) {
    if (verbose) {
      cli::cli_alert_warning("Download failed, trying once more.")
    }

    err_dwnload <- tryCatch(
      download.file(url, local_file, quiet = isFALSE(verbose), mode = "wb"),
      warning = function(e) {
        issue_url <- "https://github.com/rOpenSpain/tidyBdE/issues"
        cli::cli_alert_warning("Could not download {.file {resource}}.")
        cli::cli_alert_info(paste0(
          "If this looks like a bug, please open an issue at ",
          "{.url ",
          issue_url,
          "}."
        ))
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
#' @param tbl A tibble to process.
#' @param preserve Character vector of column names to preserve.
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
#' @param tbl A tibble to process.
#' @param preserve Character vector of column names to preserve.
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
#' @param tbl A tibble to process.
#' @param preserve Character vector of column names to preserve.
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

#' Return an empty tibble with an optional informative message
#'
#' @param msg Optional message to display before returning the empty tibble.
#'
#' @return A [tibble][dplyr::tibble].
#'
#' @noRd
bde_hlp_return_null <- function(msg = NULL) {
  if (!is.null(msg)) {
    cli::cli_alert_info(msg)
  }
  tbl <- dplyr::tibble(x = NULL)
  tbl
}

#' Match an argument with a clear error message
#'
#' @param arg The argument to match.
#' @param choices The valid choices for the argument.
#' @param .call The call to display in the error message.
#'
#' @return The matched argument.
#'
#' @noRd
match_arg_pretty <- function(arg, choices, .call = parent.frame()) {
  # jarl-ignore-start unused_object: Argument used on cli message
  arg_name <- as.character(substitute(arg)) # nolint
  # jarl-ignore-end unused_object

  if (missing(choices)) {
    sys_par <- sys.parent()
    formal_args <- formals(sys.function(sys_par))
    choices <- eval(
      formal_args[[as.character(substitute(arg))]],
      envir = sys.frame(sys_par)
    )
  }
  choices <- as.character(choices)

  if (is.null(arg)) {
    return(choices[1L])
  }

  arg <- as.character(arg)

  if (identical(arg, choices)) {
    return(arg[1])
  }

  if (length(arg) == 1 && arg %in% choices) {
    return(arg)
  }

  msg <- paste0(
    "{.arg {arg_name}} must be {.or {.str {choices}}}, not ",
    "{.or {.str {arg}}}."
  )

  hint <- NULL
  if (length(arg) == 1) {
    partial_match <- pmatch(arg, choices)[1]
    if (!is.na(partial_match)) {
      hint <- paste0("Did you mean {.str ", choices[partial_match], "}?")
    }
  }

  cli::cli_abort(c(msg, i = hint), call = .call)
}

#' Abort when a condition is false
#'
#' @param ... Named logical conditions. Each name is the error message emitted
#'   when the condition is false.
#' @param .call The call to display in the error message.
#' @param .envir Environment in which to evaluate cli expressions.
#' @param .frame The throwing context passed to [cli::cli_abort()].
#'
#' @returns `NULL`, invisibly, when every condition is true.
#'
#' @noRd
bde_hlp_abort_if_not <- function(
  ...,
  .call = .envir,
  .envir = parent.frame(),
  .frame = .envir
) {
  checks <- list(...)
  messages <- names(checks)

  if (length(checks) == 0L) {
    return(invisible(NULL))
  }

  if (is.null(messages) || !all(nzchar(messages))) {
    cli::cli_abort(
      "Every condition supplied to {.fn bde_hlp_abort_if_not} must be named.",
      call = .call,
      .envir = .envir,
      .frame = .frame
    )
  }

  passed <- vapply(
    checks,
    function(condition) {
      length(condition) > 0L && isTRUE(all(condition))
    },
    logical(1)
  )

  failed <- which(!passed)
  if (length(failed) > 0L) {
    cli::cli_abort(
      messages[[failed[[1L]]]],
      call = .call,
      .envir = .envir,
      .frame = .frame
    )
  }

  invisible(NULL)
}
