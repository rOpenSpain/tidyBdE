test_that("Latest: test errors", {
  skip_on_cran()
  expect_snapshot(error = TRUE, bde_series_api_latest())
  expect_snapshot(
    error = TRUE,
    bde_series_api_latest("An_example", language = "aaa")
  )
})

test_that("Latest: Empty results", {
  skip_on_cran()
  expect_snapshot(
    empty <- bde_series_api_latest("XXX"),
    transform = function(lines) {
      gsub("(?<=error ).*?(?= for)", "XXX", lines, perl = TRUE)
    }
  )
  expect_identical(empty, dplyr::tibble(x = NULL))

  expect_identical(bde_series_api_latest(""), dplyr::tibble())
})

test_that("Latest: Empty results", {
  skip_on_cran()
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
  ti <- bde_catalog_load("TI")
  sname <- ti$Nombre_de_la_serie[1]
  expect_silent(tb_es <- bde_series_api_latest(sname, language = "es"))
  # Another language
  expect_silent(tb_en <- bde_series_api_latest(sname, language = "en"))
  expect_identical(tb_en$valor, tb_es$valor)
  expect_false(tb_en$descripcionCorta == tb_es$descripcionCorta)
})

test_that("Latest: Several results", {
  skip_on_cran()
  ti <- bde_catalog_load("TI")
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
