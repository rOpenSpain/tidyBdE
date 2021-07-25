test_that("Catalogs", {

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
  expect_silent(bde_catalog_update("CF", cache_dir = tempdir()))

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


test_that("Parse dates", {
  # Test bde_parse_dates----
  testdates <-
    c("2002", "MAR 2002", "01 MAR 2002", "---", NA, "-an,a")
  parsed <- bde_parse_dates(testdates)

  expect_equal(class(parsed), "Date")

  would_parse <- c(
    "02 FEB2019",
    "MAR 2020",
    "ENE2020",
    "2020",
    "12-1993",
    "01-02-2014",
    "31/12/2009"
  )

  parsed_ok <- bde_parse_dates(would_parse)
  expect_false(anyNA(parsed_ok))
})
