test_that("Parse dates", {
  # Test bde_parse_dates----
  testdates <-
    c("2002", "MAR 2002", "01 MAR 2002", "---", NA, "-an,a")
  parsed <- bde_parse_dates(testdates)

  expect_s3_class(parsed, "Date")

  would_parse <- c(
    "02 FEB2019",
    "02 DIC 2019",
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
