test_that("Catalogs offline", {
  skip_on_cran()
  skip_if_bde_offline()

  dir <- file.path(tempdir(), "test_catalogs")

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

  dir <- file.path(tempdir(), "test_catalogs2")

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
  expect_error(bde_catalog_update("IE", cache_dir = tempdir()))
  expect_error(bde_catalog_update("CF", cache_dir = tempdir()))
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

  expect_message(
    bde_catalog_search("TC", catalog = "TC"),
    "does not inherit from"
  )
})

test_that("Mocks expand all", {
  # Expand all
  local_mocked_bindings(
    bde_check_access = function(...) {
      TRUE
    },
    bde_hlp_download = function(...) {
      TRUE
    }
  )
  res <- bde_catalog_update("ALL", cache_dir = tempdir())
  expect_all_true(unlist(res))
  expect_length(res, 5)
})

test_that("Mock bad catalog file", {
  local_mocked_bindings(bde_catalog_update = function(
    catalog = "a",
    cache_dir = tempdir(),
    verbose = FALSE
  ) {
    file.create(file.path(cache_dir, "catalogo_tc.csv"))
  })

  expect_message(
    bde_catalog_load(
      "TC",
      verbose = FALSE,
      cache_dir = file.path(tempdir(), "isolate")
    ),
    "is empty"
  )
})
