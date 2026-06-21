skip_if_bde_offline <- function() {
  if (bde_check_access()) {
    return(invisible(TRUE))
  }

  testthat::skip("BdE API is not reachable.")
  invisible()
}
