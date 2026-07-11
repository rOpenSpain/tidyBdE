test_that("On CRAN", {
  # Imagine we are in CRAN
  withr::local_envvar(NOT_CRAN = "false")
  expect_true(on_cran())
  expect_false(bde_check_access())
})

test_that("On CRAN falls back to interactivity when NOT_CRAN is unset", {
  withr::local_envvar(NOT_CRAN = "")
  expect_identical(!interactive(), on_cran())
})

test_that("Check url access", {
  skip_on_cran()
  skip_if_bde_offline()

  expect_true(bde_check_access())
})

test_that("Check url access handles unreachable resources", {
  withr::local_envvar(NOT_CRAN = "true")
  local_mocked_bindings(bde_check_url = function(...) {
    "http://ropenspain.github.io/tidyBdE/donotexist"
  })
  expect_false(bde_check_access())
})

test_that("Check url access cleans up temporary downloads", {
  withr::local_envvar(NOT_CRAN = "true")
  downloaded_file <- NULL

  local_mocked_bindings(download.file = function(url, destfile, ...) {
    downloaded_file <<- destfile
    writeLines("ok", destfile)
    0
  })

  expect_true(bde_check_access())
  expect_false(file.exists(downloaded_file))
})
