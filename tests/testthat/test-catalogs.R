test_that("Catalogs", {
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
