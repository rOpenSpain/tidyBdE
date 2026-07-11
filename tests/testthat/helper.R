skip_if_bde_offline <- function() {
  if (bde_check_access()) {
    return(invisible(TRUE))
  }

  testthat::skip("BdE API is not reachable.")
  invisible()
}

local_bde_cache <- function() {
  cache_dir <- withr::local_tempdir()
  withr::local_options(bde_cache_dir = cache_dir)
  local_test_paths(cache_dir)
  cache_dir
}

local_test_paths <- function(...) {
  paths <- unlist(list(...), use.names = FALSE)
  paths <- paths[!is.na(paths) & nzchar(paths)]
  current_paths <- getOption("tidyBdE_test_paths", character())
  withr::local_options(tidyBdE_test_paths = unique(c(current_paths, paths)))
  invisible(paths)
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
  family_dirs <- unique(file.path(
    cache_dir,
    c(substr(series_csv, 1, 2), toupper(substr(series_csv, 1, 2)))
  ))
  series_files <- file.path(family_dirs, tolower(series_csv))
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
  for (series_file in series_files) {
    dir.create(dirname(series_file), recursive = TRUE, showWarnings = FALSE)
    writeLines(rows, series_file, useBytes = TRUE)
  }
  series_files[[1]]
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

scrub_test_paths <- function(
  lines,
  paths = getOption(
    "tidyBdE_test_paths",
    character()
  )
) {
  paths <- unique(c(paths, tempdir()))
  paths <- paths[!is.na(paths) & nzchar(paths)]

  path_variants <- unique(unlist(lapply(paths, path_test_variants)))
  path_variants <- path_variants[nzchar(path_variants)]
  path_variants <- path_variants[order(nchar(path_variants), decreasing = TRUE)]

  for (path in path_variants) {
    escaped_path <- escape_regex(path)
    lines <- gsub(
      paste0("'", escaped_path, "[^']*'"),
      "'<tempdir>'",
      lines,
      perl = TRUE
    )
    lines <- gsub(
      paste0('"', escaped_path, '[^"]*"'),
      '"<tempdir>"',
      lines,
      perl = TRUE
    )
    lines <- gsub(path, "<tempdir>", lines, fixed = TRUE)
  }

  lines <- gsub(
    "('[^']*(Rtmp|file)[^']*')",
    "'<tempdir>'",
    lines,
    perl = TRUE
  )
  gsub(
    '("[^"]*(Rtmp|file)[^"]*")',
    '"<tempdir>"',
    lines,
    perl = TRUE
  )
}

path_test_variants <- function(path) {
  normalized <- normalizePath(path, winslash = "/", mustWork = FALSE)
  unique(c(
    path,
    normalized,
    gsub("/", "\\\\", normalized, fixed = TRUE),
    gsub("\\\\", "/", path)
  ))
}

escape_regex <- function(x) {
  gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", x, perl = TRUE)
}
