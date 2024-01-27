#' Check access to BdE
#'
#' @description
#' Check if R has access to resources at
#' <https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.
#'
#' @return a logical.
#'
#' @keywords internal
#'
#' @examples
#' \donttest{
#' bde_check_access()
#' }
#' @export
bde_check_access <- function() {
  # Internal option, for checking purposes only
  # nocov start
  test <- getOption("bde_test_offline", NULL)
  if (isTRUE(test)) {
    message("dev> Testing offline")
    return(FALSE)
  }
  # nocov end

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
