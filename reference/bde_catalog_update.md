# Update BdE catalogs

Update the time-series catalogs provided by BdE.

## Usage

``` r
bde_catalog_update(
  catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

[Time-series bulk data
download](https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html).

## Arguments

- catalog:

  A vector of characters indicating the catalogs to be updated or
  `"ALL"` as a shorthand. See **Details**.

- cache_dir:

  A path to a cache directory. The directory can also be set via options
  with `options(bde_cache_dir = "path/to/dir")`.

- verbose:

  Logical `TRUE` or `FALSE`, display information useful for debugging.

## Value

None. Downloads the catalog file(s) to the local machine.

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

## See also

Other catalog:
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md),
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_search.md)

## Examples

``` r
# \donttest{
bde_catalog_update("TI", verbose = TRUE)
#> tidyBdE> Caching on temporary directory C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOys4Us
#> tidyBdE> Updating catalogs: TI
#> tidyBdE> Downloading file from https://www.bde.es/webbe/es/estadisticas/compartido/datos/csv/catalogo_ti.csv
#> 
# }
```
