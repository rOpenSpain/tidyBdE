#' Check BdE access
#'
#' @description
#' Check whether **R** can access resources at
#' <https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.
#'
#' @return A logical value indicating whether BdE resources are reachable.
#'
#' @keywords internal
#'
#' @examples
#' \donttest{
#' bde_check_access()
#' }
#' @export
#' @encoding UTF-8
bde_check_access <- function() {
  # Use an internal option for testing purposes only.
  # nocov start
  test <- getOption("bde_test_offline", NULL)
  if (isTRUE(test)) {
    message("tidyBdE> Testing offline.")
    return(FALSE)
  }
  # nocov end

  url <- paste0(
    "https://www.bde.es/webbde/es/",
    "estadis/infoest/series/catalogo_tc.csv"
  )
  # nocov start
  access <- tryCatch(
    download.file(url, destfile = tempfile(), quiet = TRUE, mode = "wb"),
    warning = function(e) {
      FALSE
    }
  )

  if (isFALSE(access)) {
    res <- FALSE
  } else {
    res <- TRUE
  }
  res
  # nocov end
}

#' Skip tests if BdE is offline
#' @noRd
skip_if_bde_offline <- function() {
  # nocov start
  if (bde_check_access()) {
    return(invisible(TRUE))
  }

  if (requireNamespace("testthat", quietly = TRUE)) {
    testthat::skip("tidyBdE> BdE API is not reachable.")
  }
  invisible()
  # nocov end
}
