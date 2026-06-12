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
    "https://www.bde.es/webbe/es/estadisticas/",
    "compartido/datos/zip/be01.zip"
  )

  # nocov start
  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout), add = TRUE)

  timeout <- getOption("bde_api_timeout", 10)
  options(timeout = min(old_timeout, timeout))
  # nocov end

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
#' @return A logical value.
#'
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
