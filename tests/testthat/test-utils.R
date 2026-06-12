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
    "Using cache directory from options"
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
