test_that("Catalogs offline", {
  skip_on_cran()
  skip_if_bde_offline()


  dir <- file.path(tempdir(), "test_catalogs")

  expect_silent(bde_catalog_update("TI", cache_dir = dir))

  options(bde_test_offline = TRUE)

  expect_message(bde_catalog_update("TC", cache_dir = dir))

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
  options(bde_test_offline = FALSE)

  nonull <- bde_catalog_load("TC", cache_dir = dir)
  expect_gt(nrow(nonull), 0)
})

test_that("Messages", {
  skip_on_cran()
  skip_if_bde_offline()

  dir <- file.path(tempdir(), "test_catalogs2")

  options(bde_test_offline = FALSE)
  expect_message(bde_catalog_load("TC", verbose = TRUE, cache_dir = dir))
  expect_message(bde_catalog_load("TC", verbose = TRUE, cache_dir = dir))
})

test_that("Old tests: Catalogs", {
  skip_on_cran()
  skip_if_bde_offline()

  # Test load catalogs----
  expect_error(bde_catalog_load("aa"))
  expect_error(bde_catalog_search("xxxxxxx", catalog = "IE"))


  expect_message(bde_catalog_load("TC", cache_dir = tempdir(), verbose = TRUE))
  expect_message(bde_catalog_load("TC", cache_dir = NULL, verbose = TRUE))
  expect_message(bde_catalog_load(
    "TC",
    cache_dir = file.path(tempdir(), "aa"),
    verbose = TRUE
  ))

  expect_silent(bde_catalog_load("ALL"))



  # Test update catalogs----

  expect_error(bde_catalog_update("aa"))


  expect_message(bde_catalog_update("TC",
    cache_dir = tempdir(),
    verbose = TRUE
  ))
  expect_silent(bde_catalog_update("ALL", cache_dir = tempdir()))
  expect_silent(bde_catalog_update("TC", cache_dir = tempdir()))

  # Testing options cache dir
  init_cache_dir <- getOption("bde_cache_dir")
  options(bde_cache_dir = file.path(tempdir(), "test"))
  expect_message(bde_catalog_update("TC", verbose = TRUE))
  # Reset
  options(bde_cache_dir = init_cache_dir)


  # Test bde_catalog_search----

  expect_error(bde_catalog_search())


  expect_silent(bde_catalog_search("Euro", catalog = "TC"))
})

test_that("Fully Deprecation of Series", {
  expect_error(bde_catalog_update("IE", cache_dir = tempdir()))
  expect_error(bde_catalog_update("CF", cache_dir = tempdir()))
})
