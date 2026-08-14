test_that("Latest API validates required inputs", {
  expect_snapshot(error = TRUE, bde_series_api_latest())
  expect_snapshot(
    error = TRUE,
    bde_series_api_latest("An_example", language = "aaa")
  )
})

test_that("Series API load validates required inputs", {
  expect_snapshot(error = TRUE, bde_series_api_load())
  expect_snapshot(
    error = TRUE,
    bde_series_api_load("An_example", language = "aaa")
  )
  expect_snapshot(error = TRUE, {
    bde_series_api_load("An_example", time_range = c("30M", "60M"))
  })

  expect_snapshot(error = TRUE, bde_series_api_load("a", c("A", NA)))

  expect_snapshot(error = TRUE, bde_series_api_load("a", c("A", "B")))
  expect_snapshot(
    error = TRUE,
    bde_series_api_load(c("a", "b"), c("same", "same"))
  )
})

test_that("Series API load parses dates, values and query ranges", {
  queried_url <- NULL
  downloaded_file <- NULL
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    queried_url <<- url
    downloaded_file <<- local_file
    if (grepl("favoritas", url, fixed = TRUE)) {
      write_test_api_response(local_file, test_api_latest_result())
      return(TRUE)
    }
    write_test_api_response(
      local_file,
      test_api_series_result(
        dates = list(
          "2024-02-01T09:15:00Z",
          "2024-01-01T09:15:00Z"
        ),
        values = list(2.2, 1.1)
      )
    )
    TRUE
  })

  tb <- bde_series_api_load("D_TEST", language = "en", time_range = "30M")

  expect_equal(nrow(tb), 2)
  expect_named(tb, c("Date", "D_TEST"))
  expect_identical(tb$Date, as.Date(c("2024-02-01", "2024-01-01")))
  expect_identical(tb$D_TEST, c(2.2, 1.1))
  expect_match(queried_url, "listaSeries")
  expect_match(queried_url, "rango=30M")
  expect_false(file.exists(downloaded_file))
})

test_that("Series API load parses valid and invalid mocked API responses", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(
      local_file,
      list(errNum = "404"),
      test_api_series_result()
    )
    TRUE
  })

  expect_snapshot(
    out <- bde_series_api_load(
      c("BAD", "D_TEST"),
      series_label = c("bad", "good"),
      language = "en"
    )
  )
  expect_named(out, c("Date", "good"))
  expect_identical(out$Date, as.Date("2024-02-01"))
  expect_identical(out$good, 2.2)
})

test_that("Series API load reports all-invalid mocked API responses", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(local_file, list(errNum = "404"))
    TRUE
  })

  expect_snapshot(
    empty <- bde_series_api_load("BAD", language = "en")
  )
  expect_identical(empty, dplyr::tibble())
})

test_that("Latest API reports invalid JSON responses", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    writeLines("{invalid", local_file)
    TRUE
  })

  expect_snapshot(error = TRUE, bde_series_api_latest("D_TEST"))
})

test_that("Series API load reports mismatched response counts", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(local_file, test_api_series_result())
    TRUE
  })

  expect_snapshot(
    error = TRUE,
    bde_series_api_load(c("D_ONE", "D_TWO"))
  )
})

test_that("Series API load reports reordered series results", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(
      local_file,
      test_api_series_result(series = "D_TWO"),
      test_api_series_result(series = "D_ONE")
    )
    TRUE
  })

  expect_snapshot(
    error = TRUE,
    bde_series_api_load(c("D_ONE", "D_TWO"))
  )
})

test_that("Latest API reports non-object results", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(local_file, 1)
    TRUE
  })

  expect_snapshot(error = TRUE, bde_series_api_latest("D_TEST"))
})

test_that("Latest API reports missing required fields", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    result <- test_api_latest_result()
    result$fechaValor <- NULL
    write_test_api_response(local_file, result)
    TRUE
  })

  expect_snapshot(error = TRUE, bde_series_api_latest("D_TEST"))
})

test_that("Series API load reports missing observation fields", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    result <- test_api_series_result()
    result$valores <- NULL
    write_test_api_response(local_file, result)
    TRUE
  })

  expect_snapshot(error = TRUE, bde_series_api_load("D_TEST"))
})

test_that("Series API load reports mismatched dates and values", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    result <- test_api_series_result(
      dates = list(
        "2024-02-01T09:15:00Z",
        "2024-01-01T09:15:00Z"
      ),
      values = list(2.2)
    )
    write_test_api_response(local_file, result)
    TRUE
  })

  expect_snapshot(error = TRUE, bde_series_api_load("D_TEST"))
})

test_that("Series API metadata reports missing required fields", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    result <- test_api_series_result()
    result$informacion <- NULL
    write_test_api_response(local_file, result)
    TRUE
  })

  expect_snapshot(
    error = TRUE,
    bde_series_api_load("D_TEST", extract_metadata = TRUE)
  )
})

test_that("Series API load rejects ranges invalid for its frequency", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(
      local_file,
      test_api_latest_result(frequency = "D")
    )
    TRUE
  })

  expect_snapshot(error = TRUE, {
    bde_series_api_load("D_TEST", time_range = "30M")
  })
})

test_that("Series API load supports long format and metadata", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(local_file, test_api_series_result())
    TRUE
  })

  long <- bde_series_api_load(
    "D_TEST",
    series_label = "test",
    out_format = "long"
  )
  expect_named(long, c("Date", "serie_name", "serie_value"))
  expect_identical(as.character(long$serie_name), "test")

  meta <- bde_series_api_load("D_TEST", extract_metadata = TRUE)
  expect_equal(nrow(meta), 1)
  expect_identical(meta$fechaInicio[[1]], as.Date("2024-01-01"))
  expect_identical(meta$fechaFin[[1]], as.Date("2024-02-01"))
  expect_identical(meta$decimales[[1]], 1L)
})

test_that("Series API load handles empty codes", {
  expect_identical(bde_series_api_load(""), dplyr::tibble())
})

test_that("Smoke: latest API reports unknown series", {
  skip_on_cran()
  skip_if_bde_offline()

  expect_snapshot(
    empty <- bde_series_api_latest("XXX"),
    transform = function(lines) {
      gsub("(?<=error ).*?(?= for)", "XXX", lines, perl = TRUE)
    }
  )
  expect_identical(empty, dplyr::tibble(x = NULL))
})

test_that("Latest API handles empty codes and download failures", {
  expect_identical(bde_series_api_latest(""), dplyr::tibble())

  local_mocked_bindings(bde_hlp_download = function(...) {
    FALSE
  })
  expect_snapshot(empty <- bde_series_api_latest("XXX"))
  expect_identical(empty, dplyr::tibble(x = NULL))
})

test_that("Latest API parses valid and invalid mocked responses", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(
      local_file,
      list(errNum = "404"),
      test_api_latest_result(decimals = "1", value = "2.2")
    )
    TRUE
  })

  expect_snapshot(
    latest <- bde_series_api_latest(c("BAD", "D_TEST"), language = "en")
  )
  expect_named(
    latest,
    c(
      "serie",
      "descripcionCorta",
      "codFrecuencia",
      "decimales",
      "simbolo",
      "tendencia",
      "fechaValor",
      "valor"
    )
  )
  expect_identical(latest$fechaValor, as.Date("2024-02-01"))
  expect_type(latest$valor, "double")
})

test_that("Latest API reports all-invalid mocked responses", {
  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(local_file, list(errNum = "404"))
    TRUE
  })

  expect_snapshot(empty <- bde_series_api_latest("BAD", language = "en"))
  expect_identical(empty, dplyr::tibble())
})

test_that("Series API load handles download failures and null values", {
  local_mocked_bindings(bde_hlp_download = function(...) FALSE)
  expect_snapshot(empty <- bde_series_api_load("D_TEST"))
  expect_identical(empty, dplyr::tibble())

  local_mocked_bindings(bde_hlp_download = function(url, local_file, verbose) {
    write_test_api_response(
      local_file,
      test_api_series_result(values = list(NULL))
    )
    TRUE
  })

  out <- bde_series_api_load("D_TEST", out_format = "long")
  expect_equal(out$serie_value, NA)
})

test_that("Smoke: latest API loads multiple series and languages", {
  skip_on_cran()
  skip_if_bde_offline()

  sname <- c("DTCCBCEUSDEUR.B", "DTCCBCEJPYEUR.B")
  expect_silent(tb_es <- bde_series_api_latest(sname, language = "es"))
  expect_equal(nrow(tb_es), 2)
  # Another language
  expect_silent(tb_en <- bde_series_api_latest(sname, language = "en"))
  expect_identical(tb_en$valor, tb_es$valor)
  expect_false(any(tb_en$descripcionCorta == tb_es$descripcionCorta))

  # With invalid series codes.
  sname_invalid <- c("AN_ERROR", sname, "ANOTHER_ERROR")
  expect_snapshot(
    tb_es_invalid <- bde_series_api_latest(sname_invalid, language = "es"),
    transform = function(lines) {
      gsub("(?<=error ).*?(?= for)", "XXX", lines, perl = TRUE)
    }
  )

  expect_identical(tb_es, tb_es_invalid)
})

test_that("Smoke: series API loads data and metadata", {
  skip_on_cran()
  skip_if_bde_offline()

  sname <- c("DTCCBCEUSDEUR.B", "DTCCBCEJPYEUR.B")
  expect_silent(
    tb_es <- bde_series_api_load(sname, language = "es", out_format = "wide")
  )

  expect_silent(
    tb_nm <- bde_series_api_load(
      sname,
      series_label = c("a", "b"),
      out_format = "wide"
    )
  )
  expect_named(tb_nm, c("Date", "a", "b"))
  expect_identical(tb_es$DTCCBCEJPYEUR.B, tb_nm$b)

  # With invalid series codes.
  sname_invalid <- c("AN_ERROR", sname, "ANOTHER_ERROR")
  expect_snapshot(
    tb_es_invalid <- bde_series_api_load(sname_invalid, language = "es")
  )

  expect_silent(
    meta_es <- bde_series_api_load(
      sname,
      extract_metadata = TRUE,
      language = "es"
    )
  )

  expect_silent(
    meta_en <- bde_series_api_load(
      sname,
      extract_metadata = TRUE,
      language = "en"
    )
  )

  expect_false(all(names(meta_en) == names(meta_es)))
  expect_identical(meta_en$fechaInicio, meta_es$fechaInicio)
})

test_that("Time range validation bypasses missing and calendar-year ranges", {
  local_mocked_bindings(bde_series_api_latest = function(...) {
    cli::cli_abort("Latest API must not be queried for this range.")
  })

  expect_invisible(bde_hlp_api_check_range(
    series_code = "D_TEST",
    language = "en",
    time_range = NULL,
    verbose = FALSE
  ))
  expect_invisible(bde_hlp_api_check_range(
    series_code = "D_TEST",
    language = "en",
    time_range = "2024",
    verbose = FALSE
  ))
})

test_that("Time range validation accepts every documented frequency range", {
  frequency <- "D"
  local_mocked_bindings(bde_series_api_latest = function(series_code, ...) {
    dplyr::tibble(serie = series_code, codFrecuencia = frequency)
  })

  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "3M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "12M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "36M", FALSE))

  frequency <- "M"
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "30M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "60M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "MAX", FALSE))

  frequency <- "Q"
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "30M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "60M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "MAX", FALSE))

  frequency <- "A"
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "60M", FALSE))
  expect_invisible(bde_hlp_api_check_range("D_TEST", "en", "MAX", FALSE))
})

test_that("Time range validation rejects invalid documented combinations", {
  frequency <- "M"
  local_mocked_bindings(bde_series_api_latest = function(series_code, ...) {
    dplyr::tibble(serie = series_code, codFrecuencia = frequency)
  })

  expect_snapshot(
    error = TRUE,
    bde_hlp_api_check_range("D_TEST", "en", "3M", FALSE)
  )

  frequency <- "Q"
  expect_snapshot(
    error = TRUE,
    bde_hlp_api_check_range("D_TEST", "en", "12M", FALSE)
  )

  frequency <- "A"
  expect_snapshot(
    error = TRUE,
    bde_hlp_api_check_range("D_TEST", "en", "30M", FALSE)
  )
})

test_that("Time range validation tolerates unavailable frequencies", {
  local_mocked_bindings(bde_series_api_latest = function(...) {
    dplyr::tibble()
  })
  expect_invisible(bde_hlp_api_check_range(
    series_code = "DTCCBCEUSDEUR.B",
    language = "es",
    time_range = "30M",
    verbose = FALSE
  ))

  local_mocked_bindings(bde_series_api_latest = function(...) {
    dplyr::tibble(codFrecuencia = "SOME_VALUE")
  })
  expect_invisible(bde_hlp_api_check_range(
    series_code = "DTCCBCEUSDEUR.B",
    language = "es",
    time_range = "30M",
    verbose = FALSE
  ))
})
