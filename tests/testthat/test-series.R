test_that("Indicators", {
  expect_error(bde_series_load(), "`series_code` cannot be missing")

  skip_on_cran()
  skip_if_bde_offline()

  # Test load series all----
  expect_null(bde_series_full_load("aa"))

  expect_message(
    bde_series_full_load(
      "TI_1_1.csv",
      cache_dir = tempdir(),
      verbose = TRUE
    ),
    "Reading file ti_1_1.csv from cache\\.|Downloading file from"
  )
  expect_message(
    bde_series_full_load(
      "TI_1_1.csv",
      cache_dir = NULL,
      verbose = TRUE
    ),
    "Reading file ti_1_1.csv from cache\\.|Downloading file from"
  )
  expect_message(
    bde_series_full_load(
      "CF0101.csv",
      cache_dir = NULL,
      verbose = TRUE
    ),
    "Reading file cf0101.csv from cache\\.|Downloading file from"
  )
  expect_silent(bde_series_full_load("CF0101"))

  data <- bde_series_full_load("TI_1_1.csv")
  meta <- bde_series_full_load("TI_1_1.csv", extract_metadata = TRUE)

  expect_true(nrow(data) > nrow(meta))

  # Test load series ----
  expect_warning(bde_series_load("aa"))
  expect_identical(bde_series_load(12345678910), bde_hlp_return_null())
  expect_error(
    bde_series_load(c(573234, 573214), series_label = c(1, NA)),
    "`series_label` must not contain NA values\\."
  )
  expect_error(
    bde_series_load(c(573234, 573214), series_label = c("1", "1")),
    "`series_label` and `series_code` must have the same length\\."
  )
  expect_error(
    bde_series_load(573234, series_label = c("a", "b")),
    "`series_label` and `series_code` must have the same length\\."
  )

  expect_silent(bde_series_load(c(573234, 573214), series_label = c("a", "b")))

  expect_silent(bde_series_load(573234, series_label = "a"))
  expect_silent(bde_series_load("573234", series_label = "a"))
  expect_warning(bde_series_load(c("573234", "a")))
  expect_silent(bde_series_load(573234, series_label = NULL))
  expect_silent(bde_series_load(573234, extract_metadata = TRUE))
  expect_message(
    bde_series_load(573234, verbose = TRUE),
    "Extracting series 573234\\."
  )

  meta <- bde_series_load(573234, extract_metadata = TRUE)
  data <- bde_series_load(573234, extract_metadata = FALSE)
  expect_true(nrow(data) > nrow(meta))

  # Test long and wide
  wide <- bde_series_load(c(573234, 573214), series_label = c("a", "b"))
  long <- bde_series_load(
    c(573234, 573214),
    series_label = c("a", "b"),
    out_format = "long"
  )

  expect_equal(ncol(long), 3)
  expect_true(nrow(long) > nrow(wide))
  expect_equal(class(long$serie_name), "factor")
  expect_equal(levels(long$serie_name), names(wide[, -1]))

  # Wide and long does not affect on metadata
  wide <- bde_series_load(
    c(573234, 573214),
    series_label = c("a", "b"),
    extract_metadata = TRUE
  )
  long <- bde_series_load(
    c(573234, 573214),
    series_label = c("a", "b"),
    out_format = "long",
    extract_metadata = TRUE
  )
  expect_identical(wide, long)
})

test_that("Series full", {
  skip_on_cran()
  skip_if_bde_offline()
  dir <- file.path(tempdir(), paste0("testoff", sample.int(10, 1)))

  # Test all offline

  # Get a series
  tc_catalog <- bde_catalog_load("TI", cache_dir = dir)

  all_tables <- tc_catalog$Nombre_del_archivo_con_los_valores_de_la_serie
  all_names <- as.character(unique(all_tables))

  full_1 <- bde_series_full_load(all_names[1], cache_dir = dir)

  expect_s3_class(full_1, "data.frame")
  expect_gt(nrow(full_1), 5)

  options(bde_test_offline = TRUE)
  # Can't download series
  expect_message(
    bde_series_full_load(all_names[2], cache_dir = dir),
    "Testing offline\\."
  )

  fail <- bde_series_full_load(all_names[2], cache_dir = dir)
  expect_equal(nrow(fail), 0)

  # But can reload cached series
  expect_silent(bde_series_full_load(all_names[1], cache_dir = dir))
  full_2 <- bde_series_full_load(all_names[1], cache_dir = dir)

  expect_identical(full_1, full_2)

  # Now try online
  options(bde_test_offline = FALSE)

  failfix <- bde_series_full_load(all_names[2], cache_dir = dir)
  expect_gt(nrow(failfix), 10)
})
