

run_tests <-
  length(unclass(utils::packageVersion("tidyBdE"))[[1]]) > 3


if (run_tests) {
  # Test indicators----
  expect_silent(bde_ind_gdp_var())
  expect_silent(bde_ind_unemployment_rate())
  expect_silent(bde_ind_euribor_12m_monthly())
  expect_silent(bde_ind_euribor_12m_daily())
  expect_silent(bde_ind_cpi_var())
  expect_silent(bde_ind_ibex())
}
