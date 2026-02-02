# Load BdE full time-series files

Load a full time-series file provided by BdE.

## Usage

``` r
bde_series_full_load(
  series_csv,
  parse_dates = TRUE,
  parse_numeric = TRUE,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  extract_metadata = FALSE
)
```

## Arguments

- series_csv:

  csv file of a series, as defined in the field
  `Nombre del archivo con los valores de la serie` of the corresponding
  catalog. See
  [`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md).

- parse_dates:

  Logical. If `TRUE`, the dates will be parsed using
  [`bde_parse_dates()`](https://ropenspain.github.io/tidyBdE/reference/bde_parse_dates.md).

- parse_numeric:

  Logical. If `TRUE` the columns would be parsed to double (numeric)
  values. See **Note**.

- cache_dir:

  A path to a cache directory. The directory can also be set via options
  with `options(bde_cache_dir = "path/to/dir")`.

- update_cache:

  Logical. If `TRUE`, the requested file will be updated in the
  `cache_dir`.

- verbose:

  Logical `TRUE` or `FALSE`, display information useful for debugging.

- extract_metadata:

  Logical `TRUE/FALSE`. On `TRUE` the output is the metadata of the
  requested series.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with a field `Date` and the alias of the fields series as described on
the catalogs. See
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md).

## Details

### About BdE file naming

The series name is a positional code showing the location of the table.
For example, table **be_6_1** represents the Table 1, Chapter 6 of the
Statistical Bulletin ("BE"). Although it is a unique value, it is
subject to change (i.e. a new table is inserted before).

For that reason, the function
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)
is more suitable for extracting specific time-series.

## Note

This function tries to coerce the columns to numbers. For some series a
warning may be displayed if the parser fails. You can override the
default behavior with `parse_numeric = FALSE`

## See also

Other series:
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)

## Examples

``` r
# \donttest{
# Metadata
bde_series_full_load("TI_1_1.csv", extract_metadata = TRUE)
#> # A tibble: 6 × 5
#>   Date                        TI_1_1.1                TI_1_1.2 TI_1_1.3 TI_1_1.4
#>   <chr>                       <chr>                   <chr>    <chr>    <chr>   
#> 1 CÓDIGO DE LA SERIE          D_DTFK09A0              D_DTFK0… D_DNBCE… D_DNBCE…
#> 2 NÚMERO SECUENCIAL           4562340                 4562341  4573260  4573259 
#> 3 ALIAS DE LA SERIE           TI_1_1.1                TI_1_1.2 TI_1_1.3 TI_1_1.4
#> 4 DESCRIPCIÓN DE LA SERIE     Tipo de interés. Opera… Tipos d… Tipo de… Tipo de…
#> 5 DESCRIPCIÓN DE LAS UNIDADES Porcentaje              Porcent… Porcent… Porcent…
#> 6 FRECUENCIA                  LABORABLE               LABORAB… LABORAB… LABORAB…

# Data
bde_series_full_load("TI_1_1.csv")
#> # A tibble: 7,066 × 5
#>    Date       TI_1_1.1 TI_1_1.2 TI_1_1.3 TI_1_1.4
#>    <date>        <dbl>    <dbl>    <dbl>    <dbl>
#>  1 1999-01-01        3       NA     4.5      2   
#>  2 1999-01-04        3       NA     3.25     2.75
#>  3 1999-01-05        3       NA     3.25     2.75
#>  4 1999-01-06        3       NA     3.25     2.75
#>  5 1999-01-07        3       NA     3.25     2.75
#>  6 1999-01-08        3       NA     3.25     2.75
#>  7 1999-01-11        3       NA     3.25     2.75
#>  8 1999-01-12        3       NA     3.25     2.75
#>  9 1999-01-13        3       NA     3.25     2.75
#> 10 1999-01-14        3       NA     3.25     2.75
#> # ℹ 7,056 more rows
# }
```
