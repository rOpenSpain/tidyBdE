test_that("Indicators", {
  skip_if_not(
    tidyBdE:::bde_check_access(),
    "Skipping...  BdE not reachable."
  )

  # Test load series all----
  expect_null(bde_series_full_load("aa"))

  expect_message(bde_series_full_load("TI_1_1.csv",
    cache_dir = tempdir(),
    verbose = TRUE
  ))
  expect_message(bde_series_full_load("TI_1_1.csv",
    cache_dir = NULL,
    verbose = TRUE
  ))
  expect_message(bde_series_full_load("CF0101.csv",
    cache_dir = NULL,
    verbose = TRUE
  ))
  expect_silent(bde_series_full_load("CF0101"))


  data <- bde_series_full_load("TI_1_1.csv")
  meta <-
    bde_series_full_load("TI_1_1.csv", extract_metadata = TRUE)

  expect_true(nrow(data) > nrow(meta))


  # Test load series ----
  expect_error(bde_series_load("aa"))
  expect_error(bde_series_load(12345678910))
  expect_error(bde_series_load(c(573234, 573214), series_label = c(1, NA)))
  expect_error(bde_series_load(c(573234, 573214), series_label = c("1", "1")))
  expect_error(bde_series_load(c(573234, 573234), series_label = c("a", "b")))


  expect_silent(bde_series_load(c(573234, 573214), series_label = c("a", "b")))

  expect_silent(bde_series_load(573234, series_label = "a"))
  expect_silent(bde_series_load(573234, series_label = NULL))
  expect_silent(bde_series_load(573234, extract_metadata = TRUE))
  expect_message(bde_series_load(573234, verbose = TRUE))

  meta <- bde_series_load(573234, extract_metadata = TRUE)
  data <- bde_series_load(573234, extract_metadata = FALSE)
  expect_true(nrow(data) > nrow(meta))
})
