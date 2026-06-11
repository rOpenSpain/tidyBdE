test_that("Latest: test errors", {
  skip_on_cran()
  expect_snapshot(error = TRUE, bde_series_api_latest())
  expect_snapshot(
    error = TRUE,
    bde_series_api_latest("An_example", language = "aaa")
  )
})

test_that("Series API load checks inputs", {
  expect_error(
    bde_series_api_load(),
    "`series_alias` cannot be missing"
  )
  expect_error(
    bde_series_api_load("An_example", language = "aaa"),
    "'arg' should be one of"
  )
  expect_error(
    bde_series_api_load("An_example", time_range = c("30M", "60M")),
    "`time_range` must be a non-empty string or `NULL`\\."
  )
})

test_that("Series API load parses list results", {
  queried_url <- NULL
  local_mocked_bindings(
    bde_hlp_api_download = function(url, local_file, verbose) {
      queried_url <<- url
      if (grepl("favoritas", url, fixed = TRUE)) {
        writeLines(
          paste0(
            "[{",
            "\"serie\":\"D_TEST\",",
            "\"descripcionCorta\":\"Test\",",
            "\"codFrecuencia\":\"M\",",
            "\"decimales\":1,",
            "\"simbolo\":\"%\",",
            "\"tendencia\":\"=\",",
            "\"fechaValor\":\"2024-02-01T09:15:00Z\",",
            "\"valor\":2.2",
            "}]"
          ),
          local_file
        )
        return(TRUE)
      }
      writeLines(
        paste0(
          "[{",
          "\"serie\":\"D_TEST\",",
          "\"descripcion\":\"Test series\",",
          "\"descripcionCorta\":\"Test\",",
          "\"codFrecuencia\":\"M\",",
          "\"decimales\":1,",
          "\"simbolo\":\"%\",",
          "\"informacion\":[{\"titulo\":\"Name\",\"descripcion\":\"Test\"}],",
          "\"fechaInicio\":\"2024-01-01T09:15:00Z\",",
          "\"fechaFin\":\"2024-02-01T09:15:00Z\",",
          "\"fechas\":[",
          "\"2024-02-01T09:15:00Z\",",
          "\"2024-01-01T09:15:00Z\"",
          "],",
          "\"valores\":[2.2,1.1]",
          "}]"
        ),
        local_file
      )
      TRUE
    }
  )

  tb <- bde_series_api_load("D_TEST", language = "en", time_range = "30M")

  expect_equal(nrow(tb), 2)
  expect_named(tb, c("Date", "D_TEST"))
  expect_identical(tb$Date, as.Date(c("2024-02-01", "2024-01-01")))
  expect_identical(tb$D_TEST, c(2.2, 1.1))
  expect_match(queried_url, "listaSeries")
  expect_match(queried_url, "rango=30M")
})

test_that("Series API load validates time range by frequency", {
  local_mocked_bindings(
    bde_hlp_api_download = function(url, local_file, verbose) {
      writeLines(
        paste0(
          "[{",
          "\"serie\":\"D_TEST\",",
          "\"descripcionCorta\":\"Test\",",
          "\"codFrecuencia\":\"D\",",
          "\"decimales\":1,",
          "\"simbolo\":\"%\",",
          "\"tendencia\":\"=\",",
          "\"fechaValor\":\"2024-02-01T09:15:00Z\",",
          "\"valor\":2.2",
          "}]"
        ),
        local_file
      )
      TRUE
    }
  )

  expect_error(
    bde_series_api_load("D_TEST", time_range = "30M"),
    "`time_range` \"30M\" is not valid for series frequency \"D\"\\."
  )
})

test_that("Series API load supports long format and metadata", {
  local_mocked_bindings(
    bde_hlp_api_download = function(url, local_file, verbose) {
      writeLines(
        paste0(
          "[{",
          "\"serie\":\"D_TEST\",",
          "\"descripcion\":\"Test series\",",
          "\"descripcionCorta\":\"Test\",",
          "\"codFrecuencia\":\"M\",",
          "\"decimales\":1,",
          "\"simbolo\":\"%\",",
          "\"informacion\":[{\"titulo\":\"Name\",\"descripcion\":\"Test\"}],",
          "\"fechaInicio\":\"2024-01-01T09:15:00Z\",",
          "\"fechaFin\":\"2024-02-01T09:15:00Z\",",
          "\"fechas\":[\"2024-02-01T09:15:00Z\"],",
          "\"valores\":[2.2]",
          "}]"
        ),
        local_file
      )
      TRUE
    }
  )

  long <- bde_series_api_load(
    "D_TEST",
    series_label = "test",
    out_format = "long"
  )
  expect_named(long, c("Date", "serie_name", "serie_value"))
  expect_identical(as.character(long$serie_name), "test")

  meta <- bde_series_api_load("D_TEST", extract_metadata = TRUE)
  expect_equal(nrow(meta), 1)
  expect_identical(meta$serie_name, "D_TEST")
  expect_s3_class(meta$informacion[[1]], "data.frame")
  expect_identical(meta$fechas[[1]], as.Date("2024-02-01"))
  expect_identical(meta$valores[[1]], 2.2)
})

test_that("Series API load handles empty aliases", {
  expect_identical(bde_series_api_load(""), tibble::tibble())
})

test_that("Latest: Empty results", {
  skip_on_cran()
  local_mocked_bindings(
    bde_hlp_api_download = function(url, local_file, verbose) {
      writeLines("[{\"errNum\":\"XXX\"}]", local_file)
      TRUE
    }
  )

  expect_snapshot(
    empty <- bde_series_api_latest("XXX"),
    transform = function(lines) {
      gsub("(?<=error ).*?(?= for)", "XXX", lines, perl = TRUE)
    }
  )
  expect_identical(empty, dplyr::tibble(x = NULL))

  expect_identical(bde_series_api_latest(""), dplyr::tibble())
})

test_that("Latest: Single result", {
  skip_on_cran()
  skip_if_bde_offline()
  ti <- bde_catalog_load("TC", verbose = TRUE)
  sname <- ti$Nombre_de_la_serie[1]
  expect_silent(tb_es <- bde_series_api_latest(sname, language = "es"))
  # Another language
  expect_silent(tb_en <- bde_series_api_latest(sname, language = "en"))
  expect_identical(tb_en$valor, tb_es$valor)
  expect_false(tb_en$descripcionCorta == tb_es$descripcionCorta)
})

test_that("Latest: Several results", {
  skip_on_cran()
  skip_if_bde_offline()
  ti <- bde_catalog_load("TC")
  sname <- ti$Nombre_de_la_serie[1:2]
  expect_silent(tb_es <- bde_series_api_latest(sname, language = "es"))
  expect_equal(nrow(tb_es), 2)
  # Another language
  expect_silent(tb_en <- bde_series_api_latest(sname, language = "en"))
  expect_identical(tb_en$valor, tb_es$valor)
  expect_false(any(tb_en$descripcionCorta == tb_es$descripcionCorta))

  # With invalid codes
  sname_invalid <- c("AN_ERROR", sname, "ANOTHER_ERROR")
  expect_snapshot(
    tb_es_invalid <- bde_series_api_latest(sname_invalid, language = "es"),
    transform = function(lines) {
      gsub("(?<=error ).*?(?= for)", "XXX", lines, perl = TRUE)
    }
  )

  expect_identical(tb_es, tb_es_invalid)
})
