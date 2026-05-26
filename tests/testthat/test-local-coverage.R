test_that("catalog helpers work with local CSV files", {
  dir <- file.path(tempdir(), "tidybde-local-catalogs")
  unlink(dir, recursive = TRUE, force = TRUE)
  write_test_catalog(dir, "TC")

  expect_message(
    catalog <- bde_catalog_load("TC", cache_dir = dir, verbose = TRUE),
    "Using cached catalog"
  )

  expect_s3_class(catalog, "tbl_df")
  expect_equal(nrow(catalog), 1)
  expect_equal(catalog$Numero_secuencial, 12345)
  expect_s3_class(catalog$Fecha_de_la_primera_observacion, "Date")

  raw_catalog <- bde_catalog_load("TC", cache_dir = dir, parse_dates = FALSE)
  expect_type(raw_catalog$Fecha_de_la_primera_observacion, "character")

  found <- bde_catalog_search("Titulo", catalog = "TC", cache_dir = dir)
  expect_equal(found$Alias_de_la_serie, "ALIAS1")

  expect_error(
    bde_catalog_search("No existe", catalog = "TC", cache_dir = dir),
    "No matches found"
  )
})

test_that("catalog updates can be tested without network access", {
  dir <- file.path(tempdir(), "tidybde-local-update")
  unlink(dir, recursive = TRUE, force = TRUE)

  testthat::local_mocked_bindings(
    bde_check_access = function() TRUE,
    bde_hlp_download = function(url, local_file, verbose) {
      catalog <- sub("catalogo_([a-z]+)[.]csv$", "\\1", basename(local_file))
      write_test_catalog(dirname(local_file), toupper(catalog))
      TRUE
    }
  )

  expect_message(
    bde_catalog_update("TC", cache_dir = dir, verbose = TRUE),
    "Updating catalogs: TC\\."
  )
  expect_true(file.exists(file.path(dir, "catalogo_tc.csv")))

  expect_message(
    bde_catalog_update("ALL", cache_dir = dir, verbose = TRUE),
    "Updating catalogs: BE, SI, TC, TI, PB\\."
  )
})

test_that("cache helper covers option, suffix and creation paths", {
  dir <- file.path(tempdir(), "tidybde-cache-helper")
  unlink(dir, recursive = TRUE, force = TRUE)

  expect_message(
    created <- bde_hlp_cachedir(dir, verbose = TRUE),
    "Created cache directory"
  )
  expect_equal(created, dir)

  options(bde_cache_dir = dir)
  on.exit(options(bde_cache_dir = NULL))

  expect_message(
    from_option <- bde_hlp_cachedir(verbose = TRUE, suffix = "TC"),
    "Using cache directory from options"
  )
  expect_equal(basename(from_option), "TC")

  options(bde_cache_dir = NULL)
  expect_message(
    temp_cache <- bde_hlp_cachedir(verbose = TRUE, suffix = "SI"),
    "Using temporary cache directory"
  )
  expect_equal(basename(temp_cache), "SI")
})

test_that("series loaders work with local CSV files", {
  dir <- file.path(tempdir(), "tidybde-local-series")
  unlink(dir, recursive = TRUE, force = TRUE)
  write_test_catalog(dir, "TC")
  write_test_series(dir, "TC_1_1.csv")

  expect_message(
    full <- bde_series_full_load("TC_1_1.csv", cache_dir = dir, verbose = TRUE),
    "Reading file"
  )
  expect_s3_class(full, "tbl_df")
  expect_equal(names(full), c("Date", "ALIAS1", "ALIAS2"))
  expect_s3_class(full$Date, "Date")
  expect_equal(full$ALIAS1[1], 1.5)
  expect_true(is.na(full$ALIAS1[2]))

  raw <- bde_series_full_load(
    "TC_1_1",
    cache_dir = dir,
    parse_dates = FALSE,
    parse_numeric = FALSE
  )
  expect_type(raw$Date, "character")
  expect_type(raw$ALIAS1, "character")

  meta <- bde_series_full_load(
    "TC_1_1.csv",
    cache_dir = dir,
    extract_metadata = TRUE
  )
  expect_equal(nrow(meta), 6)

  wide <- bde_series_load(
    12345,
    series_label = "Test series",
    cache_dir = dir
  )
  expect_equal(names(wide), c("Date", "Test series"))

  long <- bde_series_load(
    12345,
    series_label = "Test series",
    cache_dir = dir,
    out_format = "long"
  )
  expect_equal(names(long), c("Date", "serie_name", "serie_value"))
  expect_s3_class(long$serie_name, "factor")
})

test_that("series loader reports unavailable aliases", {
  dir <- file.path(tempdir(), "tidybde-local-missing-alias")
  unlink(dir, recursive = TRUE, force = TRUE)
  catalog_file <- write_test_catalog(dir, "TC")
  catalog <- readLines(catalog_file)
  catalog <- sub("ALIAS1", "MISSING_ALIAS", catalog, fixed = TRUE)
  writeLines(catalog, catalog_file)
  write_test_series(dir, "TC_1_1.csv")

  expect_message(
    out <- bde_series_load(12345, cache_dir = dir, verbose = TRUE),
    "not available"
  )
  expect_equal(nrow(out), 0)
})

test_that("series loader validates labels before loading catalogs", {
  expect_error(
    bde_series_load(c(1, 2), series_label = c("a", NA)),
    "must not contain missing values"
  )
  expect_error(
    bde_series_load(c(1, 2), series_label = "a"),
    "must have the same length"
  )
})

test_that("series loader reports missing catalog matches", {
  dir <- file.path(tempdir(), "tidybde-local-missing-code")
  unlink(dir, recursive = TRUE, force = TRUE)
  write_test_catalog(dir, "TC")

  expect_message(
    out <- bde_series_load(99999, cache_dir = dir, verbose = TRUE),
    "was not found in catalogs"
  )
  expect_equal(nrow(out), 0)
})

test_that("full series loader covers download branches", {
  dir <- file.path(tempdir(), "tidybde-local-download")
  unlink(dir, recursive = TRUE, force = TRUE)

  options(bde_test_offline = TRUE)
  on.exit(options(bde_test_offline = FALSE))

  expect_message(
    offline <- bde_series_full_load("TC_1_2.csv", cache_dir = dir),
    "Testing offline mode"
  )
  expect_equal(nrow(offline), 0)

  options(bde_test_offline = FALSE)
  testthat::local_mocked_bindings(
    bde_check_access = function() TRUE,
    bde_hlp_download = function(url, local_file, verbose) {
      writeLines(character(), local_file)
      FALSE
    }
  )

  expect_null(bde_series_full_load("TC_1_3.csv", cache_dir = dir))
  expect_false(file.exists(file.path(dir, "TC", "tc_1_3.csv")))
})

test_that("full series loader creates default cache subdirectories", {
  unlink(file.path(tempdir(), "ZZ"), recursive = TRUE, force = TRUE)
  options(bde_test_offline = TRUE)
  on.exit(options(bde_test_offline = FALSE))

  expect_message(
    out <- bde_series_full_load("ZZ_1_1.csv", cache_dir = NULL),
    "Testing offline mode"
  )
  expect_equal(nrow(out), 0)
  expect_true(dir.exists(file.path(tempdir(), "ZZ")))
})

test_that("download helper handles mocked warnings", {
  local_file <- tempfile()
  testthat::local_mocked_bindings(
    download.file = function(...) {
      warning("offline")
    }
  )

  expect_message(
    ok <- bde_hlp_download("https://example.com/file.csv", local_file, TRUE),
    "Trying again|not reachable"
  )
  expect_false(ok)
})

test_that("download helper reports successful downloads", {
  local_file <- tempfile()
  testthat::local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      writeLines("ok", destfile)
      0
    }
  )

  expect_message(
    ok <- bde_hlp_download("https://example.com/file.csv", local_file, TRUE),
    "Downloading file"
  )
  expect_true(ok)
  expect_true(file.exists(local_file))
})

test_that("type conversion helpers convert non-preserved columns", {
  tbl <- tibble::tibble(
    keep = 1,
    convert = 2,
    text = "3"
  )

  as_char <- bde_hlp_tochar(tbl, preserve = "keep")
  expect_type(as_char$keep, "double")
  expect_type(as_char$convert, "character")

  as_double <- bde_hlp_todouble(as_char, preserve = "convert")
  expect_type(as_double$text, "double")
  expect_type(as_double$convert, "character")
})

test_that("indicator wrappers delegate to the shared loader", {
  testthat::local_mocked_bindings(
    bde_series_load = function(series_code, series_label, ...) {
      tibble::tibble(
        Date = as.Date(c("2020-01-01", "2020-01-02")),
        value = c(NA, 1)
      )
    }
  )

  indicators <- list(
    bde_ind_gdp_var(),
    bde_ind_unemployment_rate(),
    bde_ind_euribor_12m_monthly(),
    bde_ind_euribor_12m_daily(),
    bde_ind_cpi_var(),
    bde_ind_ibex_monthly(),
    bde_ind_ibex_daily(),
    bde_ind_gdp_quarterly(),
    bde_ind_population()
  )

  expect_true(all(vapply(indicators, nrow, integer(1)) == 1))
})
