#' Parse dates
#'
#' Tries to parse strings representing dates using [as.Date()]
#'
#' @export
#'
#' @family utils
#'
#' @return A [`Date`][as.Date()] object.
#'
#' @seealso [as.Date()]
#'
#' @param dates_to_parse Dates to parse
#'
#' @description
#' This function is tailored for the date formatting used on this package, so
#' it may fail if it is used for another datasets. See **Examples** for
#' checking which formats would be considered.
#'
#' ## Date Formats
#'
#' ```{r, echo=FALSE}
#'
#' dates <- tibble::tribble(
#'   ~FREQUENCY, ~FORMAT, ~EXAMPLES,
#'   "**Daily / Business day**", "DD MMMMYYYY", "*02 FEB2019*",
#'   "**Monthly**", "MMM YYYY", "*MAR 2020*",
#'   "**Quarterly**", paste(
#'     "MMM YYYY, where MMM is the first ",
#'     "or the last month of the",
#'     "quarter, depending on the value of",
#'     "its variable OBSERVED."
#'   ),
#'   "For the first quarter of 2020: *ENE 2020, MAR 2020*",
#'   "**Half-yearly**", paste(
#'     "MMM YYYY, where MMM is the first or the last month",
#'     "of the halfyear period, depending on the value of its",
#'     "variable OBSERVED."
#'   ),
#'   "For the first half of 2020: *ENE 2020, JUN 2020*",
#'   "**Annual**", "YYYY", "*2020*"
#' )
#' names(dates) <- paste0("**", names(dates), "**")
#'
#' knitr::kable(dates)
#' ```
#'
#' @examples
#' # Formats parsed
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
#' #-----------------------------------
#'
#' # Formats not admitted
#' wont_parse <- c("JAN2001", "2010-01-12", "01 APR 2017", "01/31/1990")
#'
#' parsed_fail <- bde_parse_dates(wont_parse)
#'
#' class(parsed_fail)
#'
#' tibble::tibble(raw = wont_parse, parsed = parsed_fail)
bde_parse_dates <- function(dates_to_parse) {
  dateformat <- gsub(" ", "", toupper(dates_to_parse))
  dateformat <- gsub("-", "", dateformat)
  dateformat <- gsub("/", "", dateformat)

  months_esp <- c(
    "ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO",
    "SEP", "OCT", "NOV", "DIC"
  )

  # Format months
  for (i in seq_len(length(months_esp))) {
    dateformat <- gsub(months_esp[i], sprintf("%02d", i), dateformat)
  }

  # Final format: dd-mm-yyyy
  for (j in seq_len(length(dateformat))) {
    s2 <- dateformat[j]

    if (is.na(s2) || nchar(s2) < 4) {
      # Return NULL
      dateformat[j] <- NA
    } else if (nchar(s2) == 4) {
      # This is just year, add day, month
      dateformat[j] <- paste0("3112", s2)
    } else if (nchar(s2) == 6) {
      # Month Year, add day
      dateformat[j] <- paste0("01", s2)
    }
  }

  # Convert object
  dateformat <- as.Date(dateformat, "%d%m%Y")
  dateformat
}


#' Creates `cache_dir`
#'
#' @param cache_dir a directory path
#' @param verbose logical, display parameters
#' @param suffix a suffix
#'
#' @noRd
bde_hlp_cachedir <- function(cache_dir = NULL, verbose = FALSE, suffix = NULL) {
  # Check cache dir if is null
  if (is.null(cache_dir)) {
    # Check if set via options
    cache_dir <- getOption("bde_cache_dir", NULL)

    if (is.null(cache_dir)) {
      # Not set - using tempdir
      cache_dir <- tempdir()

      if (!is.null(suffix)) {
        cache_dir <- file.path(cache_dir, suffix)
      }

      if (verbose) {
        message("tidyBdE> Caching on temporary directory ", cache_dir)
      }
      return(cache_dir)
    } else {
      # Set via options
      if (verbose) {
        message("tidyBdE> Cache dir detected on options: ", cache_dir)
      }
    }
  }

  # When provided
  if (!is.null(suffix)) {
    cache_dir <- file.path(gsub(file.path("", suffix), "", cache_dir), suffix)
  }

  if (dir.exists(cache_dir)) {
    if (verbose) {
      message("tidyBdE> Cache dir is ", cache_dir)
    }
    return(cache_dir)
  }

  dir.create(cache_dir, recursive = TRUE)
  if (verbose) {
    message("tidyBdE> Cache dir created on ", cache_dir)
  }
  cache_dir
}

#' Helper for downloading files
#'
#' @param url resource url
#'
#' @param local_file local file to be created
#'
#' @param verbose logical, display parameters and messages
#'
#' @noRd
bde_hlp_download <- function(url, local_file, verbose) {
  if (verbose) message("tidyBdE> Downloading file from ", url, "\n\n")

  err_dwnload <- tryCatch(
    download.file(url,
      local_file,
      quiet = isFALSE(verbose),
      mode = "wb"
    ),
    # nocov start
    warning = function(e) {
      TRUE
    }
  )
  # nocov end
  # Try again if not working
  # This time display a message

  # nocov start
  if (isTRUE(err_dwnload)) {
    if (verbose) message("tidyBdE> Trying again")

    err_dwnload <- tryCatch(
      download.file(url, local_file,
        quiet = isFALSE(verbose),
        mode = "wb"
      ),
      # nocov start
      warning = function(e) {
        message(
          "tidyBdE> URL \n ", url, "\nnot reachable.\n\n",
          "If you think this is a bug consider opening an issue"
        )
        TRUE
      }
    )
  }
  # nocov end

  # On warning stop the execution
  if (isTRUE(err_dwnload)) {
    return(FALSE)
    # nocov end
  }
  TRUE
}


#' Guess formats
#'
#' @param tbl a tibble
#' @param preserve vector of names to preserve
#' @noRd
bde_hlp_guess <- function(tbl, preserve = "") {
  for (i in names(tbl)) {
    if (class(tbl[[i]])[1] == "character" && !(i %in% preserve)) {
      tbl[i] <- readr::parse_guess(tbl[[i]],
        locale = readr::locale(
          grouping_mark = "",
          decimal_mark = "."
        ),
        na = c("_", "...")
      )
    }
  }
  return(tbl)
}


#' To chars
#'
#' @param tbl a tibble
#' @param preserve vector of names to preserve
#' @noRd
bde_hlp_tochar <- function(tbl, preserve = "") {
  for (i in names(tbl)) {
    if (class(tbl[[i]])[1] != "character" && !(i %in% preserve)) {
      tbl[i] <- as.character(tbl[[i]])
    }
  }
  return(tbl)
}


#' To double
#'
#' @param tbl a tibble
#' @param preserve vector of names to preserve
#' @noRd
bde_hlp_todouble <- function(tbl, preserve = "") {
  for (i in names(tbl)) {
    if (class(tbl[[i]])[1] == "character" && !(i %in% preserve)) {
      tbl[i] <-
        readr::parse_double(tbl[[i]],
          locale = readr::locale(
            grouping_mark = "",
            decimal_mark = "."
          ),
          na = c("_", "...")
        )
    }
  }
  return(tbl)
}


#' Return empty tibble
#' @return a tibble.
#'
#' @examples
#'
#' bde_hlp_return_null()
#' @noRd
bde_hlp_return_null <- function(msg = "Offline. Returning an empty tibble") {
  # nocov start
  message(paste0("tidyBdE> ", msg))
  tbl <- tibble::tibble(x = NULL)
  return(tbl)
  # nocov end
}
