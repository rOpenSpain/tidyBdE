# Relevant Indicators of Spain

Set of helper functions for downloading some of the most relevant
macroeconomic indicators of Spain. Metadata available in
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

## Arguments

- series_label:

  Optional. Character vector or value. Allows to specify a custom label
  for the series extracted. It should have the same length than
  `series_code`.

- ...:

  Arguments passed on to
  [`bde_series_load`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)

  `out_format`

  :   Defines if the format must be returned as a "long" dataset or a
      "wide" dataset. Possible values are `"wide"` or `"long"`. See
      **Value** for Details and Section **Examples**.

  `parse_numeric`

  :   Logical. If `TRUE` the columns would be parsed to double (numeric)
      values. See **Note**.

  `extract_metadata`

  :   Logical `TRUE/FALSE`. On `TRUE` the output is the metadata of the
      requested series.

  `parse_dates`

  :   Logical. If `TRUE` the dates would be parsed using
      [`bde_parse_dates()`](https://ropenspain.github.io/tidyBdE/reference/bde_parse_dates.md).

  `update_cache`

  :   Logical. If `TRUE` the requested file would be updated on the
      `cache_dir`.

  `cache_dir`

  :   A path to a cache directory. The directory can also be set via
      options with `options(bde_cache_dir = "path/to/dir")`.

  `verbose`

  :   Logical `TRUE` or `FALSE`, display information useful for
      debugging.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
the required series.

## Details

This functions are convenient wrappers of
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)
referencing specific series. Use
`verbose = TRUE, extract_metadata = TRUE` options to see the
specification and the source.

## See also

[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md),
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_search.md)

Other indicators:
[`bde_ind_db`](https://ropenspain.github.io/tidyBdE/reference/bde_ind_db.md)

## Examples

``` r
# \donttest{
bde_ind_gdp_var()
#> # A tibble: 119 × 2
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
#> # ℹ 109 more rows
# }
```
