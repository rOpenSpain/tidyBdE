test_that("Catalogs", {
  skip_on_cran()
  skip_if_bde_offline()


  dir <- file.path(tempdir(), paste0("testoff", sample(1:10, 1)))

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
