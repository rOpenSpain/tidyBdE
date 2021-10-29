#' Check access to BdE
#'
#'
#' @description
#' Check if R has access to resources at
#' <https://www.bde.es/webbde/en/estadis/infoest/descarga_series_temporales.html>.
#'
#' @return a logical.
#'
#' @family utils
#'
#' @examples
#' \donttest{
#' bde_check_access()
#' }
#' @export
bde_check_access <- function() {
  url <- paste0(
    "https://www.bde.es/webbde/es/",
    "estadis/infoest/series/catalogo_tc.csv"
  )
  # nocov start
  access <-
    tryCatch(
      download.file(url, destfile = tempfile(), quiet = TRUE),
      warning = function(e) {
        return(FALSE)
      }
    )

  if (isFALSE(access)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
  # nocov end
}

#' Skip tests
#' @noRd
skip_if_bde_offline <- function() {
  # nocov start
  if (bde_check_access()) {
    return(invisible(TRUE))
  }

  if (requireNamespace("testthat", quietly = TRUE)) {
    testthat::skip("tidyBdE> BdE API not reachable")
  }
  return(invisible())
  # nocov end
}
