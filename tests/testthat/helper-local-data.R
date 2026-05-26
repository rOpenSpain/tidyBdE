write_bde_csv <- function(path, rows) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  write.table(
    as.data.frame(rows, stringsAsFactors = FALSE),
    path,
    sep = ",",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE,
    na = ""
  )
}

write_test_catalog <- function(cache_dir, catalog = "TC") {
  catalog_file <- file.path(
    cache_dir,
    paste0("catalogo_", tolower(catalog), ".csv")
  )

  header <- paste0("header", seq_len(17))
  row <- c(
    "Serie de prueba",
    "12345",
    "ALIAS1",
    "TC_1_1.csv",
    "Descripcion de prueba",
    "Tipo",
    "Unidad",
    "0",
    "2",
    "Unidad y exponente",
    "Mensual",
    "ENE 2020",
    "FEB 2020",
    "2",
    "Titulo de prueba",
    "Fuente",
    "Notas"
  )

  write_bde_csv(catalog_file, rbind(header, row))
  catalog_file
}

write_test_series <- function(cache_dir, series_csv = "TC_1_1.csv") {
  series_dir <- file.path(cache_dir, substr(series_csv, 1, 2))
  series_file <- file.path(series_dir, tolower(series_csv))

  rows <- rbind(
    c("FREQ", "Monthly", "Monthly"),
    c("UNIT", "Index", "Index"),
    c("Fecha", "ALIAS1", "ALIAS2"),
    c("Alias", "ALIAS1", "ALIAS2"),
    c("Title", "First series", "Second series"),
    c("Decimals", "2", "2"),
    c("2020", "1.5", "2.5"),
    c("ENE 2021", "_", "3.5"),
    c("FUENTE", "BdE", "BdE"),
    c("NOTAS", "Test note", "Test note")
  )

  write_bde_csv(series_file, rows)
  series_file
}
