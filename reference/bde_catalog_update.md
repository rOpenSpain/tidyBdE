# Update BdE catalog files

Update BdE time series catalog files.

## Usage

``` r
bde_catalog_update(
  catalog = c("ALL", "BE", "SI", "TC", "TI", "PB"),
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

[Time series bulk data
download](https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html).

## Arguments

- catalog:

  A single catalog identifier to update, or `"ALL"` to update every
  catalog. See **Details**.

- cache_dir:

  Path to a cache directory. The directory can also be set with
  `options(bde_cache_dir = "path/to/dir")`.

- verbose:

  Logical. If `TRUE`, display information useful for debugging.

## Value

An invisible list of download results.

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

Use `"ALL"` as a shorthand for updating all catalogs at once.

## See also

Other catalog:
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md),
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_search.md)

## Examples

``` r
# \donttest{
bde_catalog_update("TI", verbose = TRUE)
#> ℹ Using temporary cache directory /tmp/Rtmp8PeGbr.
#> ℹ Updating catalogs: TI.
#> ℹ Downloading file from <https://www.bde.es/webbe/es/estadisticas/compartido/datos/csv/catalogo_ti.csv>.
# }
```
