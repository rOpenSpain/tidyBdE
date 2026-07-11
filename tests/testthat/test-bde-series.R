test_that("Series load returns null when catalog is empty", {
  local_mocked_bindings(bde_catalog_load = function(...) dplyr::tibble())
  expect_identical(bde_series_load(573234), bde_hlp_return_null())
})

test_that("Series load validates labels offline", {
  expect_snapshot(
    error = TRUE,
    bde_series_load(c(101, 102), series_label = c("one", NA))
  )
  expect_snapshot(
    error = TRUE,
    bde_series_load(c(101, 102), series_label = c("same", "same"))
  )
})

test_that("Indicators", {
  expect_error(bde_series_load(), "`series_code` cannot be missing")

  skip_on_cran()
  skip_if_bde_offline()

  # Test load series all----
  expect_null(bde_series_full_load("aa"))

  expect_message(
    bde_series_full_load(
      "TI_1_1.csv",
      cache_dir = local_bde_cache(),
      verbose = TRUE
    ),
    "Reading file .*ti_1_1.csv.* from cache\\.|Downloading file from"
  )
  expect_message(
    bde_series_full_load("TI_1_1.csv", cache_dir = NULL, verbose = TRUE),
    "Reading file .*ti_1_1.csv.* from cache\\.|Downloading file from"
  )
  expect_message(
    bde_series_full_load("CF0101.csv", cache_dir = NULL, verbose = TRUE),
    "Reading file .*cf0101.csv.* from cache\\.|Downloading file from"
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
    "`series_label` must not contain missing values\\."
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
  expect_message(bde_series_load(573234, verbose = TRUE), "Extracting series")

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
  expect_s3_class(long$serie_name, "factor")
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
  dir <- local_bde_cache()

  # Test all offline

  # Get a series
  tc_catalog <- bde_catalog_load("TI", cache_dir = dir)

  all_tables <- tc_catalog$Nombre_del_archivo_con_los_valores_de_la_serie
  all_names <- as.character(unique(all_tables))

  full_1 <- bde_series_full_load(all_names[1], cache_dir = dir)

  expect_s3_class(full_1, "data.frame")
  expect_gt(nrow(full_1), 5)

  # Test offline
  local_mocked_bindings(on_cran = function(...) {
    TRUE
  })

  # Can't download series
  expect_message(bde_series_full_load(all_names[2], cache_dir = dir), "empty")

  fail <- bde_series_full_load(all_names[2], cache_dir = dir)
  expect_equal(nrow(fail), 0)

  # But can reload cached series
  expect_silent(bde_series_full_load(all_names[1], cache_dir = dir))
  full_2 <- bde_series_full_load(all_names[1], cache_dir = dir)

  expect_identical(full_1, full_2)

  # Now try online
  local_mocked_bindings(on_cran = function(...) {
    FALSE
  })

  failfix <- bde_series_full_load(all_names[2], cache_dir = dir)
  expect_gt(nrow(failfix), 10)
})
test_that("Mock files series", {
  local_mocked_bindings(
    bde_catalog_load = function(...) {
      dplyr::tibble(
        catalog = c("TI", "TI"),
        Numero_secuencial = c(573234, 573214),
        Alias_de_la_serie = c("A", "B"),
        Nombre_del_archivo_con_los_valores_de_la_serie = c("a.csv", "b.csv")
      )
    },
    bde_series_full_load = function(...) {
      dplyr::tibble()
    }
  )

  expect_message(
    long <- bde_series_load(
      c(573234, 573214),
      series_label = c("a", "b"),
      out_format = "long",
      extract_metadata = TRUE
    ),
    "BdE resources are unavailable"
  )
  local_mocked_bindings(bde_series_full_load = function(...) {
    dplyr::tibble(no_name = 1, another = 2, more = 2, and_more = 2)
  })
  expect_message(
    long <- bde_series_load(
      c(573234, 573214),
      series_label = c("a", "b"),
      out_format = "long",
      verbose = TRUE
    ),
    "BdE resources are unavailable"
  )
})

test_that("Mock files all", {
  dir <- local_bde_cache()
  fpath <- file.path(dir, "TI", "ti_1_1.csv")
  dir.create(dirname(fpath), recursive = TRUE, showWarnings = FALSE)
  writeLines(" ", fpath)

  expect_true(file.exists(fpath))
  local_mocked_bindings(bde_hlp_download = function(...) {
    TRUE
  })

  expect_silent(
    ss <- bde_series_full_load(
      "TI_1_1.csv",
      cache_dir = dir,
      verbose = FALSE
    )
  )
  unlink(fpath)
})

test_that("Mock files cleanup", {
  dir <- local_bde_cache()

  local_mocked_bindings(
    bde_check_access = function(...) {
      TRUE
    },
    bde_hlp_download = function(url, local_file, verbose) {
      writeLines("a", local_file)
      FALSE
    }
  )

  expect_silent(
    ss <- bde_series_full_load(
      "TI_1_1.csv",
      cache_dir = dir,
      verbose = FALSE
    )
  )
})

test_that("Mock files empty download", {
  dir <- local_bde_cache()

  local_mocked_bindings(
    bde_check_access = function(...) {
      TRUE
    },
    bde_hlp_download = function(url, local_file, verbose) {
      file.create(local_file, showWarnings = FALSE)
      TRUE
    }
  )

  expect_message(
    ss <- bde_series_full_load(
      "TI_1_1.csv",
      cache_dir = dir,
      verbose = FALSE
    ),
    "is empty"
  )
})

test_that("Series full load reads cached CSV variants offline", {
  dir <- local_bde_cache()
  write_test_series(dir, "tc_1_1.csv")

  expect_snapshot(
    data <- bde_series_full_load(
      "tc_1_1",
      cache_dir = dir,
      verbose = TRUE
    ),
    transform = scrub_test_paths
  )
  expect_named(data, c("Date", "A", "B"))
  expect_s3_class(data$Date, "Date")
  expect_type(data$A, "double")

  raw <- bde_series_full_load(
    "tc_1_1.csv",
    cache_dir = dir,
    parse_dates = FALSE,
    parse_numeric = FALSE
  )
  expect_type(raw$Date, "character")
  expect_type(raw$A, "character")

  meta <- bde_series_full_load(
    "tc_1_1.csv",
    cache_dir = dir,
    extract_metadata = TRUE
  )
  expect_equal(nrow(meta), 6)
})

test_that("Series load reshapes mocked catalog and cached data", {
  dir <- local_bde_cache()
  write_test_series(dir, "tc_1_1.csv")

  local_mocked_bindings(bde_catalog_load = function(...) mock_catalog())

  wide <- bde_series_load(
    c(101, 102),
    series_label = c("one", "two"),
    cache_dir = dir
  )
  expect_named(wide, c("Date", "one", "two"))
  expect_equal(nrow(wide), 2)

  long <- bde_series_load(
    c(101, 102),
    series_label = c("one", "two"),
    out_format = "long",
    cache_dir = dir
  )
  expect_named(long, c("Date", "serie_name", "serie_value"))
  expect_equal(levels(long$serie_name), c("one", "two"))

  expect_snapshot(
    missing <- bde_series_load(999, cache_dir = dir, verbose = TRUE)
  )
  expect_equal(nrow(missing), 0)
})

test_that("Series full load handles offline download branches", {
  dir <- local_bde_cache()
  write_test_series(dir, "tc_1_1.csv")

  local_mocked_bindings(bde_check_access = function(...) FALSE)

  expect_snapshot(
    empty <- bde_series_full_load(
      "tc_1_1.csv",
      cache_dir = dir,
      update_cache = TRUE
    )
  )
  expect_equal(nrow(empty), 0)
})

test_that("Series full load creates family subdirectories", {
  dir <- local_bde_cache()
  family_dir <- file.path(dir, "TC")

  local_mocked_bindings(
    bde_hlp_cachedir = function(...) family_dir,
    bde_check_access = function(...) FALSE
  )

  expect_snapshot(empty <- bde_series_full_load("tc_1_1.csv", cache_dir = dir))
  expect_true(dir.exists(family_dir))
  expect_equal(nrow(empty), 0)
})
