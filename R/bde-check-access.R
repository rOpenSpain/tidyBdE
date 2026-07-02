#' Check access to BdE resources
#'
#' @description
#' Checks whether \R can access BdE resources at
#' <https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.
#'
#' @return A logical value indicating whether BdE resources are reachable.
#'
#' @keywords internal
#' @encoding UTF-8
#' @export
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

  url <- bde_check_url()
  access <- tryCatch(
    download.file(url, destfile = tempfile(), quiet = TRUE, mode = "wb"),
    warning = function(e) {
      FALSE
    }
  )

  !isFALSE(access)
}

#' Check whether the current session is running on CRAN
#'
#' @return A logical value.
#'
#' @noRd
on_cran <- function() {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive()
  } else {
    !isTRUE(as.logical(env))
  }
}

bde_check_url <- function() {
  url <- paste0(
    "https://www.bde.es/webbe/es/estadisticas/",
    "compartido/datos/zip/be01.zip"
  )
  url
}
