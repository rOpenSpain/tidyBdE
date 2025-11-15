# Load BdE catalogs

Load the time-series catalogs provided by BdE.

## Usage

``` r
bde_catalog_load(
  catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
  parse_dates = TRUE,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)
```

## Source

[Time-series bulk data
download](https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html).

## Arguments

- catalog:

  A single value indicating the catalogs to be updated or `"ALL"` as a
  shorthand. See **Details**.

- parse_dates:

  Logical. If `TRUE` the dates would be parsed using
  [`bde_parse_dates()`](https://ropenspain.github.io/tidyBdE/reference/bde_parse_dates.md).

- cache_dir:

  A path to a cache directory. The directory can also be set via options
  with `options(bde_cache_dir = "path/to/dir")`.

- update_cache:

  Logical. If `TRUE` the requested file would be updated on the
  `cache_dir`.

- verbose:

  Logical `TRUE` or `FALSE`, display information useful for debugging.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) object.

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

Use `"ALL"` as a shorthand for updating all the catalogs at a glance.

If the requested catalog is not cached
[`bde_catalog_update()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_update.md)
is invoked.

## See also

Other catalog:
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_search.md),
[`bde_catalog_update()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_update.md)

## Examples

``` r
# \donttest{
bde_catalog_load("TI", verbose = TRUE)
#> tidyBdE> Caching on temporary directory C:\Users\RUNNER~1\AppData\Local\Temp\Rtmp4UP9eQ
#> tidyBdE> Need to download catalog TI
#> tidyBdE> Cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\Rtmp4UP9eQ
#> tidyBdE> Updating catalogs: TI
#> tidyBdE> Downloading file from https://www.bde.es/webbe/es/estadisticas/compartido/datos/csv/catalogo_ti.csv
#> 
#> tidyBdE> Parsing dates
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
# }
```
