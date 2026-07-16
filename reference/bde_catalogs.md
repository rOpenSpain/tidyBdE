# Load, update and search BdE catalog metadata

These functions manage BdE time series catalog metadata from the bulk
CSV files published by Banco de España.

`bde_catalog_load()` loads time series catalog metadata into a tibble,
`bde_catalog_update()` refreshes the cached catalog files and
`bde_catalog_search()` searches catalog metadata for keywords.

## Usage

``` r
bde_catalog_load(
  catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
  parse_dates = TRUE,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)

bde_catalog_update(
  catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
  cache_dir = NULL,
  verbose = FALSE
)

bde_catalog_search(pattern, ...)
```

## Source

[Banco de España time series bulk data
download](https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html).

## Arguments

- catalog:

  A catalog identifier or `"ALL"` to load or update every catalog. See
  **Details**.

- parse_dates:

  Logical. If `TRUE`, date columns are parsed with
  [`bde_parse_dates()`](https://ropenspain.github.io/tidyBdE/reference/bde_parse_dates.md).

- cache_dir:

  Path to a cache directory. The directory can also be set with
  `options(bde_cache_dir = "path/to/dir")`.

- update_cache:

  Logical. If `TRUE`, the requested file is refreshed in `cache_dir`.

- verbose:

  Logical. If `TRUE`, display informative messages.

- pattern:

  Regular expression to search for. See **Details** and **Examples**.

- ...:

  Additional arguments passed by `bde_catalog_search()` to
  `bde_catalog_load()`.

## Value

`bde_catalog_load()` returns a
[tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
requested time series catalog metadata. See
[`vignette("csv_manual", package = "tidyBdE")`](https://ropenspain.github.io/tidyBdE/articles/csv_manual.md)
for details.

`bde_catalog_update()` returns an invisible list of download results.

`bde_catalog_search()` returns a
[tibble](https://tibble.tidyverse.org/reference/tibble.html) with
matching catalog rows.

## Details

Accepted values for `catalog` are:

|          |                      |                      |               |
|----------|----------------------|----------------------|---------------|
| **CODE** | **PUBLICATION**      | **UPDATE FREQUENCY** | **FREQUENCY** |
| `"BE"`   | Statistical Bulletin | Daily                | Monthly       |
| `"SI"`   | Summary Indicators   | Daily                | Daily         |
| `"TC"`   | Exchange Rates       | Daily                | Daily         |
| `"TI"`   | Interest Rates       | Daily                | Daily         |
| `"PB"`   | Bank Lending Survey  | Quarterly            | Quarterly     |

Use `"ALL"` as a shorthand for loading or updating all catalogs at once.

If the requested catalog is not cached, `bde_catalog_load()` calls
`bde_catalog_update()`.

**Note:** BdE catalog metadata is currently available in Spanish only.
Therefore, search terms passed to `bde_catalog_search()` must be in
Spanish to retrieve results.

`bde_catalog_search()` uses
[`base::grep()`](https://rdrr.io/r/base/grep.html) to find matches in
the catalog metadata. You can pass [regular
expressions](https://rdrr.io/r/base/regex.html) to broaden the search.

## See also

- [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)
  and
  [`bde_series_full_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)
  load bulk CSV series.

- [`bde_series_api_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_api.md)
  and
  [`bde_series_api_latest()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_api.md)
  retrieve series through the Statistics web service (API).

## Examples

``` r
# \donttest{
bde_catalog_load("TI", verbose = TRUE)
#> ℹ Using temporary cache directory /tmp/RtmppdhhKU.
#> ℹ Downloading catalog "TI".
#> ✔ Using cache directory /tmp/RtmppdhhKU.
#> ℹ Updating 1 catalog file: "TI".
#> ℹ Downloading file from <https://www.bde.es/webbe/es/estadisticas/compartido/datos/csv/catalogo_ti.csv>.
#> ℹ Parsing date columns.
#> # A tibble: 49 × 17
#>    Nombre_de_la_serie Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>    <chr>                          <dbl> <chr>             <chr>                 
#>  1 D_DTFK09A0                   4562340 TI_1_1.1          TI_1_1.csv            
#>  2 D_DTFK08A0                   4562341 TI_1_1.2          TI_1_1.csv            
#>  3 D_DNBCEA72                   4573260 TI_1_1.3          TI_1_1.csv            
#>  4 D_DNBCEB72                   4573259 TI_1_1.4          TI_1_1.csv            
#>  5 D_DTES00B7                     80395 TI_1_3.1          TI_1_3.csv            
#>  6 D_DTES00S7                     80445 TI_1_3.2          TI_1_3.csv            
#>  7 D_DTES00T7                     80455 TI_1_3.3          TI_1_3.csv            
#>  8 D_DTES00U7                     80465 TI_1_3.4          TI_1_3.csv            
#>  9 D_DTES00V7                     80475 TI_1_3.5          TI_1_3.csv            
#> 10 D_G0B1F0ZD                     97255 TI_1_3.6          TI_1_3.csv            
#> # ℹ 39 more rows
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>, …

# Simple search. Search terms must be in Spanish.
# PIB [es] == GDP [en].
bde_catalog_search("PIB")
#> # A tibble: 402 × 17
#>    Nombre_de_la_serie Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>    <chr>              <chr>             <chr>             <chr>                 
#>  1 DSPC102020WB11000… 4669410           BE_1_1.7          BE0101.csv            
#>  2 DTNSEC2010_S0000P… 2563971           BE_1_6.1          BE0106.csv            
#>  3 DTNSEC2010_S0000P… 2563952           BE_1_6.2          BE0106.csv            
#>  4 DTNSEC2010_S0000P… 5120157           BE_1_6.3          BE0106.csv            
#>  5 DTNSEC2010_S0000P… 2563953           BE_1_6.4          BE0106.csv            
#>  6 DTNSEC2010_S0000P… 2563954           BE_1_6.5          BE0106.csv            
#>  7 DTNSEC2010_S0000P… 2563955           BE_1_6.6          BE0106.csv            
#>  8 DTNSEC2010_S0000P… 2563956           BE_1_6.7          BE0106.csv            
#>  9 DTNSEC2010_S0000P… 2563957           BE_1_6.8          BE0106.csv            
#> 10 DTNSEC2010_S0000P… 2563958           BE_1_6.9          BE0106.csv            
#> # ℹ 392 more rows
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>, …

# Search with a single complex condition.
bde_catalog_search("Francia(.*)PIB")
#> # A tibble: 2 × 17
#>   Nombre_de_la_serie  Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>   <chr>               <chr>             <chr>             <chr>                 
#> 1 DTNSEC2010_S0000P_… 2563958           BE_1_6.9          BE0106.csv            
#> 2 DTNPDE2010_P0000P_… 2563918           BE_1_7.9          BE0107.csv            
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>,
#> #   Titulo_de_la_serie <chr>, Fuente <chr>, Notas <chr>

# Search with multiple complex conditions.
bde_catalog_search("Francia(.*)PIB|Italia(.*)PIB|Alemania(.*)PIB")
#> # A tibble: 6 × 17
#>   Nombre_de_la_serie  Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>   <chr>               <chr>             <chr>             <chr>                 
#> 1 DTNSEC2010_S0000P_… 2563953           BE_1_6.4          BE0106.csv            
#> 2 DTNSEC2010_S0000P_… 2563958           BE_1_6.9          BE0106.csv            
#> 3 DTNSEC2010_S0000P_… 2563959           BE_1_6.11         BE0106.csv            
#> 4 DTNPDE2010_P0000P_… 2563913           BE_1_7.4          BE0107.csv            
#> 5 DTNPDE2010_P0000P_… 2563918           BE_1_7.9          BE0107.csv            
#> 6 DTNPDE2010_P0000P_… 2563919           BE_1_7.11         BE0107.csv            
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>,
#> #   Titulo_de_la_serie <chr>, Fuente <chr>, Notas <chr>

bde_catalog_update("TI", verbose = TRUE)
#> ℹ Using temporary cache directory /tmp/RtmppdhhKU.
#> ℹ Updating 1 catalog file: "TI".
#> ℹ Downloading file from <https://www.bde.es/webbe/es/estadisticas/compartido/datos/csv/catalogo_ti.csv>.
# }
```
