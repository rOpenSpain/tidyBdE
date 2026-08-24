test_that("Live GDP variation indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_gdp_var())
  expect_gt(nrow(result), 10)
})

test_that("Live unemployment indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_unemployment_rate())
  expect_gt(nrow(result), 10)
})

test_that("Live monthly Euribor indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_euribor_12m_monthly())
  expect_gt(nrow(result), 10)
})

test_that("Live daily Euribor indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_euribor_12m_daily())
  expect_gt(nrow(result), 10)
})

test_that("Live CPI variation indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_cpi_var())
  expect_gt(nrow(result), 10)
})

test_that("Live legacy IBEX indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_ibex())
  expect_gt(nrow(result), 10)
})

test_that("Live monthly IBEX indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_ibex_monthly())
  expect_gt(nrow(result), 10)
})

test_that("Live quarterly GDP indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_gdp_quarterly())
  expect_gt(nrow(result), 10)
})

test_that("Live population indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_population())
  expect_gt(nrow(result), 10)
})

test_that("Live daily IBEX indicator returns data", {
  skip_on_cran()
  skip_if_bde_offline()

  result <- expect_silent(bde_ind_ibex_daily())
  expect_gt(nrow(result), 10)
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
  calls <- do.call(
    rbind,
    lapply(calls, function(x) {
      data.frame(
        series_code = x$series_code,
        series_label = x$series_label,
        stringsAsFactors = FALSE
      )
    })
  )
  expected <- data.frame(
    series_code = c(
      "4663788",
      "4635980",
      "587853",
      "905842",
      "1489713",
      "254433",
      "254433",
      "821340",
      "4663160",
      "4637737"
    ),
    series_label = c(
      "GDP_YoY",
      "Unemployment_Rate",
      "Euribor_12M_Monthly",
      "Euribor_12M_Daily",
      "Consumer_price_index_YoY",
      "IBEX_index_month",
      "IBEX_index_month",
      "IBEX_index_day",
      "GDP_quarterly_value",
      "Population_Spain"
    ),
    stringsAsFactors = FALSE
  )
  expect_identical(calls, expected)
})

test_that("Indicators validate labels", {
  expect_snapshot(error = TRUE, bde_ind_gdp_var(series_label = 1))
})

test_that("Indicators drop rows with missing values", {
  local_mocked_bindings(bde_series_load = function(...) {
    dplyr::tibble(
      Date = as.Date(c("2024-01-01", "2024-01-02")),
      value = c(1, NA)
    )
  })

  expect_equal(nrow(bde_ind_gdp_var()), 1)
})
