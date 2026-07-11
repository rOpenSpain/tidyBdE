test_that("Catalogs offline", {
  skip_on_cran()
  skip_if_bde_offline()

  dir <- local_bde_cache()

  expect_silent(bde_catalog_update("TI", cache_dir = dir))

  local_mocked_bindings(on_cran = function(...) {
    TRUE
  })

  expect_message(bde_catalog_update("TC", cache_dir = dir), "empty")

  table1 <- bde_catalog_load("TI", cache_dir = dir)
  all <- bde_catalog_load("ALL", cache_dir = dir)

  expect_equal(nrow(table1), nrow(all))

  null <- bde_catalog_load("TC", cache_dir = dir)

  expect_s3_class(null, "data.frame")
  expect_equal(nrow(null), 0)

  search <- as.double(table1[1, 2])

  s <- bde_catalog_search(search, catalog = "TI", cache_dir = dir)

  expect_gte(nrow(s), 1)

  s2 <- bde_catalog_search(search, catalog = "TC", cache_dir = dir)
  expect_equal(nrow(s2), 0)

  # Now try online
  local_mocked_bindings(on_cran = function(...) {
    FALSE
  })

  nonull <- bde_catalog_load("TC", cache_dir = dir)
  expect_gt(nrow(nonull), 0)
})

test_that("Messages", {
  skip_on_cran()
  skip_if_bde_offline()

  dir <- local_bde_cache()

  expect_message(
    s <- bde_catalog_load("TC", verbose = TRUE, cache_dir = dir),
    "Downloading catalog|Using cached catalog"
  )
  expect_snapshot(names(s))
  expect_message(
    bde_catalog_load("TC", verbose = TRUE, cache_dir = dir),
    "Using cached catalog"
  )
})

test_that("Fully Deprecation of Series", {
  dir <- local_bde_cache()

  expect_snapshot(error = TRUE, bde_catalog_update("IE", cache_dir = dir))
  expect_snapshot(error = TRUE, bde_catalog_update("CF", cache_dir = dir))
})

test_that("No results", {
  skip_on_cran()
  skip_if_bde_offline()
  expect_snapshot(error = TRUE, bde_catalog_search("GDP", catalog = "TI"))
})

test_that("No results with malformed catalog data", {
  local_mocked_bindings(bde_catalog_load = function(...) {
    data.frame(a = 1)
  })

  expect_snapshot(bde_catalog_search("TC", catalog = "TC"))
})

test_that("Mocks expand all", {
  dir <- local_bde_cache()

  # Expand all
  local_mocked_bindings(
    bde_check_access = function(...) {
      TRUE
    },
    bde_hlp_download = function(...) {
      TRUE
    }
  )
  res <- bde_catalog_update("ALL", cache_dir = dir)
  expect_all_true(unlist(res))
  expect_length(res, 5)
})

test_that("Mock bad catalog file", {
  dir <- local_bde_cache()

  local_mocked_bindings(bde_catalog_update = function(
    catalog = "a",
    cache_dir = dir,
    verbose = FALSE
  ) {
    file.create(file.path(cache_dir, "catalogo_tc.csv"))
  })

  expect_message(
    bde_catalog_load(
      "TC",
      verbose = FALSE,
      cache_dir = dir
    ),
    "is empty"
  )
})

test_that("Catalogs load cached files and parse search results offline", {
  dir <- local_bde_cache()
  write_test_catalog(dir, "TC")

  expect_snapshot(
    catalog <- bde_catalog_load("TC", cache_dir = dir, verbose = TRUE),
    transform = scrub_test_paths
  )
  expect_equal(catalog$Numero_secuencial, c(101, 102))
  expect_s3_class(catalog$Fecha_de_la_primera_observacion, "Date")

  raw <- bde_catalog_load("TC", cache_dir = dir, parse_dates = FALSE)
  expect_type(raw$Fecha_de_la_primera_observacion, "character")

  found <- bde_catalog_search("PIB", catalog = "TC", cache_dir = dir)
  expect_equal(found$Numero_secuencial, 101)
  expect_snapshot(error = TRUE, {
    bde_catalog_search("not-found", catalog = "TC", cache_dir = dir)
  })
})

test_that("Catalogs report unavailable updates offline", {
  dir <- local_bde_cache()

  local_mocked_bindings(bde_check_access = function(...) FALSE)

  expect_snapshot(
    res <- bde_catalog_update("TC", cache_dir = dir, verbose = TRUE)
  )
  expect_identical(res, dplyr::tibble())
  expect_snapshot(
    catalog <- bde_catalog_load("TC", cache_dir = dir, verbose = TRUE),
    transform = scrub_test_paths
  )
  expect_equal(nrow(catalog), 0)
})

test_that("Catalogs expand ALL from cached files offline", {
  dir <- local_bde_cache()
  for (catalog in c("BE", "SI", "TC", "TI", "PB")) {
    write_test_catalog(dir, catalog)
  }

  catalog <- bde_catalog_load("ALL", cache_dir = dir, parse_dates = FALSE)
  expect_equal(nrow(catalog), 10)
})

test_that("Catalog search returns an empty tibble when catalog data is empty", {
  local_mocked_bindings(bde_catalog_load = function(...) dplyr::tibble())

  expect_snapshot(empty <- bde_catalog_search("anything"))
  expect_identical(empty, dplyr::tibble())
})

test_that("Catalog update reports verbose update plans", {
  dir <- local_bde_cache()

  local_mocked_bindings(
    bde_check_access = function(...) TRUE,
    bde_hlp_download = function(...) TRUE
  )

  expect_snapshot(
    bde_catalog_update("TC", cache_dir = dir, verbose = TRUE),
    transform = scrub_test_paths
  )
})
