#' Download  thematic classified files
#'
#' Download several series based on the thematic classification of BdE.
#'
#' @export
#'
#' @family series
#'
#'
#' @encoding UTF-8
#'
#' @param themes A single value indicating the themes to be downloaded
#'   or `"ALL"` as a shorthand. See **Details**.
#'
#'
#' @inheritParams bde_series_full_load
#'
#'
#' @return Invisible. This function is called for its side effects.
#'
#' @source [Time-series bulk data download](https://www.bde.es/webbde/en/estadis/infoest/descarga_series_temporales.html)
#'
#' @description
#'
#' By the time, this function just batch-download all the series included
#' in the
#' [Theme-based classification](https://www.bde.es/webbde/en/estadis/infoest/descarga_series_temporales.html)
#' provided by Bank of Spain. However, this is useful as the function
#' [bde_series_load_all()] and [bde_series_load()] would search also in the
#' downloaded files, providing a faster response to the end user.
#'
#' @seealso [bde_series_load_all()]
#'
#'
#' @details
#' Accepted values for `themes` are:
#'
#' ```{r, echo=FALSE}
#'
#' t <- tibble::tribble(
#' ~themes, ~Description,
#' "**TE_TIPOS**", "Interest rate statistics",
#' "**TE_TIPOSCAM**", "Exchange rate statistics",
#' "**TE_CF**", "Financial accounts statistics",
#' "**TE_IFINA**", "Financial corporations statistics",
#' "**TE_DEU**", "General government statistics",
#' "**TE_CENBAL**", "Non-Financial corporations statistics",
#' "**TE_SECEXT**", "External statistics",
#' "**TE_MERCA**", "Financial market statistics",
#' "**TE_ESTECON**", "General economic statistics",
#' )
#'
#'
#' knitr::kable(t)

#'
#'
#' ```
#'
#' Use `"ALL"` as a shorthand for updating all the catalogs at a glance.
#'
#' If this function has been called, [bde_series_load_all()] and
#' [bde_series_load()] would try to find the series on the downloaded files.
#'
#' @examplesIf bde_check_access()
#' \dontrun{
#' bde_themes_download()
#' }
bde_themes_download <- function(themes = "ALL", cache_dir = NULL,
                                verbose = FALSE) {
  # Validate
  valid_themes <- c(
    "TE_TIPOS", "TE_TIPOSCAM", "TE_CF",
    "TE_IFINA", "TE_DEU", "TE_CENBAL",
    "TE_SECEXT", "TE_MERCA", "TE_ESTECON",
    "ALL"
  )
  stopifnot(
    themes %in% valid_themes,
    length(themes) == 1,
    is.null(cache_dir) || is.character(cache_dir)
  )

  # nocov start
  if (!bde_check_access()) {
    message("tidyBdE> Offline")
    return(invisible())
  }
  # nocov end

  if (themes == "ALL") {
    themes_batch <- setdiff(valid_themes, "ALL")
  } else {
    themes_batch <- themes
  }

  themes_batch <- paste0(themes_batch, ".zip")

  # Helper function to download and unzip files
  unzip_themes <- function(x, cache_dir = cache_dir,
                           verbose = verbose) {
    baseurl <- "https://www.bde.es/webbde/es/estadis/infoest/series/"
    fullurl <- paste0(baseurl, x)
    cache_dir <- bde_hlp_cachedir(cache_dir)
    local_zip <- file.path(cache_dir, x)


    bde_hlp_download(fullurl, local_zip, verbose = verbose)

    # Extract all files
    exdir <- bde_hlp_cachedir(cache_dir = cache_dir, suffix = "TE")
    if (verbose) {
      message("tidyBdE> Extracting ", x, " content on ", exdir)
    }
    unzip(local_zip, exdir = exdir, junkpaths = FALSE)

    if (verbose) {
      message("tidyBdE> Removing ", local_zip)
    }
    unlink(local_zip)
    return(NULL)
  }

  # Apply to all
  r <- lapply(themes_batch, unzip_themes,
    cache_dir = cache_dir,
    verbose = verbose
  )


  if (verbose) {
    exdir <- bde_hlp_cachedir(cache_dir, suffix = "TE")
    nfiles <- length(list.files(exdir))

    message("tidyBdE> Sucess! ", nfiles, " files available in ", exdir)
  }

  return(invisible())
}
