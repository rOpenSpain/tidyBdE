#' Check access to BdE resources
#'
#' @description
#' Checks whether \R can access BdE resources at
#' <https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.
#'
#' @return A logical value indicating whether BdE resources are reachable.
#'
#' @keywords internal
#' @export
#' @encoding UTF-8
#'
#' @examples
#' \donttest{
#' bde_check_access()
#' }
bde_check_access <- function() {
  # Skip the access check on CRAN.
  if (on_cran()) {
    return(FALSE)
  }

  url <- bde_check_url()
  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  access <- tryCatch(
    download.file(url, destfile = tmp, quiet = TRUE, mode = "wb"),
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
