test_that("Thematic", {
  skip_on_cran()
  skip_if_bde_offline()

  # Test load catalogs----
  expect_error(bde_themes_download("aa"))

  expect_message(bde_themes_download("TE_DEU",
    cache_dir = tempdir(),
    verbose = TRUE
  ))
  expect_message(bde_themes_download("TE_DEU",
    cache_dir = NULL,
    verbose = TRUE
  ))
  expect_silent(bde_themes_download("ALL"))
})
