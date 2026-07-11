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

  n8 <- expect_silent(bde_ind_population())
  expect_true(nrow(n8) > 10)

  n9 <- expect_silent(bde_ind_ibex_daily())
  expect_true(nrow(n9) > 10)
})

test_that("Indicators pass configured series and labels", {
  calls <- list()

  local_mocked_bindings(bde_series_load = function(
    series_code,
    series_label,
    ...
  ) {
    calls[[length(calls) + 1]] <<- list(
      series_code = series_code,
      series_label = series_label
    )
    dplyr::tibble(Date = as.Date("2024-01-01"), value = 1)
  })

  expect_named(bde_ind_gdp_var(), c("Date", "value"))
  expect_named(bde_ind_unemployment_rate(), c("Date", "value"))
  expect_named(bde_ind_euribor_12m_monthly(), c("Date", "value"))
  expect_named(bde_ind_euribor_12m_daily(), c("Date", "value"))
  expect_named(bde_ind_cpi_var(), c("Date", "value"))
  expect_named(bde_ind_ibex_monthly(), c("Date", "value"))
  expect_named(bde_ind_ibex(), c("Date", "value"))
  expect_named(bde_ind_ibex_daily(), c("Date", "value"))
  expect_named(bde_ind_gdp_quarterly(), c("Date", "value"))
  expect_named(bde_ind_population(), c("Date", "value"))

  expect_length(calls, 10)
  expect_setequal(
    vapply(calls, `[[`, character(1), "series_label"),
    c(
      "GDP_YoY",
      "Unemployment_Rate",
      "Euribor_12M_Monthly",
      "Euribor_12M_Daily",
      "Consumer_price_index_YoY",
      "IBEX_index_month",
      "IBEX_index_day",
      "GDP_quarterly_value",
      "Population_Spain"
    )
  )
})

test_that("Indicators validate labels and drop missing rows", {
  local_mocked_bindings(bde_series_load = function(...) {
    dplyr::tibble(
      Date = as.Date(c("2024-01-01", "2024-01-02")),
      value = c(1, NA)
    )
  })

  expect_snapshot(error = TRUE, bde_ind_gdp_var(series_label = 1))
  expect_equal(nrow(bde_ind_gdp_var()), 1)
})
