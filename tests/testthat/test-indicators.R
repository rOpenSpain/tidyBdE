test_that("Indicators", {
  skip_on_cran()
  skip_if_bde_offline()

  # Test indicators----
  n <- expect_silent(bde_ind_gdp_var())
  expect_true(nrow(n) > 10)

  n2 <- expect_silent(bde_ind_unemployment_rate())
  expect_true(nrow(n2) > 10)

  n3 <- expect_silent(bde_ind_euribor_12m_monthly())
  expect_true(nrow(n3) > 10)

  n4 <- expect_silent(bde_ind_euribor_12m_daily())
  expect_true(nrow(n4) > 10)

  n5 <- expect_silent(bde_ind_cpi_var())
  expect_true(nrow(n5) > 10)

  n6 <- expect_silent(bde_ind_ibex())
  expect_true(nrow(n6) > 10)

  n6b <- expect_silent(bde_ind_ibex_monthly())
  expect_identical(n6, n6b)

  n7 <- expect_silent(bde_ind_gdp_quarterly())
  expect_true(nrow(n7) > 10)

  n9 <- expect_silent(bde_ind_ibex_daily())
  expect_true(nrow(n9) > 10)
})
