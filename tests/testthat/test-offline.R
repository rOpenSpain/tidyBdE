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


test_that("Series full", {
  skip_on_cran()
  skip_if_bde_offline()
  dir <- file.path(tempdir(), paste0("testoff", sample(1:10, 1)))


  # Get a series
  tc_catalog <- bde_catalog_load("TI", cache_dir = dir)

  all_tables <- tc_catalog$Nombre_del_archivo_con_los_valores_de_la_serie
  all_names <- as.character(unique(all_tables))

  full_1 <- bde_series_full_load(all_names[1], cache_dir = dir)

  expect_s3_class(full_1, "data.frame")
  expect_true(nrow(full_1) > 5)

  options(bde_test_offline = TRUE)
  # Can't download series
  expect_message(bde_series_full_load(all_names[2], cache_dir = dir))

  fail <- bde_series_full_load(all_names[2], cache_dir = dir)
  expect_equal(nrow(fail), 0)

  # But can reload cached series
  expect_silent(bde_series_full_load(all_names[1], cache_dir = dir))
  full_2 <- bde_series_full_load(all_names[1], cache_dir = dir)

  expect_identical(full_1, full_2)

  # Now try online
  options(bde_test_offline = FALSE)

  failfix <- bde_series_full_load(all_names[2], cache_dir = dir)

  expect_gt(nrow(failfix), 0)
})
