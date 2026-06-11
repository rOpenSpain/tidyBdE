#' Check BdE access
#'
#' @description
#' Check whether \R can access resources at
#' <https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.
#'
#' @return A logical value indicating whether BdE resources are reachable.
#'
#' @export
#' @encoding UTF-8
#' @keywords internal
#'
#' @examples
#' \donttest{
#' bde_check_access()
#' }
bde_check_access <- function() {
  # Use an internal option for testing purposes only.
  if (on_cran()) {
    return(FALSE)
  }

  url <- paste0(
    "https://www.bde.es/webbde/es/",
    "estadis/infoest/series/catalogo_tc.csv"
  )

  access <- tryCatch(
    download.file(url, destfile = tempfile(), quiet = TRUE, mode = "wb"),
    warning = function(e) {
      FALSE # nocov
    }
  )

  !isFALSE(access)
}

#' Check whether the current session is running on CRAN
#'
#' @return A logical.
#' @noRd
on_cran <- function() {
  # nocov start
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive()
  } else {
    !isTRUE(as.logical(env))
  }
  # nocov end
}
