test_that("Indicators", {
  skip_on_cran()
  skip_if_bde_offline()

  # Test indicators----
  expect_silent(bde_ind_gdp_var())
  expect_silent(bde_ind_unemployment_rate())
  expect_silent(bde_ind_euribor_12m_monthly())
  expect_silent(bde_ind_euribor_12m_daily())
  expect_silent(bde_ind_cpi_var())
  expect_silent(bde_ind_ibex())
  expect_silent(bde_ind_gdp_quarterly())
  expect_silent(bde_ind_population())
})
