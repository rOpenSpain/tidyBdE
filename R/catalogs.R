#' Load BdE catalogs
#'
#' @description
#' Load the time-series catalogs provided by BdE.
#'
#' @export
#'
#' @family catalog
#'
#' @encoding UTF-8
#'
#' @return A [`tibble`][tibble::tibble] object.
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[Time-series bulk data download]",
#'       "(https://www.bde.es/webbe/en/estadisticas/recursos/",
#'       "descargas-completas.html)."))
#'
#'
#' ```
#'
#' @param catalog A single value indicating the catalogs to be updated
#'   or `"ALL"` as a shorthand. See **Details**.
#'
#' @param parse_dates Logical. If `TRUE` the dates would be parsed using
#'  [bde_parse_dates()].
#'
#' @param update_cache Logical. If `TRUE` the requested file would be updated on
#'  the `cache_dir`.
#'
#' @inheritParams bde_catalog_update
#'
#' @details
#' Accepted values for `catalog` are:
#'
#' ```{r, echo=FALSE}
#'
#' t <- tibble::tribble(
#' ~CODE, ~PUBLICATION, ~UPDATEFREQUENCY, ~FREQUENCY,
#' '`"BE"`', "Statistical Bulletin", "Daily", "Monthly",
#' '`"SI"`', "Summary Indicators", "Daily", "Daily",
#' '`"TC"`', "Exchange Rates", "Daily", "Daily",
#' '`"TI"`', "Interest Rates", "Daily", "Daily",
#' '`"PB"`', "Bank Lending Survey", "Quarterly", "Quarterly",
#' )
#'
#' names(t) <- paste0("**",
#'   c("CODE","PUBLICATION", "UPDATE FREQUENCY", "FREQUENCY"),
#'   "**")
#'
#' knitr::kable(t)
#' ```
#' Use `"ALL"` as a shorthand for updating all the catalogs at a glance.
#'
#' If the requested catalog is not cached [bde_catalog_update()] is invoked.
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' bde_catalog_load("TI", verbose = TRUE)
#' }
bde_catalog_load <- function(catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
                             parse_dates = TRUE, cache_dir = NULL,
                             update_cache = FALSE, verbose = FALSE) {
  catalog <- match.arg(catalog)
  # Validate
  valid_catalogs <- c("BE", "SI", "TC", "TI", "PB", "ALL")
  stopifnot(
    catalog %in% valid_catalogs, length(catalog) == 1,
    any(is.null(cache_dir), is.character(cache_dir)),
    is.logical(verbose), is.logical(parse_dates),
    is.logical(update_cache)
  )


  catalog_to_load <- catalog
  if (catalog == "ALL") catalog_to_load <- setdiff(valid_catalogs, "ALL")

  # Get cache dir
  cache_dir <- bde_hlp_cachedir(cache_dir = cache_dir, verbose = verbose)

  final_catalog <- lapply(catalog_to_load, function(x) {
    catalog_file <- paste0("catalogo_", tolower(x), ".csv")
    catalog_file <- file.path(cache_dir, catalog_file)
    has_cache <- file.exists(catalog_file)

    if (all(has_cache, isFALSE(update_cache))) {
      if (verbose) message("tidyBdE> Cached version of ", x, " detected")
    } else {
      # If no catalog is found or requested, update
      if (verbose) message("tidyBdE> Need to download catalog ", x)

      result <- bde_catalog_update(
        catalog = x, cache_dir = cache_dir,
        verbose = verbose
      )

      # On error return NULL
      if (any(is.data.frame(result), isFALSE(result))) {
        message("Download not available for ", x)
        return(NULL)
      }
    }


    # Catch error
    # nocov start
    r <- readLines(catalog_file)
    if (length(r) == 0) {
      message("File ", catalog_file, " not valid")
      return(invisible())
    }
    # nocov end

    catalog_load <- read.csv2(catalog_file,
      sep = ",",
      stringsAsFactors = FALSE, na.strings = "",
      header = FALSE, fileEncoding = "latin1"
    )

    # Convert names
    # Hard-coded, problematic on checks because UTF-8 values
    # Some OS would fail if this workaround is not used
    names_catalog <- c(
      "Nombre_de_la_serie",
      "Numero_secuencial",
      "Alias_de_la_serie",
      "Nombre_del_archivo_con_los_valores_de_la_serie",
      "Descripcion_de_la_serie",
      "Tipo_de_variable",
      "Codigo_de_unidades",
      "Exponente",
      "Numero_de_decimales",
      "Descripcion_de_unidades_y_exponente",
      "Frecuencia_de_la_serie",
      "Fecha_de_la_primera_observacion",
      "Fecha_de_la_ultima_observacion",
      "Numero_de_observaciones",
      "Titulo_de_la_serie",
      "Fuente",
      "Notas"
    )

    # Rename and delete first row
    names(catalog_load) <- names_catalog
    catalog_load <- catalog_load[-1, ]

    catalog_load <- bde_hlp_tochar(catalog_load)
    catalog_load
  })

  res_all <- unlist(lapply(final_catalog, is.null))

  if (any(res_all)) {
    msg <- paste0(catalog_to_load[res_all], collapse = ", ")
    message("tidyBdE> Could not load catalogs: ", msg)
  }

  # Guess formats

  # Unlist
  final_catalog <- dplyr::bind_rows(final_catalog)
  final_catalog <- bde_hlp_guess(final_catalog,
    preserve = names(final_catalog)[c(5, 15)]
  )


  # To tibble
  final_catalog <- tibble::as_tibble(final_catalog)


  # Parse dates dates
  if (parse_dates) {
    if (verbose) {
      message("tidyBdE> Parsing dates")
    }
    date_fields <- names(final_catalog)[grep("Fecha", names(final_catalog))]

    for (i in seq_len(length(date_fields))) {
      field <- date_fields[i]
      final_catalog[field] <- bde_parse_dates(final_catalog[[field]])
    }
  }
  final_catalog
}


#' Update BdE catalogs
#'
#' @description
#' Update the time-series catalogs provided by BdE.
#'
#' @export
#'
#' @family catalog
#'
#' @encoding UTF-8
#'
#' @return None. Downloads the catalog file(s) to the local machine.
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[Time-series bulk data download]",
#'       "(https://www.bde.es/webbe/en/estadisticas/recursos/",
#'       "descargas-completas.html)."))
#'
#'
#' ```
#'
#' @param catalog A vector of characters indicating the catalogs to be updated
#'   or `"ALL"` as a shorthand. See **Details**.
#' @param cache_dir A path to a cache directory. The directory can also be set
#'   via options with `options(bde_cache_dir = "path/to/dir")`.
#' @param verbose Logical `TRUE` or `FALSE`, display information useful for
#'   debugging.
#'
#' @details
#' Accepted values for `catalog` are:
#'
#' ```{r, echo=FALSE}
#'
#' t <- tibble::tribble(
#' ~CODE, ~PUBLICATION, ~UPDATEFREQUENCY, ~FREQUENCY,
#' '`"BE"`', "Statistical Bulletin", "Daily", "Monthly",
#' '`"SI"`', "Summary Indicators", "Daily", "Daily",
#' '`"TC"`', "Exchange Rates", "Daily", "Daily",
#' '`"TI"`', "Interest Rates", "Daily", "Daily",
#' '`"PB"`', "Bank Lending Survey", "Quarterly", "Quarterly",
#' )
#'
#' names(t) <- paste0("**",
#'   c("CODE","PUBLICATION", "UPDATE FREQUENCY", "FREQUENCY"),
#'   "**")
#'
#' knitr::kable(t)
#'
#' ```
#' Use `"ALL"` as a shorthand for updating all the catalogs at a glance.
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' bde_catalog_update("TI", verbose = TRUE)
#' }
bde_catalog_update <- function(catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
                               cache_dir = NULL, verbose = FALSE) {
  catalog <- match.arg(catalog)
  # Validate
  valid_catalogs <- c("BE", "SI", "TC", "TI", "PB", "ALL")
  stopifnot(
    catalog %in% valid_catalogs,
    any(is.null(cache_dir), is.character(cache_dir)),
    is.logical(verbose)
  )

  # nocov start
  if (!bde_check_access()) {
    tbl <- bde_hlp_return_null()
    return(tbl)
  }
  # nocov end

  # Get cache dir
  cache_dir <- bde_hlp_cachedir(cache_dir = cache_dir, verbose = verbose)

  # Loop and download
  catalog_download <- catalog
  if ("ALL" %in% catalog) {
    catalog_download <- valid_catalogs[valid_catalogs != "ALL"]
  }

  if (verbose) {
    message(
      "tidyBdE> Updating catalogs: ",
      paste0(catalog_download, collapse = ", ")
    )
  }

  res <- lapply(catalog_download, function(x) {
    serie <- x
    base_url <- paste0(
      "https://www.bde.es/webbe/es/estadisticas/",
      "compartido/datos/csv/"
    )
    catalog_file <- paste0("catalogo_", tolower(serie), ".csv")

    full_url <- paste0(base_url, catalog_file)
    local_file <- file.path(cache_dir, catalog_file)

    # Download
    result <- bde_hlp_download(
      url = full_url, local_file = local_file,
      verbose = verbose
    )
    result
  })

  return(invisible(res))
}

#' Search BdE catalogs
#'
#' @description
#' Search for keywords on the time-series catalogs.
#'
#' @export
#'
#' @family  catalog
#'
#' @return A [`tibble`][tibble::tibble] object with the results of the query.
#'
#' @param pattern [`regex`][base::regex]  pattern to search See **Details**
#'   and **Examples**.
#'
#' @inheritDotParams bde_catalog_load
#'
#' @encoding UTF-8
#'
#' @details
#' **Note that** BdE files are only provided in Spanish, for the time being.
#' Therefore search terms should be provided in Spanish as well in order to get
#' search results.
#'
#' This function uses [base::grep()] function for finding matches on
#' the catalogs. You can pass [regular expressions][base::regex] to broaden
#' the search.
#'
#' @seealso [bde_catalog_load()], [base::regex]
#'
#' @examplesIf bde_check_access()
#' \donttest{
#' # Simple search (needs to be in Spanish)
#' # !! PIB [es] == GDP [en]
#'
#' bde_catalog_search("PIB")
#'
#' # More complex - Single
#' bde_catalog_search("Francia(.*)PIB")
#'
#' # Even more complex - Double
#' bde_catalog_search("Francia(.*)PIB|Italia(.*)PIB|Alemania(.*)PIB")
#'
#'
#' # Search a sequential code: Exact match
#' # Note that this series (sequential code) appears on several tables
#'
#' bde_catalog_search("^3779313$")
#' }
bde_catalog_search <- function(pattern, ...) {
  # Extract info
  catalog_search <- bde_catalog_load(...)

  # nocov start
  if (nrow(catalog_search) == 0) {
    tbl <- bde_hlp_return_null()
    return(tbl)
  }

  if (!tibble::is_tibble(catalog_search)) {
    message("Catalogs corrupted. Try redownloading with bde_catalog_update()")
    return(invisible())
  }
  # nocov end

  # Index lookup columns
  col_ind <- c(2, 3, 4, 5, 15)

  search_match_rows <- NULL
  # Loop thorugh cols
  for (i in col_ind) {
    search_match_rows <- unique(
      c(search_match_rows, grep(pattern, catalog_search[[i]],
        ignore.case = TRUE, useBytes = TRUE
      ))
    )
  }

  search_results <- catalog_search[search_match_rows, ]
  if (nrow(search_results) == 0) {
    stop("tidyBdE> No matches found for ", pattern)
  }
  search_results
}
