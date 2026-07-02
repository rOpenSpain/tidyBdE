test_that("Parse dates", {
  # Test bde_parse_dates----
  testdates <- c("2002", "MAR 2002", "01 MAR 2002", "---", NA, "-an,a")
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

test_that("cache helper covers option, suffix and creation paths", {
  dir <- file.path(tempdir(), "tidybde-cache-helper")
  unlink(dir, recursive = TRUE, force = TRUE)

  expect_message(
    created <- bde_hlp_cachedir(dir, verbose = TRUE),
    "Created cache directory"
  )

  expect_message(
    ss <- bde_hlp_cachedir(dir, verbose = TRUE),
    "Using cache directory"
  )

  expect_equal(created, dir)

  options(bde_cache_dir = dir)
  on.exit(options(bde_cache_dir = NULL))

  expect_message(
    from_option <- bde_hlp_cachedir(verbose = TRUE, suffix = "TC"),
    "Using cache directory from option"
  )
  expect_equal(basename(from_option), "TC")

  options(bde_cache_dir = NULL)
  expect_message(
    temp_cache <- bde_hlp_cachedir(verbose = TRUE, suffix = "SI"),
    "Using temporary cache directory"
  )
  expect_equal(basename(temp_cache), "SI")
})

test_that("Help guess", {
  df <- dplyr::tibble(a = "11", protect = "1.1", a2 = "1.000.000")
  all <- bde_hlp_guess(df)
  expect_type(all$a, "double")
  expect_type(all$protect, "double")
  expect_type(all$a2, "character")

  prot <- bde_hlp_guess(df, preserve = "protect")
  expect_type(prot$a, "double")
  expect_type(prot$protect, "character")
  expect_type(prot$a2, "character")
})

test_that("Help to char", {
  df <- dplyr::tibble(a = 1.1, protect = 1.1)
  all <- bde_hlp_tochar(df)
  expect_type(all$a, "character")
  expect_type(all$protect, "character")

  prot <- bde_hlp_tochar(df, preserve = "protect")
  expect_type(prot$a, "character")
  expect_type(prot$protect, "double")
})

test_that("Errors on download", {
  skip_on_cran()
  skip_if_bde_offline()

  tmp <- tempfile()
  expect_snapshot(
    a <- bde_hlp_download("https://www.invented_test_url.com", tmp, TRUE)
  )
  unlink(tmp)
  expect_false(file.exists(tmp))

  # Existing url
  tmp2 <- tempfile()
  expect_snapshot(
    b <- bde_hlp_download(
      "https://ropenspain.github.io/tidyBdE/sitemap.xml",
      tmp2,
      verbose = TRUE
    )
  )
  expect_true(file.exists(tmp2))
  unlink(tmp2)
})

test_that("Help guess to double", {
  df <- dplyr::tibble(a = c("11", "..."), protect = c("1000000.23", "_"))
  all <- bde_hlp_todouble(df)
  expect_type(all$a, "double")
  expect_type(all$protect, "double")

  prot <- bde_hlp_todouble(df, preserve = "protect")
  expect_type(prot$a, "double")
  expect_type(prot$protect, "character")
  expect_identical(df$protect, prot$protect)
})

test_that("Messages", {
  expect_snapshot(df <- bde_hlp_return_null())
  expect_snapshot(df2 <- bde_hlp_return_null("An example message."))
  expect_identical(df, dplyr::tibble())
  expect_identical(df, df2)
})


test_that("Pretty match", {
  skip_on_cran()
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(my_fun("error here"), error = TRUE)

  # Several values no match
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)

  # One value regex
  expect_snapshot(my_fun("5"), error = TRUE)
  # Several value regex
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)
})

test_that("Argument matching returns defaults and exact values", {
  match_year <- function(year = c(2020, 2024)) {
    match_arg_pretty(year)
  }

  expect_identical(match_year(), "2020")
  expect_identical(match_year(NULL), "2020")
  expect_identical(match_year(2024), "2024")
})

test_that("Argument matching reports invalid values", {
  match_year <- function(year = c(2020, 2024)) {
    match_arg_pretty(year)
  }

  expect_error(match_year(2030), "must be")
  expect_error(match_year(c(2020, 2030)), "must be")
})


test_that("bde_hlp_abort_if_not", {
  skip_on_cran()

  expect_invisible(bde_hlp_abort_if_not())
  expect_snapshot(error = TRUE, bde_hlp_abort_if_not(isFALSE(TRUE)))
  expect_invisible(bde_hlp_abort_if_not("A" = is.character("a")))

  expect_snapshot(error = TRUE, bde_catalog_load(cache_dir = 1))
  expect_snapshot(error = TRUE, bde_catalog_load(verbose = 1))
  expect_snapshot(error = TRUE, bde_catalog_load(parse_dates = 1))
  expect_snapshot(error = TRUE, bde_catalog_load(update_cache = 1))
})
