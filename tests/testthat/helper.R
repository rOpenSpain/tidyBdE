skip_if_bde_offline <- function() {
  if (bde_check_access()) {
    return(invisible(TRUE))
  }

  testthat::skip("BdE API is not reachable.")
  invisible()
}

local_bde_cache <- function() {
  withr::local_tempdir()
}

write_test_catalog <- function(cache_dir, catalog = "TC") {
  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  catalog_file <- file.path(
    cache_dir,
    paste0("catalogo_", tolower(catalog), ".csv")
  )
  rows <- c(
    paste(rep("header", 17), collapse = ","),
    paste(
      c(
        "SERIES_A",
        "101",
        "A",
        "tc_1_1.csv",
        "Producto interior bruto",
        "Tipo",
        "EUR",
        "0",
        "2",
        "Units",
        "Mensual",
        "ENE 2020",
        "FEB 2020",
        "2",
        "PIB de España",
        "BdE",
        "Nota"
      ),
      collapse = ","
    ),
    paste(
      c(
        "SERIES_B",
        "102",
        "B",
        "tc_1_1.csv",
        "Inflacion",
        "Tipo",
        "EUR",
        "0",
        "2",
        "Units",
        "Mensual",
        "ENE 2020",
        "FEB 2020",
        "2",
        "IPC de España",
        "BdE",
        "Nota"
      ),
      collapse = ","
    )
  )
  writeLines(rows, catalog_file, useBytes = TRUE)
  catalog_file
}

write_test_series <- function(cache_dir, series_csv = "tc_1_1.csv") {
  family_dir <- file.path(cache_dir, toupper(substr(series_csv, 1, 2)))
  dir.create(family_dir, recursive = TRUE, showWarnings = FALSE)
  series_file <- file.path(family_dir, tolower(series_csv))
  rows <- c(
    "Meta,A,B",
    "Meta,A,B",
    "Fecha,A,B",
    "Alias,A,B",
    "Name,Series A,Series B",
    "Units,EUR,EUR",
    "ENE 2020,1.1,2.2",
    "FEB 2020,1.2,_",
    "FUENTE,BdE,BdE",
    "NOTAS,Note A,Note B"
  )
  writeLines(rows, series_file, useBytes = TRUE)
  series_file
}

mock_catalog <- function() {
  dplyr::tibble(
    catalog = c("TC", "TC", "TC"),
    Numero_secuencial = c(101, 102, NA),
    Alias_de_la_serie = c("A", "B", "C"),
    Nombre_del_archivo_con_los_valores_de_la_serie = c(
      "tc_1_1.csv",
      "tc_1_1.csv",
      "tc_1_1.csv"
    )
  )
}

scrub_test_paths <- function(lines) {
  gsub(
    "C:[^']*(Rtmp|file)[^']*",
    "<tempdir>",
    lines,
    perl = TRUE
  )
}
