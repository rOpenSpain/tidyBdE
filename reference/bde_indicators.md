# Selected Spanish macroeconomic indicators

Retrieve selected Spanish macroeconomic indicators. Metadata is
available in
[bde_ind_db](https://ropenspain.github.io/tidyBdE/reference/bde_ind_db.md).

## Usage

``` r
bde_ind_gdp_var(series_label = "GDP_YoY", ...)

bde_ind_unemployment_rate(series_label = "Unemployment_Rate", ...)

bde_ind_euribor_12m_monthly(series_label = "Euribor_12M_Monthly", ...)

bde_ind_euribor_12m_daily(series_label = "Euribor_12M_Daily", ...)

bde_ind_cpi_var(series_label = "Consumer_price_index_YoY", ...)

bde_ind_ibex_monthly(series_label = "IBEX_index_month", ...)

bde_ind_ibex_daily(series_label = "IBEX_index_day", ...)

bde_ind_gdp_quarterly(series_label = "GDP_quarterly_value", ...)

bde_ind_population(series_label = "Population_Spain", ...)
```

## Source

[Banco de España time series bulk data
download](https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html).

## Arguments

- series_label:

  An optional character vector of labels to assign to the extracted
  series.

- ...:

  Arguments passed on to
  [`bde_series`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)

  `out_format`

  :   The output format, either `"wide"` or `"long"`. See **Value** for
      details and the **Examples** section.

  `parse_numeric`

  :   Logical. If `TRUE`, parse observation columns as double vectors.
      See **Note**.

  `extract_metadata`

  :   Logical. If `TRUE`, return the metadata associated with the
      requested series.

  `parse_dates`

  :   Logical. If `TRUE`, date columns are parsed with
      [`bde_parse_dates()`](https://ropenspain.github.io/tidyBdE/reference/bde_parse_dates.md).

  `update_cache`

  :   Logical. If `TRUE`, the requested file is refreshed in
      `cache_dir`.

  `cache_dir`

  :   Path to a cache directory. The directory can also be set with
      `options(bde_cache_dir = "path/to/dir")`.

  `verbose`

  :   Logical. If `TRUE`, display informative messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
requested indicator series.

## Details

These functions are convenient wrappers for
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)
that retrieve specific series. Use
`verbose = TRUE, extract_metadata = TRUE` to inspect the metadata and
source.

## Note

These functions attempt to parse columns as double values. For some time
series, a warning may be displayed if parsing fails. Set
`parse_numeric = FALSE` to disable numeric parsing.

## See also

[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)
for loading arbitrary bulk CSV series and
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalogs.md)
for finding series in catalog metadata.

Selected indicators and metadata:
[`bde_ind_db`](https://ropenspain.github.io/tidyBdE/reference/bde_ind_db.md)

## Examples

``` r
# \donttest{
bde_ind_gdp_var()
#> # A tibble: 121 × 2
#>    Date       GDP_YoY
#>    <date>       <dbl>
#>  1 1996-03-01    2.46
#>  2 1996-06-01    2.49
#>  3 1996-09-01    2.87
#>  4 1996-12-01    2.61
#>  5 1997-03-01    3.04
#>  6 1997-06-01    3.26
#>  7 1997-09-01    3.55
#>  8 1997-12-01    4.49
#>  9 1998-03-01    4.33
#> 10 1998-06-01    4.53
#> # ℹ 111 more rows
# }
```
